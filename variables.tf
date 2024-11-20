# Frequently changed variables
variable "region" {
  description = "AWS region for this deployment"
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "Local ~/.aws/config profile to utilize for AWS access"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "AWS availability zone for this deployment"
  default     = "eu-central-1a"
}

variable "bastion_host_ami" {
  description = "AMI ID for the bastion host, or null to use the latest openSUSE 15.6 ARM image in your region"
  default     = null
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file (can be generated with `ssh-keygen -t ed25519`)"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key file (can be generated with `ssh-keygen -t ed25519`)"
  default     = "~/.ssh/id_ed25519"
}

variable "ssh_user" {
  description = "User name to use for the SSH connection"
  default     = "root"
}

variable "ssh_bastion_user" {
  description = "User name for the SSH bastion host's OS"
  default     = "root"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "cluster"
}

variable "server_count" {
  description = "Number of server nodes in the upstream cluster"
  type        = number
  default     = 1
}

variable "agent_count" {
  description = "Number of agent nodes in the upstream cluster"
  type        = number
  default     = 3
}

variable "distro_version" {
  description = "Version of the Kubernetes distro in the upstream cluster"
  type        = string
  default     = "v1.31.2+rke2r1"
}

variable "public_ip" {
  description = "Whether the upstream cluster should have a public IP assigned"
  type        = bool
  default     = false
}

variable "reserve_node_for_monitoring" {
  description = "Set a 'monitoring' label and taint on one node of the upstream cluster to reserve it for monitoring"
  type        = bool
  default     = false
}

variable "datastore" {
  description = "Optional datastore to utilize for the upstream cluster"
  type        = string
  default     = null
}

variable "server_instance_type" {
  description = "Instance type for the upstream cluster server nodes"
  default     = "t3a.xlarge" // cheap x86 instance
}

variable "agent_instance_type" {
  description = "Instance type for the upstream cluster agent nodes"
  default     = "g4dn.xlarge" // cheap x86 instance with nVidia GPU
}

variable "instance_tags" {
  description = "Tags to apply to the EC2 instances"
  type        = map(string)
  default = {
    "Owner"       = "moio-hackweek-ai",
    "DoNotDelete" = "true"
  }
}

variable "ami" {
  description = "AMI ID for the cluster nodes, or null to use the latest openSUSE 15.6 x86 image in your region"
  type        = string

  # HACK: latest CUDA (12.6 Update 1) only supports an outdated (open)SUSE kernel (6.4.0-150600.21)
  # Using later kernels such as the current 6.4.0-150600.23 breaks CUDA
  # As a workaround, set an outdated image that that ships with kernel 6.4.0-150600.21
  # Note: https://pint.suse.com/?resource=images&csp=amazon&search=15-6 can be used to find AMIs in other regions
  default     = "ami-07ff38c9d82129423"
}

variable "driver_version" {
  description = "Version of the nVidia driver to use"

  # HACK: work around version conflicts per https://documentation.suse.com/suse-ai/1.0/html/NVIDIA-GPU-driver-on-SL-Micro/index.html#nvidia-gpu-pre-install-version-mismatch
  default = "550.100"
}

variable "project_name" {
  description = "Name of this project, used as prefix for resources it creates"
  default     = "moio-hackweek-ai"
}

variable "first_kubernetes_api_port" {
  description = "Port number where the Kubernetes API of the first cluster is published locally. Other clusters' ports are published in successive ports"
  default     = 7445
}
