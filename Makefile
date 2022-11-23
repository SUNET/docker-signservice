VERSION := 1.4.5
EIDAS_BUILD_ARGS := "--you --forgot --username --and --passw"
-include local.mk

all: build push

build: 
	./build.sh $(EIDAS_BUILD_ARGS) --version $(VERSION) -i signservice --tag $(VERSION)

push:
	docker tag signservice:$(VERSION) docker.sunet.se/signservice:$(VERSION)
	docker push docker.sunet.se/signservice:$(VERSION)
