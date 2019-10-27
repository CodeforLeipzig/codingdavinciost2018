define(["leaflet", "jquery"], function(leaflet, $) {
	return function(markerGroup, mapPositionHandler, gameData) {
		return {
			handleClickOnMap: function(e) {
			  	if(gameData.isRoundInit()) return;
				var isClickOnPhoto = e.originalEvent && e.originalEvent.originalTarget 
				        && e.originalEvent.originalTarget.id == "photo";
				if(isClickOnPhoto) return;

				// disable setting marker on map when clicking on button 			  	
			  	var clickPos = e.containerPoint;
			  	var buttonPos = $("#checkLocationButton").offset();
			  	var buttonX2 = buttonPos.left + $("#checkLocationButton").width();
			  	var buttonY2 = buttonPos.top + $("#checkLocationButton").height();
			  	
			  	if (clickPos.x >= (buttonPos.left - 20) && clickPos.x <= (buttonX2 + 20) 
			  		&& clickPos.y >= (buttonPos.top - 20) && clickPos.y <= (buttonY2 + 20)) {
			  		return;
			  	}
			  	
			    var marker = leaflet.marker(e.latlng, { draggable: true } );
			    marker.on('dragend', function(e) {
			      setTimeout(function() {
			        mapPositionHandler.setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
			      }, 10);
			    });
			    marker.addTo(markerGroup);
			    mapPositionHandler.setMarkerPosition(e.target.latlng ? e.target.latlng : e.latlng);
			    gameData.setRoundInit(true);
				$("#checkLocationButton").removeAttr('disabled');
			}
		};
	}
});
