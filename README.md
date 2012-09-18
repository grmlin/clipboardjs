clipboardjs
===========

A collaborative clipboard using meteor

A *work in progress* version can be seen here: [clipboardjs.meteor.com](http://clipboardjs.meteor.com)


## local installation

### Activate websockets (optional)

**Websockets will not work on meteor.com!**

open `.meteor/local/build/static/packages/stream/client.js` and add websockets to the connection
    
    self.socket = new SockJS(self.url, undefined, {
          debug: false, protocols_whitelist: [
            // only allow polling protocols. no websockets or streaming.
            // streaming makes safari spin, and websockets hurt chrome.
            'websocket', 'xdr-polling', 'xhr-polling', 'iframe-xhr-polling', 'jsonp-polling'
          ]});
          
## TODO

### Messages
* message delete
* message editing (?)
* message count in list
* lazy loading of messages
* all messages views
* message privacy / password protection
* message annotation
* message embedding

### Message streams
* Streams of messages
* drag n drop messages into streams
* invite other users
* participating users list

### Friend-List
* have a list of friends

### MISC
* keep alive 