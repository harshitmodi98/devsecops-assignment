📌 1. Project Structure
devsecops-assignment/
├── Dockerfile
├── package.json
├── src/
│   └── index.js
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── networkpolicy.yaml
│   ├── pdb.yaml
│   └── hpa.yaml
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── modules/
│       ├── vpc/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── eks/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── .github/
│   └── workflows/
│       └── ci.yml
├── Report.md

🐳 2. Docker & Image Hardening
✔ Multi-stage Docker build
✔ Minimal base (node:18-alpine + Distroless)
✔ Non-root user
✔ Trivy scan enforced in CI pipeline
Build locally:
docker build -t mynodeapp:latest .

Scan locally:
trivy image mynodeapp:latest

🔐 3. CI/CD Pipeline Security (GitHub Actions)

Path: .github/workflows/ci.yml

Pipeline includes:

✔ Semgrep – SAST scanning
✔ Trivy – Container scanning
✔ Terraform validate
✔ tfsec + Checkov – IaC scanning
✔ K8s YAML validation (dry-run)
✔ Build fails if HIGH/CRITICAL vulnerabilities found
✔ Artifacts/images only pushed when all gates pass

Run Node tests locally:
npm install
npm test


IMPORTANT: Add SEMGREP_APP_TOKEN inside GitHub Secrets
Repo → Settings → Secrets → Actions.

☁️ 4. Terraform – EKS Simulation (Local Only)

Terraform simulates a real AWS EKS architecture without requiring an AWS account.

Resources Modeled:

VPC

Public & Private Subnets

Internet Gateway

Route Tables

IAM Roles for EKS

EKS Cluster (simulated)

Worker Node Group

Run Terraform locally:
cd terraform
terraform init -backend=false
terraform validate

Security Scans:
tfsec .
checkov -d .

Optional (no AWS needed):
terraform plan -refresh=false

🔎 How Terraform Maps to Real AWS EKS
Terraform Resource	AWS Equivalent
aws_vpc	Amazon VPC
aws_subnet.public	Public Subnet
aws_subnet.private	Private Node Subnets
aws_internet_gateway	IGW
aws_route_table	Route Table
aws_iam_role.eks_cluster_role	IAM Role for EKS Control Plane
aws_eks_cluster	EKS Control Plane
aws_eks_node_group	EC2 Worker Nodes

Terraform validates the IaC and simulates AWS infrastructure but does not create real resources.

☸️ 5. Kubernetes Deployment + Hardening

All manifests are inside /k8s.

Includes:

✔ Namespace
✔ Deployment
✔ Service
✔ Ingress
✔ NetworkPolicy
✔ HorizontalPodAutoscaler
✔ PodDisruptionBudget

Security Hardening Features:

runAsNonRoot: true

allowPrivilegeEscalation: false

Drop Linux capabilities

livenessProbe & readinessProbe

Resource limits (CPU/Memory)

Validate manifests:
kubectl apply --dry-run=client -f k8s/

Run on local cluster:
minikube start
kubectl apply -f k8s/
kubectl get pods -n app-prod

📊 6. Observability (Optional Enhancements)

Potential add-ons:

Prometheus annotations for scraping

CPU/Memory alerts

Loki logs integration

Pod restart alert configuration

(Not mandatory but adds DevOps maturity.)

📝 7. Security & Compliance Summary

See Report.md for:

✔ Vulnerabilities found
✔ Fixes applied
✔ Remaining risks
✔ Production hardening recommendations

📦 8. How to Run All Components
Install dependencies:
npm install

Build + scan container:
docker build -t mynodeapp:ci .
trivy image mynodeapp:ci

Terraform security:
terraform validate
tfsec .
checkov -d .

Kubernetes validation:
kubectl apply --dry-run=client -f k8s/

📤 9. Submission Instructions

You only need to submit the GitHub repo link:

👉 https://github.com/harshitmodi98/devsecops-assignment

This repository already includes:

✔ Dockerfile
✔ CI pipeline
✔ Kubernetes manifests
✔ Terraform EKS simulation
✔ Security scans
✔ Report.md
✔ README (this file)

Everything required by the assignment is complete and validated.