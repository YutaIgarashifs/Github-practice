# 1. Public Subnets (ALB, NAT用)
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"
  map_public_ip_on_launch = true
  tags = { Name = "${var.project_name}-public-${count.index == 0 ? "1a" : "1c"}" }
}

# 2. Protected Subnets (EC2用)
resource "aws_subnet" "protected" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.protected_subnet_cidrs[count.index]
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"
  tags = { Name = "${var.project_name}-protected-${count.index == 0 ? "1a" : "1c"}" }
}

# 3. Private Subnets (RDS用)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "${var.region}${count.index == 0 ? "a" : "c"}"
  tags = { Name = "${var.project_name}-private-${count.index == 0 ? "1a" : "1c"}" }
}