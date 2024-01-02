terraform {
  backend "s3"{
    bucket = "pv24-terraform-state"
    key    = "misc/jenkins-ip-update/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_instance" "jenkins" {
  instance_id = "i-02ed0bfb289519a7b"
}

resource "aws_route53_record" "jenkins" {
  name    = "jenkins"
  type    = "A"
  zone_id = "Z017218723D63YD2W9JSZ"
  ttl = 10
  records = [data.aws_instance.jenkins.public_ip]
}