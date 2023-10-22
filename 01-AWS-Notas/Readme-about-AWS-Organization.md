# SCP Policies

## AWS Deny Root User


### Description
DenyRootUser best Practice Based On https://towardsthecloud.com/aws-scp-examples

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": "arn:aws:iam::*:root"
        }
      },
      "Action": "*",
      "Resource": "*",
      "Effect": "Deny",
      "Sid": "DenyRootUser"
    }
  ]
}
```


## AWS Restrict Available Regions

### Description
Restrict Available Regions to - Habilita Algunas Regiones, no todas: Virgina / Ohahi / Oregon / Irlanda / San Pablo "us-east-1", "us-east-2", "us-west-2", "eu-west-1", "sa-east-1"

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsidePrefereRegions",
      "Effect": "Deny",
      "NotAction": [
        "a4b:*",
        "acm:*",
        "aws-marketplace-management:*",
        "aws-marketplace:*",
        "aws-portal:*",
        "budgets:*",
        "ce:*",
        "chime:*",
        "cloudfront:*",
        "config:*",
        "cur:*",
        "directconnect:*",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpnGateways",
        "fms:*",
        "globalaccelerator:*",
        "health:*",
        "iam:*",
        "importexport:*",
        "kms:*",
        "mobileanalytics:*",
        "networkmanager:*",
        "organizations:*",
        "pricing:*",
        "route53:*",
        "route53domains:*",
        "s3:GetAccountPublic*",
        "s3:ListAllMyBuckets",
        "s3:PutAccountPublic*",
        "shield:*",
        "sts:*",
        "support:*",
        "trustedadvisor:*",
        "waf-regional:*",
        "waf:*",
        "wafv2:*",
        "wellarchitected:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "us-east-1",
            "us-east-2",
            "us-west-2",
            "eu-west-1",
            "sa-east-1"
          ]
        }
      }
    }
  ]
}
```




## AWS Restrict Instance Type

### Description
Require Amazon EC2 instances to use a specific type

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireSmallInstanceType",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": [
        "arn:aws:ec2:*:*:instance/*"
      ],
      "Condition": {
        "ForAnyValue:StringNotLike": {
          "ec2:InstanceType": [
            "*.nano",
            "*.micro",
            "*.small",
            "*.medium",
            "*.large",
            "*.xlarge",
            "*.2xlarge"
          ]
        }
      }
    }
  ]
}
```


