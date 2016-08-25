# Guacamole database container using MySQL
#
# VERSION 0.1

FROM mysql

# Update these to stay in line with the official guacamole containers.
ARG GUAC_REPO=glyptodon/guacamole-client
ARG GUAC_VERSION=0.9.9

# Fetch the needed schema files from the guacamole repo and place them where the
# container will use them when initializing the server.
ARG BASE_URL=https://raw.githubusercontent.com/${GUAC_REPO}/${GUAC_VERSION}/extensions/guacamole-auth-jdbc/modules/guacamole-auth-jdbc-mysql/schema/
ADD ${BASE_URL}001-create-schema.sql /docker-entrypoint-initdb.d/
ADD ${BASE_URL}002-create-admin-user.sql /docker-entrypoint-initdb.d/

# Create a simple script that will run before the schema files and modify them
# to use the database created by the MYSQL_DATABASE environment variable.
RUN echo 'sed -i "1i USE $MYSQL_DATABASE;" /docker-entrypoint-initdb.d/*.sql' > /docker-entrypoint-initdb.d/000-use-database.sh

# Change the permissions so everything can be modified and executed at runtime.
RUN chmod 777 -R /docker-entrypoint-initdb.d/
