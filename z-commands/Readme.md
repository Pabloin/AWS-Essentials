# AWS CLI Command Useful

# ______________-----______________
# Set the Region

AZ=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
export AWS_DEFAULT_REGION=${AZ::-1}


# ______________-----______________
# Obtener la última Linux AMI

AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)

echo $AMI


# ______________-----______________
# Obtener el SG

SG=$(aws ec2 describe-security-groups --filters Name=group-name,Values=WebSecurityGroup --query SecurityGroups[].GroupId --output text)

echo $SG


# ______________-----______________
# Obtener la subnet

SUBNET=$(aws ec2 describe-subnets --filters 'Name=tag:Name,Values=Public Subnet' --query Subnets[].SubnetId --output text)

echo $SUBNET


# ______________-----______________
# Launch EC2 INSTANCE

wget ... /user_data.txt 

EC2_INSTANCE=$(\
aws ec2 run-instances \
--image-id $AMI \
--subnet-id $SUBNET \
--security-group-ids $SG \
--user-data file:///home/ec2-user/user_data.txt \
--instance-type t2.micro \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Web Server}]' \
--query 'Instances[*].InstanceId' \
--output text \
)

echo $EC2_INSTANCE


# ______________-----______________
# Instance Ready, Status + Public DNS

aws ec2 describe-instances --instance-ids $INSTANCE

aws ec2 describe-instances --instance-ids $INSTANCE --query 'Reservations[].Instances[].State.Name' --output text

aws ec2 describe-instances --instance-ids $INSTANCE --query Reservations[].Instances[].PublicDnsName --output text


