# Setup guide

FYSA - I'm using a Macbook Air with an M2 chip and 16 GB of memory. In lieu of Docker Desktop, I'm running [Colima](https://github.com/abiosoft/colima), and I'm using VS Code as a code editor. 

### Terraform
```bash
```Using Homebrew (recommended for M2 Mac)
brew install terraform

# Verify installation
terraform version
```

### Kind (Kubernetes in Docker)
```bash
brew install kind

# Verify installation
kind version
```

### kubectl (Kubernetes CLI)
```bash
brew install kubectl

# Verify installation
kubectl version --client
```

### LocalStack
```bash
# Install LocalStack CLI
brew install localstack/tap/localstack-cli

# Verify installation
localstack --version
```

### Helm (for Kubernetes package management)
```bash
brew install helm

# Verify installation
helm version
```

### VS Code Extensions
Install these extensions for the best development experience:

* HashiCorp Terraform - Syntax highlighting, validation, formatting
* Kubernetes - YAML support, cluster management
* YAML - Better YAML editing for Kubernetes manifests
* GitLens - Git integration (helpful for pipeline work later)
* Thunder Client - API testing (useful for LocalStack endpoints)

## Optional but Recommended

### tfenv (Terraform version manager)
```bash
brew install tfenv
```

### awscli-local (for LocalStack)
```bash
pip3 install awscli-local
# Provides 'awslocal' command for easier LocalStack interaction
```

### jq (JSON processor)
```bash
brew install jq
# Useful for parsing Terraform outputs and API responses. You _should_ have this installed anyway
```

