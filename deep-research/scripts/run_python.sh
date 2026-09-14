#!/bin/bash
VENV_DIR="$HOME/.gemini/config/skills/deep-research/.venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "Error: .venv not found. Run scripts/pip_install.sh first."
    exit 1
fi

source "$VENV_DIR/bin/activate"
python3 "$@"
