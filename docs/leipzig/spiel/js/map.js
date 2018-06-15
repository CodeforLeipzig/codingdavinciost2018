var createMap = function() {
	var map = L.map('map').setView([51.3399028, 12.3742236], 14)
	L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
		attribution: 'Map data &#64; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors</a>'
	}).addTo(map);

	$.ajaxSetup({
	    scriptCharset: "utf-8",
	    contentType: "application/json; charset=utf-8"
	});
	var jsonMimeType = "application/json;charset=UTF-8";
	$.ajax({
	    type: "GET",
	    url: "http://damals.in/leipzig/damals.geojson",
	    beforeSend: function(x) {
	        if (x && x.overrideMimeType) {
	            x.overrideMimeType(jsonMimeType);
	        }
	    },
	    dataType: "json",
	    success: function(data) {
			map.on('click', handleClickOnMap);				    
	    }
	});
	return map;
};