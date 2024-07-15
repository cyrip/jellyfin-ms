# Define variables
IMAGE_NAME = cyrip/samba
TAG = latest

# Default target
.PHONY: all
all: build

# Build the Docker image
.PHONY: build
build:
	@echo "Building Docker image $(IMAGE_NAME):$(TAG)..."
	docker buildx build -t $(IMAGE_NAME):$(TAG) .
	docker push $(IMAGE_NAME):$(TAG)

# Clean target (optional, can be used to remove the image)
.PHONY: clean
clean:
	@echo "Removing Docker image $(IMAGE_NAME):$(TAG)..."
	docker compose -f docker-compose.yml rm -fsv
	docker rmi $(IMAGE_NAME):$(TAG)

# Run target (optional, can be used to run the built image)
.PHONY: run
run:
	@echo "Running Jellyfin/Samba MS ..."
	./change-permissions.sh
	docker compose -f docker-compose.yml up -d
