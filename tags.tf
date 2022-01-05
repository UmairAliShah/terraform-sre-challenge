# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: Common Tags for all resources
# @license: All Rights Reserved to Raisin DS

########################################
# Common Tags for Upload bucket and SQS
########################################
locals {
  raisin_common_tags = {
      environment           = terraform.workspace 
      team                  = var.team 
      project               = var.project 
      created_by            = var.created_by
      organization          = var.organization 
  }
}