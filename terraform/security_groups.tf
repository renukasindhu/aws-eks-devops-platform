# EKS Cluster Security Group

resource "aws_security_group" "eks_cluster_sg" {

  name        = "eks-prod-cluster-sg"
  description = "Security Group for EKS Control Plane"
  vpc_id      = aws_vpc.eks_prod_vpc.id

  tags = {
    Name = "eks-prod-cluster-sg"
  }
}

# RDS Security Group

resource "aws_security_group" "eks_rds_sg" {

  name        = "eks-prod-rds-sg"
  description = "Security Group for MySQL Database"
  vpc_id      = aws_vpc.eks_prod_vpc.id

  tags = {
    Name = "eks-prod-rds-sg"
  }
}

# Cluster SG Rules

resource "aws_security_group_rule" "cluster_egress" {

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id = aws_security_group.eks_cluster_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# RDS SG Rules

resource "aws_security_group_rule" "rds_egress" {

  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id = aws_security_group.eks_rds_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}
