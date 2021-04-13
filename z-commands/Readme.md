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


######################
(based on:
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
)
# II. Attaching EBS to Linux

$ lsblk

New volumes are raw block devices, and you must create a file system on them before you can mount and use them.

$ sudo file -s /dev/xvdf

to format empty "data" files system

$ lsblk
$ sudo mkdir /my-data
$ sudo  mount /dev/xvdf /my-data
$ lsblk


[ec2-user@ip-172-31-2-187 ~]$ lsblk
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0   8G  0 disk 
└─xvda1 202:1    0   8G  0 part /
xvdf    202:80   0   8G  0 disk /my-data



$ blkid

[ec2-user@ip-172-31-2-187 ~]$ sudo blkid 
/dev/xvda1: LABEL="/" UUID="15c7809d-e6e3-4062-a5eb-afeb1939fc6e" TYPE="xfs" PARTLABEL="Linux" PARTUUID="cfb2e895-ecec-41c
5-afc2-40ffe2e4384a"
/dev/xvdf: UUID="80029fd7-fa14-4515-a698-29711f1d8e38" TYPE="xfs"


[ec2-user@ip-172-31-2-187 ~]$ 

UUID=80029fd7-fa14-4515-a698-29711f1d8e38  /my-data  xfs  defaults,nofail  0  2


cat /etc/fstab



# SSH Agent

https://medium.com/devops-dudes/setting-up-an-ssh-agent-to-access-the-bastion-in-vpc-532918577949


## Se inicia el SSH-Agent & list private keys: 
ssh-agent -s
ssh-add -l

## Add the private keys & list
ssh-add -k lab-vpc-k3-oregon-borrame.pem
ssh-add -k lab-vpc-k3-virginia-borrame.pem
ssh-add -l

## To delete
ssh-add -d  ~/.ssh/cloud-infra-key.pem

## To login
ssh -A <hostname>


# To Stress  EC2 Instances

    sudo amazon-linux-extras install epel -y
    sudo yum install -y stress

    # Stress 10 minutos
    stress --cpu 2 --timeout 300
