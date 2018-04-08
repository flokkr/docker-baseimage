

TAG := $(if $(TRAVIS_BRANCH),$(TRAVIS_BRANCH),"latest")
HASH := ""

build:
#	docker build --no-cache -t flokkr/base .
	$(eval HASH := $(shell docker run --entrypoint=git flokkr/base --work-tree=/opt/launcher/ --git-dir=/opt/launcher/.git describe --tags))
	docker build -t flokkr/base --label io.github.flokkr.launcher.version=$(HASH) .
deploy:
	docker tag flokkr/base flokkr/base:$(TAG)
	docker push flokkr/base:$(TAG)

.PHONY: deploy build
