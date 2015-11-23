# Create the AWS collections using the `userId` property to store the owner.
Meteor.startup -> AWSCollectionsConfig.configure({userId: 'userId'})
