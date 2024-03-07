#!/bin/bash

# Update package lists
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Create a new Nginx configuration file for the Flask application
sudo tee /etc/nginx/sites-available/flaskapp <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://app_tier_ip:app_port; # Replace app_tier_ip and app_port with your Flask app's IP and port
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the configuration
sudo ln -s /etc/nginx/sites-available/flaskapp /etc/nginx/sites-enabled/

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

# Install Python and pip
sudo apt install -y python3 python3-pip

# Install Flask and Werkzeug
pip3 install Flask werkzeug

# Create a simple Flask application to test the setup
sudo tee /home/ubuntu/flaskapp.py <<EOF
from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Make the Flask application executable
sudo chmod +x /home/ubuntu/flaskapp.py

# Run the Flask application
nohup python3 /home/ubuntu/flaskapp.py &

echo "Setup complete. Flask application is running and accessible via Nginx."
