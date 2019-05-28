.PHONY : all final 

all : final

code-server : Dockerfile.1
	docker build -t vscode:build . -f Dockerfile.1 && \
	docker container create --name extract vscode:build && \
	docker container cp extract:/src/packages/server/cli-linux-x64 ./code-server  && \
	docker container rm -f extract

ubuntu.log : Dockerfile.2
	docker build -t ubuntu-cxx . -f Dockerfile.2 && touch ubuntu.log
	
final : code-server ubuntu.log Dockerfile
	docker build -t vscode:latest . && touch final.log

