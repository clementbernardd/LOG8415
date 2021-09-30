#!/bin/bash

sudo apt-get update
# Install python3 for virtual environment
echo yes | sudo apt install python3-venv

# Create virtual env
mkdir flask_folder && cd flask_folder
python3 -m venv flask_env
source flask_env/bin/activate

# Install flask
pip install Flask

# Create python file
echo "from flask import Flask
import urllib.request
public_id = urllib.request.urlopen('http://169.254.169.254/latest/meta-data/public-ipv4').read()
public_id = public_id.decode('utf-8')
instance_id = urllib.request.urlopen('http://169.254.169.254/latest/meta-data/instance-id').read().decode('utf-8')


app = Flask(__name__)

@app.route('/')
def my_app():
    return f'Instance ID : {instance_id}  IP : {public_id}'

if __name__ == '__main__':
    app.run(port=80, host='0.0.0.0')

    " > flask_app.py

# Run the FLASK app
export FLASK_APP=flask_app.py
sudo flask_env/bin/python3  flask_app.py
