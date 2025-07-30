#!/bin/bash

# source /opt/Django_CICD/.env_config
# source "/opt/Django_CICD/$ENV_NAME/bin/activate"
# cd /opt/Django_CICD/app

source /opt/Django_CICD/env-new/bin/activate

python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py collectstatic --noinput

echo "Migrations and static files setup complete."


if systemctl is-active --quiet gunicorn; then
    echo "Gunicorn is already active. Skipping service setup."
else
    echo "Gunicorn is not active. Proceeding with service setup..."

    # Copy service files only if necessary
    sudo cp -rf scripts/gunicorn.socket /etc/systemd/system/
    sudo cp -rf scripts/gunicorn.service /etc/systemd/system/

    sudo systemctl daemon-reload
    sudo systemctl start gunicorn
    sudo systemctl enable gunicorn
    echo "Gunicorn has been started and enabled."
fi

sudo systemctl status gunicorn

