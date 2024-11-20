provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "network" {
  source               = "./modules/aws_network"
  project_name         = var.project_name
  region               = var.region
  availability_zone    = var.availability_zone
  bastion_host_ami     = var.bastion_host_ami != null ? var.bastion_host_ami : data.aws_ami.latest_opensuse_leap_15_6_arm.id
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
  ami                       = var.ami != null ? var.ami : data.aws_ami.latest_opensuse_leap_15_6_x86.id
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
    "zypper --gpg-auto-import-keys refresh",
    "zypper install -y --auto-agree-with-licenses nvidia-open-driver-G06-signed-kmp=${var.driver_version} nvidia-compute-utils-G06=${var.driver_version}",
  ]
}

data "aws_ami" "latest_opensuse_leap_15_6_arm" {
  most_recent = true

  filter {
    name   = "name"
    values = ["openSUSE-Leap-15-6-*-arm64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]  # official openSUSE
}

data "aws_ami" "latest_opensuse_leap_15_6_x86" {
  most_recent = true

  filter {
    name   = "name"
    values = ["openSUSE-Leap-15-6-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]  # official openSUSE
}
