#!/bin/bash
set -e

if [ "$1" = 'nvim' ]; then
    # custom setup here
    exec "$@"
fi

exec "$@"
