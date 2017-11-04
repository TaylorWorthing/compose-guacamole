[Guacamole](https://guacamole.incubator.apache.org/) is a really useful tool,
but can be difficult to setup properly. The deployment  process can be greatly
simplified using docker containers, and orchestrated docker-compose.

This is a sample configuration for docker-compose (originally from [BrowncoatShadow](https://github.com/BrowncoatShadow/compose-guacamole) that puts together all the
components needed to deploy guacamole in a containerized environment.

## Usage
Assuming you already have a working docker installation and docker-compose,
setup is really easy.

```
git clone git@github.com:rcarmo/docker-compose-guacamole.git
cd docker-compose-guacamole
docker-compose up -d
```

Give it a few seconds to initialize and then you can access guacamole
at `http://docker-host:8080/guacamole/`. The default username and password are
both `guacadmin`.

You definitely want to open the `.env` file and change the example database passwords
before deploying this to anything resembling a production environment.


## Behind the Scenes
Docker-compose is putting together several components to make this work.

- `guacamole_data` - A persistent data volume that stores all the data even
  if the containers are destroyed.
- `guacamole_db_1` - A MySQL container that acts as the database for all of
  guacamole's data.
- `guacamole_server_1` - The guacamole-server daemon (guacd) container that handles all the
  remote connections that guacamole makes.
- `guacamole_client_1` - The guacamole-client web application container that ties
  everything together and provides the front-end for the user.


## The Database Problem
Guacamole does not initialize it's own database tables. Per the official
documentation, the user is expected to create the database manually and use
tools from the client container to generate the needed schema files to
initialize the database tables.

That is not very portable for a docker containers, which should be able to be
created and destroyed on the fly. This can be remedied with a Dockerfile for the
database container that fetches the needed schema files, and uses environment
variables to create the needed database and user.
