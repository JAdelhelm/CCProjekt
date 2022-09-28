# File Converter

This Python Lambda App converts YAML files from S3 into JSON and uploads the result again to S3.

Good entrypoint for python lambda function development: [https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html](https://docs.aws.amazon.com/lambda/latest/dg/python-handler.html)

## Package Lambda App

We need dependecies like PyYaml --> means we have to provide a custom python environment [https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-create-package-with-dependency](https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-create-package-with-dependency)

1. package zip file with: `bash package.sh`
