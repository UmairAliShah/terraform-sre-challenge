# @author: Syed Umair Ali
# @since: December 29, 2021
# @description: VPC Module Variables
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-vpc 
# @module_version: 3.11.0

##################################
# VPC Module Variables
##################################

variable "name" {
  description = "Name of VPC"
  type        = string
}
variable "vpc_cidr" {
  description = "Set the vpc_cidr"
  type        = string
}
variable "azs" {
  description = "AZs for the subnets"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "CIDRs for the private subnets"
  type        = list(string)
}
variable "public_subnets" {
  description = "CIDRs for the public subnets"
  type        = list(string)
}
variable "single_nat_gateway" {
  description = "Single nat gateway in VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}
variable "common_tags" {
  description       = "Common tags for resources"
  type              = map(string)
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone."
  type        = bool
  default     = false
}