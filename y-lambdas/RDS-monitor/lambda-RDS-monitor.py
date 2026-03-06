##
# Apaga todas las instancias RDS, en un entorno sandbox
# Para Evitar Costos por Instancias prendidas
#
# Necesita:
#   - La lambda
#   - Un Event Bridge (rate: 7 days)
#   - Una Policy
#   - Subir timeout de 3 segundos (Ej 60)
#
# Nota: AWS reinicia automaticamente las instancias RDS detenidas a los 7 dias.
#       Por eso el trigger de EventBridge debe ejecutarse cada 7 dias.
#
import json
import boto3

def get_rds_instances(region):
    try:
        rds_client = boto3.client('rds', region_name=region)
        paginator  = rds_client.get_paginator('describe_db_instances')
        instances  = []

        for page in paginator.paginate():
            for db in page['DBInstances']:
                db_id     = db['DBInstanceIdentifier']
                db_status = db['DBInstanceStatus']

                print("Region: {0:10} - RDS Instance [{1}, {2}]".format(
                        region, db_id, db_status)
                    )

                if db_status == 'available':
                    instances.append(db_id)

        return instances

    except Exception as exception:
        print(f"Encountered exception in Region {region} get_rds_instances: {exception}")
        return []


def lambda_handler(event, context):
    try:
        regiones = ['us-east-1', 'us-west-2', 'af-south-1']

        stopped_total = []

        for region in regiones:
            rds_client   = boto3.client('rds', region_name=region)
            instance_ids = get_rds_instances(region)

            for db_id in instance_ids:
                try:
                    rds_client.stop_db_instance(DBInstanceIdentifier=db_id)
                    stopped_total.append(f"{region}/{db_id}")
                    print(f"Region {region} ::: Stop RDS instance [{db_id}] OK")
                except Exception as e:
                    print(f"Region {region} ::: Error stopping [{db_id}]: {e}")

        code     = 200
        response = f"Instancias RDS detenidas: {stopped_total}"

    except Exception as exception:
        code     = 500
        response = f"Encountered exception in lambda_handler: {exception}"

    return {
        'statusCode': code,
        'body': json.dumps(response)
    }
