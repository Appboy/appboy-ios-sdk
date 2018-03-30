//# sourceURL=application.js

/*
 application.js
 tvOS_TVML_Stopwatch
 
 Copyright (c) 2018 Braze. All rights reserved.
*/

/*
 * This file provides an example skeletal stub for the server-side implementation 
 * of a TVML application.
 *
 * A javascript file such as this should be provided at the tvBootURL that is 
 * configured in the AppDelegate of the TVML application. Note that  the various 
 * javascript functions here are referenced by name in the AppDelegate. This skeletal 
 * implementation shows the basic entry points that you will want to handle 
 * application lifecycle events.
 */

/**
 * @description The onLaunch callback is invoked after the application JavaScript 
 * has been parsed into a JavaScript context. The handler is passed an object 
 * that contains options passed in for launch. These options are defined in the
 * swift or objective-c client code. Options can be used to communicate to
 * your JavaScript code that data and as well as state information, like if the 
 * the app is being launched in the background.
 *
 * The location attribute is automatically added to the object and represents 
 * the URL that was used to retrieve the application JavaScript.
 */
App.onLaunch = function(options) {
    var alert = createAlert("Hello Braze!", "Welcome to tvOS");
    alert.getElementById("changeUserButton").addEventListener("select", changeUser);
    alert.getElementById("logEventsAndPurchasesButton").addEventListener("select", logEventsAndPurchases);
    alert.getElementById("logAttributesButton").addEventListener("select", logAttributes);
    alert.getElementById("submitFeedbackButton").addEventListener("select", submitFeedback);
    navigationDocument.pushDocument(alert);
}

App.onWillResignActive = function() {

}

App.onDidEnterBackground = function() {

}

App.onWillEnterForeground = function() {
}

App.onDidBecomeActive = function() {
    
}

App.onWillTerminate = function() {
    
}

var changeUser = function() {
  AppboyBridge.changeUser("tvOSUser");
}
var logEventsAndPurchases = function() {
  AppboyBridge.logCustomEventsAndPurchases();
}
var logAttributes = function() {
  AppboyBridge.logAttributes();
}
var submitFeedback = function() {
  AppboyBridge.submitFeedback();
}

/**
 * This convenience funnction returns an alert template, which can be used to present errors to the user.
 */
var createAlert = function(title, description) {
    var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <alertTemplate>
            <title>${title}</title>
            <description>${description}</description>
              <button id="changeUserButton">
                <text>Change User</text>
              </button>
              <button id="logEventsAndPurchasesButton">
              <text>Log Custom Events And Purchases</text>
              </button>
              <button id="logAttributesButton">
                <text>Log Attributes</text>
              </button>
              <button id="submitFeedbackButton">
                <text>Submit Feedback</text>
              </button>
          </alertTemplate>
        </document>`

    var parser = new DOMParser();

    var alertDoc = parser.parseFromString(alertString, "application/xml");

    return alertDoc
}
