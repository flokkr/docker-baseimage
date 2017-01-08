#!/bin/bash
DOCKER_TAG=${DOCKER_TAG:-latest}
docker build -t elek/bigdata-base:$DOCKER_TAG .
