define(["jquery", "leaflet", "leaflet.ajax", "leaflet.markercluster"], ($, leaflet, leafletAjax, leafletMarkerCluster) => ({
	create: (state) => {
    var museumMap = leaflet.map('map').setView([51.65, 12], 8);
    leaflet.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      {
        attribution: 'Map data &#64; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors</a>'
      }
    ).addTo(museumMap);
    state.setMuseumMap(museumMap);
    return museumMap;
  },
  getOffset: (zoomLevel) => {
    return 0.39 / Math.pow(2, zoomLevel - 6);
  },
  createCircleMarker: (state) => (feature, latlng) => {
    const selectedMuseum = state.getSelectedMuseum();
    const lastSelectedMuseum = state.getLastSelectedMuseum();
    const museum = feature.properties["name"];
    state.addMuseum(museum);
    var options = {
      radius: 8,
      fillColor: selectedMuseum && selectedMuseum === feature.properties["name"] ? "red" : "lightgreen",
      color: "black",
      weight: 1,
      opacity: 1,
      fillOpacity: 0.8
    }
    const matchesMuseum = !lastSelectedMuseum || lastSelectedMuseum == 0 || state.getMuseums()[lastSelectedMuseum] == museum;
    if (matchesMuseum) {
      state.setMatchCount(state.getMatchCount() + 1);
      return L.circleMarker(latlng, options);
    }
  }
}));