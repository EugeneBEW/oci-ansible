VERSION=v6
NAME=oci-ansible

.PHONY: all

all: 
	docker build -t "$(NAME):$(VERSION)" --label "name"="$(NAME)" --label "version"="$(VERSION)" . \
		&& docker save $(NAME):$(VERSION) | gzip > $(NAME)-$(VERSION).tgz
