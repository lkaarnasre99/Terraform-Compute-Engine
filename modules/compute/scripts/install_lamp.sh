```bash
#!/bin/bash
set -e

# Update package repository
sudo apt-get update

# Install Apache2 and PHP 7.0
sudo apt-get install -y apache2 php7.0

# Enable and restart Apache2 service
sudo systemctl enable apache2
sudo service apache2 restart

# Create a simple PHP info page
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Set permissions
sudo chown -R www-data:www-data /var/www/html/
```