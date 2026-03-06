#!/bin/bash
##
# Deploy Lambda RDS Monitor con AWS CLI
# Uso: ./deploy.sh
# Perfil AWS: cloti
##

set -e

# ── Config ────────────────────────────────────────────────────────────────────
PROFILE="cloti"
REGION="us-east-1"
LAMBDA_NAME="rds-monitor-stop"
ROLE_NAME="lambda-rds-monitor-role"
POLICY_NAME="lambda-rds-monitor-policy"
LAMBDA_FILE="lambda-RDS-monitor.py"
ZIP_FILE="lambda-RDS-monitor.zip"
SCHEDULE="rate(3 days)"
RULE_NAME="rds-monitor-schedule"
TAGS="Environment=sandbox,Project=rds-monitor,Owner=cloti,deployment-mode=claude-and-script"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ─────────────────────────────────────────────────────────────────────────────

echo ""
echo "==> Obteniendo Account ID..."
ACCOUNT_ID=$(aws sts get-caller-identity \
  --profile "$PROFILE" \
  --query Account \
  --output text)
echo "    Account ID: $ACCOUNT_ID"

ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
LAMBDA_ARN="arn:aws:lambda:${REGION}:${ACCOUNT_ID}:function:${LAMBDA_NAME}"

# ── 1. IAM Role ───────────────────────────────────────────────────────────────
echo ""
echo "==> Verificando IAM Role: $ROLE_NAME"
if aws iam get-role --role-name "$ROLE_NAME" --profile "$PROFILE" > /dev/null 2>&1; then
  echo "    Role ya existe, OK."
else
  echo "    Creando role..."
  aws iam create-role \
    --profile "$PROFILE" \
    --role-name "$ROLE_NAME" \
    --assume-role-policy-document '{
      "Version":"2012-10-17",
      "Statement":[{
        "Effect":"Allow",
        "Principal":{"Service":"lambda.amazonaws.com"},
        "Action":"sts:AssumeRole"
      }]
    }' \
    --output text > /dev/null
  echo "    Role creado."
fi

# ── 2. Attach AWS managed policy for Lambda basic execution ───────────────────
echo ""
echo "==> Adjuntando AWSLambdaBasicExecutionRole..."
aws iam attach-role-policy \
  --profile "$PROFILE" \
  --role-name "$ROLE_NAME" \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" 2>/dev/null || true

# ── 3. Inline policy para RDS ─────────────────────────────────────────────────
echo ""
echo "==> Aplicando inline policy RDS al role..."
aws iam put-role-policy \
  --profile "$PROFILE" \
  --role-name "$ROLE_NAME" \
  --policy-name "$POLICY_NAME" \
  --policy-document file://"${SCRIPT_DIR}/lambda-RDS-monitor-policy.json"
echo "    Policy aplicada."

# ── 4. Empaquetar Lambda ──────────────────────────────────────────────────────
echo ""
echo "==> Generando ZIP..."
cd "$SCRIPT_DIR"
zip -q -j "$ZIP_FILE" "$LAMBDA_FILE"
echo "    ZIP generado: $ZIP_FILE"

# ── 5. Crear o actualizar Lambda ──────────────────────────────────────────────
echo ""
echo "==> Verificando Lambda: $LAMBDA_NAME"
if aws lambda get-function --function-name "$LAMBDA_NAME" \
    --profile "$PROFILE" --region "$REGION" > /dev/null 2>&1; then
  echo "    Lambda ya existe, actualizando codigo..."
  aws lambda update-function-code \
    --profile "$PROFILE" \
    --region "$REGION" \
    --function-name "$LAMBDA_NAME" \
    --zip-file fileb://"${SCRIPT_DIR}/${ZIP_FILE}" \
    --output text > /dev/null
  echo "    Codigo actualizado."

  echo "    Esperando que el update de codigo termine..."
  aws lambda wait function-updated \
    --profile "$PROFILE" \
    --region "$REGION" \
    --function-name "$LAMBDA_NAME"

  echo "    Actualizando configuracion (timeout)..."
  aws lambda update-function-configuration \
    --profile "$PROFILE" \
    --region "$REGION" \
    --function-name "$LAMBDA_NAME" \
    --timeout 60 \
    --output text > /dev/null

  echo "    Actualizando tags..."
  aws lambda tag-resource \
    --profile "$PROFILE" \
    --region "$REGION" \
    --resource "$LAMBDA_ARN" \
    --tags "$TAGS" 2>/dev/null || true
else
  echo "    Lambda no existe, creando (esperando que el role se propague)..."
  sleep 10
  aws lambda create-function \
    --profile "$PROFILE" \
    --region "$REGION" \
    --function-name "$LAMBDA_NAME" \
    --runtime python3.12 \
    --role "$ROLE_ARN" \
    --handler "lambda-RDS-monitor.lambda_handler" \
    --zip-file fileb://"${SCRIPT_DIR}/${ZIP_FILE}" \
    --timeout 60 \
    --description "Detiene instancias RDS cada 3 dias en entorno sandbox" \
    --tags "$TAGS" \
    --output text > /dev/null
  echo "    Lambda creada."
fi

# ── 6. EventBridge Rule ───────────────────────────────────────────────────────
echo ""
echo "==> Creando/actualizando regla EventBridge: $RULE_NAME"
RULE_ARN=$(aws events put-rule \
  --profile "$PROFILE" \
  --region "$REGION" \
  --name "$RULE_NAME" \
  --schedule-expression "$SCHEDULE" \
  --state ENABLED \
  --description "Ejecuta rds-monitor-stop cada 3 dias" \
  --query RuleArn \
  --output text)
echo "    Rule ARN: $RULE_ARN"

# ── 7. Permiso para que EventBridge invoque la Lambda ─────────────────────────
echo ""
echo "==> Agregando permiso Lambda para EventBridge..."
aws lambda add-permission \
  --profile "$PROFILE" \
  --region "$REGION" \
  --function-name "$LAMBDA_NAME" \
  --statement-id "allow-eventbridge-rds-monitor" \
  --action "lambda:InvokeFunction" \
  --principal "events.amazonaws.com" \
  --source-arn "$RULE_ARN" 2>/dev/null || echo "    Permiso ya existia, OK."

# ── 8. Target de EventBridge → Lambda ────────────────────────────────────────
echo ""
echo "==> Configurando target de la regla hacia la Lambda..."
aws events put-targets \
  --profile "$PROFILE" \
  --region "$REGION" \
  --rule "$RULE_NAME" \
  --targets "Id=rds-monitor-target,Arn=${LAMBDA_ARN}" \
  --output text > /dev/null
echo "    Target configurado."

# ── Cleanup ───────────────────────────────────────────────────────────────────
rm -f "${SCRIPT_DIR}/${ZIP_FILE}"

echo ""
echo "============================================"
echo " Deploy completado exitosamente!"
echo "  Lambda : $LAMBDA_NAME"
echo "  Region : $REGION"
echo "  Trigger: $SCHEDULE"
echo "  Profile: $PROFILE"
echo "============================================"
echo ""
