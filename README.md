# Hack Zurich Infra

PoC to build an infrastructure on AWS.

## Contributing

You need the following software instaled to be able to deploy the infrastructure:

- [aws cli](https://aws.amazon.com/cli/) configured with your access key
- [terraform](https://www.terraform.io/)

Run `terraform init` to install the dependencies.

## Playing with the infrastructure

1. Rename `terraform.tfvars.example` file into `terraform.tfvars` and edit it following your needs
2. Run `terraform validate` to validate your configuration and make sure it is runnable
3. Run `terraform plan` to check what actions need to be performed to reach the desired state
4. Run `terraform apply` to perform actions to reach the desired state (create/delete/update resources)
5. Run `terraform destroy` to destroy your infrastructure
