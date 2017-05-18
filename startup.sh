#!/bin/bash

DATA_DIR=/opt/soda/datadir

[[ -d $DATA_DIR/mysql ]] || mkdir -p $DATA_DIR/mysql
[[ -d $DATA_DIR/soda ]] || mkdir -p $DATA_DIR/soda

echo "using data dir: $DATA_DIR"

echo "start the MySQL container ..."
# to expose the 3306 port to the host, add: -p 3306:3306  
docker run \
  --name soda-mysql \
  -v $DATA_DIR/mysql:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=r00t \
  -e MYSQL_DATABASE=soda \
  -e MYSQL_USER=soda-user \
  -e MYSQL_PASSWORD=soda-pw \
  -d mysql/mysql-server:5.7 \
  --character-set-server=utf8 \
  --collation-server=utf8_general_ci \
  --max_allowed_packet=25M \
  --sql-mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"

echo "start the soda4LCA container and link it to MySQL ..."
# use the options `--rm -it` instead of -d to run the container
# in interactive mode
docker run \
  -p 8080:8080 \
  -v $DATA_DIR/soda:/opt/soda/data
  --name soda \
  --link soda-mysql:mysqld \
  -d soda

echo "all done"
