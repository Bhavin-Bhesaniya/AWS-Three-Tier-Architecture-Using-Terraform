# # # # # # # # # #
# DB Subnet Group #
# # # # # # # # # #
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnets"
  # subnet_ids  = [aws_subnet.DB-Private-Subnet-1.id, aws_subnet.DB-Private-Subnet-2.id]
  subnet_ids  = [aws_subnet.subnets[4].id, aws_subnet.subnets[5].id]
  description = "Database Subnet Group"

  tags = {
    Name = "Database Subnets"
  }
}


# # # # # # # #
# DB Instance #
# # # # # # # #
resource "aws_db_instance" "new_db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.database-instance-class
  db_name              = "mysqldb"
  username             = "DB_USER"
  password             = "DB_PASSWORD"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  # publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  tags = {
    Name = "MyDB"
  }

}