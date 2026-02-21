#!/bin/bash
# HyperLnx OS — Client Provisioning Script
# Deploys a new isolated client instance on a VPS
# Usage: bash client-provision.sh --name "ClientName" --tier audit --channel telegram --token "BOT_TOKEN"

set -e

CLIENT_NAME=""
TIER="hyperlnx-audit"
CHANNEL="telegram"
BOT_TOKEN=""
BASE_DIR="/opt/hyperlnx-clients"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --name) CLIENT_NAME="$2"; shift ;;
    --tier) TIER="$2"; shift ;;
    --channel) CHANNEL="$2"; shift ;;
    --token) BOT_TOKEN="$2"; shift ;;
  esac
  shift
done

[[ -z "$CLIENT_NAME" ]] && { echo "Error: --name required"; exit 1; }
[[ -z "$BOT_TOKEN" ]] && { echo "Error: --token required"; exit 1; }

SLUG=$(echo "$CLIENT_NAME" | tr [:upper:] [:lower:] | tr 