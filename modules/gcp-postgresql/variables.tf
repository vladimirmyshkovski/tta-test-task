variable "project_id" {
  description = "The project ID to manage the Cloud SQL resource"
  type        = string
}

variable "name" {
  description = "The name of the Cloud SQL resource"
  type        = string
}

variable "region" {
  description = "The region of the Cloud SQL resource"
  type        = string
}

variable "tier" {
  description = "The tier for the master instance"
  type        = string
}

variable "zone" {
  description = "The zone for the master instance, it should be something like: `a`, `c`"
  type        = string
}

variable "disk_size" {
  description = "The disk size for the master instance"
  type        = number
  default     = 10
}

variable "authorized_networks" {
  description = "List of mapped public networks authorized to access to the instances"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      "name": "DO Dev",
      "value": "137.184.24.122/32"
    },
    {
      "name": "DO Staging"
      "value": "159.223.111.175/32"
    },
    {
      "name": "Denis"
      "value": "95.24.128.153/32"
    },
    {
      "name": "Vladimir"
      "value": "212.58.120.37/32"
    },
    {
      "name": "Kevin"
      "value": "193.148.18.35/32"
    },
  ]
}

variable "enable_backups" {
  description = "Whether backups are enabled or not"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  type    = bool
  default = true
}
