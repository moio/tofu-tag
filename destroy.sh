#!/usr/bin/env bash

set -euo pipefail

tofu init
tofu destroy --auto-approve
