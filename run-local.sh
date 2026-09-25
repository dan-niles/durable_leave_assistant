#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
read -rsp "OpenRouter API key: " BAL_CONFIG_VAR_OPENROUTERAPIKEY
echo
export BAL_CONFIG_VAR_OPENROUTERAPIKEY
exec java -jar target/bin/durable_leave_assistant.jar
