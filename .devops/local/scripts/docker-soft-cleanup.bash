#!/bin/bash

BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

printf "${LBLUE}Removing exited docker containers...${NC}\n"
docker ps -a -q -f status=exited | xargs docker rm -v

printf "${LBLUE}Removing dangling images...${NC}\n"
docker images -f "dangling=true" -q | xargs docker rmi

printf "${LBLUE}Removing unused images...${NC}\n"
docker images -q |xargs docker rmi

printf "${LBLUE}Removing volumes...${NC}\n"
docker volume ls -q |xargs docker volume rm

printf "${GREEN}Done${NC}\n"