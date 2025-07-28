#!/bin/bash

source nam-env/bin/activate

cd /opt/Django_CICD/app

python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py collectstatic -- no-input

echo "Migrations done"

cd /opt/Django_CICD

pwd

sudo cp -rf scripts/gunicorn.socket /etc/systemd/system/
sudo cp -rf scripts/gunicorn.service /etc/systemd/system/

echo "$USER"
echo "$PWD"



sudo systemctl daemon-reload
sudo systemctl start gunicorn

echo "Gunicorn has started."

sudo systemctl enable gunicorn

echo "Gunicorn has been enabled."

sudo systemctl restart gunicorn


sudo systemctl status gunicorn

