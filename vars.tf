variable "deployment_username" {

}

variable "deployment_password" {

}

variable "deployment_client_id" {
}

variable "deployment_client_secret" {

}

variable "deployment_subscription_id" {

}
variable "deployment_tenant_id" {

}
variable "location" {
  default     = "eastus"
  description = "Azure location"
  
}

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "app" {
  type        = string
  description = "Name of application"
  default     = "terraform-kata"
}
variable "zone" {
  default = "us-east-2b"
}
variable "docker-image" {
  type        = string
  description = "name of the docker image to deploy"
  default     = "chrisgallivan/kata-friday:latest"
}
