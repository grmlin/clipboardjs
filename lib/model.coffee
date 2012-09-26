##////////// Shared code (client and server) //////////

Messages = new Meteor.Collection 'messages'
StreamMessages = new Meteor.Collection 'streamMessages'
MessageAnnotations = new Meteor.Collection 'messageAnnotations'
Invitations = new Meteor.Collection 'invitations'
Users = new Meteor.Collection 'users'
Streams = new Meteor.Collection 'streams'