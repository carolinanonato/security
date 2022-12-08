

variable "num_windows_vms" {
  default     = 1
  description = "Number of Windows VMs to provision"
  type        = number
}

variable "windows_instance_type" {
  default     = "t2.micro"
  description = "Instance type to use"
  type        = string
}

variable "path_to_windows_key" {
  default     = "/home/ec2-user/.ssh/windows.pub"
  description = "Path to the public key to use in Windows VMs provisioning"
  type        = string
}