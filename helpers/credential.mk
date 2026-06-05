# **************************************************************************** #
#                          PASSWORD | .ENV                                     #
# **************************************************************************** #

# Couleurs pour le style
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RESET        = \033[0m

provision: env secrets certificate # setup complet : env + secrets + certificat

reprovision: # reset env, secrets and certificate
	cd srcs/ && rm -rf .env *.secret
	$(MAKE) provision

env: # build .env
	@cd srcs/ && if [ ! -f .env ]; then \
		read -p "MYSQL_DATABASE=" dbname; \
		read -p "MYSQL_USER=" login; \
		\
		read -p "WP_TITLE=" wptitle; \
		read -p "(pas admin/administrator) WP_ADMIN_USER=" wpadmin; \
		read -p "WP_ADMIN_EMAIL=" wpadminemail; \
		read -p "WP_USER=" wpuser; \
		read -p "WP_USER_EMAIL=" wpuseremail; \
		\
		echo "MYSQL_DATABASE=$$dbname" > .env; \
		echo "MYSQL_USER=$$login" >> .env; \
		\
		echo "WP_TITLE=$$wptitle" >> .env; \
		echo "WP_ADMIN_USER=$$wpadmin" >> .env; \
		echo "WP_ADMIN_EMAIL=$$wpadminemail" >> .env; \
		echo "WP_USER=$$wpuser" >> .env; \
		echo "WP_USER_EMAIL=$$wpuseremail" >> .env; \
		\
		echo "HOST_DATA_PATH=$$HOME/DB" >> .env; \
		echo "HOST_WP_PATH=$$HOME/WP" >> .env; \
		echo "WP_FILES_LOCATION=/var/www/html" >> .env; \
		echo "DOMAIN_NAME=aykrifa.42.fr" >> .env; \
	else \
		printf ".env already exist — écraser ? [y/N] : "; \
		read confirm; \
		if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
			rm .env || { echo "Permission denied — lance: sudo rm srcs/.env"; exit 1; }; \
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
		\
		printf "Mot de passe ADMIN Portainer : "; \
		stty -echo; \
		read portainerpass; \
		stty echo; \
		echo ""; \
		echo "$$portainerpass" > portainer_admin_password.secret; \
		printf "Mot de passe FTP : "; \
		stty -echo; \
		read ftppass; \
		stty echo; \
		echo ""; \
		echo "$$ftppass" > ftp_password.secret; \
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

certificate: # build self signed key/certificate for nginx
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout srcs/key.pem.secret \
		-out srcs/cert.pem.secret \
		-subj "/CN=aykrifa.42.fr"

.PHONY: provision reprovision env secrets certificate
