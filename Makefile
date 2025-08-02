build:
	@test -d static-bin || mkdir static-bin
	docker run --mount type=bind,src=$(CURDIR)/static-bin/,dst=/tmp/bin/ -it hs-static-bin

build-image:
	docker buildx build -t hs-static-bin ./docker

all: clean build-image build

clean:
	rm -rf $(CURDIR)/static-bin/
