include env_make
NS = docker.antillion.com:5000
VERSION ?= antillion-devel-api
PRIVATE_REG = docker-registry.poven.antillion.mil.uk:5000

REPO = salt-master-docker
NAME = salt-master
INSTANCE = default

.PHONY: build push shell run start stop rm release

build:
	sudo docker build -t $(NS)/$(REPO):$(VERSION) .
	sudo docker tag -f $(NS)/$(REPO):$(VERSION) $(PRIVATE_REG)/$(REPO):$(VERSION)

push:
	sudo gcloud docker -- push $(NS)/$(REPO):$(VERSION)

push_private:
	sudo docker push $(PRIVATE_REG)/$(REPO):$(VERSION)

tag_private: build
	sudo docker tag $(NS)/$(REPO):$(VERSION) $(PRIVATE_REG)/$(REPO):$(VERSION)

push_docker:
	sudo docker tag -f $(NS)/$(REPO):$(VERSION) antillion/salt-master-docker:$(VERSION)
	sudo docker push antillion/salt-master-docker:$(VERSION)

shell:
	sudo docker run --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/bash

run:
	echo "Note: to kill you'll need to Ctrl+Z and then issue: make kill"
	sudo docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

kill:
	sudo docker kill $(NAME)-$(INSTANCE)

start:
	sudo docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	sudo docker stop $(NAME)-$(INSTANCE)

test:
	rake SPEC_USER=$(SPEC_USER) SPEC_PASSWORD=$(SPEC_PASSWORD)

rm:
	sudo docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build
