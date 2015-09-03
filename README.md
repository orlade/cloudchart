# Cortex

**Cortex** is an application for monitoring and managing the Urbanetic infrastructure, including the
Fabric application and its associated services and databases.

## Configuration

You must have the `AWS_ACCESS_KEY_ID` and `AWS_SECREY_ACCESS_KEY` environment variables set before
starting the app, and the user they represent must have at least read-only access to all systems.

The ECS Task Definition specifications are deliberately incomplete. The missing values will be
populated from the `process.env` of the host machine. Refer to the `configs` to determine which
environment variables must be set to create new services.

## Contact

Contact Oliver Lade ([oliver@urbanetic.net](mailto:oliver@urbanetic.net)) for more information.
