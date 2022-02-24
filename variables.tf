variable "container_port"{
    description = "Port for the ALB to connect to container(s)"
    type = number
    default = 3000
}

variable "container_environment" {
  description = "Environment Vars to pass to container"
  type        = list
  default = []
}

variable "zone_id" {
  description = "Zone ID for Route53"
  type        = string
  default = "Z2M7MAEIPQ61O7"
}