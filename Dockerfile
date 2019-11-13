FROM alpine:latest

MAINTAINER ssd04

ARG work_folder=/dev_work

ENV TERM screen-256color
ENV GOPATH ${work_folder}

COPY init.vim /root/.config/nvim/init.vim

COPY setup_neovim.sh /tmp/setup_neovim.sh
RUN chmod +x /tmp/setup_neovim.sh
RUN ["/tmp/setup_neovim.sh"]

RUN mkdir ${work_folder}
WORKDIR ${work_folder}

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nvim"]
