# Cortex

**Cortex** is an application for monitoring and managing AWS infrastructure.

Cortex accompanies the WIP book on AWS configuration and deployment, [**Modern Deployment**][book].

> **NOTE**: Although available, Cortex is still **pre-release** and should not even be expected to
> work just yet. A more stable version will be ready soon and hosted on AWS as per
> [**Modern Deployment**][book].

![Cortex dashboard view](.docs/screenshots/services.png)

![Cortex EC2 instances](.docs/screenshots/ec2.png)

![Cortex ECS clusters](.docs/screenshots/clusters.png)


## Disclaimer

Cortex is under development as a side project. It **should not** be considered safe for production
use. Providing full access your AWS account to any person or application, even if read-only, is a
risky proposition.

As per the MIT license, this software comes with absolutely no warranty, and the author will not be
held liable if you manage to stuff up any aspect of your AWS environment.

If you choose to run Cortex at all, I would recommend a private instance with read-only access and a
very strong admin password.


## Configuration

The following environment variables must be set on the Cortex server:

* AWS IAM credentials for a user with at least read-only access to EC2, ECS and S3:
  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECREY_ACCESS_KEY`
* Cortex admin user account details (for login):
  * `METEOR_ADMIN_USERNAME`
  * `METEOR_ADMIN_PASSWORD`

The upcoming multi-tenancy feature will allow Cortex users to register their AWS access credentials within the app, rather than having to set them on the server.

Some of the `/common/configs` specifications are deliberately incomplete. The missing values will be
populated from the `process.env` of the host machine. Refer to the `/common/configs` to determine
which environment variables must be set to create new services.


## Build and Run

Cortex is designed to be built with Meteor and run as a Node.js app. To simplify this process, we
use Docker for both building and deploying the app using the `Dockerfile`.

Refer to [docker-meteor](https://github.com/DanielDent/docker-meteor) for more detailed
instructions, but in summary:

1. Install Docker, then `cd` to the Cortex repo root directory
1. Build the `orlade/cortex` Docker image with `# docker build -t orlade/cortex .`
1. Run a Cortex container with `# docker run --rm -p 3000:3000
   -e "MONGO_URL=mongodb://username:password@host/database" -e "ROOT_URL=http://localhost:3000"
   -e "AWS_ACCESS_KEY_ID=myaccesskey" -e "AWS_SECRET_ACCESS_KEY=mysecretkey" orlade/cortex`

If manually hosting an instance of MongoDB:

1. Run it in the background in a named Docker container like `# docker run --name mydb -d mongo`
1. Add `--link mydb:db` to the `docker run` command above
1. Also in the `run` command, replace the `MONGO_URL` variable above with `mongodb://db`


[book]: https://orlade.gitbooks.io/aws/content/
