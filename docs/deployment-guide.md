# Deployment Guide
This guide explains how to deploy the AWS EKS DevOps Platform from infrastructure provisioning to application deployment and platform services.

---

# Prerequisites
Before deploying the project, ensure the following requirements are met: 
- AWS Account
- AWS CLI configured with appropriate permissions
- Git
- Docker
- Java 17
- Maven
- kubectl
- Helm
- eksctl
- Terraform

The repository includes a helper script to install the required tools. 
```bash
chmod +x scripts/setup-environment.sh
./scripts/setup-environment.sh
```

---

# Clone the Repository
```bash
git clone https://github.com/renukasindhu/aws-eks-devops-platform.git
cd aws-eks-devops-platform
```

---

# Configure AWS CLI
Configure AWS credentials before provisioning infrastructure. 
```bash
aws configure
```
Verify the active identity. 
```bash
aws sts get-caller-identity
```

---

# Provision Infrastructure using Terraform
Navigate to the Terraform directory. 
```bash
cd terraform
```

Initialize Terraform. 
```bash
terraform init
```

Review the execution plan. 
```bash
terraform plan
```

Provision the infrastructure. 
```bash
terraform apply
```

Terraform creates: 
- Amazon VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Amazon EKS Cluster
- Amazon EKS Managed Node Group
- Amazon RDS MySQL

---

# Configure EKS Access
Update the Kubernetes configuration. 
```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```
Verify cluster connectivity. 
```bash
kubectl get nodes
```

---

# Post-Provision Cluster Configuration
After Terraform provisioning, perform the following configuration tasks. \
- Associate IAM OIDC Provider
- Install AWS Load Balancer Controller
- Install Amazon EBS CSI Driver
- Import the Amazon EKS Cluster Security Group into Terraform
- Update the Amazon RDS Security Group to allow MySQL access from the EKS Cluster Security Group
- Configure the default StorageClass \
Verify the cluster before deploying workloads.

---

# Build and Push Docker Images
Build the backend and frontend Docker images. \
Push both images to Docker Hub. \
Update the Kubernetes manifests or Helm values with the correct image tags before deployment. 

---

# Deploy the Backend Application
Deploy the backend application using Helm. \
The backend Helm chart creates: 
- Namespace
- Deployment
- Service
- ConfigMap
- Secret \
Verify the deployment. 
```bash
kubectl get pods -n backend
```

---

# Deploy the Frontend Application
Deploy the frontend Kubernetes manifests. \
Verify the deployment. 
```bash
kubectl get pods -n frontend
```

---

# Configure Ingress
Deploy the NGINX Ingress resources. \
Verify that the AWS Application Load Balancer has been created.

---

# Configure DNS
Create Route 53 records for the Application Load Balancer. \
Configured subdomains include:
- Application
- Argo CD
- Prometheus
- Grafana
- Alertmanager
- Kibana \
Wait for DNS propagation.

---

# Configure Argo CD
Deploy Argo CD. \
Create the backend application. \
Enable automatic synchronization. \
Verify the application status from the Argo CD dashboard.

---

# Deploy Monitoring Stack
Install:
- Prometheus
- Grafana
- Alertmanager

Verify:
- Prometheus Targets
- Grafana Dashboards
- Alertmanager Status

---

# Deploy Logging Stack
Deploy:
- Fluent Bit
- Elasticsearch
- Kibana \
Verify that application logs appear in Kibana.

---

# Validate the Platform
Verify the following components.
- Terraform Infrastructure
- Amazon EKS Cluster
- Backend Application
- Frontend Application
- Amazon RDS Connectivity
- Helm Deployment
- Argo CD Synchronization
- Prometheus Metrics
- Grafana Dashboards
- Alertmanager Alerts
- Kibana Logs
- Route 53 DNS Resolution \
The platform is now ready for use.
