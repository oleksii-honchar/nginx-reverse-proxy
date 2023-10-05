#!/bin/bash
source ./.devops/local/scripts/blablo.sh
source ./.devops/local/scripts/checkProjectEnvFile.sh

BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW=$(tput setaf 3)
CYAN1='\033[38;5;51m'
NC='\033[0m' # No Color
BOLD_ON='\033[1m'
BOLD_OFF='\033[22m'

projectEnvFile=${1:-'project.env'}

blablo.cleanLog "🎯 Init configuration files"
checkProjectEnvFile "${projectEnvFile}"

# squid
blablo.log "Processing ${CYAN1}'squid'${NC} configuration"
sed -e "s|\$SQUID_PORT|$SQUID_PORT|g" \
    -e "s|\$DNSMASQ_IP|$DNSMASQ_IP|g" \
     ./configs/squid/squid.conf.dist > ./configs/squid/squid.conf
blablo.chainLog "${GREEN}DONE${NC}"
blablo.finish

# dnsmasq
blablo.log "Processing ${CYAN1}'dnsmasq'${NC} configuration"
sed -e "s|\$NGINX_REVERSE_PROXY_IP|$NGINX_REVERSE_PROXY_IP|g" \
    -e "s|\$SQUID_IP|$SQUID_IP|g" \
    -e "s|\$SQUID_PORT|$SQUID_PORT|g" \
     ./configs/dnsmasq/dnsmasq.conf.dist > ./configs/dnsmasq/dnsmasq.conf

domainNames=$(yq '.services[].domainName' nrp.yaml)
stringData=$(for domainName in "${domainNames[@]}"; do
  echo "$domainName"
done | sort -u)
normalStringData=${stringData//\"/}

# echo $normalStringData
read -ra uniqueDomains <<< $normalStringData

for domainName in "${uniqueDomains[@]}"; do
  echo "address=/$domainName/$NGINX_REVERSE_PROXY_IP" >> ./configs/dnsmasq/dnsmasq.conf
done

blablo.chainLog "${GREEN}DONE${NC}"
blablo.finish

blablo.cleanLog "🎯 Done ✨"