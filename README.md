# Terraform Local Learning Project

This project demonstrates Infrastructure as Code using Terraform with local development tools.

## Prerequisites
- Kind cluster running
- LocalStack running
- All tools installed per the [setup guide](setup-guide.md)

## Setup Instructions

### 1. Start Local Services
```bash
# Start LocalStack
localstack start -d

# Create Kind cluster
kind create cluster --name terraform-learning

# Verify cluster is ready
kubectl cluster-info --context kind-terraform-learning
```

### 2. Initialize and Apply Terraform
```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply

# See the outputs
terraform output
```

### 3. Verify Resources

**Check Kubernetes resources:**
```bash
kubectl get all -n my-local-app-dev
kubectl describe deployment my-local-app-app -n my-local-app-dev
```

**Check AWS resources in LocalStack:**
```bash
awslocal s3 ls
awslocal dynamodb list-tables
awslocal sqs list-queues
```

### 4. Access the Application
```bash
# Port forward to access the app
kubectl port-forward service/my-local-app-service 8080:80 -n my-local-app-dev

# Visit http://localhost:8080 in your browser
```

### 5. Experiment and Learn

Try these modifications:
- Change `app_replicas` in terraform.tfvars and run `terraform apply`
- Add new environment variables to the ConfigMap
- Create additional AWS resources
- Add more Kubernetes resources

### 6. Cleanup
```bash
# Destroy Terraform resources
terraform destroy

# Delete Kind cluster
kind delete cluster --name terraform-learning

# Stop LocalStack
localstack stop
```

## Key Learning Points

1. **Resource Dependencies**: Notice how Kubernetes resources reference AWS resources
2. **Variable Usage**: See how variables make configurations flexible
3. **State Management**: Observe how Terraform tracks resource state
4. **Local Development**: Experience the fast feedback loop with local tools
5. **Multi-Provider**: Learn to work with multiple Terraform providers

## Next Steps

- Try deploying to a real cloud environment
- Add modules to organize your code
- Experiment with different resource configurations
- Add validation and testing