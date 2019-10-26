DOCKERFILE = Dockerfile

.PHONY: help c go clean-c clean-go

help:
	@echo help me

c:
	@echo "INFO: Create link to neovim config"
	ln -s neovim/init.vim_$@ init.vim
	@echo "INFO: Build docker image ..."
	docker build --tag=my$@img -f $(DOCKERFILE) .
	@echo "INFO: Build docker image completed."
	@echo "INFO: Create docker image ..."
	docker create -it -v ~/dev/c:/dev_work -v /run:/run --name my$@ide my$@img sh
	rm init.vim
	@echo "INFO: Setup completed."

go:
	@echo "ENV GOPATH /dev" >> $(DOCKERFILE)
	ln -s neovim/init.vim_$@ init.vim
	docker build --tag=my$@img -f $(DOCKERFILE) .
	docker create -it -v ~/dev/c:/dev_work -v /run:/run --name my$@ide my$@img sh
	rm init.vim

clean-c:
	@echo "INFO: Deleting docker container and image ..."
	docker stop mycide
	docker rm mycide
	docker rmi mycimg
	@echo "INFO: Cleanup completed."

clean-go:
	@echo "INFO: Deleting docker container and image ..."
	docker stop mygoide
	docker rm mygoide
	docker rmi mygoimg
	@echo "INFO: Cleanup completed."
