#!/bin/bash
set -e

echo "==> Starting container initialization..."

/download_models.sh

echo "==> Starting RunPod Worker Serverless handler..."
exec python -u /start.py
