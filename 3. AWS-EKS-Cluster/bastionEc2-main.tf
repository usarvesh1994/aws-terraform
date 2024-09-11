#Fetching AMI
data "aws_ami" "example" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/*-amd64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name                = "${local.name}-bastion-sg"
  description         = "Security group for Bastion host"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
  tags                = local.common_tags
}

module "ec2-bastion-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name = "${local.name}-bastionHost"

  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [module.security-group.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = local.common_tags
}

resource "aws_eip" "bastion_eip" {
  instance   = module.ec2-bastion-instance.id
  tags       = local.common_tags
  domain     = "vpc"
  depends_on = [module.vpc, module.ec2-bastion-instance]
}

resource "null_resource" "copy_keys" {

  depends_on = [module.ec2-bastion-instance]

  connection {
    type        = "ssh"
    host        = module.ec2-bastion-instance.public_ip
    user        = "ec2-user"
    private_key = file("../../../../Downloads/devops.pem")
  }

  provisioner "file" {

    source      = "../../../../Downloads/devops.pem"
    destination = "/tmp/devops.pem"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 400 /tmp/devops.pem"]
  }

}
