

TAG := $(if $(TRAVIS_BRANCH),$(TRAVIS_BRANCH),"latest")

build:
	docker build --no-cache -t flokkr/base .

deploy:
	docker tag flokkr/base flokkr/base:$(TAG)
	docker push flokkr/base:$(TAG)

.PHONY: deploy build
