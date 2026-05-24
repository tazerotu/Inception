USERNAME = ttas

all:
	mkdir -p /home/$(USERNAME)/data/db_data
	mkdir -p /home/$(USERNAME)/data/wp_data
	docker compose -f docker-compose.yml up -d --build

down:
	docker compose -f docker-compose.yml down

clean: down
	docker system prune -af
	sudo rm -rf /home/$(USERNAME)/data

re: clean all