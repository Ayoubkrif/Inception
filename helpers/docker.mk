# **************************************************************************** #
#                            DOCKER COMMAND                                    #
# **************************************************************************** #
BUILD_DIR    = srcs
COMPOSE_FILE = $(BUILD_DIR)/docker-compose.yml

move: # copy srcs files in build path
	mkdir -p $(BUILD_DIR)
	cp -r srcs/. $(BUILD_DIR)/

crash: # simule un crash sur tous les containers (kill -9 depuis le host)
	@for pid in $$(docker inspect --format='{{.State.Pid}}' $$(docker ps -q)); do \
		sudo kill -9 $$pid 2>/dev/null || true; \
	done

## COMPOSE
compose: # docker compose
	mkdir -p $$(grep -E '^HOST_DATA_PATH=' $(BUILD_DIR)/.env | cut -d= -f2)
	mkdir -p $$(grep -E '^HOST_WP_PATH=' $(BUILD_DIR)/.env | cut -d= -f2)
	docker compose -f $(COMPOSE_FILE) up -d

compose_verbose: # docker compose verbose
	docker compose -v -f $(COMPOSE_FILE) up -d

compose_debug: # show docker compose variable expanditure
	docker compose -f $(COMPOSE_FILE) config

stop: # docker compose down
	docker compose -f $(COMPOSE_FILE) down -v

re: # wipe everything (containers, images, volumes, build cache, db data) and recompose
	$(MAKE) kill
	docker builder prune -f
	sudo rm -rf $$(grep -E '^HOST_DATA_PATH=' $(BUILD_DIR)/.env | cut -d= -f2)
	$(MAKE) compose

## HELPERS
ls: image_ls container_ls volume_ls # list images, containers and volumes

ls_image: # list all docker images
	docker images

ls_container: # list all docker containers
	docker ps -a

ls_volume: # list all docker volumes
	docker volume ls

kill: container_kill image_kill volume_kill ls # remove all containers, images and volumes

kill_image: # remove all docker images
	docker rmi $$(docker images -aq) -f

kill_container: # remove all docker containers
	docker rm $$(docker ps -aq) -f

kill_volume: # remove all docker volumes
	docker volume rm $$(docker volume ls -q) -f

logs: # logs de tous les services
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps NGINX WordPress MariaDB Portainer WebServ Adminer

logs_nginx: # logs du service nginx
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps NGINX

logs_wordpress: # logs du service wordpress
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps WordPress

logs_mariadb: # logs du service mariadb
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps MariaDB

# BONUS
logs_portainer: # logs du service portainer
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps Portainer

logs_webserv: # logs du service webserv
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps WebServ

logs_adminer: # logs du service adminer
	docker compose -f $(COMPOSE_FILE) logs -f --timestamps Adminer
# END OF BONUS

maria_switch: # swap MariaDB Dockerfile/entrypoint entre debian (actif) et alpine (.tmp)
	mv srcs/MariaDB/Dockerfile               srcs/MariaDB/Dockerfile.swap
	mv srcs/MariaDB/Dockerfile.tmp           srcs/MariaDB/Dockerfile
	mv srcs/MariaDB/Dockerfile.swap          srcs/MariaDB/Dockerfile.tmp
	mv srcs/MariaDB/docker-entrypoint.sh     srcs/MariaDB/docker-entrypoint.sh.swap
	mv srcs/MariaDB/docker-entrypoint.sh.tmp srcs/MariaDB/docker-entrypoint.sh
	mv srcs/MariaDB/docker-entrypoint.sh.swap srcs/MariaDB/docker-entrypoint.sh.tmp

.PHONY: compose compose_verbose compose_debug clean \
        image_ls container_ls volume_ls ls \
        image_kill container_kill volume_kill kill \
        logs logs_nginx logs_wordpress logs_mariadb \
        logs_portainer logs_webserv logs_adminer \
        restart maria_switch
