#!/bin/bash

set -e  # Exit immediately if a command fails
set -x  # Print each command before executing (for debug)

# Update packages and install venv if not already installed
ENV_DIR="/Django_CICD/nam-env"
INSTALL_FLAG="$1"

sudo apt update

# Ensure script runs from the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Install python3.12-venv if not installed
if ! python3.12 -m venv --help >/dev/null 2>&1; then
    echo "Installing python3.12-venv..."
    sudo apt update
    sudo apt install -y python3.12-venv
fi

# Step 1: Create virtual environment if it doesn't exist
if [ -d "$ENV_DIR" ]; then
    echo " Virtual environment '$ENV_DIR' already exists. Activating it."
else
    echo "🛠 Creating new virtual environment: '$ENV_DIR'"
    python3.12 -m venv "$ENV_DIR"

    if [ $? -ne 0 ]; then
        echo " Failed to create virtual environment."
        exit 1
    fi
fi

# Ensure we own the environment folder (avoid permission denied)
sudo chown -R "$USER:$USER" "$ENV_DIR"

# Step 2 : Activate the virtual environment
source "$ENV_DIR/bin/activate"

# Step 3 :Upgrade pip and install dependencies
pip install --upgrade pip


# Step 4: Install requirements only if flag is passed
if [[ "$INSTALL_FLAG" == "--install" ]]; then
    echo "📦 Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
    pip install gunicorn
else
    echo "⏭️ Skipping dependency installation as '--install' flag not provided."
fi

pip install gunicorn

# Step 5: Create logs directory
LOG_DIR="logs"
if [ ! -d "$LOG_DIR" ]; then
    echo "📝 Creating logs directory..."
    mkdir "$LOG_DIR"
    touch "$LOG_DIR/error.log" "$LOG_DIR/access.log"
else
    echo "ℹ️ Logs directory already exists."
fi

chmod -R 755 "$LOG_DIR"
echo "✅ Environment setup complete."
