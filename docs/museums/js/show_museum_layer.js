define(["jquery", "leaflet", "leaflet.ajax", "leaflet.markercluster", "map", "progress"], ($, leaflet, leafletAjax, leafletMarkercluster, map, updateProgressBar) => {
  return (state, data) => {
    function style(feature) {
      return {
        fillColor: '#FFEDA0',
        weight: 2,
        opacity: 1,
        color: 'white',
        fillOpacity: 1
      };
    };
    var museumLayer = leaflet.geoJson(data, {style: style, pointToLayer: map.createCircleMarker(state) });
    //var markers = leaflet.markerClusterGroup({ chunkedLoading: true, chunkProgress: updateProgressBar,
    //  maxClusterRadius: function (zoom) { return 25; } });
    //markers.addLayer(museumLayer);
    state.getMuseumMap().addLayer(museumLayer);

    registerLayerMouseOver(map, leaflet, state, museumLayer);
    registerLayerMouseOut(state, museumLayer);
    museumLayer.on('click', registerLayerMouseClick(state));
    state.setLastMuseumLayer(museumLayer);
    state.getInfo().update(state);
  }
});

var registerLayerMouseOver = function(map, leaflet, state, museumLayer) {
  museumLayer.on('mouseover', function(e) {
    var coordinates = e.layer.feature.geometry.coordinates;
    var swapped_coordinates = [coordinates[1] + map.getOffset(state.getMuseumMap().getZoom()), coordinates[0]];
    var props = e.layer.feature.properties
    var layerPopup = leaflet.popup()
      .setLatLng(swapped_coordinates)
      .setContent(props.name)
      .openOn(state.getMuseumMap());
    state.setLayerPopup(layerPopup);
    state.getInfo().update(state);
  });
};

function registerLayerMouseOver(state, museumLayer) {
  museumLayer.on('mouseover', function (e) {
    state.getInfo().update(state);
  });
};

function registerLayerMouseOut(state, museumLayer) {
  museumLayer.on('mouseout', function (e) {
    if (state.getLayerPopup() && state.getMuseumMap()) {
      state.getMuseumMap().closePopup(state.getLayerPopup());
      state.setLayerPopup(null);
      state.getInfo().update(state);
    }
    state.getMuseumMap().closePopup(state.getInfo());
    state.getInfo().update(state);
  });
};

var registerLayerMouseOut = function(state, museumLayer) {
  museumLayer.on('mouseout', function (e) {
    if (state.getInfo() && state.getMuseumMap()) {
      state.getMuseumMap().closePopup(state.getInfo());
      state.getInfo().update(state);
    }
  });
};


function registerLayerMouseClick(state) {
  return (e) => {
    state.getInfo().update(state);
  }
}
