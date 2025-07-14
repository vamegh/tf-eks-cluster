locals {
  region = var.region == "" ? data.aws_region.current.region : var.region

  self_managed_addons = var.eks_auto_mode.enabled ? false : var.eks.self_managed_addons
}
