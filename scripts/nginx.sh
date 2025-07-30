#!/bin/bash

set -e
set -x

# source /opt/Django_CICD/.env_config
# source "/opt/Django_CICD/$ENV_NAME/bin/activate"

source /opt/Django_CICD/env-new/bin/activate

echo " Current directory:"
pwd

# Check if nginx is already running
if systemctl is-active --quiet nginx; then
    echo " Nginx is already active. Skipping setup."
else
    echo " Nginx is not active. Proceeding with setup"

    echo "Copying nginx config to sites-available"
    sudo cp -rf app.conf /etc/nginx/sites-available/app

    echo "Setting permissions on project directory"
    chmod +x /opt/Django_CICD

    # Create symlink only if it doesn't already exist
    if [ ! -e /etc/nginx/sites-enabled/app ]; then
        echo " Creating symlink for nginx site."
        sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled
    else
        echo " Symlink for nginx site already exists."
    fi

    echo " Testing nginx configuration."
    if ! sudo nginx -t; then
        echo " Nginx configuration test failed. Fix the config before proceeding."
        exit 1
    fi

    echo "==> Starting and enabling nginx..."
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "Nginx has been started and enabled."
fi

# nginx status
sudo systemctl status nginx
