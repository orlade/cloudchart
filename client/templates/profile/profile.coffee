Template.profile.helpers
  name: -> Meteor.user().profile?.name ? "User"
  email: -> Meteor.user().emails?[0]?.address ? Meteor.user().services?.google?.email ? "None"
