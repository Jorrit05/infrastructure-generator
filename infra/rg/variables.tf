variable "prefix" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "cn-demo"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "West Europe"
}

variable "env" {
  type    = string
  default = "dev"
}


