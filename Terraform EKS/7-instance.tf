resource "aws_iam_role" "worker_node_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_Node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_CNI_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "worker_node_EC2_CRR_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node_role.name
}


resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = aws_eks_cluster.test_eks_cluster.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.worker_node_role.arn

  subnet_ids = [
    aws_subnet.my_vpc_pri_subnet_ap-south-1a.id,
    aws_subnet.my_vpc_pri_subnet_ap-south-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "General"
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_Node_policy,
    aws_iam_role_policy_attachment.worker_node_CNI_policy,
    aws_iam_role_policy_attachment.worker_node_EC2_CRR_policy,
  ]
}