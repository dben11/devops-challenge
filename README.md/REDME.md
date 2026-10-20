# Production-Ready DevOps Challenge

## 1. Architecture Overview

This project deploys a containerized Python (Flask) application to AWS using a highly available, production-ready architecture. 

### High-Level Flow
`User -> Application Load Balancer (ALB) -> ECS Fargate (2 Tasks) -> Docker Container (Flask)`

### Architecture Diagram
*(https://drive.google.com/file/d/1mv5rbRhEMo_TzKW6OoUBhHh3vwQrKmD-/view?usp=sharing)*
- **VPC:** `10.0.0.0/16` CIDR block with DNS hostnames enabled.
- **Subnets:** 2 Public Subnets across 2 Availability Zones (`us-east-1a`, `us-east-1b`) for high availability.
- **Compute:** AWS ECS Fargate (Serverless containers) running 2 tasks of the application.
- **Load Balancing:** An internet-facing ALB routes HTTP traffic (port 80) to the containers. It performs health checks on the `/health` endpoint to ensure zero-downtime deployments.
- **Registry:** Amazon ECR stores the versioned Docker images.
- **CI/CD:** GitHub Actions pipeline handles the build, push, and rolling deployment.
- **Observability:** CloudWatch Logs capture container stdout/stderr, and Container Insights is enabled on the ECS cluster.

## 2. Deployment Steps

This project is designed to be fully automated. 

### Prerequisites
- AWS CLI configured with AdministratorAccess.
- Terraform installed (v1.6+).
- Docker installed.
- A GitHub repository.

### Phase 1: Infrastructure Provisioning (One-time setup)
1. Navigate to the bootstrap directory:
   ```bash
   cd terraform/bootstrap
