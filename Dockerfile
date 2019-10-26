FROM alpine:latest

MAINTAINER ssd04

ENV TERM screen-256color

COPY init.vim /root/.config/nvim/init.vim

COPY setup_neovim.sh /tmp/setup_neovim.sh
RUN chmod +x /tmp/setup_neovim.sh
RUN ["/tmp/setup_neovim.sh"]

RUN mkdir /dev_work
WORKDIR /dev_work
