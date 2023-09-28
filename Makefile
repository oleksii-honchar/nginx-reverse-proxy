SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include ./.devops/envs/deployment.env
export $(shell sed 's/=.*//' ./.devops/envs/deployment.env)

LATEST_VERSION := $(shell cat ./latest-version.txt)

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Docker
cleanup:
	@bash ./scripts/docker-cleanup.bash

soft-cleanup:
	@bash ./scripts/docker-soft-cleanup.bash

.ONESHELL:
check-project-env-vars:
	@bash ./.devops/local/scripts/check-project-env-vars.sh

logs: ## docker logs
	@docker compose logs --follow

log: ## docker log for svc=<docker service name>
	@docker compose logs --follow ${svc}

up:  ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down:  ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart:  ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

run-bash: ## run bash
	docker run -it ${IMAGE_NAME}:$(LATEST_VERSION) bash

test-nginx-config: ## get shell for svc=<svc-name> container
	@docker run -it ${IMAGE_NAME}:$(LATEST_VERSION) nginx -t

# NRP image

build:
	docker build --load -f ./Dockerfile -t ${IMAGE_NAME}:$(LATEST_VERSION) --platform linux/arm64 .

tag-latest: 
	@docker tag ${IMAGE_NAME}:$(LATEST_VERSION) ${IMAGE_NAME}:latest

push: 
	@docker push docker.io/${IMAGE_NAME}:$(LATEST_VERSION)
	@docker push docker.io/${IMAGE_NAME}:latest