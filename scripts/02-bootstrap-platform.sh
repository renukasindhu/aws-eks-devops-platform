#!/bin/bash

set -e

echo "===================================================="
echo " AWS EKS DevOps Platform Bootstrap"
echo "===================================================="

# ----------------------------------------------------
# Check Required Commands
# ----------------------------------------------------

echo ""
echo "Checking required tools..."

REQUIRED_TOOLS=("aws" "kubectl" "helm" "eksctl")

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null
    then
        echo "ERROR: $tool is not installed."
        echo "Run setup-environment.sh first."
        exit 1
    fi
done

echo "All required tools are installed."

# ----------------------------------------------------
# AWS Credentials
# ----------------------------------------------------

echo ""
echo "Verifying AWS credentials..."

if ! aws sts get-caller-identity > /dev/null 2>&1
then
    echo ""
    echo "AWS CLI is not configured."
    echo ""
    echo "Run:"
    echo "aws configure"
    exit 1
fi

echo "AWS credentials verified."

# ----------------------------------------------------
# Cluster Information
# ----------------------------------------------------

echo ""
read -p "AWS Region: " REGION
read -p "EKS Cluster Name: " CLUSTER_NAME

echo ""
echo "Updating kubeconfig..."

aws eks update-kubeconfig \
--region "$REGION" \
--name "$CLUSTER_NAME"

echo "Connected to cluster."

# ----------------------------------------------------
# Verify Cluster
# ----------------------------------------------------

echo ""
echo "Cluster Information"

kubectl get nodes

echo ""
kubectl get ns

# ----------------------------------------------------
# Associate IAM OIDC Provider
# ----------------------------------------------------

echo ""
echo "Associating IAM OIDC Provider..."

eksctl utils associate-iam-oidc-provider \
--region "$REGION" \
--cluster "$CLUSTER_NAME" \
--approve

echo "OIDC Provider configured."

# ----------------------------------------------------
# Install AWS Load Balancer Controller
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "AWS Load Balancer Controller"
echo "=========================================="

echo ""
echo "Follow the official AWS documentation:"
echo "https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html"

echo ""
read -p "Press ENTER after completing the installation..."

kubectl get deployment -n kube-system

# ----------------------------------------------------
# Install Amazon EBS CSI Driver
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "Amazon EBS CSI Driver"
echo "=========================================="

echo ""
echo "Install the Amazon EBS CSI Driver."

read -p "Press ENTER after installation..."

kubectl get pods -n kube-system

# ----------------------------------------------------
# Install Argo CD
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "Argo CD"
echo "=========================================="

echo ""
echo "Installing Argo CD..."

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo ""
echo "Waiting for Argo CD..."

kubectl wait \
--for=condition=available \
deployment/argocd-server \
-n argocd \
--timeout=300s

echo "Argo CD installed."

# ----------------------------------------------------
# Monitoring Stack
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "Monitoring Stack"
echo "=========================================="

echo ""
echo "Install:"

echo "- Prometheus"
echo "- Grafana"
echo "- Alertmanager"

echo ""
read -p "Press ENTER after installation..."

# ----------------------------------------------------
# Logging Stack
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "Logging Stack"
echo "=========================================="

echo ""
echo "Install:"

echo "- Elasticsearch"
echo "- Kibana"
echo "- Fluent Bit"

echo ""
read -p "Press ENTER after installation..."

# ----------------------------------------------------
# Final Verification
# ----------------------------------------------------

echo ""
echo "=========================================="
echo "Verification"
echo "=========================================="

echo ""
kubectl get nodes

echo ""
kubectl get pods -A

echo ""
kubectl get svc -A

echo ""
helm list -A

# ----------------------------------------------------
# Complete
# ----------------------------------------------------

echo ""
echo "===================================================="
echo " Bootstrap Completed Successfully"
echo "===================================================="

echo ""
echo "Installed / Configured"

echo "✔ IAM OIDC Provider"
echo "✔ AWS Load Balancer Controller"
echo "✔ Amazon EBS CSI Driver"
echo "✔ Argo CD"
echo "✔ Monitoring Stack"
echo "✔ Logging Stack"

echo ""
echo "Next Steps"

echo "1. Deploy Backend"
echo "2. Deploy Frontend"
echo "3. Configure Route 53"
echo "4. Validate Monitoring"
echo "5. Validate Logging"

echo ""
echo "Happy Deploying!"
