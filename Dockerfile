# Guacamole database container using MySQL
#
# VERSION 0.1
ARG GUAC_VERSION=1.0.0
FROM guacamole/guacamole:${GUAC_VERSION} as GUAC
RUN /opt/guacamole/bin/initdb.sh --mysql > /initdb.sql

FROM mysql
COPY --from=GUAC /initdb.sql /docker-entrypoint-initdb.d/guac-init.sql
# Update these to stay in line with the official guacamole containers.

# Create a simple script that will run before the schema files and modify them
# to use the database created by the MYSQL_DATABASE environment variable.
RUN echo 'sed -i "1i USE $MYSQL_DATABASE;" /docker-entrypoint-initdb.d/*.sql' > /docker-entrypoint-initdb.d/000-use-database.sh

# Change the permissions so everything can be modified and executed at runtime.
RUN chmod 777 -R /docker-entrypoint-initdb.d/
