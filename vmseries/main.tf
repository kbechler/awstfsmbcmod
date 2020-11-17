### Bootstrap ###
module "bootstrap" {
  for_each         = var.buckets
  source           = "../modules/bootstrap"
  global_tags      = var.global_tags
  prefix           = var.bootstrap-prefix
  hostname         = each.value.name
  panorama-server  = var.init-cfg.panorama-server
  panorama-server2 = var.init-cfg.panorama-server2
  tplname          = var.init-cfg.tplname
  dgname           = var.init-cfg.dgname
  dns-primary      = var.init-cfg.dns-primary
  dns-secondary    = var.init-cfg.dns-secondary
  vm-auth-key      = var.init-cfg.vm-auth-key
  op-command-modes = var.init-cfg.op-command-modes
}

locals {
  buckets_map = {
    for k, bkt in module.bootstrap :
    k => {
      "arn"  = bkt.bucket.arn
      "name" = bkt.bucket.bucket
    }
  }

}

### Inbound / Outbound ###
module "north-south_vpc" {
  source           = "../modules/vpc"
  global_tags      = var.global_tags
  prefix_name_tag  = var.prefix_name_tag
  vpc              = var.north-south_vpc
  vpc_route_tables = var.north-south_vpc_route_tables
  subnets          = var.north-south_vpc_subnets
  nat_gateways     = var.north-south_nat_gateways
  vpc_endpoints    = var.north-south_vpc_endpoints
  security_groups  = var.north-south_vpc_security_groups
}

module "north-south_vmseries" {
  source               = "../modules/vmseries"
  region               = var.region
  prefix_name_tag      = var.prefix_name_tag
  ssh_key_name         = var.ssh_key_name
  fw_license_type      = var.fw_license_type
  fw_version           = var.fw_version
  fw_instance_type     = var.fw_instance_type
  tags                 = var.global_tags
  firewalls            = var.north-south_firewalls
  interfaces           = var.north-south_interfaces
  addtional_interfaces = var.north-south_addtional_interfaces
  subnets_map          = module.north-south_vpc.subnet_ids
  security_groups_map  = module.north-south_vpc.security_group_ids
  buckets_map          = local.buckets_map
  prefix_bootstrap     = "pan-bootstrap-ns"
}

module "north-south_vpc_routes" {
  source            = "../modules/vpc_routes"
  region            = var.region
  global_tags       = var.global_tags
  prefix_name_tag   = var.prefix_name_tag
  vpc_routes        = var.north-south_vpc_routes
  vpc_route_tables  = module.north-south_vpc.route_table_ids
  internet_gateways = module.north-south_vpc.internet_gateway_id
  # nat_gateways      = module.north-south_vpc.nat_gateway_ids
}



# Inter-VPC ###
module "east-west_vpc" {
  source           = "../modules/vpc"
  global_tags      = var.global_tags
  prefix_name_tag  = var.prefix_name_tag
  vpc              = var.east-west_vpc
  vpc_route_tables = var.east-west_vpc_route_tables
  subnets          = var.east-west_vpc_subnets
  nat_gateways     = var.east-west_nat_gateways
  vpc_endpoints    = var.east-west_vpc_endpoints
  security_groups  = var.east-west_vpc_security_groups
}

module "east-west_vmseries" {
  source               = "../modules/vmseries"
  region               = var.region
  prefix_name_tag      = var.prefix_name_tag
  ssh_key_name         = var.ssh_key_name
  fw_license_type      = var.fw_license_type
  fw_version           = var.fw_version
  fw_instance_type     = var.fw_instance_type
  tags                 = var.global_tags
  firewalls            = var.east-west_firewalls
  interfaces           = var.east-west_interfaces
  addtional_interfaces = var.east-west_addtional_interfaces
  subnets_map          = module.east-west_vpc.subnet_ids
  security_groups_map  = module.east-west_vpc.security_group_ids
  buckets_map          = local.buckets_map
  prefix_bootstrap     = "pan-bootstrap-ew"

}

module "east-west_vpc_routes" {
  source            = "../modules/vpc_routes"
  region            = var.region
  global_tags       = var.global_tags
  prefix_name_tag   = var.prefix_name_tag
  vpc_routes        = var.east-west_vpc_routes
  vpc_route_tables  = module.east-west_vpc.route_table_ids
  internet_gateways = module.east-west_vpc.internet_gateway_id
  # nat_gateways      = module.east-west_vpc.nat_gateway_ids
}
