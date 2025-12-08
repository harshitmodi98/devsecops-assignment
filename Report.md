# Security & Compliance Report

This document outlines the security posture of the sample Node.js + MongoDB microservice, its containerization approach, Terraform-based EKS simulation, and Kubernetes deployment strategy.  
It includes identified risks, implemented hardening measures, and recommendations to achieve production-level readiness.

---

## 1. Overview

This project demonstrates a complete DevSecOps workflow across:

- **Application Security** → Node.js app with basic health endpoint.
- **Container Security** → Hardened Dockerfile with multi-stage build + non-root execution.
- **CI/CD Security** → GitHub Actions pipeline enforcing security gates.
- **IaC Security** → Terraform-based VPC + EKS simulation with tfsec & Checkov scanning.
- **Kubernetes Security** → Namespaced deployment, non-root pods, resource controls.
- **Image & Code Scanning** → Semgrep, Trivy, Terraform validation, tfsec, Checkov.
- **Supply Chain Protection** → CI prevents publishing unsafe images.

✔ Objective achieved: showcase how an application can be securely built, scanned, validated, and deployed.

---

## 2. Risks Identified During Security Scanning

### 2.1 Container Image Risks (Trivy)

Common issues identified:

- High/Critical CVEs in Alpine base layer (musl, openssl, zlib).
- Medium-level vulnerabilities in Node.js package dependencies.
- General container hardening gaps (capabilities, user privileges).

**Mitigations Applied:**

- Implemented **multi-stage build** to reduce final image size and attack surface.
- Forced execution using **non-root user**.
- **Dropped all Linux capabilities** for least privilege.
- CI pipeline **fails if any HIGH/CRITICAL vulnerabilities** are detected.
- Switched to minimal `node:18-alpine` for reduced footprint.

---

### 2.2 Application Code Risks (Semgrep)

Static analysis highlighted:

- Missing validation for user input fields.
- No rate-limiting or auth on routes (acceptable for demo scope).
- Lack of granular error-handling patterns.

**Mitigations Applied:**

- Simplified but structured routing for future middleware validation.
- Semgrep scan now runs on every push or PR.
- CI blocks the pipeline if Semgrep reports violations under “CI” ruleset.

---

### 2.3 Terraform Risks (tfsec + Checkov)

Scans identified:

- IAM roles rely on AWS-managed policies → broad permissions.
- Public subnets flagged due to open route to internet.
- Missing explicit encryption/rotation settings in EKS components.
- Absence of SG rules (simplified because real AWS infra not provisioned).

**Mitigations Applied:**

- Introduced module-level isolation (VPC & EKS separated cleanly).
- Added consistent tagging for traceability.
- Ensured Terraform formatting, validation, and security scans run as part of CI.
- Documented improvements required for production (below).

---

### 2.4 Kubernetes Risks & Hardening

Initial risks:

- Pods could run as root.
- Possible privilege escalation.
- No network isolation (default allow).
- No resource limits → risk of node starvation.
- Insufficient availability controls.

**Mitigations Applied:**

- Applied strong `securityContext`:
  - `runAsNonRoot: true`
  - `allowPrivilegeEscalation: false`
  - Dropping all capabilities.
- Added **resource requests & limits** for CPU/Memory.
- Created **PodDisruptionBudget** ensuring 2 pods remain available.
- Added **HorizontalPodAutoscaler** (autoscaling on CPU).
- Added **NetworkPolicy default-deny** for namespace isolation.

---

## 3. End-to-End Security Gates (CI/CD)

The CI/CD pipeline enforces multiple security gates:

### ✔ Static Code Analysis (Semgrep)
Blocks build on risky patterns.

### ✔ Supply Chain / Dependency Security
`npm ci` ensures clean reproducible builds.

### ✔ Container Scanning with Trivy
Blocks pipeline on HIGH / CRITICAL vulnerabilities.

### ✔ Infrastructure Scanning
- `terraform validate`
- `tfsec .`
- `checkov -d .`

### ✔ Kubernetes YAML Validation
`kubectl apply --dry-run=client -f k8s/`

### ✔ Secure Artifact Publishing
Docker images are pushed to **GHCR only when all gates pass**, enforced by:

```yaml
if: success()
