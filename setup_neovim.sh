#!/bin/sh

get_os_type ()
{
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
    elif type lsb_release > /dev/null 2>&1; then
        OS=$(lsb_release -si)
        VERSION=$(lsb_release -sr)
    else
        OS=$(uname -s)
        VERSION=$(uname -r)
    fi
}

install_package ()
{
    if [ -z "$1" ]; then
        echo "No package parameter supplied."
    fi

    case $OS in
        "Ubuntu")
            echo "INFO: Installing package [ $1 ] ..."
            apt-get install $1 -y 1> /dev/null || (echo "ERROR: Installation of package $1 failed." && exit 1)
            ;;
        "Arch Linux")
            echo "INFO: Installing package [ $1 ] ..."
            pacman -S $1 --noconfirm 1> /dev/null || (echo "ERROR: Installation of package $1 failed." && exit 1)
            ;;
        "Alpine Linux")
            echo "INFO: Installing package [ $1 ] ..."
            apk add --update --no-cache $1 1> /dev/null || (echo "ERROR: Installation of package $1 failed." && exit 1)
            ;;
        *)
            echo "This script is not compatible with this OS."
            ;;
    esac
}

install_dein()
{
    curl -s https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
    chmod +x /tmp/installer.sh
    echo "INFO: Install [ dein ] ..."
    sh /tmp/installer.sh ~/.cache/dein &> /dev/null
    #echo "INFO: Install neovim plugins ..."
    #nvim -c 'call dein#install()' 1> /dev/null
    echo "INFO: dein setup done."
}

install_neovim()
{
    install_package neovim
    echo "INFO: Install python2 support ..."
    pip install neovim &> /dev/null
    echo "INFO: Install python3 support ..."
    pip3 install neovim &> /dev/null
}

olg_pkgs='
        automake
        m4
        autoconf
        xz
        unzip
        ncurses ncurses-dev ncurses-libs ncurses-terminfo
        clang
        linux-headers
    '

packages='
        git
        alpine-sdk build-base
        libtool
        python
        python3
        python-dev
        python3-dev
        py-pip
        go
        curl
    '

install_packages()
{
    echo "INFO: Install dependencies"
    for i in $packages; do
        install_package "$i"
    done
    rm -rf /var/cache/apk/*
}

custom_setup()
{
    # setup working dir
    cd ~

    echo "INFO: Install nvim plugins."
    nvim +'call dein#install()' +qall &> /dev/null
    nvim +UpdateRemotePlugins +qall &> /dev/null
    #echo "INFO: Install go binaries."
    #nvim +GoInstallBinaries +qall 1> /dev/null
}

# Main flow
get_os_type

install_packages
install_neovim
install_dein

custom_setup

echo "INFO: Config setup finished successfully."

exit 0
