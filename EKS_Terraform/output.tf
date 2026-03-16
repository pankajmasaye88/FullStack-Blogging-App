output "cluster_id" {
  value = aws_eks_cluster.pankaj.id
}

output "node_group_id" {
  value = aws_eks_node_group.pankaj.id
}

output "vpc_id" {
  value = aws_vpc.pankaj_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.pankaj_subnet[*].id
}
