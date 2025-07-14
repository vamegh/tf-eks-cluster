resource "aws_eks_cluster" "eks" {
  # required
  name       = var.eks.name
  role_arn   = var.eks.role_arn
  version    = var.eks.version
  vpc_config = var.eks.vpc_config

  # optionals
  access_config                 = var.eks.access_config
  bootstrap_self_managed_addons = local.self_managed_addons
  encryption_config             = var.encryption_config
  enabled_cluster_log_types     = var.eks.cluster_log_types
  region                        = local.region
  upgrade_policy                = var.eks.upgrade_policy
  zonal_shift_config            = var.eks.zonal_shift_config

  # eks auto node mgmt
  compute_config            = var.eks_auto_mode.compute_config
  kubernetes_network_config = var.eks_auto_mode.kubernetes_network_config
  storage_config            = var.eks_auto_mode.storage_config

  tags = (merge(var.tags, { Name = "eks-cluster-${var.eks.name}" }))
}

resource "aws_eks_addon" "addons" {
  for_each = var.addons

  addon_name                  = each.key
  cluster_name                = aws_eks_cluster.eks.name
  region                      = local.region
  addon_version               = each.value.addon_version
  resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
  resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
  preserve                    = each.value.preserve
  service_account_role_arn    = each.value.service_account_role_arn
  pod_identity_association    = each.value.pod_identity_association


  configuration_values = jsonencode(each.value.configuration_values)
  tags                 = (merge(var.tags, { Name = "eks-addon-${each.key}" }))
}

resource "aws_eks_node_group" "aws_managed" {
  for_each = var.eks_node_group

  # required
  cluster_name   = aws_eks_cluster.eks.name
  node_role_arn  = each.value.node_role_arn
  scaling_config = each.value.scaling_config
  subnet_ids     = each.value.subnet_ids

  # optionals
  region                 = local.region
  ami_type               = each.value.ami_type
  capacity_type          = each.value.capacity_type
  disk_size              = each.value.disk_size
  force_update_version   = each.value.force_update_version
  instance_types         = each.value.instance_types
  launch_template        = each.value.launch_template
  node_group_name        = each.value.name == "" ? null : each.value.name
  node_group_name_prefix = each.value.name == "" ? each.value.name_prefix : null
  node_repair_config     = each.value.node_repair_config
  release_version        = each.value.release_version
  remote_access          = each.value.remote_access
  update_config          = each.value.update_config
  version                = each.value.version

  dynamic "taint" {
    for_each = each.value.taints

    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  labels = var.eks_labels
  tags   = (merge(var.tags, { Name = "eks-node-${each.key}" }))
}
