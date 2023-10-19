## Create Security Groups ##

# Create ALB Security Group
resource "aws_security_group" "alb-sg" {
    name        = "allow_HTTP"    # "HTTPS" more secure option
    description = "Allow HTTP inbound traffic from internet"  
    vpc_id      = aws_vpc.app-vpc.id

    ingress {
        description      = "HTTP"
        from_port        = 80         # 443
        to_port          = 80          # 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_tls"
    }
}

# App Server Security Group
resource "aws_security_group" "app-sg" {
    name        = "allow http"
    description = "Allow http inbound traffic from ALB"
    vpc_id      = aws_vpc.app-vpc.id
}

resource "aws_security_group_rule" "app-sg-ingress" {
    type              = "ingress"
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    security_group_id = aws_security_group.app-sg.id
    source_security_group_id = aws_security_group.alb-sg.id
}

resource "aws_security_group_rule" "app-sg-egress" {
    type              = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.app-sg.id
}

# RDS instance Security Group
resource "aws_security_group" "rds-sg" {
    name        = "allow MySql port"
    description = "Allow MySql inbound traffic from app-server"
    vpc_id      = aws_vpc.app-vpc.id
}

resource "aws_security_group_rule" "rds-sg-ingress" {
    type              = "ingress"
    from_port         = 3306
    to_port           = 3306
    protocol          = "tcp"
    security_group_id = aws_security_group.rds-sg.id
    source_security_group_id = aws_security_group.app-sg.id
}

resource "aws_security_group_rule" "alb-sg-egress" {
    type              = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    security_group_id = aws_security_group.rds-sg.id
}
