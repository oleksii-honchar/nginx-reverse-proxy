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
include project.env
export $(shell sed 's/=.*//' project.env)
export $(shell sed 's/=.*//' ./.devops/envs/deployment.env)

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

up: check-project-env-vars ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down: check-project-env-vars ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart: check-project-env-vars ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

.ONESHELL:
restart-nrp: check-project-env-vars ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d nginx-reverse-proxy
	@docker compose logs --follow

exec-bash: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

test-nginx-config: ## get shell for svc=<svc-name> container
	@docker run -it ${IMAGE_NAME}:${IMAGE_TAG} nginx -t

# Certbot

# baseDir - path in docker volume
.ONESHELL:
certbot-request-cert: baseDir=/etc/letsencrypt
certbot-request-cert: ## get certificates for domain=<domain-name.tld>, cert-name=<nrp-X>, email=<e@ma.il>
	docker volume create letsencrypt
	docker compose run nginx-reverse-proxy sh -c "mkdir -p ${baseDir}/acme-challenge"
	docker compose run certbot certonly --non-interactive --webroot --cert-name "${cert-name}" \
		--agree-tos --email "${email}" --domains "${domain}" \
		--webroot-path ${baseDir}/acme-challenge \
		--cert-path ${baseDir} \
		--config-dir ${baseDir} \
		--work-dir ${baseDir} \
		--logs-dir ${baseDir}

certbot-renew-cert: ## get certificates for domain=<domain-name.tld>
	@docker compose run certbot renew

# NRP image

build:
	@docker build --load -f ./Dockerfile -t ${IMAGE_NAME}:${IMAGE_TAG} --platform linux/arm64 .

tag-latest: check-project-env-vars
	@docker tag ${IMAGE_NAME}:${IMAGE_TAG} tuiteraz/squid:latest

push: check-project-env-vars
	@docker push docker.io/${IMAGE_NAME}:${IMAGE_TAG}
	@docker push docker.io/${IMAGE_NAME}:latest