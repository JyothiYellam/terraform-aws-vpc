data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "peer" {
  id = "vpc-0fbd6f6e92597a946"
}

data "aws_route_table" "peer" {
  vpc_id = data.aws_vpc.peer.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}