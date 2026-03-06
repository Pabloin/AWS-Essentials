# RDS Monitor - Lambda Stop

Lambda que detiene automaticamente todas las instancias RDS en un entorno sandbox para evitar costos innecesarios.

## Por que cada 7 dias?

AWS reinicia automaticamente las instancias RDS detenidas despues de 7 dias. El trigger de EventBridge se ejecuta cada 3 dias para volver a detenerlas antes de que AWS las reactive (AWS las reactiva a los 7 dias).

## Archivos

```
RDS-monitor/
├── lambda-RDS-monitor.py          # Codigo de la Lambda
├── lambda-RDS-monitor-policy.json # IAM Policy para RDS
├── deploy.sh                      # Script de deploy con AWS CLI
└── README.md
```

## Regiones monitoreadas

- `us-east-1`
- `us-west-2`
- `af-south-1`

Para agregar o quitar regiones, editar la lista `regiones` en `lambda-RDS-monitor.py` y en `deploy.sh`.

## Recursos que crea el deploy

| Recurso | Nombre |
|---------|--------|
| Lambda | `rds-monitor-stop` |
| IAM Role | `lambda-rds-monitor-role` |
| IAM Policy (inline) | `lambda-rds-monitor-policy` |
| EventBridge Rule | `rds-monitor-schedule` (`rate(3 days)`) |

## Deploy

Requiere tener configurado el perfil AWS `cloti` en `~/.aws/credentials`.

```bash
cd AWS-Essentials/y-lambdas/RDS-monitor
./deploy.sh
```

El script es idempotente: si se ejecuta mas de una vez, actualiza los recursos existentes sin crear duplicados.

## Permisos IAM requeridos por el perfil `cloti`

El usuario/rol asociado al perfil `cloti` debe tener permisos para:

- `iam:CreateRole`, `iam:GetRole`, `iam:AttachRolePolicy`, `iam:PutRolePolicy`
- `lambda:CreateFunction`, `lambda:UpdateFunctionCode`, `lambda:UpdateFunctionConfiguration`, `lambda:GetFunction`, `lambda:AddPermission`
- `events:PutRule`, `events:PutTargets`
- `sts:GetCallerIdentity`

## Configuracion de la Lambda

| Parametro | Valor |
|-----------|-------|
| Runtime | Python 3.12 |
| Timeout | 60 segundos |
| Trigger | EventBridge `rate(7 days)` |
| Region de deploy | `us-east-1` |
