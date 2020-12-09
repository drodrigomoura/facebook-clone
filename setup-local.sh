#!/bin/bash

docker stop $(docker ps -qa)

docker-compose build

echo "#####################";
echo "###### FB ########";
echo "#####################";

cp .env.example .env

docker-compose up -d

docker exec fb_php composer install
docker exec fb_php php artisan migrate:fresh
docker exec fb_php php artisan migrate:fresh --env testing
docker exec fb_php chmod -R 775 storage
docker exec fb_php chown -R 1000:www-data storage bootstrap/cache
docker exec fb_php php artisan storage:link
docker exec fb_php php artisan key:generate

##### START SERVICES #####
docker-compose down
docker-compose up -d
