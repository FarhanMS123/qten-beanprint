#!/bin/bash
VENV_DIR="$HOME/.gemini/config/skills/deep-research/.venv"

# Create .venv if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating local .venv in $VENV_DIR..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Install packages with SSL bypass
echo "Installing packages with SSL bypass..."
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org "$@"
