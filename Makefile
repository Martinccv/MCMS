#!make
include .env

SERVICE_NAME=mysql
HOST=127.0.0.1
PORT=3306

PASSWORD=${MYSQL_ROOT_PASSWORD}
DATABASE=${MYSQL_DATABASE}
USER=${MYSQL_USER}

DOCKER_COMPOSE_FILE=./docker-compose.yml
DATABASE_CREATION=./Proyecto/Structure.sql
DATABASE_POPULATION=./Proyecto/data.sql

FILES=vistas funciones stored_procedures triggers user_roles


.PHONY: all up objects test-db access-db down

all: info up objects

info:
	@echo "This is a project for $(DATABASE)"
	

up:
	@echo "Create the instance of docker"
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

	@echo "Waiting for MySQL to be ready..."
	bash mysql_wait.sh


	@echo "Create the import and run de script"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD)  -e "source $(DATABASE_CREATION);"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) --local-infile=1 -e "source $(DATABASE_POPULATION)"

objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Process $$file and add to the database: $(DATABASE_NAME)"; \
	docker exec -it $(SERVICE_NAME)  mysql -u$(MYSQL_USER) -p$(PASSWORD) -e "source ./Proyecto/datos/$$file.sql"; \
	done

test-db:
	@echo "Testing the tables"
	docker exec -it $(SERVICE_NAME)  mysql -u$(MYSQL_USER) -p$(PASSWORD)  -e "source ./Proyecto/check_db_objects.sql";

access-db:
	@echo "Access to db-client"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD)

backup-db:
	@echo "Back up database by structure and data"
	# Dump MySQL database to a file
	# para que te permita descargar con procedimientos
	mkdir -p /workspaces/MCMS/temp_backup
	docker exec -it $(SERVICE_NAME) mysqldump --routines=true -u$(MYSQL_USER) -p$(PASSWORD) --host 127.0.0.1 --port 3306 $(DATABASE) > ./temp_backup/$(DATABASE)-backup.sql

restore-db:
	@echo "Restore database by structure and data"
	# Restore MySQL database from a dump file
	# Debe ingresar al archivo dumpeado las lineas drop y create database CentroLogistico, USE CentroLogistico y comentar la primera linea de codigo donde advierte sobre contraseña
	docker exec -i $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) < ./backup/$(DATABASE)-backup.sql

down:
	@echo "Remove the Database"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) --host $(HOST) --port $(PORT) -e "DROP DATABASE IF EXISTS $(DATABASE);"
	@echo "Bye"
	docker compose -f $(DOCKER_COMPOSE_FILE) down