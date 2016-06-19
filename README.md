# SmokeLess for iOS

Project is part of [smokeless project] (https://github.com/igorrendulic/smokeless) but it can be used for any Web App. 

## Project Goal

Currently [Google's Firebase analytics](https://firebase.google.com) support only iOS and Android. This is example how to track WKWebView embedded mobile web app with Firebase Analytics. 

### Main method

The main method is in ViewController.m which receives events from web app through userContentController. WebApp simply uses 
```html
window.webkit.messageHandlers.youeventhandlername.postMessage(event)
```
