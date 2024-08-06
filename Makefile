SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

IMAGE_VERSION := $(shell yq -r '.version' project.yaml)
IMAGE_NAME := $(shell yq -r '.name' project.yaml)
LOG_LEVEL := $(shell yq -r '.logLevel' project.yaml)

export LOG_LEVEL

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Misc
check-env-vars: # check env vars mentioned in project.env.dist to be filled in project.env
	@bash ./.devops/local/scripts/check-env-vars.sh

# Docker
cleanup:
	@bash .devops/local/scripts/docker-cleanup.bash

soft-cleanup:
	@bash .devops/local/scripts/docker-soft-cleanup.bash

logs:  ## docker logs
	@docker compose logs --follow

log:  ## docker log for svc=<docker service name>
	@docker compose logs --follow ${svc}

# make log-proc --follow nrp | grep nginx
log-proc:  ## docker log --follow <svc> |grep <proc>
	@docker compose logs --follow ${svc} | grep ${proc}

up: check-env-vars ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down: check-env-vars ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart: check-env-vars  ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: check-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: check-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

run-nrp-bash: check-env-vars ## run NRP bash
	docker run -it $(IMAGE_NAME):$(IMAGE_VERSION) bash

test-nginx-config: check-env-vars ## text nginx config
	@docker run -it $(IMAGE_NAME):$(IMAGE_VERSION) nginx -t

# To get <volume-name> use `docker volume ls`
# make run-volume name=nginx-reverse-proxy_letsencrypt
run-volume: check-env-vars ## run container to check volume content for name=<volume-name>
	docker run -it --rm -v $(name):/volume-data --name volume-check busybox

# used for multi-platform builds
create-docker-container-builder:
	@docker buildx create --use --name docker-container --driver docker-container
	@docker buildx inspect docker-container --bootstrap

use-docker-container-builder:
	@docker buildx create --use --name docker-container --driver docker-container
	@docker buildx inspect docker-container --bootstrap
	@docker buildx use docker-container

# NRP image
build: ## build NRP image
	docker build --load -f ./Dockerfile --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg IMAGE_NAME=$(IMAGE_NAME) -t $(IMAGE_NAME):$(IMAGE_VERSION) --platform linux/arm64 .

build-n-push: ## build NRP image
	docker buildx build --builder docker-container --platform linux/amd64,linux/arm64 --push -f ./Dockerfile --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg IMAGE_NAME=$(IMAGE_NAME) -t $(IMAGE_NAME):$(IMAGE_VERSION) -t $(IMAGE_NAME):latest .

tag-latest: ## tag NRP image as latest
	@docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(IMAGE_NAME):latest

push: ## push latest image to docker hub
	@docker push docker.io/$(IMAGE_NAME):$(IMAGE_VERSION)
	@docker push docker.io/$(IMAGE_NAME):latest