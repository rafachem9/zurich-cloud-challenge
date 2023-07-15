## Block 1:
### Part 2: Create and automated a CI/CD pipeline using Jenkins and Gogs. Gogs is a described as a self-hosted Git service. The CI/CD pipeline should do the following:
- To address the challenge, the following changes have been made:
  - docker-compose.yaml
      - Change the port of "github_local" to 3000 (otherwise, it will cause connection issues).
  - Jenkins takes a long time to become active (URL http://localhost:8000/).
  - To connect Jenkins and Gogs, the following tutorial was used:  https://medium.com/@salohyprivat/getting-gogs-and-jenkins-working-together-5e0f21377bcd.
      - Jenkins configuration:
          - Install the Gogs plugin.
          - Configure SSH to create a public and private key pair.
          - Create a Jenkins pipeline.
              - Build Triggers: Select "Build when a change is pushed to Gogs".
              - Pipeline: Pipeline script from SCM.
                  - Repository URL: http://172.21.0.4:3000/rafachem9/test-repo.git.
                  - Credentials: SSH.
      - Gogs' configuration, accessible at http://localhost:3000:
          - Create a repository.
          - Go to Settings -> Webhooks.
              - Payload URL: http://172.21.0.1:8000/gogs-webhook/?job={jenkins-pipeline-name}.
              - You can test it with "Test_Delivery".
  - In the "example-repo" repository, you will find the necessary files to build the pipeline.
      - deploy/main.tf:
          - Terraform code to create EC2 instances to address Part 1. Since I'm not familiar with creating EC2 instances, I asked look for a sample Terraform file.
      - Jenkinsfile:
          - A pipeline has been created that is ready to fetch the Jenkinsfile from the git repository.
          - In the "Terraform apply" stage, the viability of the project and any new changes are checked. In case of an error, the Jenkins pipeline is stopped.

## Block 2:
### Part 2: is about creating an IaC project infrastructure as professional as possible for a simple problem. The problem is being able to efficiently scale a WebApp for uploading images into an S3 AWS bucket.

- Option 1: Using App Runner with horizontal scaling:
  - App Runner is an AWS fully managed service that simplifies the deployment of containerized applications. It enables quick and easy deployment, eliminating the need to worry about underlying environment configuration. For this scenario, it is recommended to configure App Runner with horizontal scaling, allowing for the addition of more application instances as needed to handle increased request volume. By utilizing a Docker image located in the "app" folder, the application can be deployed and automatically scaled based on the demands of the business.
- Option 2: Using ECS and Fargate with auto scaling:
  - In this approach, the application would be deployed to ECS, the AWS container service, leveraging the auto scaling functionality provided by ECS. By appropriately configuring auto scaling policies, ECS can continuously monitor the application's traffic and load, automatically adjusting the number of instances as necessary to maintain optimal performance. This approach enables efficient management of incoming requests and ensures sufficient capacity to handle traffic spikes effectively.