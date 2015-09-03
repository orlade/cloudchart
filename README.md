# Cortex

**Cortex** is an application for monitoring and managing the Urbanetic infrastructure, including the
Fabric application and its associated services and databases.

## Configuration

You must have the `AWS_ACCESS_KEY_ID` and `AWS_SECREY_ACCESS_KEY` environment variables set before
starting the app, and the user they represent must have at least read-only access to all systems.

The ECS Task Definition specifications are deliberately incomplete. The missing values will be
populated from the `process.env` of the host machine. Refer to the `configs` to determine which
environment variables must be set to create new services.

## Build and Run

Cortex is designed to be built with Meteor and run as a Node.js app. To simplify this process, we
use Docker for both building and deploying the app using the `Dockerfile`.

Refer to [docker-meteor](https://github.com/DanielDent/docker-meteor) for more detailed
instructions, but in summary:

0. Install Docker, then `cd` to the Cortex repo root directory
1. Build the `urbanetic/cortex` Docker image with `# docker build -t urbanetic/cortex .`
2. Run a Cortex container with `# docker run --rm -p 3000:3000
   -e "MONGO_URL=mongodb://username:password@host/database" -e "ROOT_URL=http://localhost:3000"
   -e "AWS_ACCESS_KEY_ID=myaccesskey" -e "AWS_SECRET_ACCESS_KEY=mysecretkey" urbanetic/cortex`

If manually hosting an instance of MongoDB:

1. Run it in the background in a named Docker container like `# docker run --name mydb -d mongo`
2. Add `--link mydb:db` to the `docker run` command above
3. Also in the `run` command, replace the `MONGO_URL` variable above with `mongodb://db`

## Contact

Contact Oliver Lade ([oliver@urbanetic.net](mailto:oliver@urbanetic.net)) for more information.
