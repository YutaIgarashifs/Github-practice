# セキュリティグループ (ALBからのみ許可)
resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress { # NAT経由で外に出るため全許可
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2インスタンス作成 (2台)
resource "aws_instance" "app" {
  count         = 2 # 2台作成
  
  ami           = "ami-09cd9fdbf26acc6b4"
  instance_type = var.instance_type
  
  # プロテクテッドサブネットに配置 (0=1a, 1=1c)
  subnet_id              = aws_subnet.protected[count.index].id
  
  vpc_security_group_ids = [aws_security_group.app.id]
  
  # iam.tfで作ったプロファイルを参照
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello success! (Server ${count.index + 1})" > /var/www/html/index.html
EOF

  tags = { Name = var.server_names[count.index]
  }
}

# ターゲットグループへ2台とも登録
resource "aws_lb_target_group_attachment" "app" {
  count            = 2
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}