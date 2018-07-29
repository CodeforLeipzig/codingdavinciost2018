define(["jquery", "icons", "fancybox", "leaflet"], function($, icons, fancybox, leaflet) {
	return function(map, markerGroup, mapPositionHandler, gameData) {
		var scores = 0;
		
		var getThisRoundScore = function(distance) {
			if(distance < 50) {
		        return 100;
		    } else if(distance < 100) {
		        return 80;
		    } else if(distance < 200) {
		        return 60;
		    } else if(distance < 400) {
		        return 60;
		    } else if(distance < 800) {
		        return 40;
		    } else if(distance < 1500) {
		        return 20;
		    }
		};
		
		var addInfobox = function(map) {
			this._div = leaflet.DomUtil.create('div', 'info');
			this.update();
			return this._div;
		};
		
		var checkLocation = function() {
		    var realMarker = leaflet.marker(mapPositionHandler.getRealMarkerPosition(), { draggable: false } );
		    realMarker.setIcon(icons.redIcon);
		    realMarker.addTo(markerGroup);
		    
		    var distance = map.distance(mapPositionHandler.getMarkerPosition(), mapPositionHandler.getRealMarkerPosition())
		    var thisRoundScore = getThisRoundScore(distance);
		    scores = scores + thisRoundScore;
		    
		    if(distance > 1000) {
		        distanceStr = (distance / 1000).toPrecision(1) + " km"
		    } else {
		        distanceStr = distance.toFixed(0) + " m"				
		    }
		    
		    alert("Ihr Marker ist " + distanceStr + " vom tatsächlichen Ort entfernt." +
		     "\nSie bekommen " + thisRoundScore + " Punkte." + 
		     "\nIhre Punkte nach dieser Runde: " + scores);
		     
		     
			$("#checkLocationButton").html('Nächste Runde');
			$("#checkLocationButton").unbind('click');
			$("#checkLocationButton").on('click', function(e) {
	    		nextLocation();
			});
		};		
		
		var nextLocation = function() {
		    while(!gameData.nextPhoto()) {
		    	// retrying
		    }
		    
		    mapPositionHandler.setRealMarkerPosition(gameData.getImageGeoPosition())
		    markerGroup.eachLayer(function (layer) {
   				map.removeLayer(layer);
			});
			$("#checkLocationButton").unbind('click');
			$("#checkLocationButton").html('Prüfe Position');
			$("#checkLocationButton").on('click', function(e) {
	    		checkLocation();
			});
			$("#photo_enlarged").prop('href', gameData.getImageUrl());
			$("#photo").prop('src', gameData.getImageUrl());

		    gameData.setRoundInit(false);
		}
	
		var	updateInfobox = function(id, props) {
			var htmlInner = '<div style="width: 300px;"><h4>Fotos</h4>';
			htmlInner += '<h4>Finde den Standort des angezeigten Fotos</h4>'
			htmlInner += '<button id="checkLocationButton">Prüfe Position</button>'
			var imageUrl = gameData.getImageUrl();
			var imageGeoPosition = gameData.getImageGeoPosition(); 
			htmlInner += '<br /><br /><div id="damalsPhotoContainer"><a id="photo_enlarged" href="' + imageUrl + '"><img id="photo" src="' + imageUrl + '" style="width:295px" /></a></div>'
			mapPositionHandler.setRealMarkerPosition(leaflet.latLng(imageGeoPosition[0], imageGeoPosition[1]))
			this._div.innerHTML = htmlInner;
		};

		var info = leaflet.control();

		info.update = updateInfobox;
		info.onAdd = addInfobox;

		info.addTo(map);
		
		$("#checkLocationButton").on('click', function(e) {
    		checkLocation();
		});
        $("a#photo_enlarged").fancybox();
	};
}); 