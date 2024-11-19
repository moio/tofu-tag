# TabletopGames.ai TAG AI Framework Deployment

This project contains scripts to deploy the [TabletopGames.ai TAG](https://tabletopgames.ai/) framework on [SUSE AI](https://www.suse.com/products/ai/): an RKE2 Kubernetes cluster based on openSUSE, running on AWS, with GPU support using the NVIDIA GPU Operator.

## Requirements

- [OpenTofu](https://opentofu.org/) v1.8.5
- Helm v3.0.0+
- AWS CLI configured with appropriate credentials

## Usage

1. Clone this repository:
```sh
git clone https://github.com/moio/tofu-tag.git
cd tofu-tag
```

2. Initialize and apply the Tofu configuration:
```sh
./deploy.sh
```

3. Access the Kubernetes cluster:
```sh
export KUBECONFIG=`pwd`/config/cluster.yaml
k9s
```

## About
This project was created during SUSE's HackWeek 24 open source hackathon. For more information, visit the [HackWeek project page](https://hackweek.opensuse.org/24/projects/suse-ai-meets-the-game-board).