#!/usr/bin/bash

# Install required packages
apt-get update
apt-get install -y wget unzip apache2

# Start and enable Apache web server
systemctl start apache2
systemctl enable apache2

# Download the template zip
wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip

# Unzip the template
unzip -o 2117_infinite_loop.zip

# Copy files to the Apache web directory
cp -r 2117_infinite_loop/* /var/www/html/

# Restart Apache to load the new content
systemctl restart apache2
