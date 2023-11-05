# terraform-3tier-alb-ecs-rds
This repository contains a Terraform project that creates an ECS cluster with Fargate, exposes services from ECS using ALB, and creates an RDS database, all using a 3-tier network architecture.

## Branching strategy
To keep it simple, this repository is using Trunk Based Development Strategy but without release branches, since we are creating a single environment right now.
![TrunkBasedDevelopment](https://trunkbaseddevelopment.com/trunk1c.png)

There is a main branch protected. This branch is connected to Terraform Cloud, so there are no GitHub Actions workflows applying Terraform commands, all this occurs on Terraform Cloud.

> We can use later Terraform Workspaces or different folders to provision other environments and better structure the project, and use Github Actions leveraging [Terraform Cloud Action](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions) to create a better flow, for example: use GitHub Actions Approvals or create GitHub Releases once a change is applied to prod.

To introduce changes to the main branch, a Pull Requests is needed to run some Github Actions checks on the Terraform project. This improves the quality and security without requiring too much manual review. The rules of the scanners can be modified as needed.


## Terraform Cloud
To make this project I used a Terraform Cloud Free tier.

- Connection to Github

The connection between Terraform Cloud and Github was made using Terraform's Github App, following this documentation: https://developer.hashicorp.com/terraform/cloud-docs/vcs/github-app

- Connection to AWS

The main branch is the only connected branch to Terraform Cloud.

![TerraformOIDCAWS](https://d2908q01vomqb2.cloudfront.net/77de68daecd823babbb58edb1c8e14d7106e83bb/2023/03/01/HashiCorp-Terraform-Provider-3.png)
*Image from AWS Blog

The connection between Terraform Cloud and AWS was made using OpenID Connect, so Terraform Cloud can assume an IAM Role on AWS without requiring to generate and rotate Access Keys. The configuration was made following this documentation: https://aws.amazon.com/es/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/

> For a quick setup I mostly used AWS-managed policies, but for better security, we can create our own policies like the ones I created for Parameter Store.

The IAM role created for Terraform Cloud is called _terraform-cloud-role_ and it has the following AWS-managed policies:
- ElasticLoadBalancingFullAccess
- AmazonVPCFullAccess
- AmazonRDSFullAccess
- AmazonECS_FullAccess
- AmazonRoute53FullAccess
- AWSCertificateManagerFullAccess
- IAMFullAccess

I also made some user-managed policies:
- ParameterStoreFullAccess

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ParameterStoreFullAccess",
            "Effect": "Allow",
            "Action": [
                "ssm:PutParameter",
                "ssm:LabelParameterVersion",
                "ssm:DeleteParameter",
                "ssm:DescribeParameters",
                "ssm:GetParameterHistory",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:DeleteParameters",
                "ssm:AddTagsToResource",
                "ssm:ListTagsForResource"
            ],
            "Resource": "*"
        }
    ]
}
```

We will need to set up the following environment variables. The AWS Terraform provider needs these to know which role is going to be use to apply changes.
![imagen](https://github.com/manraog/terraform-3tier-alb-ecs-rds/assets/5847960/f918e53a-f0f5-4632-a869-80f78d6156bb)

---------------

## Improvements


---------------
### References:
- https://developer.hashicorp.com/terraform/cloud-docs/vcs/github-app
- https://www.hashicorp.com/resources/a-practitioner-s-guide-to-using-hashicorp-terraform-cloud-with-github
- https://aws.amazon.com/es/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/
