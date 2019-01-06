//var siteUrl = window.location.protocol + "//" + window.location.host + "/";
//var siteUrl = "https://damals.in/leipzig/spiel/";
var siteUrl = "file:///D:/git/maps/codingdavinciost2018/de.oklab.leipzig.cdv.damals.generator/res/";
requirejs.config({
    baseUrl: siteUrl + "js/",
    paths: {
		"leaflet": "https://unpkg.com/leaflet@1.0.3/dist/leaflet",
		"leaflet.ajax": "https://cdnjs.cloudflare.com/ajax/libs/leaflet-ajax/2.1.0/leaflet.ajax.min",
		"jquery": "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min",
		"fancybox": "https://cdn.jsdelivr.net/npm/fancybox@3.0.1/dist/js/jquery.fancybox.pack"
	},
    shim: {
        "fancybox": ["jquery"]
    }
});
require(["mapposition", "map", "game", "data", "leaflet"], function (mapposition, map, game, data, leaflet) {
	var mapPositionHandler = new mapposition();
	var gameData = data.gameData();
	var callback = function(geojsonData, theMap, markerGroup) {
		gameData.setData(geojsonData);	
		new game(theMap, markerGroup, mapPositionHandler, gameData);
	};
	var theMap = new map(mapPositionHandler, callback, gameData);
});