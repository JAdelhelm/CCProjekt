# AWS-TERRAFORM-COURSE

In this repo we collect terraform examples for the aws terraform course.

## Prerequisites

Please install the following tools/packages/plugins.

### Install terraform linter

1. vscode marketplace: `hashicorp terraform plugin`

### Create iam account

1. open aws management console
2. go to iam console + create user with admin permissions
3. find aws access and secret key --> copy
4. copy account id

### Install aws cli

[https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Configure aws cli

[https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config)

1. `aws configure` --> access, secret key + default region

### Install terraform

1. Download zip from [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
2. unzip binary
3. `mv` to `/usr/local/bin` or any path which is included in $PATH


## Terraform Workspaces

1. Create new workspace with: `terraform workspace new <WORKSPACE_NAME>`
[https://www.terraform.io/language/state/workspaces](https://www.terraform.io/language/state/workspaces)