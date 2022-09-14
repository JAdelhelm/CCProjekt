# Basic Commands

Work closely with the docs:

* [https://registry.terraform.io/providers/hashicorp/aws/latest/docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [https://www.terraform.io/language](https://www.terraform.io/language)

1. `terraform init [-reconfigure -upgrade]`
2. `terraform plan` or `terraform plan -out=plan`
    - terraform plan -out=plan, zeigt die Änderungen auf, bevor applyt wird (sicherer)
3. `terraform apply`
4. `terraform destroy`

## Environment Variables

terraform.tfvars will be detected automatically

1. `export TF_VAR_variable_name=value`
2. `-var` behind a command like `terraform plan -var VARIABLE_NAME=VARIABLE_VALUE`
3. `-var-file` behind a command like `terraform plan -var-file VARIABLE_FILE.tfvars`

## Hints

1. Use unique s3 bucket names, e.g. starting with your domain
2. To use `terraform graph` install graphviz, then save graph with `terraform graph | dot -Tsvg > graph.svg` or just execute `terraform graph`, copy the result from terminal output and paste into [https://dreampuf.github.io/GraphvizOnline](https://dreampuf.github.io/GraphvizOnline)

## AWS CLI

1. Delete all objects in bucket: `aws s3 rm s3://<BUCKET_NAME> --recursive`
