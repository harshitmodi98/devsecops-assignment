## CI/CD Pipeline Notes

The Docker image build step fails during pipeline execution.

Reason:
- This repository does not contain a runnable Node.js application.
- The pipeline is created to demonstrate security scanning and gating logic only.

Impact:
- This does not affect the demonstration of DevSecOps concepts.
- Security tools (Semgrep, Trivy) are correctly integrated into the pipeline.

Note:
In a real-world project, application source files would be present and the pipeline would pass successfully.
