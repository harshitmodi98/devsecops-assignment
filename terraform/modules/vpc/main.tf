##############################
# CloudWatch Log Group for VPC Flow Logs
##############################
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/${var.name}"
  retention_in_days = 90
}

##############################
# VPC Flow Logs
##############################
resource "aws_flow_log" "vpc" {
  vpc_id              = aws_vpc.this.id
  traffic_type        = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination     = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn        = var.flow_log_iam_role_arn
}
