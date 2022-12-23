variable "aws_region" {
    description = "The AWS region things are created in"
    type    = string
    default = "ap-southeast-2" #Sydney
}

variable "az_count" {
    description = "Number of AZs to cover in a given region"
    default = "2"
}

variable "app_port" {
    description = "Port Exposed by the cokder image to redirect traffic to"
    default = 80
}

variable "app_count" {
    description = "Number of docker container to run"
    default = 1
}

variable "health_check_path" {
    default = "/"
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}