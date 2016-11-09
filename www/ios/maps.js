document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() {
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
    	size = 15;        
	    var img = new google.maps.MarkerImage('https://cdn4.iconfinder.com/data/icons/small-n-flat/24/map-marker-128.png',           
	      new google.maps.Size(size, size),
	      new google.maps.Point(0, 0),
	      new google.maps.Point(size / 2, size / 2)
	   	);

      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map,
        icon: img,
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