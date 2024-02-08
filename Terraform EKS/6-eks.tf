resource "aws_iam_role" "test_eks_iam_role" {
  name = "test-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "test_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.test_eks_iam_role.name
}

resource "aws_eks_cluster" "test_eks_cluster" {
  name     = "test_eks_cluster"
  role_arn = aws_iam_role.test_eks_iam_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.my_vpc_pri_subnet_ap-south-1a.id,
      aws_subnet.my_vpc_pri_subnet_ap-south-1b.id,
      aws_subnet.my_vpc_pub_subnet_ap-south-1a.id,
      aws_subnet.my_vpc_pub_subnet_ap-south-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.test_eks_cluster_policy]
}