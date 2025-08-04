CURUSER=$(shell whoami)

help:
	@echo "Usage:"
	@echo
	@echo "   image         Build hs-static-bin Docker image"
	@echo "   binary        Build static binary (needs sudo root)"
	@echo "   clean         Remove static-bin/ where the binary artefact is delivered"
	@echo "   clean-all     Remove also hs-static-bin Docker image"
	@echo "   help          Show this usage notice"
	@echo
	@echo "Copyright (c) 2025 Michel Boucey (https://github.com/MichelBoucey/hs-static-bin)"

image:
	docker buildx build -t hs-static-bin ./docker/

binary: clean
	@mkdir ${CURDIR}/static-bin
	docker run \
	--mount type=bind,src=$(CURDIR)/script/,dst=/tmp/script/ hs-static-bin \
	--mount type=bind,src=$(CURDIR)/static-bin/,dst=/tmp/bin/ \
	/bin/ash /tmp/script/build.sh
	sudo chown ${CURUSER}:${CURUSER} ${CURDIR}/static-bin/*
	strip --strip-all ${CURDIR}/static-bin/*

all: clean-all image binary

clean:
	rm -rf $(CURDIR)/static-bin/

clean-all: clean
	docker rm hs-static-bin
