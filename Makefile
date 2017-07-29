

build:
	docker build -t flokkr/base .

deploy:
	docker push flokkr/base

.PHONY: deploy build
