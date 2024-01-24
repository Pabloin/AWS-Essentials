##
# Apaga todas las instancias, en un entorno sandbox
# Para Evitar Costos por Instancias prendidas
#
# Necesita:
#   - La lambda
#   - Un Event Bridge
#   - Una Policy
#
import json
import boto3

def get_instances_ids(region):
    try:
        ec2_client = boto3.client('ec2', region_name=region)
        response   = ec2_client.describe_instances()

        instance_ids = []
    
        for reservation in response["Reservations"]:
            for instance in reservation["Instances"]:

                instance_id = instance['InstanceId']
                state_name  = instance['State']['Name']

                print("Region: {0:10} - Instancia [{1}, {2}]".format(
                        region, instance_id, state_name)
                    )
                
                if state_name != 'stopped':
                    instance_ids.append(instance["InstanceId"])

        return instance_ids

    except Exception as exception:
        print(f"Encountered exception in Region {region} get_instances_ids: {exception}")


    
def lambda_handler(event, context):
    try:
        regiones = [ 'us-east-1', 'us-west-2', 'af-south-1' ]
        
        for region in regiones:    
            
            ec2_client = boto3.client('ec2', region_name=region)
                    
            instance_ids = get_instances_ids(region)
            
            if instance_ids != []:
                ec2_client.stop_instances(InstanceIds=instance_ids)

            print(f"Region {region} ::: Stop de instances {instance_ids}")

        code = 200
        response = "Todas las instancias detenidas Ok"

    except Exception as exception:
        code = 500
        response = f"Encountered exception in list_instance: {exception}"
        

        
    return {
            'statusCode': code,
            'body': json.dumps(response)
        }
  