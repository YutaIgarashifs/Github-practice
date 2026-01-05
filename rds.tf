# セキュリティグループ (EC2からのみ許可)
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }
}

# サブネットグループ (プライベート層を使用)
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  # Privateサブネットを指定
  subnet_ids = aws_subnet.private[*].id
  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# RDSインスタンス (MySQL / Multi-AZ)
resource "aws_db_instance" "default" {
  engine                 = "mysql"
  engine_version         = "8.0"
  multi_az               = true # Multi-AZ有効化
  
  allocated_storage      = 20
  storage_type           = "gp2"
  instance_class         = "db.t3.micro"
  identifier             = "${var.project_name}-db"
  username               = "admin"
  password               = "password1234" 
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
}