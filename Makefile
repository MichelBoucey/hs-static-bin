
install: build
	docker run --mount type=bind,src=/home/hank/.cabal/bin/,dst=/tmp/bin/ -it hs-static-bin

build: pre-build
	docker buildx build -t hs-static-bin ./docker

pre-build:
	@test -d bin || mkdir bin
