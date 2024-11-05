
pipeline {
    agent any

    tools {
        terraform 'Terraform'  // Ensure Terraform is installed and configured
    }

    environment {
        // AWS credentials from Jenkins credentials store
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Git checkout from prod branch') {
            steps {
                echo 'Cloning project codebase...'
                git branch: 'main', url: 'https://github.com/ashleypearl-web/webapp-cicd-terraform.git'
                sh 'ls'  // List files to verify the checkout
            }
        }

        stage('Verifying AWS Configuration') {
            steps {
                echo 'Verifying AWS configuration...'
                sh 'aws s3 ls'  // Test if AWS CLI is configured correctly by listing S3 buckets
            }
        }

        stage('Verify Terraform Version') {
            steps {
                echo 'Verifying Terraform version...'
                sh 'terraform --version'  // Display the installed Terraform version
            }
        }

        stage('Terraform init') {
            steps {
                echo 'Initializing Terraform project...'
                sh 'terraform init'  // Initialize the Terraform working directory
            }
        }

        stage('Terraform validate') {
            steps {
                echo 'Code syntax checking with terraform validate...'
                sh 'terraform validate'  // Validate the Terraform configuration
                sh 'pwd'  // Display the current working directory (optional for debugging)
            }
        }

        stage('Terraform plan') {
            steps {
                echo 'Running terraform plan for the dry run...'
                sh 'terraform plan'  // Run Terraform plan (no need for -var-file if you're using variables.tf)
            }
        }

        stage('Terraform apply') {
            steps {
                echo 'Applying Terraform changes...'
                sh 'terraform apply --auto-approve'  // Apply the Terraform changes with auto-approve
            }
        }
    }
}
