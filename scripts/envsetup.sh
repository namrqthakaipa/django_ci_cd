#!/bin/bash

set -e  # Exit immediately if a command fails
set -x  # Print each command before executing 

# Update packages and install venv if not already installed

#ENV_DIR="/opt/Django_CICD/nam-env"
INSTALL_FLAG="$1"
export ENV_NAME="${2:-new-env}"


# Base directory
BASE_DIR="/opt/Django_CICD"
ENV_DIR="$BASE_DIR/$ENV_NAME"

#update package list
sudo apt update

# Install python3.12-venv if not installed
if ! python3.12 -m venv --help >/dev/null 2>&1; then
    echo "Installing python3.12-venv..."
    sudo apt update
    sudo apt install -y python3.12-venv
else
        echo "The Python virtual is installed"
fi


# Step 1: Create virtual environment if it doesn't exist
if [ -d "$ENV_DIR" ]; then
    echo " Virtual environment '$ENV_DIR' already exists. Activating it."
else
    echo " Creating new virtual environment: '$ENV_DIR'"
    python3.12 -m venv "$ENV_DIR"

    if [ $? -ne 0 ]; then
        echo " Failed to create virtual environment."
        exit 1
    fi
fi

# Giving permision to virtual environment
sudo chown -R "$USER:$USER" "$ENV_DIR"

# Step 2 : Activate the virtual environment
source "$ENV_DIR/bin/activate"

echo "INSTALL_DEPS received: '$INSTALL_DEPS'"
echo "ENV_NAME received: '$ENV_NAME'"

# Step 3: Install requirements only if flag is passed
if [[ "$INSTALL_FLAG" == "--install" ]]; then
    echo " Installing dependencies from requirements.txt"
    cd "$BASE_DIR"
    pip install -r requirements.txt
else
    echo " Skipping dependency installation as '--install' flag not provided."
fi

# Step 5: Create logs directory
LOG_DIR="$BASE_DIR/logs"
if [ ! -d "$LOG_DIR" ]; then
    echo " Creating logs directory..."
    mkdir "$LOG_DIR"
    touch "$LOG_DIR/error.log" "$LOG_DIR/access.log"
else
    echo " Logs directory already exists."
fi

chmod -R 755 "$LOG_DIR"
echo " Environment setup complete."
