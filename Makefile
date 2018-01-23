.PHONY: *

all: init 

build-base:
	docker build -t build-env -f Dockerfile.build .

init:
	mv /project/upload/config-dist.php /project/upload/config.php 
	mv /project/upload/admin/config-dist.php /project/upload/admin/config.php
	chown -R www-data:www-data /project 

reset:
	docker exec -it opencart php /var/www/html/install/cli_install.php install --db_hostname mariadb --db_username root --db_password mariaSql --db_database opencart --db_driver mysqli --db_port 3306 --username admin --password opencartpass --email admin@myopencart.com --http_server http://13.57.225.143/ 

up: 
	docker-compose up -d

down:
	docker-compose down
