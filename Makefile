
help:
	@echo "Usage:"
	@echo
	@echo "   build         Build static binary"
	@echo "   build-image   Build hs-static-bin Docker image"
	@echo "   clean         Remove exited hs-static-bin containers from Docker"
	@echo "   clean-all     Remove also static-bin/ where static binaries are copied"
	@echo

build:
	@test -d static-bin || mkdir static-bin
	docker run --mount type=bind,src=$(CURDIR)/static-bin/,dst=/tmp/bin/ -it hs-static-bin

build-image:
	docker buildx build -t hs-static-bin ./docker

all: clean build-image build

clean:
	docker rm $(docker container ls -a -q --filter ancestor=hs-static-bin --filter status=exited)

clean-all: clean
	rm -rf $(CURDIR)/static-bin/
