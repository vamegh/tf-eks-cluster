variable "region" {
  description = "AWS Region"
  type        = string
  default     = ""
}

variable "eks" {
  description = "configuration for eks cluster"
  type = object({
    cluster_log_types    = optional(list(string), null)
    force_update_version = optional(bool, false)
    name                 = string
    role_arn             = string
    self_managed_addons  = optional(bool, false)
    version              = string
    access_config = optional(object({
      authentication_mode                         = optional(string, "CONFIG_MAP")
      bootstrap_cluster_creator_admin_permissions = optional(bool, false)
    }))
    upgrade_policy = optional(object({
      support_type = optional(string)
    }))
    vpc_config = object({
      endpoint_private_access = bool
      endpoint_public_access  = bool
      public_access_cidrs     = optional(list(string), null)
      subnet_ids              = list(string)
    })
    zonal_shift_config = optional(object({
      enabled = optional(bool)
    }))
  })
}

variable "eks_auto_mode" {
  description = "EKS Auto Mode compute config, all must be enabled, to work"
  type = object({
    enabled = optional(bool, false)
    compute_config = optional(object({
      enabled       = optional(bool)
      node_pools    = optional(string)
      node_role_arn = optional(string)
    }), null)
    kubernetes_network_config = optional(object({
      ip_family         = optional(string)
      service_ipv4_cidr = optional(string)
      elastic_load_balancing = optional(object({
        enabled = optional(bool)
      }), null)
    }), null)
    storage_config = optional(object({
      block_storage = optional(object({
        enabled = optional(bool, null)
      }), null)
    }), null)
  })
}

variable "eks_node_group" {
  description = "aws managed eks node group"
  type = map(object({
    ami_type             = optional(string)
    capacity_type        = optional(string)
    disk_size            = optional(number)
    force_update_version = optional(bool)
    instance_types       = optional(list(string))
    name                 = optional(string)
    name_prefix          = optional(string)
    node_role_arn        = optional(string)
    release_version      = optional(string)
    subnet_ids           = optional(list(string))
    version              = optional(string)

    scaling_config = optional(object({
      desired_size = optional(number)
      max_size     = optional(number)
      min_size     = optional(number)
    }), null)
    launch_template = optional(object({
      id      = optional(string)
      name    = optional(string)
      version = optional(string)
    }), null)
    node_repair_config = optional(object({
      enabled = optional(bool)
    }), null)
    remote_access = optional(object({
      ec2_ssh_key               = optional(string)
      source_security_group_ids = optional(set(string))
    }), null)
    taints = optional(object({
      key    = optional(string)
      value  = optional(string)
      effect = optional(string)
    }), null)
    update_config = optional(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    }), null)
  }))
}

variable "encryption_config" {
  description = ""
  type = object({
    provider = optional(object({
      key_arn = optional(string)
    }), null)
    resources = optional(list(string), null)
  })
}

variable "addons" {
  description = "A map of objects configuring addons"
  type = map(object({
    addon_version               = optional(string, null)
    configuration_values        = optional(map(any), null)
    resolve_conflicts_on_create = optional(string, null)
    resolve_conflicts_on_update = optional(string, null)
    preserve                    = optional(bool, null)
    service_account_role_arn    = optional(string, null)
    pod_identity_association = optional(object({
      role_arn        = optional(string, null)
      service_account = optional(string, null)
    }), null)
  }))
}

variable "eks_labels" {
  description = "A map of eks labels"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags"
  type        = map(string)
  default     = {}
}
