output "vpc_id" {
  description = "VPC ID created by VPC module"
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}
