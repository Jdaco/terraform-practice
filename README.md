# Terraform Practice Project

## Requirements

### Tools
1. `terraform`
2. AWS CLI

### Setup
1. Create an AWS account to start testing with
2. Store the [terraform remote state](https://www.terraform.io/language/state/remote) in [s3](https://www.terraform.io/language/settings/backends/s3)
    - You'll need an **S3 Bucket** and a DynamoDB table for this. It's alright to create these manually
    - Once you have those created, you can add this to your terraform code to use the remote state
    ```terraform
    terraform {
        backend "s3" {
        bucket = "mybucket"
        key    = "main.tfstate"
        region = "us-east-1"
        }
    }
    ```

### Terraform
1. Create a VPC with a public subnet (probably best to use [this module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) for that)
2. Create an [ECS cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) and [Service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) that will run a container in your public subnet (we'll use the `sonatype/nexus3` container from [dockerhub](https://hub.docker.com/r/sonatype/nexus3))
    - If this is done successfully, you should be able to see the webpage for that service by navigating your browser to the public DNS name / IP address of your service
    - Use [AWS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html) as your capacity provider for the cluster (it's the easiest)
3. Make sure all of the logs for that service are going to a [Cloudwatch Log Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)

### Structure
You can structure your terraform files however you like, but you'll need at least one `main.tf` file
