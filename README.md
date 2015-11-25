# CloudChart

**CloudChart** is an application for monitoring and managing AWS infrastructure.

[**See the website for more details**][web].

CloudChart accompanies the WIP book on AWS configuration and deployment, [**Modern Deployment**][book].

> **NOTE**: Although available, CloudChart is still **pre-release** and should not even be expected to
> work just yet. A more stable version will be ready soon and hosted on AWS as per
> [**Modern Deployment**][book].


## Disclaimer

CloudChart is under development as a side project. It **should not** be considered safe for
production use. Providing full access your AWS account to any person or application, even if
read-only, is a risky proposition.

As per the MIT license, this software comes with absolutely no warranty, and the author will not be
held liable if you manage to stuff up any aspect of your AWS environment.

If you choose to run CloudChart at all, I would recommend a private instance with read-only access
and a very strong admin password.

## Configuration

Some of the `/common/configs` specifications are deliberately incomplete. The missing values will be
populated from the `process.env` of the host machine. Refer to the `/common/configs` to determine
which environment variables must be set to create new services.


## Build and Run

CloudChart is designed to be built with Meteor and run as a Node.js app. To simplify this process, we
use Docker for both building and deploying the app using the `Dockerfile`.

Refer to [docker-meteor](https://github.com/DanielDent/docker-meteor) for more detailed
instructions, but in summary:

1. Install Docker, then `cd` to the CloudChart repo root directory
1. Build the `orlade/cloudchart` Docker image with `# docker build -t orlade/cloudchart .`
1. Run a CloudChart container with `# docker run --rm -p 3000:3000
   -e "MONGO_URL=mongodb://username:password@host/database"
   -e "ROOT_URL=http://localhost:3000"
   -e orlade/cloudchart`

If manually hosting an instance of MongoDB:

1. Run it in the background in a named Docker container like `# docker run --name mydb -d mongo`
1. Add `--link mydb:db` to the `docker run` command above
1. Also in the `run` command, replace the `MONGO_URL` variable above with `mongodb://db`

## Screenshots

![CloudChart dashboard view](.docs/screenshots/ss-dashboard.png)

![CloudChart EC2 instances](.docs/screenshots/ss-ec2.png)

![CloudChart ECS clusters](.docs/screenshots/ss-ecs.png)

![CloudChart S3 buckets](.docs/screenshots/ss-s3.png)


[book]: https://orlade.gitbooks.io/aws/content/
[web]: http://www.cloudchart.io/
