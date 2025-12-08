module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs

  # Required IAM role ARN for VPC Flow Logs
  flow_log_iam_role_arn = var.flow_log_iam_role_arn

  # KMS key ARN for CloudWatch Log Group encryption
  cloudwatch_kms_key_arn = var.cloudwatch_kms_key_arn
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name

  # EKS will run in private subnets
  subnet_ids = module.vpc.private_subnet_ids

  node_group_desired = var.node_group_desired
  node_group_min     = var.node_group_min
  node_group_max     = var.node_group_max
  instance_types     = var.instance_types
  tags               = var.tags

  # KMS key ARN for EKS secrets encryption
  kms_key_arn = var.kms_key_arn
}
