# @author: Syed Umair Ali
# @since: 31 December, 2021
# @description: Application EC2 Server
# @license: All Rights Reserved to Raisin DS


locals {
  ec2s = {
    app-instance = {
      ami                         = var.raisin_app_instance_ami
      instance_type               = var.raisin_app_instance_type
      key_name                    = var.raisin_app_instance_key_name
      monitoring                  = true
      subnet_id                   = element(module.vpc.public_subnets, 0)
      enable_eip                  = true
      vpc_security_group_ids      = [module.app_ec2_sg.security_group_id]
      iam_instance_profile        = element(module.ec2_iam_role.ec2_instance_profile, 0)
      associate_public_ip_address = var.associate_public_ip_address
      root_block_device = [
        {
          volume_type = "gp2"
          delete_on_termination = true
          volume_size = var.raisin_app_instance_volume_size
        }
      ]
    }
  }
}

module "app_ec2_instance" {
  source                      = "./modules/ec2"

  for_each                    = local.ec2s

  name                        = "${each.key}-${terraform.workspace}"

  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = each.value.key_name
  monitoring                  = each.value.monitoring
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  subnet_id                   = each.value.subnet_id
  enable_eip                  = each.value.enable_eip
  iam_instance_profile        = each.value.iam_instance_profile
  associate_public_ip_address = each.value.associate_public_ip_address
  root_block_device           = lookup(each.value, "root_block_device", [])

  common_tags                 = local.raisin_common_tags
}
