var exec = require('cordova/exec');
var http = {
	downloadFile: function(text) {
		var win = function(result) {
	    alert(result + "-" + text);
	  };

	  var failure = function(mes) {
	  	alert(mes);
	  }

	  return exec(win, failure, "showAllMarker", "getLocation", []);
	}
};

module.exports = http;
window.cordovaHTTP = http;

document.addEventListener("deviceready", onDeviceReady, false);
function onDeviceReady() {
	cordovaHTTP.downloadFile();
	function initialize() {
    var locations = [
      ['Bondi Beach', -33.890542, 151.274856, 4],
      ['Coogee Beach', -33.923036, 151.259052, 5],
      ['Cronulla Beach', -34.028249, 151.157507, 3],
      ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
      ['Maroubra Beach', -33.950198, 151.259302, 1]
    ];

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 10,
      center: new google.maps.LatLng(-33.92, 151.25),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;

    for (i = 0; i < locations.length; i++) {
    	var size = 30;
    	var icon = {
		    url: "http://www.myiconfinder.com/uploads/iconsets/256-256-76f453c62108782f0cad9bfc2da1ae9d.png", // url
		    scaledSize: new google.maps.Size(size, size), // scaled size
		    origin: new google.maps.Point(0, 0), // origin
		    anchor: new google.maps.Point(size / 2, size / 2) // anchor
			};

      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map,
        icon: icon,
        title: locations[i][0]
      });

      google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(locations[i][0]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
	}

	google.maps.event.addDomListener(window, 'load', initialize);
}