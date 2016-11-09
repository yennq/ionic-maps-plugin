document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() {
	alert("Testing...");
	function initialize() {
        var myLatlng = new google.maps.LatLng(43.565529, -80.197645);
        var mapOptions = {
            zoom: 8,
            center: myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

         //=====Initialise Default Marker    
        var marker = new google.maps.Marker({
            position: myLatlng,
            map: map,
            title: 'marker'
         //=====You can even customize the icons here
        });

         //=====Initialise InfoWindow
        var infowindow = new google.maps.InfoWindow({
          content: "<B>Skyway Dr</B>"
        });

        //=====Eventlistener for InfoWindow
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map, marker);
        });
  	}

  	google.maps.event.addDomListener(window, 'load', initialize);
}