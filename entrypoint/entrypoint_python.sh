#!/bin/bash
set -e

if [ "$1" = "nvim" ]; then
    pip install jedi &> /dev/null
    exec "$@"
fi

exec "$@"
