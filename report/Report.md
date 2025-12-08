# DevSecOps Assignment – Security & Compliance Summary

## 1. Objective
This assignment demonstrates an end-to-end DevSecOps workflow including:

- Secure Docker image hardening
- CI/CD pipeline with security scanning
- Terraform-based EKS infrastructure simulation
- Kubernetes hardening
- Basic observability practices

---

## 2. Risks Identified
- Docker build fails in GitHub Actions due to missing application files
- Terraform IAM role allows admin permissions (demo purpose)
- Kubernetes manifests do not include a real application (simulation only)

---

## 3. Hardening Implemented
- Docker:
  - Multi-stage build
  - Minimal base image (Alpine + Distroless)
  - Non-root user
  - Trivy scan results documented

- CI/CD Pipeline:
  - Static code analysis (Semgrep)
  - Docker security scanning (Trivy)
  - Critical vulnerabilities fail the pipeline

- Terraform (EKS Simulation):
  - VPC, subnet, IAM roles, and EKS cluster defined
  - tfsec scan documented
  - Valid Terraform syntax

- Kubernetes:
  - Deployment, Service, NetworkPolicy manifests
  - PodSecurityContext with non-root user
  - Resource requests and limits
  - Namespace isolation

---

## 4. Remaining Improvements Before Production
- Add actual application code to Docker build
- Connect Terraform simulation to real AWS account
- Deploy Kubernetes manifests on a live cluster
- Add observability tools like Prometheus, ELK, or Datadog
- Enhance NetworkPolicies and PodDisruptionBudgets

---

## 5. Notes
- All steps are documented and tested in GitHub-only simulation
- Security scans (Trivy, tfsec) are attached as proof of DevSecOps practices
- This setup demonstrates a full DevSecOps workflow suitable for learning and assessment purposes
