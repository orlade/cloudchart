# Create the AWS collections using the `userId` property to store the owner.
Meteor.startup ->	AWSCollections.configure({userId: 'userId'})
