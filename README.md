# Bigdata base image

This repository contains docker images [for all other](https://github.com/elek/bigdata-docker) hadoop/bigdata related docker images.

It contains all the configuration loading and starting script. The detailed documentation is part of each container's README, but usually copied from the `readme-parts/` directory of this repository.

## Changelog

### Version 14

 * Python installation has been removed
 * Environment based configuration has been switched from python to a more simple [go implementation](https://github.com/elek/envtoconf)

### Version 13

 * Spring configserver based configuratio has been removed
 * Consul based configuration reader ported to go
 * Client side configuration file has been removed
