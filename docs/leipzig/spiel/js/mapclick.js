var init = false;

var handleClickOnMap = function(e) {
  	if(init) return;
  	
    var marker = L.marker(e.latlng, { draggable: true } );
    marker.on('dragend', function(e) {
      setTimeout(function() {
        setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
      }, 10);
    });
    marker.addTo(map);
    setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
    init = true;
}

var markerPosition = undefined;
var setMarkerPosition = function (mp) {
	markerPosition = mp;
}
var getMarkerPosition = function () {
	return markerPosition;
}
