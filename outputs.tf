output "alicloud_ecs_instance_id" {
  value       = alicloud_instance.ecs_instance.id
  description = "ECS Instance ID"
}

output "alicloud_vpc_id" {
  value       = alicloud_vpc.prod.id
  description = "VPC ID"
}

output "alicloud_vswitch_id" {
  value       = alicloud_vswitch.vswitch.id
  description = "vSwitch ID"
}
