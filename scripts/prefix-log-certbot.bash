#!/bin/bash

padded_name=$(printf "%-10s" "certbot")

# Prefix outputs with Time Stamp and Process Name
exec 1> >(while IFS= read -r line; do echo "${padded_name} | $line"; done >&1)
exec 2> >(while IFS= read -r line; do echo "${padded_name} | $line"; done >&2)

exec "$@"