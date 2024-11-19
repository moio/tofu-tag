provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "network" {
  source               = "./modules/aws_network"
  project_name         = var.project_name
  region               = var.region
  availability_zone    = var.availability_zone
  bastion_host_ami     = length(var.bastion_host_ami) > 0 ? var.bastion_host_ami : null
  ssh_user             = var.ssh_user
  ssh_public_key_path  = var.ssh_public_key_path
  ssh_private_key_path = var.ssh_private_key_path
}

module "cluster" {
  source       = "./modules/aws_rke2"
  project_name = var.project_name
  name         = var.cluster_name
  server_count = var.server_count
  agent_count  = var.agent_count
  agent_labels = var.reserve_node_for_monitoring ? [
    [{ key : "monitoring", value : "true" }]
  ] : []
  agent_taints = var.reserve_node_for_monitoring ? [
    [{ key : "monitoring", value : "true", effect : "NoSchedule" }]
  ] : []
  distro_version = var.distro_version

  sans                      = ["${var.cluster_name}.local.gd"]
  local_kubernetes_api_port = var.first_kubernetes_api_port
  ami                       = var.ami
  server_instance_type      = var.server_instance_type
  agent_instance_type       = var.agent_instance_type
  availability_zone         = var.availability_zone
  ssh_key_name              = module.network.key_name
  ssh_private_key_path      = var.ssh_private_key_path
  ssh_user                  = var.ssh_user
  ssh_bastion_host          = module.network.bastion_public_name
  ssh_bastion_user          = var.ssh_bastion_user
  subnet_id                 = var.public_ip ? module.network.public_subnet_id : module.network.private_subnet_id
  vpc_security_group_id     = var.public_ip ? module.network.public_security_group_id : module.network.private_security_group_id
  host_configuration_commands = [
    "zypper ar https://download.nvidia.com/suse/sle15sp6/ nvidia-sle15sp6-main",
    "zypper ar https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo",
    "zypper --gpg-auto-import-keys refresh",
    "zypper install -y --auto-agree-with-licenses nvidia-open-driver-G06-signed-kmp=550.100 nvidia-compute-utils-G06=550.100 nvidia-container-toolkit",
  ]
}
