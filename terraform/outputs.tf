output "vpc_id" {
  value = aws_vpc.eks_prod_vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.eks_prod_igw.id
}

output "nat_id" {
  value = aws_nat_gateway.eks_prod_nat.id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_b.id
}

output "private_subnet_1" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_2" {
  value = aws_subnet.private_subnet_b.id
}

output "eks_cluster_sg" {
  value = aws_security_group.eks_cluster_sg.id
}

output "eks_rds_sg" {
  value = aws_security_group.eks_rds_sg.id
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks_prod_cluster.id
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks_prod_cluster.version
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_node_group_status" {
  value = aws_eks_node_group.eks_prod_node_group.status
}

output "rds_endpoint" {
  value = aws_db_instance.eks_prod_rds.endpoint
}

output "rds_database" {
  value = aws_db_instance.eks_prod_rds.db_name
}

output "rds_username" {
  value = aws_db_instance.eks_prod_rds.username
}

output "rds_port" {
  value = aws_db_instance.eks_prod_rds.port
}


