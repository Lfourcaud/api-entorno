#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$ROOT_DIR/venv"

# Find a python3 executable (prefer Homebrew, fallback to system python3)
if command -v /opt/homebrew/bin/python3 >/dev/null 2>&1; then
  PYTHON_EXEC="/opt/homebrew/bin/python3"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_EXEC="$(command -v python3)"
else
  echo "python3 no está disponible en el sistema. Instala Python 3 antes de continuar." >&2
  exit 1
fi

if [ -x "$VENV_DIR/bin/python" ]; then
  echo "Using existing virtualenv at $VENV_DIR"
  "$VENV_DIR/bin/python" "$ROOT_DIR/app.py"
else
  echo "No virtualenv found. Creating venv at $VENV_DIR and installing requirements..."
  "$PYTHON_EXEC" -m venv "$VENV_DIR"
  "$VENV_DIR/bin/python" -m pip install --upgrade pip
  "$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/requirements.txt"
  "$VENV_DIR/bin/python" "$ROOT_DIR/app.py"
fi

# To make this script executable: chmod +x api-entorno/run.sh
