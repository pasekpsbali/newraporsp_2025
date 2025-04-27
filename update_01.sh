#!/bin/bash
sudo apt update
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 0/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^max_input_time = .*/max_input_time = -1/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = -1/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 10240M/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 1024M/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^default_socket_timeout = .*/default_socket_timeout = 600000/' /etc/php/8.2/fpm/php.ini
sudo sed -i '/^; Dynamic Extensions/i zend_extension=/usr/local/ioncube/ioncube_loader_lin_8.2.so' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 0/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^max_input_time = .*/max_input_time = -1/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = -1/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^post_max_size = .*/post_max_size = 10240M/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 1024M/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^default_socket_timeout = .*/default_socket_timeout = 600000/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^output_buffering = .*/output_buffering = Off/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^implicit_flush = .*/implicit_flush = On/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 0/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = -1/' /etc/php/8.2/fpm/php.ini
sudo sed -i 's/^output_buffering = .*/output_buffering = Off/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^implicit_flush = .*/implicit_flush = On/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^max_execution_time = .*/max_execution_time = 0/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = -1/' /etc/php/8.2/cli/php.ini
sudo sed -i 's/^request_terminate_timeout = .*/request_terminate_timeout = 0/' /etc/php/8.2/fpm/pool.d/www.conf
sudo sed -i 's/^request_slowlog_timeout = .*/request_slowlog_timeout = 0/' /etc/php/8.2/fpm/pool.d/www.conf
sudo sed -i 's/^request_terminate_timeout = .*/request_terminate_timeout = 0/' /etc/php/8.2/cli/pool.d/www.conf
sudo sed -i 's/^request_slowlog_timeout = .*/request_slowlog_timeout = 0/' /etc/php/8.2/cli/pool.d/www.conf
sudo systemctl restart php8.2-fpm
sudo sed -i '
# Mengubah shared_buffers menjadi 4GB
s/^#shared_buffers = 128MB/shared_buffers = 4GB/;

# Mengubah work_mem menjadi 128MB
s/^#work_mem = 4MB/work_mem = 128MB/;

# Mengubah maintenance_work_mem menjadi 2GB
s/^#maintenance_work_mem = 64MB/maintenance_work_mem = 2GB/;

# Mengubah effective_cache_size menjadi 12GB
s/^#effective_cache_size = 4GB/effective_cache_size = 12GB/;

# Menonaktifkan fsync untuk meningkatkan performa (dapat berisiko)
s/^#fsync = on/fsync = off/;

# Menambahkan wal_level menjadi replica
s/^#wal_level = replica/wal_level = replica/' /etc/postgresql/14/main/postgresql.conf

# Reload PostgreSQL untuk menerapkan perubahan
sudo systemctl reload postgresql

sudo tee /etc/nginx/sites-available/raporsp2025 > /dev/null <<EOF
server {
    listen 8055 default_server;
    listen [::]:8055 default_server;
    server_name _;

    root /var/www/wwwroot/public;
    index index.php index.html index.htm;

    access_log /var/log/nginx/wwwroot.access.log;
    error_log /var/log/nginx/wwwroot.error.log;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
		fastcgi_read_timeout 3600;
		fastcgi_send_timeout 3600;
		proxy_buffering off;
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    client_max_body_size 10240M;
    keepalive_timeout 360000;
}
EOF

sudo chown -R www-data:www-data /var/www/wwwroot/writable/
sudo chmod -R 777 /var/www/wwwroot/writable/
sudo chown -R www-data:www-data /var/www/wwwroot/public/bcfile/
sudo chmod -R 777 /var/www/wwwroot/public/bcfile/
sudo chown -R www-data:www-data /var/www/wwwroot/public/excel/
sudo chmod -R 777 /var/www/wwwroot/public/excel/
sudo chown -R www-data:www-data /var/www/wwwroot/public/images/
sudo chmod -R 777 /var/www/wwwroot/public/images/
sudo chown -R www-data:www-data /var/www/wwwroot/public/pdf/
sudo chmod -R 775 /var/www/wwwroot/public/pdf/
sudo chown -R www-data:www-data /var/www/wwwroot/public/restore/
sudo chmod -R 777 /var/www/wwwroot/public/restore/
sudo chown -R www-data:www-data /var/www/wwwroot/public/tempup/
sudo chmod -R 777 /var/www/wwwroot/public/tempup/
sudo chown -R www-data:www-data /var/www/wwwroot/public/uploads/
sudo chmod -R 777 /var/www/wwwroot/public/uploads/
sudo rm -r /var/www/wwwroot/public/tempup/*.json
sudo rm -r /var/www/wwwroot/public/restore/*.zip 
sudo rm -r /var/www/wwwroot/public/tempup/*.enc
sudo ln -s /etc/nginx/sites-available/raporsp2025 /etc/nginx/sites-enabled/
sudo systemctl reload nginx
sudo systemctl reload php8.2-fpm
sudo systemctl reload postgresql
sudo systemctl restart php8.2-fpm
sudo systemctl restart postgresql
sudo systemctl restart nginx
sudo rm -r /tmp/newrapor2025
sudo rm -r /tmp/dbraporsp25
sudo rm newraporsp2025.tar.gz 
sudo rm install.sh
sudo rm -r newraporsp2025.tar.gz 
sudo rm -r install.sh
sudo rm update_01.sh
