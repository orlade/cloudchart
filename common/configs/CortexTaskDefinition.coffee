@CortexTaskDefinition = {
  "family": "cortex"
  "containerDefinitions": [
    {
      "name": "cortex"
      "image": "urbanetic/cortex"
      "memory": 50
      "cpu": 1024
      "essential": true
      "portMappings": [
        {
          "hostPort": 80
          "containerPort": 3000
          "protocol": "tcp"
        }
      ]
      "environment": [
        {
          "name": "MONGO_URL"
          "value": "mongodb://db"
        }
      ]
      "links": [
        "mongo:db"
      ]
    }
    {
      "name": "mongo"
      "image": "mongo"
      "memory": 100
      "cpu": 1024
      "essential": true
      "environment": []
      "mountPoints": [
        {
          "containerPath": "/data/db"
          "sourceVolume": "data"
          "readOnly": false
        }
      ]
    }
  ]
  "volumes": [
    {
      "host": {
        "sourcePath": "/data/db"
      }
      "name": "data"
    }
  ]
}
