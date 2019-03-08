#!/bin/sh
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > tmp.sql
echo "USE $(grep 'MYSQL_DATABASE' .env | cut -d '=' -f2- | xargs);" | cat - tmp.sql > initdb.sql
rm tmp.sql
echo 'Generated initdb.sql'
