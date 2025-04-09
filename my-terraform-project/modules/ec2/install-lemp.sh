#!/bin/bash
sudo apt update -y
sudo apt install -y nginx mysql-server php php-fpm php-mysql
systemctl start nginx
systemctl enable nginx