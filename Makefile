# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: dleite-b <dleite-b@student.42lausanne.c    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/04/08 12:52:55 by dleite-b          #+#    #+#              #
#    Updated: 2026/04/08 12:52:56 by dleite-b         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME        = inception
COMPOSE     = docker compose
COMPOSE_FILE= srcs/docker-compose.yml
DATA_PATH   = /home/$(USER)/data
WP_DATA     = $(DATA_PATH)/wordpress
DB_DATA     = $(DATA_PATH)/mariadb

all: up

init:
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)

up: init
	@$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

down:
	@$(COMPOSE) -f $(COMPOSE_FILE) down

logs:
	@$(COMPOSE) -f $(COMPOSE_FILE) logs

clean:
	@$(COMPOSE) -f $(COMPOSE_FILE) down -v

fclean: clean
	@sudo rm -rf $(WP_DATA) $(DB_DATA)

re: fclean up

.PHONY: all init up down logs clean fclean re