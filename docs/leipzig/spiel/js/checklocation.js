var scores = 0;

function checkLocation() {
    var realMarker = L.marker(realMarkerPosition, { draggable: false } );
    realMarker.setIcon(redIcon);
    realMarker.addTo(map);
    
    var distance = map.distance(markerPosition, realMarkerPosition)
    var thisRoundScore = 0;
    if(distance < 50) {
        thisRoundScore = 100;
    } else if(distance < 100) {
        thisRoundScore = 80;
    } else if(distance < 200) {
        thisRoundScore = 60;
    } else if(distance < 400) {
        thisRoundScore = 60;
    } else if(distance < 800) {
        thisRoundScore = 40;
    } else if(distance < 1500) {
        thisRoundScore = 20;
    }
    scores = scores + thisRoundScore;
    
    if(distance > 1000) {
        distanceStr = (distance / 1000).toPrecision(1) + " km"
    } else {
        distanceStr = distance.toFixed(0) + " m"				
    }
    
    alert("Ihr Marker ist " + distanceStr + " vom tatsächlichen Ort entfernt." +
     "\nSie bekommen " + thisRoundScore + " Punkte." + 
     "\nIhre Punkte nach dieser Runde: " + scores);
}