##################################################
# Manage docker containers and NeoVim configs
##################################################

DOCKERFILE = Dockerfile
env = c
neovim_configs = neovim
#local_dev_folder = ~/dev/$(env)
local_dev_folder = /home/$(USER)
container_dev_folder = /dev_work

docker_user = ssd04
docker_repo = mygoide

.PHONY: help clean build purge run list

help:
	@echo -e ""
	@echo -e "Create IDE based on NeoVim in a container environment.\n"
	@echo -e "Create container for each environment based on init.vim config from neovim directory."
	@echo -e "Available commands:"
	@echo -e "\tmake list\t\tList environemts"
	@echo -e "\tmake build env=<env>\tCreate docker image"
	@echo -e "\tmake create env=<env>\tCreate docker container"
	@echo -e "\tmake run env=<env>\tStart container and run nvim"
	@echo -e "\tmake clean env=<env>\tStop and delete container"
	@echo -e "\tmake purge env=<env>\tDelete docker container and image"
	@echo -e ""

build:
	@echo "INFO: Create link to neovim config"
	ln -s neovim/init.vim_$(env) init.vim
	ln entrypoint/entrypoint_$(env).sh docker-entrypoint.sh
	@echo "INFO: Build docker image ..."
	docker build --build-arg work_folder=$(container_dev_folder) --tag=my$(env)img -f $(DOCKERFILE) .
	@echo "INFO: Build docker image completed."
	rm init.vim
	rm docker-entrypoint.sh
	@echo "INFO: Setup completed."

create:
	@echo "INFO: Create docker image ..."
	docker create -it -v $(local_dev_folder):$(container_dev_folder) -v /run:/run --name my$(env)ide my$(env)img sh

run:
	docker start my$(env)ide
	docker exec -it my$(env)ide nvim

push:
	docker tag my$(env)ide:latest $(docker_user)/$(docker_repo):latest
	docker push $(docker_user)/$(docker_repo):latest

list:
	@ls -1 $(neovim_configs) | cut -d '_' -f 2

clean:
	@echo "INFO: Deleting docker container ..."
	docker stop my$(env)ide
	docker rm my$(env)ide
	@echo "INFO: Cleanup completed."

purge:
	@echo "INFO: Deleting docker container and image ..."
	docker stop my$(env)ide
	docker rm my$(env)ide
	docker rmi my$(env)img
	@echo "INFO: Cleanup completed."
