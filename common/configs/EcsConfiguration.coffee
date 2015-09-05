# Configuration of the ECS environment.
@EcsConfiguration = {}

# If called on the client, delegate to the server via a Meteor method.
if Meteor.isClient
  EcsConfiguration.install = -> Meteor.call 'ecs/config/install', (err, res) ->
    console[if err then 'error' else 'log'] "ECS config install: #{err ? res}"
  return
Meteor.methods
  'ecs/config/install': -> EcsConfiguration.install()

# The name of the S3 bucket that stores private Urbanetic configuration data.
EcsConfiguration.configBucket = process.env.URBANETIC_CONFIG_BUCKET ? 'urbanetic-config'

# The S3 key at which the ECS config file is stored.
EcsConfiguration.ecsConfigKey = "ecs/ecs.config"

# The Urbanetic authentication credentials for Docker Hub.
Object.defineProperty EcsConfiguration, 'authData', get: ->
  values = {}
  for name in ['USERNAME', 'PASSWORD', 'EMAIL']
    value = process.env["DOCKER_#{name}"]
    unless value? then throw new Error "DOCKER_#{name} not defined"
    values[name.toLowerCase()] = value

  return {"https://index.docker.io/v1/": values}

# This is the contents of a file that should be placed in a private S3 bucket and downloaded by new
# ECS container instances to configure their Docker daemons with the credentials to pull private
# Docker images.
Object.defineProperty EcsConfiguration, 'script', get: ->
  """ECS_ENGINE_AUTH_TYPE=docker
ECS_ENGINE_AUTH_DATA=\"#{JSON.stringify(EcsConfiguration.authData)}\""""

# This is an EC2 instance User Data script that is executed each time a new ECS container instance
# is created. It installs the AWS CLI tool and downloads the ECS configuration script, which in turn
# contains credentials for Docker Hub, allowing the container instance to pull private Docker
# images.
EcsConfiguration.userData = """#!/bin/bash
yum install -y aws-cli
aws s3 cp s3://#{EcsConfiguration.configBucket}/#{EcsConfiguration.ecsConfigKey} /etc/ecs/ecs.config"""

# Installs the ECS configuration script on S3. Server only, since client-side returns above.
EcsConfiguration.install = ->
  State.ecsConfigInstalling = true
  console.log "Installing ECS configuration script to #{EcsConfiguration.ecsConfigKey}..."
  try
    s3 = new AWS.S3()

    # If the S3 bucket doesn't exist, create it.
    try s3.headBucketSync Bucket: EcsConfiguration.configBucket
    catch e then s3.createBucketSync Bucket: EcsConfiguration.configBucket

    # Copy the configuration script to the private S3 bucket.
    s3.putObjectSync
      Bucket: EcsConfiguration.configBucket
      Key: EcsConfiguration.ecsConfigKey
      Body: EcsConfiguration.script
  finally State.ecsConfigInstalling = false
