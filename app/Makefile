TAG ?= latest
REGISTRY_ID ?= 351279727922
REPOSITORY_REGION ?= eu-central-1
APP_NAME ?= apache-server
ENV_NAME ?= dev-server
REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/${APP_NAME}-${ENV_NAME}

.PHONY: build
build:
		aws ecr get-login-password --region $(REPOSITORY_REGION) | docker login --username AWS --password-stdin $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com
		docker build -t $(REPO_NAME):$(TAG) .
		docker push $(REPO_NAME):$(TAG)