SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include project.env
export $(shell sed 's/=.*//' project.env)

include ./.devops/envs/deployment.env
export $(shell sed 's/=.*//' ./.devops/envs/deployment.env)

export LATEST_VERSION=$(shell cat ./latest-version.txt)

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Misc
check-project-env-vars: # check env vars mentioned in project.env.dist to be filled in project.env
	@bash ./.devops/local/scripts/check-project-env-vars.sh

generate-config: # generate squid and dnsmasq configs
	@bash ./generate-config.bash

# Docker
cleanup:
	@bash ./scripts/docker-cleanup.bash

soft-cleanup:
	@bash ./scripts/docker-soft-cleanup.bash

logs: check-project-env-vars ## docker logs
	@docker compose logs --follow

log: check-project-env-vars ## docker log for svc=<docker service name>
	@docker compose logs --follow ${svc}

up: check-project-env-vars generate-config ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down: check-project-env-vars ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart: check-project-env-vars generate-config ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

run-nrp-bash: check-project-env-vars ## run NRP bash
	docker run -it $(IMAGE_NAME):$(LATEST_VERSION) bash

test-nginx-config: check-project-env-vars ## text nginx config
	@docker run -it $(IMAGE_NAME):$(LATEST_VERSION) nginx -t

# To get <volume-name> use `docker volume ls`
# make run-volume name=nginx-reverse-proxy_letsencrypt
run-volume: ## run container to check volume content for name=<volume-name>
	docker run -it --rm -v $(name):/volume-data --name volume-check busybox

# NRP image

build:
	docker build --load -f ./Dockerfile -t $(IMAGE_NAME):$(LATEST_VERSION) --platform linux/arm64 .

tag-latest: 
	@docker tag $(IMAGE_NAME):$(LATEST_VERSION) $(IMAGE_NAME):latest

push: 
	@docker push docker.io/$(IMAGE_NAME):$(LATEST_VERSION)
	@docker push docker.io/$(IMAGE_NAME):latest