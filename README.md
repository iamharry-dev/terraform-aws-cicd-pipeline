# 🔄 Terraform AWS CI/CD Pipeline

Automated AWS application delivery with **Terraform**, **Docker**, and **CI/CD**. This project builds a pipeline that tests a Python application, builds a Docker image, pushes it to **Amazon ECR**, and provisions the deployment host — all defined as code.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)

---

## 📌 What this demonstrates

- **Test → Build → Push → Deploy** pipeline for a containerized Python app
- **Amazon ECR** repository with image scanning and a lifecycle policy
- **GitHub Actions OIDC** — passwordless, key-less AWS authentication
- **Jenkins** declarative pipeline as an alternative CI runner
- **Terraform** provisions the registry, IAM roles, artifacts bucket, and an EC2 deployment host

## 🏗️ Architecture

```
   git push ──▶ ┌────────────────────────┐
                │  GitHub Actions /      │
                │  Jenkins Pipeline      │
                └───────────┬────────────┘
                            │ 1. test  2. build image
                            ▼
                ┌────────────────────────┐
                │      Amazon ECR        │
                └───────────┬────────────┘
                            │ 3. push
                            ▼
                ┌────────────────────────┐
                │  EC2 deployment host   │◀── IAM (ECR read, SSM)
                │  runs Docker container │
                └────────────────────────┘
```

## 📁 Repository Structure

```
terraform-aws-cicd-pipeline/
├── app/
│   ├── main.py                # Sample Flask app
│   ├── requirements.txt
│   └── tests/test_app.py
├── infra/
│   ├── providers.tf
│   ├── main.tf                # ECR, IAM OIDC, S3 artifacts, EC2 host
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── scripts/
│   └── health_check.sh
├── Dockerfile
├── Jenkinsfile
├── .github/workflows/deploy.yml
└── README.md
```

## ✅ Prerequisites

- Terraform >= 1.5, Docker, and AWS credentials
- Python 3.11+ (for local runs)

## 🚀 Usage

### 1. Run the app and tests locally

```bash
pip install -r app/requirements.txt
python app/main.py
pytest -q
```

### 2. Provision infrastructure

```bash
cd infra
terraform init
cp terraform.tfvars.example terraform.tfvars
terraform apply -auto-approve
```

Note the outputs — especially `github_actions_role_arn` and `ecr_repository_url`.

### 3. Configure CI

For GitHub Actions, add the role ARN as a repository secret:

```
AWS_ROLE_ARN = <github_actions_role_arn output>
```

The workflow assumes this role via OIDC — no long-lived AWS keys required.

## ⚙️ Key Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `ap-south-1` |
| `project_name` | Resource name prefix | `cicd-pipeline` |
| `github_repo` | Repo allowed to assume the deploy role | `iamharry-dev/terraform-aws-cicd-pipeline` |
| `instance_type` | Deployment host size | `t3.micro` |
| `app_port` | Application port | `8000` |

## 🔐 Security Notes

- Uses **OIDC federation** instead of static AWS access keys
- ECR image scanning on push; lifecycle policy keeps the last 10 images
- Deployment host has least-privilege IAM (ECR read + SSM only)

## 📄 License

Released under the MIT License.

---

⭐ If you find this useful, please consider giving it a star.
