# build or push the corydodt/circus-base images
#


.PHONY: circus-base images push

all:


RELEASE_VERSION=$(shell python setup.py --version)
NAME=corydodt/circus-base

circus-base:
	docker build \
		-t $(NAME):latest \
		-t $(NAME):$(RELEASE_VERSION) \
		$$(pwd)
	
images: circus-base

push: images
	docker push $(NAME):latest
	docker push $(NAME):$(RELEASE_VERSION)
