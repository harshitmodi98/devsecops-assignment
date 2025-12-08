module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name

  # EKS ko private subnets me chala rahe hain
  subnet_ids = module.vpc.private_subnet_ids

  node_group_desired = var.node_group_desired
  node_group_min     = var.node_group_min
  node_group_max     = var.node_group_max
  instance_types     = var.instance_types
  tags               = var.tags

  # NEW: KMS key ARN for secrets encryption
  kms_key_arn = var.kms_key_arn
}
