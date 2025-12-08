# DevSecOps Candidate Task – Node.js + MongoDB on Kubernetes

This repo shows how I would build and secure a small Node.js/Express + MongoDB service running on Kubernetes, with Terraform simulating an EKS-style setup and a CI pipeline enforcing security gates.

---

## 1. Project Structure

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
