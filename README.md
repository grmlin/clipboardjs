clipboardjs
===========

A collaborative clipboard using meteor

A *work in progress* version can be seen here: [clipboardjs.meteor.com](http://clipboardjs.meteor.com)


## local installation

### Activate websockets (optional)

open `.meteor/local/build/static/packages/stream` and add websockets to the connection
    
    self.socket = new SockJS(self.url, undefined, {
          debug: false, protocols_whitelist: [
            // only allow polling protocols. no websockets or streaming.
            // streaming makes safari spin, and websockets hurt chrome.
            'websocket', 'xdr-polling', 'xhr-polling', 'iframe-xhr-polling', 'jsonp-polling'
          ]});
          
### Install higlight.js

    > cd .meteor/local/build/server           
    > npm install highlight.js