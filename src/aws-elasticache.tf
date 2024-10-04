resource "aws_security_group" "elasticache_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "healthmed-redis-cluster"
  description                = "Redis replication group"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  engine                     = "redis"
  engine_version             = "6.x"
  port                       = 6379
  parameter_group_name       = "default.redis6.x"
  security_group_ids         = [aws_security_group.elasticache_sg.id]
  subnet_group_name          = aws_elasticache_subnet_group.main.name

  tags = {
    Name = "My Redis Cluster"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "elasticache-subnet-group"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "Elasticache Subnet Group"
  }
}
