## users
Accounts.config(sendVerificationEmail: false)
## Collections used by server and client
Messages = new Meteor.Collection 'messages'
MessageAnnotations = new Meteor.Collection 'messageAnnotations'
Invitations = new Meteor.Collection 'invitations'
#Users = new Meteor.Collection 'users'
Streams = new Meteor.Collection 'streams'