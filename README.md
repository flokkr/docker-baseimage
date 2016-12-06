

This repository contains docker images for all other hadoop/bigdata related docker images.

## Configuration

There are multiple ways to configure the images based on image. The configuration methods are stored in the ```/opt/configuration``` directory and could be selected by setting the environment variable CONFIG_TYPE

### Simple configuration

This is the default configuration.

Main behaviours:

 * Only overwrite config files if they do not exist. (Typically from the frist run)
 * There are default configuration in the /opt/default configuration
 * All the configuration are stored as key=value pairs but they are converted to the appropriate format (eg. hadoop xml configuration format).
 * Any configuration variable could be overridden with environment variable with the form ```CONFIG_FILE_NAME_config_key=value```
 * All the hadoop configurations could be overridden with environment variables, with the form: ```CONFIG_FILE_NAME_CONFIG_NAME``` For example CORE_SITE_FS_DEFAULT_NAME=hdfs://xxx will generate a ```fs.default.name=hdfs://xxx``` entry to the core-site.xml, but *only at the first time, if config file doesn't exists```
 * But this is only works if there is a (possible empty) default file in the /opt/defaults directory. (Eg. if a /opt/defaults/core-site.xml exists, the ```CORE_SITE_fs_default_name=hdfs://xxxx:9000``` will valid 
### Simle consul config loading

Could be activated with ```CONFIG_TYPE=consul-simple```

 * The starter script iterates over the existing files in defaults directory. All the files will be downloaded from the consul key value store and the application process will be started with consul-template (enable an automatic restart in case of configuration change)
 * ```CONSUL_PREFIX``` contains the prefix of the subtree in the consul key value store (default is ```conf```)
 * Consul server location could set with ```CONSUL_SERVER``` environment variable (default is ```localhost:8500```)
