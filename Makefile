

TRAVIS_TAG ?= latest

build:
	docker build -t flokkr/base .

deploy:
	docker tag flokkr/base flokkr/base:$(TRAVIS_TAG)
	docker push flokkr/base:$(TRAVIS_TAG)

.PHONY: deploy build
