# **************************************************************************** #
#                            DOCKER COMMAND                                    #
# **************************************************************************** #
compose: # docker compose
	docker compose -f srcs/docker-compose.yml up -d

compose_debug: # docker compose debug
	docker compose -v -f srcs/docker-compose.yml up -d

clean: # docker compose down
	docker compose down -v

kill: # remove all containers then remove all images then ls
	docker rm $$(docker ps -aq) -f; \
	docker rmi $$(docker images -aq) -f
	make ls

kill_volumes: # remove all docker volumes
	docker volume rm $$(docker volume ls -q) -f
	make ls

ls: # list images and containers
	docker images
	docker ps -a

ls_volumes: # list all docker volumes
	docker volume ls
.PHONY: clean, ls, ls_volumes, kill, kill_volumes, compose, debug

