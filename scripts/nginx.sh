#!/bin/bash

source "/opt/Django_CICD/$ENV_NAME/bin/activate"
echo "==> Current directory:"

pwd

echo "==> Copying nginx config to sites-available..."
sudo cp -rf app.conf /etc/nginx/sites-available/app

echo "==> Setting permissions on project directory..."
chmod 710 /opt/Django_CICD

sudo ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled


echo "==> Creating symlink for nginx site..."
sudo nginx -t
if [ $? -ne 0 ]; then
    echo "❌ Nginx configuration test failed. Fix the config before proceeding."
    exit 1
fi

echo "==> Starting and enabling nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Nginx has been started"

sudo systemctl status nginx
