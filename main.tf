terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.198.0"
    }
  }
  cloud {
    organization = "virtuosity"

    workspaces {
      name = "tfghactions-demo"
    }
  }
}

provider "alicloud" {
  region     = "ap-southeast-3"
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu_[0-9]+_[0-9]+_x64*"
  most_recent = true
  owners      = "system"
}

resource "alicloud_vpc" "prod" {
  vpc_name   = "VPC-Prod-Demo"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.prod.id
  cidr_block   = "172.16.1.0/24"
  zone_id      = "ap-southeast-3a"
  vswitch_name = "vswitch-demo"
  depends_on = [
    alicloud_vpc.prod
  ]
}

resource "alicloud_security_group" "sec_group" {
  name        = "sec-group-demo"
  description = "foo"
  vpc_id      = alicloud_vpc.prod.id
}

resource "alicloud_instance" "ecs_instance" {

  count = 1
  security_groups   = alicloud_security_group.sec_group.*.id
  instance_type              = "ecs.n4.large"
  system_disk_category       = "cloud_efficiency"
  system_disk_name           = "ecs-system-disk"
  system_disk_description    = "System Disk for ECS"
  system_disk_size     = 40
  image_id                   = data.alicloud_images.default.images[0].id
  instance_name              = "ecs-instance-demo"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 10
}
