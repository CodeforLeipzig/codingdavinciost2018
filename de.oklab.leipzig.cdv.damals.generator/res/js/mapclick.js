define(["leaflet"], function(leaflet) {
	return function(markerGroup, mapPositionHandler, gameData) {
		return {
			handleClickOnMap: function(e) {
			  	if(gameData.isRoundInit()) return;
			  	
			    var marker = leaflet.marker(e.latlng, { draggable: true } );
			    marker.on('dragend', function(e) {
			      setTimeout(function() {
			        mapPositionHandler.setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
			      }, 10);
			    });
			    marker.addTo(markerGroup);
			    mapPositionHandler.setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
			    gameData.setRoundInit(true);
			}
		};
	}
});