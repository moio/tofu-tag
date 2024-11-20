#!/usr/bin/env bash

set -euo pipefail

tofu state list | grep cluster | xargs -n1 tofu taint
