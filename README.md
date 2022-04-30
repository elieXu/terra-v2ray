# terra-v2ray

This repo is for hosting tf files for setting up v2ray server via Terraform.

## Prerequisites 
### AWS

1. Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html). 
2. Your AWS credentials configured locally.
```bash
aws configure
```

Follow the prompts to input your AWS Access Key ID and Secret Access Key, which you'll find on [this page](https://console.aws.amazon.com/iam/home?#security_credential).

The configuration process creates a file at `~/.aws/credentials` on MacOS and Linux or `~/.aws/credentials` on Windows, where your credentials are stored.


## Initialize the directory

1. Initialize the directory. Go into the directory for the specific provider and region and run 
```bash
terraform init
```
2. Create infrastructure. Run
```bash
terraform apply
```

## Destory
1. Go into the directory for the specific provider and region and run 
```bash
terryform destroy
```

## debug info

Latest v2ray server may not work, need to install specific version
v2ray -config /usr/local/etc/v2ray/config.json
systemctl stop firewalld.service
open port in security group
set timezone same as local machine - Asia/Shanghai


