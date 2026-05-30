# **************************************************************************** #
#                            DOCKER COMMAND                                    #
# **************************************************************************** #
compose: # docker compose
	mkdir -p $$(grep -E '^HOST_DATA_PATH=' srcs/.env | cut -d= -f2)
	mkdir -p $$(grep -E '^HOST_WP_PATH=' srcs/.env | cut -d= -f2)
	docker compose -f srcs/docker-compose.yml up -d

compose_verbose: # docker compose verbose
	docker compose -v -f srcs/docker-compose.yml up -d

compose_debug: # show docker compose variable expanditure
	docker compose -f srcs/docker-compose.yml config

clean: # docker compose down
	docker compose down -v

image_ls: # list all docker images
	docker images

container_ls: # list all docker containers
	docker ps -a

volume_ls: # list all docker volumes
	docker volume ls

ls: image_ls container_ls volume_ls # list images, containers and volumes

image_kill: # remove all docker images
	docker rmi $$(docker images -aq) -f

container_kill: # remove all docker containers
	docker rm $$(docker ps -aq) -f

volume_kill: # remove all docker volumes
	docker volume rm $$(docker volume ls -q) -f

kill: container_kill image_kill volume_kill ls # remove all containers, images and volumes

restart: # wipe everything (containers, images, volumes, build cache, db data) and recompose
	$(MAKE) kill
	docker builder prune -f
	sudo rm -rf $$(grep -E '^HOST_DATA_PATH=' srcs/.env | cut -d= -f2)
	$(MAKE) compose

logs: # logs des 3 services (nginx, wordpress, mariadb)
	docker compose -f srcs/docker-compose.yml logs -f --timestamps NGINX WordPress MariaDB

logs_nginx: # logs du service nginx
	docker compose -f srcs/docker-compose.yml logs -f --timestamps NGINX

logs_wordpress: # logs du service wordpress
	docker compose -f srcs/docker-compose.yml logs -f --timestamps WordPress

logs_mariadb: # logs du service mariadb
	docker compose -f srcs/docker-compose.yml logs -f --timestamps MariaDB

.PHONY: compose compose_verbose compose_debug clean \
        image_ls container_ls volume_ls ls \
        image_kill container_kill volume_kill kill \
        logs logs_nginx logs_wordpress logs_mariadb \
        restart
