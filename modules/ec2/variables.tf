# @author: Syed Umair Ali
# @since: 31 December, 2021
# @description: Generic Terraform EC2 Module Variables
# @license: All Rights Reserved to Raisin DS
# @Reference: https://github.com/terraform-aws-modules/terraform-aws-ec2-instance

variable "name" {
  type        = string
  description = "EC2 instance name"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "ami" {
  type        = string
  default     = "ami-09e67e426f25ce0d7"
  description = "EC2 instance ami"
}

variable "key_name" {
  type        = string
  description = "EC2 instance key name"
}

variable "monitoring" {
  type        = bool
  default     = false
  description = "EC2 instance monitoring status"
}

variable "common_tags" {
  type        = map(string)
  description = "Common Tags for the EC2"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "EC2 instance security groups"
}

variable "subnet_id" {
  type        = string
  description = "EC2 instance subnet id"
}

variable "iam_instance_profile" {
  type        = string
  description = "EC2 instance instance profile"
}

variable "associate_public_ip_address" {
  default     = false
  type        = bool
  description = "Assign Public IP to instance"
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "enable_eip" {
  default     = false
  type        = bool
  description = "Assign eip to instance"
}