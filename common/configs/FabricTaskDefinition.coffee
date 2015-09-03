@FabricTaskDefinition = {
  "family": "fabric"
  "containerDefinitions": [
    {
      "name": "fabric"
      "image": "urbanetic/fabric"
      "cpu": 1024
      "memory": 400
      "portMappings": [
        {
          "containerPort": 8000
          "hostPort": 80
          "protocol": "http"
        }
      ]
      "essential": true
      # Items with undefined `value`s will be populated from `process.env`.
      "environment": [
        {
          "name": "S3_BUCKET_NAME"
          "value": "fabric-user-assets"
        }
        {
          "name": "S3_REGION"
          "value": "ap-southeast-2"
        }
        {
          "name": "METEOR_ADMIN_EMAIL"
          "value": "admin@urbanetic.net"
        }
        {
          "name": "METEOR_ADMIN_PASSWORD"
        }
        {
          "name": "MAILGUN_USERNAME"
          "value": "postmaster@mg.urbanetic.net"
        }
        {
          "name": "MAILGUN_PASSWORD"
        }
        {
          "name": "ROOT_URL"
          "value": "http://fabric.urbanetic.net"
        }
        {
          "name": "MONGO_URL"
        }
      ]
    }
  ]
}

# Populate the missing values from the current environment.
for container of FabricTaskDefinition.containerDefinitions
  for env of container.environment
    unless env.value? then env.value = process.env[env.name]
