# EC2 Monitor Lambda Module

Self-contained Lambda module that stops EC2 instances on a schedule.

## What's Included

- ✅ Lambda Python code (`lambda-function.py`)
- ✅ Automatic zip creation (no build needed!)
- ✅ IAM role with EC2 permissions
- ✅ CloudWatch Logs
- ✅ EventBridge integration

## Usage

```terraform
module "ec2_monitor_lambda" {
  source = "./modules/lambda"

  project_name         = "moreno-stack"
  environment          = "dev"
  monitored_regions    = "us-east-1,us-west-2,af-south-1"
  eventbridge_rule_arn = aws_cloudwatch_event_rule.schedule.arn
}
```

## Files

- `lambda-function.py` - Python code (stops EC2 instances)
- `main.tf` - Lambda resource + auto-zip
- `iam.tf` - IAM role + EC2 permissions
- `variables.tf` - Input variables
- `outputs.tf` - Outputs

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| project_name | Project name | required |
| environment | Environment (dev/prod) | required |
| monitored_regions | Regions to monitor | us-east-1,us-west-2,af-south-1 |
| eventbridge_rule_arn | EventBridge rule ARN | required |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | Lambda function ARN |
| function_name | Lambda function name |

## How It Works

1. Terraform automatically zips `lambda-function.py`
2. Creates Lambda function
3. Sets up IAM permissions (EC2 stop/start/describe)
4. Connects to EventBridge schedule
5. Lambda runs and stops instances

## Modifying the Lambda

Edit `lambda-function.py` and run `terraform apply`. Terraform will:
- Detect changes
- Re-zip the code
- Update the Lambda function

No manual build needed! 🎉
