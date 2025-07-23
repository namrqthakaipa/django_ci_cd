#!/bin/bash

if [ ! -d "env" ]; then
    python3.12 -m venv env
    echo " Virtual environment created."
else
    echo " Virtual environment already exists."
fi

source env/bin/activate


pip3 install -r requirements.txt

if [ -d "logs" ] 
then
    echo "Log folder exists." 
else
    mkdir logs
    touch logs/error.log logs/access.log
fi

sudo chmod -R 777 logs
