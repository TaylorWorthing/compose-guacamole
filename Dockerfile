# Guacamole database container using MySQL
#
# VERSION 0.1

FROM mysql

ADD ./schema/initdb.sql /docker-entrypoint-initdb.d/
# Create a simple script that will run before the schema files and modify them
# to use the database created by the MYSQL_DATABASE environment variable.

# Change the permissions so everything can be modified and executed at runtime.
RUN chmod 777 -R /docker-entrypoint-initdb.d/
