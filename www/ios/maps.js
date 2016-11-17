// using exec and cordova library
var exec = require('cordova/exec'),
    cordova = require('cordova');

var marker = [];

var GoogleMarker = function() {};

GoogleMarker.getLocation = function() {
  firebase.auth().signInAnonymously().catch(function(error) {
    // Handle Errors here.
    var errorCode = error.code;
    var errorMessage = error.message;
  });

  var starCountRef = firebase.database().ref('googlemarker');
  starCountRef.on('value', function(snapshot) {
    marker = snapshot.val();
    var success = function(result) {
      // alert("result: " + result);
    }

    var error = function(msg) {
      alert("error: " + msg);
    }

    exec(success, error, "GoogleMarker", "getLocation", marker);
  });
};

GoogleMarker.addNewMarker = function(title, subtitle, latitude, longitude) {
  alert("Add new Marker success!\n" + "Title: " + title + "\n" + "Subtitle: " + subtitle + "\n" + "Latitude: " + latitude + "\n" + "Longtitude: " + longitude);
};

module.exports = GoogleMarker;