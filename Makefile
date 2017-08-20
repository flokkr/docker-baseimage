

TAG := $(if $(TRAVIS_TAG),$(TRAVIS_TAG),"latest")

build:
	docker build -t flokkr/base .

deploy:
	docker tag flokkr/base flokkr/base:$(TAG)
	docker push flokkr/base:$(TAG)

.PHONY: deploy build
