### Global
variable "region" {}
variable "prefix_name_tag" {}
variable "global_tags" {}
variable "fw_instance_type" {}
variable "fw_license_type" {}
variable "fw_version" {}
variable "ssh_key_name" {}

# ### Bootstrap
variable "init-cfg" {}
variable "bootstrap-prefix" {}
variable "buckets" {}

### inbound/outbound
variable "north-south_vpc" {}
variable "north-south_vpc_route_tables" {}
variable "north-south_vpc_subnets" {}
variable "north-south_vpc_security_groups" {}
variable "north-south_interfaces" {}
variable "north-south_firewalls" {}
variable "north-south_addtional_interfaces" {}
variable "north-south_nat_gateways" {}
variable "north-south_vpc_endpoints" {}
variable "north-south_vpc_routes" {}

### inter-vpc
variable "east-west_vpc" {}
variable "east-west_vpc_route_tables" {}
variable "east-west_vpc_subnets" {}
variable "east-west_vpc_security_groups" {}
variable "east-west_interfaces" {}
variable "east-west_firewalls" {}
variable "east-west_addtional_interfaces" {}
variable "east-west_nat_gateways" {}
variable "east-west_vpc_endpoints" {}
variable "east-west_vpc_routes" {}
