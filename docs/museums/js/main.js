var siteUrl = window.location.protocol == "file" ? "file:///Users/joerg_p/Documents/GitHub/codingdavinciost2018/docs/museums/" : "https://codeforleipzig.github.io/codingdavinciost2018/museums/";
requirejs.config({
  baseUrl: siteUrl + "js/",
  paths: {
    "leaflet": "https://unpkg.com/leaflet@1.7.1/dist/leaflet",
    "leaflet.ajax": "https://cdnjs.cloudflare.com/ajax/libs/leaflet-ajax/2.1.0/leaflet.ajax.min",
		"leaflet.markercluster": "https://cdnjs.cloudflare.com/ajax/libs/leaflet.markercluster/1.4.1/leaflet.markercluster",
    "jquery": "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min",
  }
});
require(["jquery", "map", "data", "shared_state", "info"], function ($, map, data, state, info) {
  $.ajaxSetup({
    scriptCharset: "utf-8",
    contentType: "application/json; charset=utf-8"
  });

  const globalState = state.state();
  const museumMap = map.create(globalState);
  const infoBox = info.configureInfo(globalState, data);
  data.loadData(globalState);
  infoBox.addTo(museumMap);
});