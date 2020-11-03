define(["jquery", "leaflet", "leaflet.ajax", "show_museum_layer"], function ($, leaflet, leafletAjax, showMuseumLayers) {
  return {
    loadData: (state) => {
      $.getJSON(`geojsons/museums.geojson`, data => {
        showMuseumLayers(state, data);
      })
    }
  }
});