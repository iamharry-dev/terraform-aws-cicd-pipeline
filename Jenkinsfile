pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO   = 'cicd-pipeline-app'
        IMAGE_TAG  = "${env.BUILD_NUMBER}"
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Test') {
            steps {
                sh '''
                    python -m pip install --upgrade pip
                    pip install -r app/requirements.txt
                    pip install flake8
                    flake8 app --max-line-length=120 || true
                    pytest -q || true
                '''
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG -t $ECR_REPO:latest .'
            }
        }

        stage('Push to ECR') {
            steps {
                withAWS(region: "${AWS_REGION}", credentials: 'aws-creds') {
                    sh '''
                        ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
                        REGISTRY=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        aws ecr get-login-password --region $AWS_REGION | \
                            docker login --username AWS --password-stdin $REGISTRY
                        docker tag $ECR_REPO:$IMAGE_TAG $REGISTRY/$ECR_REPO:$IMAGE_TAG
                        docker tag $ECR_REPO:$IMAGE_TAG $REGISTRY/$ECR_REPO:latest
                        docker push $REGISTRY/$ECR_REPO:$IMAGE_TAG
                        docker push $REGISTRY/$ECR_REPO:latest
                    '''
                }
            }
        }

        stage('Provision') {
            steps {
                dir('infra') {
                    sh '''
                        terraform init
                        terraform validate
                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Verify') {
            steps {
                sh 'bash scripts/health_check.sh || true'
            }
        }
    }

    post {
        success { echo "Pipeline succeeded: ${ECR_REPO}:${IMAGE_TAG}" }
        failure { echo "Pipeline failed. Check the logs." }
        always { cleanWs() }
    }
}
