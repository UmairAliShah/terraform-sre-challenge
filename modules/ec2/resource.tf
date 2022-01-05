# @author: Syed Umair Ali
# @since: 31 December, 2021
# @description: Generic Terraform EC2 Module
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance

module "ec2_instance" {
  source                        = "terraform-aws-modules/ec2-instance/aws"
  version                       = "3.3.0"
  name                          = var.name

  ami                           = var.ami
  instance_type                 = var.instance_type
  key_name                      = var.key_name
  monitoring                    = var.monitoring
  vpc_security_group_ids        = var.vpc_security_group_ids
  subnet_id                     = var.subnet_id
  iam_instance_profile          = var.iam_instance_profile
  associate_public_ip_address   = var.associate_public_ip_address
  root_block_device             = var.root_block_device
  
  tags = merge(
    var.common_tags,
    {
      Name          = var.name
    }
  )
}


resource "aws_eip" "eip" {
  count = var.enable_eip ? 1 : 0
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  count = var.enable_eip ? 1 : 0
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.eip[0].id
}
