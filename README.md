# Flokkr base image

This repository contains the base docker image [for all other](https://github.com/flokkr?utf8=%E2%9C%93&q=docker&type=&language=) hadoop/bigdata related docker images.

It contains all the configuration loading and starting script. The detailed documentation is part of each container's README, but usually copied from the `readme-parts/` directory of this repository.

## Configuration and extensions

The flokkr containers support multiple configuration loading mechanism and various extensions. All of the these are defined in the [flokkr baseimage](https://github.com/flokkr/docker-baseimage) and could be activated by environment variables.

The available plugins:

| Name         | Description                              |
| ------------ | ---------------------------------------- |
| installer    | Download a tar file and replace existing product with that. Useful -- for example -- to test RC releases. |
| envtoconf    | **Simple configuration loading**, suggested for stand-alone docker files. Converts environment variables to xml/property configuration based on naming convention |
| retry        | Retries the run of the process. |
| consul       | **Complex configuration loading from consul**, downloads configuration from consul server and restart when the configuration is changed. Suggested for multi-host setups. |
| btrace       | Instruments the java option with custom Btrace script (with modifying the JAVA_OPTS) |
| sleep        | Wait for a defined amount of seconds. Useful for dirty workarounds (for example wait for all containers to be started and registered in dns server) |
| kerberos     | Downloads kerberos keytabs and java keystores from the rest endpoint of the unsecure [krb5 dev server](https://github.com/flokkr/docker-krb5)
| permissionfix| Workaround for docker: fixes the permission of the data volume |
### Plugin details

#### ENVTOCONF: Simple configuration loading

Could be activated by ```CONFIG_TYPE=simple``` settings, but it's the default.

Every configuration could be defined with environment variables, and they will be converted finally to *hadoop xml, properties, conf* or other format. The destination format (and the destination file name) is defined with the name of the environment variable according to a naming convention.

The generated files will be saved to the `$CONF_DIR` directory.

The source code of the converter utility can be found in a [separated repository](https://github.com/elek/envtoconf).

##### Naming convention for set config keys from enviroment variables

To set any configuration variable you should follow the following pattern:

```
NAME.EXTENSION_configkey=VALUE
```

The extension could be any extension which has a predefined transformation (currently xml, yaml, properties, configuration, yaml, env, sh, conf, cfg)

examples:

```
CORE-SITE_fs.default.name: "hdfs://localhost:9000"
HDFS-SITE_dfs_namenode_rpc-address: "localhost:9000"
HBASE-SITE.XML_hbase_zookeeper_quorum: "localhost"
```

In some rare cases the transformation and the extension should be different. For example the kafka `server.properties` should be in the format `key=value` which is the `cfg` transformation in our system. In that case you can postfix the extension with an additional format specifier:


```
NAME.EXTENSION!FORMAT_configkey=VALUE
```

For example:

```
SERVER.CONF!CFG_zookeeper.address=zookeeper:2181
```

##### Available transformation

*  xml: HADOOP xml file format

*  properties: key value pairs with ```:``` as separator

*  cfg: key value pairs with ```=``` as separator

*  conf: key value pairs with space as separator (spark-defaults is an example)

*  env: key value pairs with ```=``` as separator

*  sh: as the env but also includes the export keyword

      ##### Configuration reference

      The plugin itself could be configured with the following environment variables.

   | Name        | Default                                  | Description                              |
   | ----------- | ---------------------------------------- | ---------------------------------------- |
   | CONF_DIR    | *Set in the docker container definitions* | The location where the configuration files will be saved. |
   | CONFIG_TYPE | simple                                   | For compatibility reason. If the value is simple, the conversion is active. |

#### CONSUL: Consul config loading

Could be activated with ```CONFIG_TYPE=consul```

* The starter script list the configuration file names based on a consul key prefix. All the files will be downloaded from the consul key value store and the application process will be started with consul-template (enable an automatic restart in case of configuration file change)

The source code of the consul based configuration loading and launcher is available at the [elek/consul-launcher](https://github.com/elek/consul-launcher) repository.

| Name        | Default                                  | Description                              |
| ----------- | ---------------------------------------- | ---------------------------------------- |
| CONF_DIR    | *Set in the docker container definitions* | The location where the configuration files will be saved. |
| CONFIG_TYPE | consul                                   | For compatibility reason. If the value is consul, the consul based configuration handling is active. |
| CONSUL_PATH | conf                                     | The path of the subtree in the consul where the configurations are. |
| CONSUL_KEY  |                                          | The  path where the configuration for this container should be downloaded from. The effective path will be ```$CONSUL_PATH/$CONSUL_KEY``` |

#### BTRACE: btrace instrumentation

Could be enabled with setting ```BTRACE_ENABLED=true``` or just setting ```BTRACE_SCRIPT```.

It adds btrace javaagent configuration to the JAVA_OPTS (or any other opts defined by BTRACE_OPTS_VAR). The standard output is redirected to ```/tmp/output.log```, and the btrace output will be displayed on the standard output (over a ```/tmp/btrace.out``` file)

| Name            | Default                                  | Description                              |
| --------------- | ---------------------------------------- | ---------------------------------------- |
| CONF_DIR        | *Set in the docker container definitions* | The location where the configuration files will be saved. |
| BTRACE_SCRIPT   | <notset>                                 | The location of the compiled btrace script. Could be absolute or relative to the ```/opt/plugins/020_btrace/btrace``` |
| BTRACE_OPTS_VAR | JAVA_OPTS                                | The name of the shell variable where the agent parameters should be injected. |


#### Configuration

* `CONSUL_PATH` defines the root of the subtree where the configuration are downloaded from. The root could also contain a configuration `config.ini`. Default is `conf`

* `CONSUL_KEY` is optional. It defines a subdirectory to download the the config files. If both `CONSUL_PATH` and `CONSUL_KEY` are defined, the config files will be downloaded from `$CONSUL_PATH/$CONSUL_KEY` but the config file will be read from `$CONSUL_PATH/config.ini`

#### INSTALLER: replace built in components

The original products usually unpacked to the /opt directory during the container build (eg. /opt/hadoop, /opt/spark, etc...). The install plugin deletes the original product directory and replaces it with a newly one downloaded from the internet.

| Name          | Default  | Description                              |
| ------------- | -------- | ---------------------------------------- |
| INSTALLER_XXX | <notset> | The value of the environment variable should be an url. If set, the URL will be downloaded and untar-ed to the /opt/xxx directory. For example set ```INSTALER_HADOOP=http://home.apache.org/~shv/hadoop-2.7.4-RC0/https://home.apache.org/~shv/hadoop-2.7.4-RC0/hadoop-2.7.4-RC0.tar.gz``` to test an RC. |

#### SLEEP: sleep for a specified amount of time.

| Name          | Default  | Description                              |
| ------------- | -------- | ---------------------------------------- |
| SLEEP_SECONDS | <notset> | If set, the ```sleep``` bash command will be called with the value of the environment variable. Better to not use this plugin, if possible. |

#### RETRY: process running retry

The plugin tries to run the entrypoint of the image multiple times. If the process has been exited with non zero exit code, it tries to rerun the command after a sleep. The sleep time increasing with every iteration and the whole process will be stopped anyway after a fix amount of retry. If the process run enough time (60s) the failure counter and sleep time is reseted.  

### Configuration

| Name          | Default  | Description                              |
| ------------- | -------- | ---------------------------------------- |
| RETRY_NUMBER  | 10       | Number of times the process will be restarted (in case of non-zero exit code |
| RETRY_NORMAL_RUN_DURATION | 60 | After this amount of seconds the RETRY_NUMBER counter will be reseted. Example: After 5 tries the process is started and run successfully 5 minutes. After a non-zero exit, it will be rerun RETRY_NUM (10) times. Example 2: After 5 tries the process is starts, runs for 40 seconds, and exits. The retry will continue with the remaining 5 try. |

#### KERBEROS: download kerberos keytabs and ssl key/truststore

Our total UNSECURE [kerberos server](https://github.com/flokkr/docker-krb5) contains a REST endpoint to download on-the-fly generated kerberos keytabs, java keystores (ssl keystores, trustores). This plugin could be configured to download the files. The plugin also copies krb5.cfg to /etc.

### Configuration

| Name               | Default  | Description                              |
| ------------------ | -------- | ---------------------------------------- |
| KERBEROS_SERVER    | krb5     | The name of the UNSECURE kerberos server where the REST endpoint is available on :8081 |
| KERBEROS_KEYTABS   | <notset> | Space separated list of keytab names. With every element a new keytab will generated to $CONF_DIR/$NAME.keytab with a key for $NAME/$HOSTNAME@EXAMPLE.COM. |
| KERBEROS_KEYSTORES | <notset> | Space separated list of certificate names. For every name a new keystore file will be generated to the $CONF_DIR/$NAME.keystore which contains a key for cn=$NAME. Trust store  will also be generated to $CONF_DIR/truststore. |

## Changelog

### Version 22

 * Permission fixer plugin

### Version 21

 * Custom flokkr group with sudo permission

### Version 20

 * Consul start bugfix

### Version 19

 * Retry plugin
 * Kerberos plugin

### Version 18

* Sleep and installer plugins

### Version 17

- Refactored (hopefully simplified) architecture with plugin chain
- BTrace support

### Version 16

- Use fixed version from envtoconf

### Version 15

- Fixes in the configuration generation and handling

### Version 14

* Python installation has been removed
* Environment based configuration has been switched from python to a more simple [go implementation](https://github.com/elek/envtoconf)

### Version 13

* Spring configserver based configuration has been removed
* Consul based configuration reader ported to go
* Client side configuration file has been removed
