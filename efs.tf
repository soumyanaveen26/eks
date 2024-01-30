resource "aws_vpc" "efs_vpc" {
  cidr_block = var.vpc_cidr

}
resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"
  performance_mode = "generalPurpose"  # or "maxIO"
  throughput_mode  = "bursting"        # or "provisioned" for higher performance

  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"  # or other values
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count          = length(var.availability_zones)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = element(aws_subnet.eks_subnets[*].id, count.index)
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  vpc_id = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust based on your security requirements
  }
  }

