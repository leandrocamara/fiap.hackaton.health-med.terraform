resource "aws_eks_cluster" "eks_cluster" {
  name     = "EKS-${var.projectName}"
  role_arn = data.aws_iam_role.labRole.arn

  vpc_config {
    subnet_ids         = data.aws_subnets.default.ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  access_config {
    authentication_mode = var.eksAccessConfig
  }

  depends_on = [aws_security_group.eks_sg]
}

resource "aws_security_group" "eks_sg" {
  name        = "EKS-SG-${var.projectName}"
  description = "This group is used AWS EKS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "All"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "EKS-NG-${var.projectName}"
  node_role_arn   = data.aws_iam_role.labRole.arn
  subnet_ids      = aws_eks_cluster.eks_cluster.vpc_config[0].subnet_ids
  disk_size       = 50
  instance_types  = ["${var.eksInstanceType}"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_access_policy_association" "eks_policy" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  policy_arn    = var.eksPolicyArn
  principal_arn = replace(data.aws_iam_role.labRole.arn, "LabRole", "voclabs")

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_entry" "eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks_cluster.name
  principal_arn     = replace(data.aws_iam_role.labRole.arn, "LabRole", "voclabs")
  kubernetes_groups = ["fiap"]
  type              = "STANDARD"
}