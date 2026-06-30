resource "aws_vpc_peering_connection" "peer" {
  count = var.is_peering_required ? 1 : 0

  peer_vpc_id = data.aws_vpc.peer.id
  vpc_id      = aws_vpc.main.id

  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-peer"
    }
  )
}

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}

resource "aws_route" "peer_to_new_vpc" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = data.aws_route_table.peer.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}