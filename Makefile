IMAGE ?= fishOS:latest

.PHONY: build run shell iso

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm -it $(IMAGE)

shell:
	docker compose run --rm ubuntu-base /bin/bash

iso:
	bash scripts/build-iso.sh
