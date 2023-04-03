#!/bin/bash
# shellcheck source=/dev/null
source /home/ampersand/.bashrc
set -euo pipefail
cd /var/www/html
eval "$1"