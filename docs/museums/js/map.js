define(["jquery", "leaflet", "leaflet.ajax"], ($, leaflet, leafletAjax) => ({
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
  createMarker: (state) => (feature, latlng) => {
    const lastSelectedMuseum = state.getLastSelectedMuseum();
    const museum = feature.properties["name"];
    state.addMuseum(museum);
    var museumIcon = new L.Icon({
	    // icon source: https://de.wikipedia.org/wiki/Datei:Openstreetmap_Carto_Museum.svg
	    iconUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Openstreetmap_Carto_Museum.svg',
      iconSize: [14, 14],
      iconAnchor: [7, 7],
      popupAnchor: [7, 0],
	  });
    var options = { icon: museumIcon }
    const matchesMuseum = !lastSelectedMuseum || lastSelectedMuseum == 0 || state.getMuseums()[lastSelectedMuseum] == museum;
    if (matchesMuseum) {
      state.setMatchCount(state.getMatchCount() + 1);
      return L.marker(latlng, options);
    }
  }
}));