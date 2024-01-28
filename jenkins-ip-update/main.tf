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

data "aws_instance" "artifactory" {
  instance_id = "i-0d9dcbc0cb9e4af34"
}

resource "aws_route53_record" "artifactory" {
  name    = "artifactory"
  type    = "A"
  zone_id = "Z017218723D63YD2W9JSZ"
  ttl = 10
  records = [data.aws_instance.artifactory.public_ip]
}

data "aws_instance" "elk" {
  instance_id = "i-0dab5334ba634046e"
}

resource "aws_route53_record" "elk" {
  name    = "elasticsearch"
  type    = "A"
  zone_id = "Z017218723D63YD2W9JSZ"
  ttl = 10
  records = [data.aws_instance.elk.public_ip]
}

data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

resource "aws_instance" "load-gen" {
  ami = data.aws_ami.ami.image_id
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-05c45d4106139409c"]
  tags = {
    Name = "load-gen"
  }
}