variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets where EKS control plane and nodes will run"
  type        = list(string)
}

variable "node_group_desired" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_min" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_max" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "disk_size" {
  description = "Node root volume size in GiB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Common tags to apply to EKS resources"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encrypting EKS secrets"
  type        = string
}
