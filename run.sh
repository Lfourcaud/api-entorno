#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$ROOT_DIR/venv"

if [ -x "$VENV_DIR/bin/python" ]; then
  echo "Using existing virtualenv at $VENV_DIR"
  "$VENV_DIR/bin/python" "$ROOT_DIR/app.py"
else
  echo "No virtualenv found. Creating venv at $VENV_DIR and installing requirements..."
  /opt/homebrew/bin/python3 -m venv "$VENV_DIR"
  "$VENV_DIR/bin/python" -m pip install --upgrade pip
  "$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/requirements.txt"
  "$VENV_DIR/bin/python" "$ROOT_DIR/app.py"
fi

# To make this script executable: chmod +x api-entorno/run.sh
