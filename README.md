# compose-guacamole

[Guacamole](https://guacamole.incubator.apache.org/) is a really useful tool,
but can be difficult to setup properly. The deployment  process can be greatly
simplified using docker containers, and orchestrated using `docker-compose`.

This is a sample configuration for `docker-compose` that puts together all the components needed to deploy guacamole in a containerized environment. I merely fixed it and updated it to the newer official containers as of November 2017.

This is currently version-pinned to `0.9.12-incubating`, since the database `Dockerfile` requires the client repository to be properly tagged to extract the database schema, and at the time of this writing there wasn't a newer tag.

## Usage

Assuming you already have a working Docker installation and `docker-compose`,
setup is really easy.

```
git clone git@github.com:BrowncoatShadow/compose-guacamole.git
cd docker-compose-guacamole
./generate_sql.sh
docker-compose up -d
```

Give it a few seconds to initialize and then you can access guacamole
at `http://docker-host:8080/guacamole/`. The default username and password are
both `guacadmin` (go to your user preferences to change it, and then create another user for regular use).

You _definitely_ want to open the `.env` file and change the example database passwords
before deploying this to anything resembling a production environment.

## Behind the Scenes

`docker-compose` brings together several components to make this work.

- `guacamole_data` - A persistent data volume that stores all the data even
  if the containers are destroyed.
- `guacamole_db_1` - A MySQL container that acts as the database for all of
  guacamole's data.
- `guacamole_guacd_1` - The guacamole server daemon (`guacd`) container that handles all the
  remote connections that guacamole makes.
- `guacamole_guacamole_1` - The guacamole client web application container that ties
  everything together and provides the front-end for the user.


## The Database Problem

Guacamole does not initialize its own database tables. Per the official
documentation, the user is expected to create the database manually and use
tools from the client container to generate the needed schema files to
initialize the database tables.

That is not very portable for a Docker container, which should be able to be
created and destroyed on the fly. This is remedied in this project with
the `generate_sql.sh` script and a `Dockerfile` for the database container that
uses the generated schema file and uses environment variables to
self-initialize.
