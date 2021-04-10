SHELL := /bin/bash
.DEFAULT_GOAL := help

include .env
export

ifndef index
override index = 1
endif

.PHONY: help
help:		## Display this help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: pull
pull: 			## Pull the latest image version
	docker-compose pull

.PHONY: up
upd: 			## Start the node in daemon mode
	docker-compose up -d --build --remove-orphans

.PHONY: upt
upt: 			## Start the node in terminal mode
	docker-compose up --build --remove-orphans

.PHONY: upl
upl: 			## Start the node in daemon mode and directly follow logs
	docker-compose up --build --remove-orphans; docker-compose logs -t --tail=10 -f node

.PHONY: stop
stop: 			## Stop the node
	docker-compose stop

.PHONY: destroy
destroy: 		## Destroy the node (volumes are not removed)
	docker-compose down --remove-orphans

.PHONY: restart
restart: 		## Restart the node
	docker-compose restart

.PHONY: shell
shell: 			## Enter the container shell
	docker-compose exec --index=$(index) node bash

.PHONY: logs
logs: 			## Display the container logs
	docker-compose logs -t --tail=10 -f node

.PHONY: status
status: 		## Get the running node status
	docker-compose exec --index=$(index) node golemsp status

.PHONY: settings
settings: 		## Show the running node settings
	docker-compose exec --index=$(index) node golemsp settings show

.PHONY: clean
clean:			## Remove cached files older than 7 days
	docker-compose exec --index=$(index) node find /root/.local/share/ya-provider/exe-unit/cache/ -mtime +7 -type f -exec rm {} +

.PHONY: presets
presets: 		## Show the running node settings
	python generate_presets.py
