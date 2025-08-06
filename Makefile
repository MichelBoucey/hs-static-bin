help:
	@echo "Usage:"
	@echo
	@echo "   image          Build hs-static-bin Docker image"
	@echo "   binary         Build an Haskell static binary"
	@echo "   clean          Remove static-bin/ where Haskell binary artifacts are delivered"
	@echo "   docker-clean   Remove hs-static-bin image and containers from Docker"
	@echo "   clean-all      clean and docker-clean combined"
	@echo "   help           Show this usage notice"
	@echo
	@echo "Copyright (c) 2025 Michel Boucey (https://github.com/MichelBoucey/hs-static-bin)"

show-image-env-vars:
	@echo "BOOTSTRAP_HASKELL_CABAL_VERSION=$(BOOTSTRAP_HASKELL_CABAL_VERSION)"
	@echo "BOOTSTRAP_HASKELL_GHC_VERSION=$(BOOTSTRAP_HASKELL_GHC_VERSION)"

export CURUID:=$(shell id -u)
export CURGID:=$(shell id -g)
export BOOTSTRAP_HASKELL_GHC_VERSION
export BOOTSTRAP_HASKELL_CABAL_VERSION
image:
	docker buildx build \
	--build-arg CURUID=$(CURUID) \
	--build-arg CURGID=$(CURGID) \
	--build-arg BOOTSTRAP_HASKELL_GHC_VERSION=$(BOOTSTRAP_HASKELL_GHC_VERSION) \
	--build-arg BOOTSTRAP_HASKELL_CABAL_VERSION=$(BOOTSTRAP_HASKELL_CABAL_VERSION) \
	-t hs-static-bin ./docker/

show-binary-env-vars:
	@echo "HASKELL_GIT_REPO_URL=$(HASKELL_GIT_REPO_URL)"

export HASKELL_GIT_REPO_URL
binary:
	@if [ -z "$$HASKELL_GIT_REPO_URL" ]; then \
	    echo "You have to set env var HASKELL_GIT_REPO_URL"; \
	    exit 1; \
	else \
	    echo "OK... trying to build an Haskell static binary artifact from $(HASKELL_GIT_REPO_URL)"; \
	fi
	@test -d $(CURDIR)/static-bin || mkdir $(CURDIR)/static-bin
	docker run \
	--mount type=bind,src=$(CURDIR)/script/,dst=/tmp/script/ \
	--mount type=bind,src=$(CURDIR)/static-bin/,dst=/tmp/bin/ \
	hs-static-bin /bin/ash /tmp/script/build.sh $(HASKELL_GIT_REPO_URL)
	strip --strip-all $(CURDIR)/static-bin/*

show-env-vars: show-image-env-vars show-binary-env-vars

clean:
	rm -rf $(CURDIR)/static-bin/

docker-clean:
	echo $(shell docker ps -a -q -f ancestor=hs-static-bin) | xargs -r docker rm -f
	echo $(shell docker images | grep hs-static-bin | awk '{print $$3}' | uniq) | xargs -r docker rmi

clean-all: clean docker-clean
