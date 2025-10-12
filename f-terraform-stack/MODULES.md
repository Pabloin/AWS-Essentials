# Module Structure

This document describes the modular architecture of the Terraform stack.

## Directory Structure

```
f-terraform-stack/
├── main.tf                  # Root module - Bastion resources
├── variables.tf             # Root variables
├── outputs.tf               # Root outputs
├── locals.tf                # Local values and tags
├── user_data.sh             # Bastion bootstrap script
├── terraform.tfvars.example # Example configuration
│
├── modules/
│   └── networking/          # Networking module
│       ├── main.tf          # VPC, Subnets, IGW, Route Tables
│       ├── variables.tf     # Module inputs
│       ├── outputs.tf       # Module outputs
│       └── README.md        # Module documentation
│
└── envs/
    └── dev/                 # Development environment
        ├── main.tf          # Calls root module
        ├── variables.tf     # Environment variables
        ├── terraform.tfvars # Environment-specific values
        ├── providers.tf     # Provider configuration
        ├── backend.tf       # State backend config
        └── data.tf          # Data sources

```

## Module Responsibilities

### Root Module (`main.tf`)
**Purpose:** Bastion host and security

**Resources:**
- Security Group (bastion SSH access)
- SSH Key Pair
- EC2 Instance (bastion)
- Elastic IP
- AMI data source (Ubuntu 24.04)

**Calls:**
- `modules/networking` - VPC infrastructure

### Networking Module (`modules/networking/`)
**Purpose:** Network infrastructure

**Resources:**
- VPC
- Internet Gateway
- Public Subnet
- Route Table
- Route Table Association

**Outputs:**
- VPC ID
- Subnet IDs
- Internet Gateway ID
- Availability Zone

## Data Flow

```
┌─────────────────────────────────────────────────────┐
│  Environment (envs/dev/)                            │
│  ┌───────────────────────────────────────────────┐  │
│  │ Variables + Values                            │  │
│  │ - project_name                                │  │
│  │ - environment                                 │  │
│  │ - vpc_cidr                                    │  │
│  │ - ssh_public_key                              │  │
│  └───────────────────┬───────────────────────────┘  │
│                      │                              │
│                      ↓                              │
│  ┌───────────────────────────────────────────────┐  │
│  │ Root Module (main.tf)                         │  │
│  │ ┌───────────────────────────────────────────┐ │  │
│  │ │ Networking Module                         │ │  │
│  │ │ - Creates VPC                             │ │  │
│  │ │ - Creates Subnet                          │ │  │
│  │ │ - Creates Internet Gateway                │ │  │
│  │ │                                           │ │  │
│  │ │ Outputs: vpc_id, subnet_id               │ │  │
│  │ └───────────────┬───────────────────────────┘ │  │
│  │                 │                             │  │
│  │                 ↓                             │  │
│  │ ┌───────────────────────────────────────────┐ │  │
│  │ │ Bastion Resources                         │ │  │
│  │ │ - Security Group (uses vpc_id)            │ │  │
│  │ │ - EC2 Instance (uses subnet_id)           │ │  │
│  │ │ - Elastic IP                              │ │  │
│  │ └───────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Benefits of This Structure

### 1. **Separation of Concerns**
- Networking logic isolated in its own module
- Bastion logic in root module
- Easy to understand and maintain

### 2. **Reusability**
- Networking module can be used in other projects
- Easy to add more compute modules later

### 3. **Scalability**
```
modules/
├── networking/      # Network infrastructure
├── bastion/         # Could move bastion here too
├── database/        # Future: RDS in private subnet
├── application/     # Future: App servers
└── monitoring/      # Future: CloudWatch, alarms
```

### 4. **Testing**
- Test networking module independently
- Test bastion functionality separately
- Easier to debug issues

### 5. **Clear Dependencies**
```terraform
# Explicitly shows bastion depends on networking
resource "aws_security_group" "bastion" {
  vpc_id = module.networking.vpc_id  # ← Clear dependency
}
```

## Adding More Modules

To add a new module (e.g., database):

1. **Create module directory:**
   ```
   modules/database/
   ├── main.tf
   ├── variables.tf
   └── outputs.tf
   ```

2. **Call from root module:**
   ```terraform
   module "database" {
     source = "./modules/database"
     
     vpc_id    = module.networking.vpc_id
     subnet_id = module.networking.private_subnet_id
   }
   ```

3. **Use outputs:**
   ```terraform
   resource "aws_instance" "app" {
     environment_variables = {
       DB_HOST = module.database.endpoint
     }
   }
   ```

## Best Practices Applied

✅ **Single Responsibility** - Each module has one job
✅ **DRY** (Don't Repeat Yourself) - Networking code in one place
✅ **Loose Coupling** - Modules communicate through inputs/outputs
✅ **High Cohesion** - Related resources grouped together
✅ **Explicit Dependencies** - Clear module relationships

## Next Steps

Consider creating additional modules:
- `modules/bastion/` - Move bastion logic to its own module
- `modules/security/` - Security groups and NACLs
- `modules/monitoring/` - CloudWatch logs and alarms
- `modules/backup/` - Backup policies and schedules
