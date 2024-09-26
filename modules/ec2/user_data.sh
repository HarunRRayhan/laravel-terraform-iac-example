#!/bin/bash
set -e

# Update and install dependencies
apt-get update
apt-get install -y nginx ruby wget

# Install CodeDeploy agent
cd /home/ubuntu
wget https://aws-codedeploy-${region}.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Start CodeDeploy agent
service codedeploy-agent start

# Set up Nginx
cat > /etc/nginx/sites-available/${application_name} <<EOL
server {
    listen 80;
    server_name _;
    root /var/www/${application_name}/public;

    index index.html index.htm index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOL

ln -s /etc/nginx/sites-available/${application_name} /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Enable and start services
systemctl enable nginx
systemctl start nginx

# Set correct permissions
mkdir -p /var/www/${application_name}
chown -R www-data:www-data /var/www/${application_name}
chmod -R 755 /var/www/${application_name}