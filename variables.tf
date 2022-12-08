variable "aws_vpc_name" {
  default     = "assignment"
  type        = string
  description = "VPC Name"
}

variable "cidr_block" {
  default     = "10.1.0.0/16"
  type        = string
  description = "cider block"
}

variable "cidr_subnet_block" {
  type = map(any)
  default = {
    "SN1" = "10.1.1.0/24"
    "SN2" = "10.1.2.0/24"
  }
}

variable "igw_name" {
  default = "igw"
  type    = string
}

variable "default_tags_Debian" {
  default = {
    "Owner" = "shiva-Debian"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}
variable "default_tags_RedHat" {
  default = {
    "Owner" = "shiva-RedHat"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

variable "vmprefix" {
  default = "linux"
  type    = string
}
variable "prefix" {
  default = "shiva"
  type    = string
}