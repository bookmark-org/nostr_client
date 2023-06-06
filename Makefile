default: help

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

.PHONY: build
build: # Build docker image.
	docker build -t nostr-client:latest .
	docker tag nostr-client:latest bookmarkorg/nostr-client:latest

.PHONY: push-image
push-image: # Push image to registry
	docker tag nostr-client:latest bookmarkorg/nostr-client:latest
	docker push bookmarkorg/nostr-client:latest

.PHONY: pull-images
pull-images: # Pull images from registry
	docker pull bookmarkorg/nostr-client:latest