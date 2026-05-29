# **************************************************************************** #
#                          PASSWORD | .ENV                                     #
# **************************************************************************** #

# Couleurs pour le style
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RESET        = \033[0m

reset: # reset env and secret
	cd srcs/ && rm -rf .env *.secret
	make env
	make secrets

env: # build .env
	@cd srcs/ && if [ ! -f .env ]; then \
		read -p "(DB_NAME) : " dbname; \
		read -p "(USER_LOGIN) : " login; \
		read -p "(WP_TITLE) : " wptitle; \
		read -p "(WP_ADMIN_USER, pas admin/administrator) : " wpadmin; \
		read -p "(WP_ADMIN_EMAIL) : " wpadminemail; \
		read -p "(WP_USER) : " wpuser; \
		read -p "(WP_USER_EMAIL) : " wpuseremail; \
		\
		echo "MYSQL_DATABASE=$$dbname" > .env; \
		echo "MYSQL_USER=$$login" >> .env; \
		echo "HOST_DATA_PATH=/home/vagrant/DB" >> .env; \
		echo "WP_FILES_LOCATION=/var/www/html" >> .env; \
		echo "DOMAIN_NAME=aykrifa.42.fr" >> .env; \
		echo "WP_TITLE=$$wptitle" >> .env; \
		echo "WP_ADMIN_USER=$$wpadmin" >> .env; \
		echo "WP_ADMIN_EMAIL=$$wpadminemail" >> .env; \
		echo "WP_USER=$$wpuser" >> .env; \
		echo "WP_USER_EMAIL=$$wpuseremail" >> .env; \
	else \
		printf ".env already exist — écraser ? [y/N] : "; \
		read confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			rm .env; \
			$(MAKE) -C $(CURDIR) env; \
		fi; \
	fi

secrets: # build passwd
	@cd srcs/ && if [ ! -f mariadb_root_password.secret ]; then \
		printf "Mot de passe ROOT MariaDB : "; \
		stty -echo; \
		read rootpass; \
		stty echo; \
		echo ""; \
		printf "Mot de passe USER MariaDB : "; \
		stty -echo; \
		read userpass; \
		stty echo; \
		echo ""; \
		printf "Mot de passe ADMIN WordPress : "; \
		stty -echo; \
		read wpadminpass; \
		stty echo; \
		echo ""; \
		printf "Mot de passe USER WordPress : "; \
		stty -echo; \
		read wpuserpass; \
		stty echo; \
		echo ""; \
		echo "$$rootpass" > mariadb_root_password.secret; \
		echo "$$userpass" > mariadb_password.secret; \
		echo "$$wpadminpass" > wp_admin_password.secret; \
		echo "$$wpuserpass" > wp_user_password.secret; \
		echo ""; \
		echo "$(YELLOW)⚠ Secrets modifiés — lance 'make restart' pour re-provisionner la DB$(RESET)"; \
	else \
		printf "secrets already exist — écraser ? [y/N] : "; \
		read confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			rm -f *.secret; \
			$(MAKE) -C $(CURDIR) secrets; \
		fi; \
	fi

.PHONY: setup env secrets
