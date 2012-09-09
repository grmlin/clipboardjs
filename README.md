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

* message delete
* message editing (?)
* message count in list
* all messages views
* message search
* message privacy / password protection

