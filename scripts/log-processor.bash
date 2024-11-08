#!/bin/bash

escape_json() {
    printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

process_log_line() {
    local line="$1"
    local default_level="$2"

    # Extract log level from square brackets if present, but exclude HTTPS
    if [[ $line =~ \[([-a-zA-Z]+)\] ]] && [[ ${BASH_REMATCH[1]} != "HTTPS" ]]; then
        level="${BASH_REMATCH[1]}"
    elif [[ $line =~ WARNING ]]; then
        level="warning"
    elif [[ $line =~ INFO ]]; then
        level="info"
    elif [[ $line =~ DEBUG ]]; then
        level="debug"
    elif [[ $line =~ ERROR ]]; then
        level="error"
    elif [[ $line =~ WARN ]]; then
        level="warning"
    else
        level="$default_level"
    fi
    
    # Strip timestamp and process ID if present
    cleaned_line=${line#[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]*\]*: }
    # Then try to remove "YYYY/MM/DD HH:MM:SS|" pattern
    cleaned_line=${cleaned_line#[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]*| }
    # Then try to remove "dnsmasq[NUMBER]:" pattern
    cleaned_line=${cleaned_line#dnsmasq\[[0-9]*\]: }
    # Then try to remove "INFO | ", "WARN | ", "ERROR | " patterns
    cleaned_line=${cleaned_line#INFO | }
    cleaned_line=${cleaned_line#WARN | }
    cleaned_line=${cleaned_line#ERROR | }
    cleaned_line=${cleaned_line#DEBUG | }
    
    # If line is already JSON, handle differently
    if [[ $cleaned_line == {* ]]; then
        echo "{\"process\":\"${SUPERVISOR_PROCESS_NAME}\",\"level\":\"${level}\",\"jsonLog\":${cleaned_line}}"
    else
        escaped_line=$(escape_json "$cleaned_line")
        echo "{\"process\":\"${SUPERVISOR_PROCESS_NAME}\",\"level\":\"${level}\",\"log\":${escaped_line}}"
    fi
}

exec 1> >(while IFS= read -r line; do process_log_line "$line" "info" >&1; done)
exec 2> >(while IFS= read -r line; do process_log_line "$line" "info" >&2; done)

exec "$@"