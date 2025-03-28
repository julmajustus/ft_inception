all: prepare
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yml down

re: prepare
	@docker compose -f ./srcs/docker-compose.yml up -d --build

clean:
	@ids=$$(docker ps -qa); \
	if [ -n "$$ids" ]; then \
		docker stop $$ids; \
	fi
	@ids=$$(docker ps -qa); \
	if [ -n "$$ids" ]; then \
		docker rm $$ids; \
	fi
	@imgs=$$(docker images -qa); \
	if [ -n "$$imgs" ]; then \
		docker rmi -f $$imgs; \
	fi
	@vols=$$(docker volume ls -q); \
	if [ -n "$$vols" ]; then \
		docker volume rm $$vols; \
	fi
	@nets=$$(docker network ls --format "{{.Name}}" | grep -vE "^(bridge|host|none)$$"); \
	if [ -n "$$nets" ]; then \
		docker network rm $$nets; \
	fi

fclean: clean
	sudo rm -rf $(HOME)/data

prepare:
	@mkdir -p $(HOME)/data/wordpress
	@mkdir -p $(HOME)/data/mysql
	@cp $(HOME)/.env ./srcs/.env

.PHONY: all re down clean prepare
