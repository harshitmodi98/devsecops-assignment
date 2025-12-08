variable "name" {
  description = "Prefix name for tagging"
  type        = string
  default     = "demo"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability zones (matching subnet counts)"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}
