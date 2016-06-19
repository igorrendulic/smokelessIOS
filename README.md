# SmokeLess for iOS

Project is part of [smokeless project] (https://github.com/igorrendulic/smokeless) but it can be used for any Web App. 

## Project Goal

Currently [Google's Firebase analytics](https://firebase.google.com) support only iOS and Android. This is example how to track WKWebView embedded mobile web app with Firebase Analytics. 

## Setup

You need to follow instructions [Firebase SDK Setup](https://firebase.google.com/docs/ios/setup#prerequisites) and include GoogleService-Info.plist file into the project. 

### Main method

The main method is in ViewController.m which receives events from web app through userContentController. 

On your WebApp javascript simply use: 
```html
window.webkit.messageHandlers.youeventhandlername.postMessage(event)
```
