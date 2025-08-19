export HASKELL_GHC_VERSION
export HASKELL_CABAL_VERSION
export HASKELL_GIT_REPO_URL

help:
	@echo "Usage:"
	@echo
	@echo "   image            Build hs-static-bin Docker image"
	@echo "   show-env-vars    Show hs-static-bin environment variables settings"
	@echo "   envrc            Create a .envrc for hs-static-bin environment variables"
	@echo "   binary           Build an Haskell static binary"
	@echo "   clean            Remove static-bin/ where Haskell binary artifacts are delivered"
	@echo "   docker-clean     Remove hs-static-bin image and containers from Docker"
	@echo "   clean-all        Clean and docker-clean combined"
	@echo "   help             Show this usage notice"
	@echo
	@echo "Copyright (c) 2025 Michel Boucey (github.com/MichelBoucey/hs-static-bin)"

image:
	docker buildx build \
	--build-arg BOOTSTRAP_HASKELL_GHC_VERSION=$(HASKELL_GHC_VERSION) \
	--build-arg BOOTSTRAP_HASKELL_CABAL_VERSION=$(HASKELL_CABAL_VERSION) \
	-t hs-static-bin:ghc-$(HASKELL_GHC_VERSION) docker/

show-env-vars:
	@echo "HASKELL_CABAL_VERSION=$(HASKELL_CABAL_VERSION)"
	@echo "HASKELL_GHC_VERSION=$(HASKELL_GHC_VERSION)"
	@echo "HASKELL_GIT_REPO_URL=$(HASKELL_GIT_REPO_URL)"

binary:
	@if [ -n "$$HASKELL_GHC_VERSION" ] && [ -n "$$HASKELL_GIT_REPO_URL" ]; then \
	    echo "OK... trying to build Haskell static binary artifacts at $(HASKELL_GIT_REPO_URL)"; \
	else \
	    echo "You have to set env vars HASKELL_GHC_VERSION and HASKELL_GIT_REPO_URL"; \
	    exit 1; \
	fi
	@test -d $(CURDIR)/static-bin || mkdir $(CURDIR)/static-bin
	docker run \
	--env HASKELL_GIT_REPO_URL \
	--env CURUID=$(shell id -u) \
	--env CURGID=$(shell id -g) \
	--mount type=bind,src=$(CURDIR)/script/,dst=/tmp/script/ \
	--mount type=bind,src=$(CURDIR)/static-bin/,dst=/tmp/bin/ \
	hs-static-bin:ghc-$(HASKELL_GHC_VERSION) \
	/bin/ash /tmp/script/build.sh
	strip --strip-all $(CURDIR)/static-bin/*
	make --no-print-directory docker-clean-containers

envrc:
	@make --no-print-directory show-env-vars | sed 's/^/export /' > .envrc

clean:
	rm -rf $(CURDIR)/static-bin/

docker-clean-containers:
	@echo $(shell docker ps -a -q -f ancestor=hs-static-bin:ghc-$$HASKELL_GHC_VERSION -f status=exited) | xargs -r docker rm -f

docker-clean: docker-clean-containers
	@echo $(shell docker images | grep -P hs-static-bin\\s*ghc-$$HASKELL_GHC_VERSION | awk '{print $$3}' | uniq) | xargs -r docker rmi

clean-all: clean docker-clean
