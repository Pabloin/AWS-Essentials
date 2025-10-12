# Provisioners Guide

## Two Ways to Run Custom Setup Script

### **Option 1: Automatic** (Set and forget)
Edit `terraform.tfvars`:
```terraform
run_custom_setup = true
```
Script runs automatically during `terraform apply`.

### **Option 2: Manual** (Run when needed)
Keep default `run_custom_setup = false` and run:
```bash
./scripts/deploy-and-run.sh
```

---

## Quick Start

**Automatic mode:**
```bash
# 1. Enable in terraform.tfvars
run_custom_setup = true

# 2. Deploy
cd envs/dev
terraform apply
```

**Manual mode:**
```bash
# 1. Deploy infrastructure
cd envs/dev
terraform apply

# 2. Run script anytime
cd ../../scripts
./deploy-and-run.sh
```

---

## Re-running the Script

**Manual:** Just run `./scripts/deploy-and-run.sh` again

**Automatic:** Force Terraform to re-run it
```bash
terraform taint null_resource.configure_bastion[0]
terraform apply
```

---

## Recommendation

Use **automatic** for initial deployment, keep **manual script** for updates.

| Method | Best For | Flexibility |
|--------|----------|-------------|
| Automatic | First deployment | Low |
| Manual | Development/updates | High |
