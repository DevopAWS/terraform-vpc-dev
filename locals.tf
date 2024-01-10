locals {
  name = "${var.project_name}-${var.environment}"
  azs_name = slice(data.aws_availability_zones.azs.names,0,2)
}