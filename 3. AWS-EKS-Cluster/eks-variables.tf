variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "eksdemo"
}

variable "endpoint_public_access" {
  description = "Cluster Public Access"
  type        = bool
  default     = true
}
variable "endpoint_private_access" {
  description = "Cluster Private Access"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Public IP address Raange to access Cluster"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_version" {
  description = "Cluster Version"
  type        = string
  default     = "1.30"
}
