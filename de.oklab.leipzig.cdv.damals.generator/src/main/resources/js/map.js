define(["jquery", "leaflet", "leaflet.ajax", "mapclick", "data"], function ($, leaflet, leafletAjax, mapclick, data) {
	return function (mapPositionHandler, callback, gameData) {
		var map = leaflet.map('map').setView(data.mapConfig.center, data.mapConfig.zoom)
		leaflet.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
			attribution: data.mapConfig.attribution
		}).addTo(map);
		var markerGroup = leaflet.layerGroup();
		markerGroup.addTo(map);		
		var clickHandler = new mapclick(markerGroup, mapPositionHandler, gameData);

		$.ajaxSetup({
			scriptCharset: "utf-8",
			contentType: "application/json; charset=utf-8"
		});
		var jsonMimeType = "application/json;charset=UTF-8";
		$.ajax({
			type: "GET",
			url: data.geojsonFile,
			beforeSend: function (x) {
				if (x && x.overrideMimeType) {
					x.overrideMimeType(jsonMimeType);
				}
			},
			dataType: "json",
			success: function (geojsonData) {
				callback(geojsonData, map, markerGroup)
				map.on('click', clickHandler.handleClickOnMap);
			}
		});
	};
});
