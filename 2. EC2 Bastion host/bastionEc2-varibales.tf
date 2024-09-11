variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "instance key name"
  type        = string
  default     = "devops"
}
