vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
azs             = ["ap-south-1a", "ap-south-1b"]
cluster_name    = "my-eks-cluster"
node_group_desired = 2
node_group_min     = 1
node_group_max     = 3
instance_types     = ["t3.medium"]
tags               = { Environment = "dev" }

# IAM and KMS ARNs
flow_log_iam_role_arn    = "arn:aws:iam::123456789012:role/vpc-flow-logs-role"
kms_key_arn              = "arn:aws:kms:ap-south-1:123456789012:key/abcd-1234-efgh-5678"

# NEW: KMS key ARN for CloudWatch Log Group encryption
cloudwatch_kms_key_arn   = "arn:aws:kms:ap-south-1:123456789012:key/wxyz-5678-ijkl-9012"
