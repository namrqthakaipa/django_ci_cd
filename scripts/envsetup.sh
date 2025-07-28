#!/bin/bash

set -e  # Exit immediately if a command fails
set -x  # Print each command before executing (for debug)

# Update packages and install venv if not already installed
sudo apt update
sudo apt install -y python3.12-venv

# Ensure script runs from the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Create virtual environment if it doesn't exist
if [ ! -d "nam-env" ]; then
    python3.12 -m venv nam-env
    echo "✅ Virtual environment created."
else
    echo "ℹ️ Virtual environment already exists."
fi

# Ensure we own the environment folder (avoid permission denied)
sudo chown -R "$USER:$USER" nam-env

# Activate the virtual environment
source nam-env/bin/activate

# Upgrade pip and install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Create logs directory and log files if not present
if [ ! -d "logs" ]; then
    mkdir logs
    touch logs/error.log logs/access.log
    echo "✅ Logs directory and files created."
else
    echo "ℹ️ Logs directory already exists."
fi

# Set permissions
chmod -R 755 logs
echo "✅ Setup complete."
