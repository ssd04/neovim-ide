#!/bin/bash
set -e

if [ "$1" = 'nvim' ]; then
    nvim +GoInstallBinaries +qall 1> /dev/null
    exec "$@"
fi

exec "$@"
