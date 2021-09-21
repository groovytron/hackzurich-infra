# Hack Zurich Infra

PoC to build an infrastructure on AWS.

## Contributing

You need the following software instaled to be able to deploy the infrastructure:

- [aws cli](https://aws.amazon.com/cli/) configured with your access key
- [terraform](https://www.terraform.io/)

Run `terraform init` to install the dependencies.

## Playing with the infrastructure

1. Run `terraform validate` to validate your configuration and make sure it is runnable
2. Run `terraform plan` to check what actions need to be performed to reach the desired state
3. Run `terraform apply` to perform actions to reach the desired state (create/delete/update resources)
4. Run `terraform destroy` to destroy your infrastructure
