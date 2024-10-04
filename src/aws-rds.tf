resource "aws_db_instance" "rds" {
  identifier        = "healthmed"
  db_name           = "healthmed"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "11.22" # aws rds describe-db-engine-versions --engine postgres --output table --region us-east-1
  instance_class    = var.rdsInstanceClass
  username          = var.rdsHealthmedUsername
  password          = var.rdsHealthmedPassword


  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true

  depends_on = [aws_security_group.sg]
}

resource "aws_security_group" "rds_sg" {
  name        = "SG-databases"
  description = "This group is used AWS RDS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "All"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
