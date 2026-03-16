# **************************************************************************** #
#                                                                              #
#    Makefile                                           :+:      :+:    :+:    #
#    By: aykrifa <aykrifa@student.42.fr>            +#+  +:+       +#+         #
#    Created: 2026/03/07 18:25:14 by aykrifa           #+#    #+#              #
#                                                                              #
# **************************************************************************** #

list:
	@echo "Commandes disponibles :"
	@grep -hE '^[a-zA-Z0-9_-]+:.*#' $(MAKEFILE_LIST) | \
		sed 's/:.*#/:/' | \
		awk -F: '{ printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }'

.PHONY: list

include helpers/*
