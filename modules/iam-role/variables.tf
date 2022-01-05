# @author: Syed Umair Ali
# @since: 30 December, 2021
# @description: Generic Terraform IAM Role Variables
# @license: All Rights Reserved to Raisin DS
# @Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

variable "name" {
  description = "Role name for the service"
  type        = string
}

variable "profile_name" {
  description = "Profile name for the ec2"
  type        = string
  default     = ""
}

variable "enable_instance_profile" {
  description = "Enable instance profile for the ec2"
  type        = bool 
  default     = true
}

variable "policy_name" {
  description = "Policy name for the service"
  type        = string
}

variable "service_identifiers" {
  description = "Service Identifier"
  type        = string
}

variable "policy_actions" {
  description = "Policy json"
  type        = list(string)
}

variable "common_tags" {
  type        = map(string)
  description = "Common Tags for the EC2"
}