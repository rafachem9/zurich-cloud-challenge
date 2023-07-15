provider "aws" {

  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  region                      = "us-east-1"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true


  endpoints {
    s3             = "http://s3.172.21.0.2.localstack.cloud:4566"
    lambda         = "http://172.21.0.2:4566"
    dynamodb        = "http://172.21.0.2:4566"
    ec2            = "http://172.21.0.2:4566"
  }
}
resource "aws_apprunner_auto_scaling_configuration_version" "hello" {
  auto_scaling_configuration_name = "hello"  # scale between 1-5 containers
  min_size = 1
  max_size = 5
}
resource "aws_apprunner_service" "hello" {

  service_name = "hello-app-runner"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8000"
      }

      image_identifier       = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }

    auto_deployments_enabled = false
  }
}
output "apprunner_service_hello" {
  value = aws_apprunner_service.hello
}