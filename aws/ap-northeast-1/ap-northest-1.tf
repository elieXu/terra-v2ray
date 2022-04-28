terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_key_pair" "v2ray" {
  key_name   = "v2raykey"
  public_key = file("~/.ssh/terraform.pub")
}

resource "aws_instance" "v2ray" {
  key_name      = aws_key_pair.v2ray.key_name
  ami           = "ami-03b993a5a631b0050"
  instance_type = "t2.micro"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.v2ray.public_ip} > ip_address.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh",
      "curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh",
      "sudo bash install-release.sh --version v4.24.0",
      "sudo bash install-dat-release.sh",
      "sudo systemctl enable v2ray",
      "sudo systemctl start v2ray"
    ]
  }

  provisioner "file" {
    source      = "../../config/config.json"
    destination = "/tmp/config.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/config.json /usr/local/etc/v2ray/config.json",
      "sudo systemctl restart v2ray"
    ]
  }
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.v2ray.id
}

output "ip" {
  value = aws_eip.ip.public_ip
}
