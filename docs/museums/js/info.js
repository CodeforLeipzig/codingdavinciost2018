define(["jquery", "leaflet", "leaflet.ajax", "museum"], ($, leaflet, leafletAjax, museum) => {
  return {
    configureInfo: (state, data) => {
      // control that shows state info on hover
      var info = leaflet.control({
        position : 'topright'
      });
      info.onAdd = function (map) {
        this._div = leaflet.DomUtil.create('div', 'info');
        this.update(state);
        return this._div;
      };
      info.update = function (id, props) {
        var htmlInner = '<div style="width: 300px;">';
        htmlInner += "<b>Museum:</b> "
        htmlInner += museum.museumSelectionBox(state);
        htmlInner += '</div>';
        this._div.innerHTML = htmlInner;
        museum.setMuseumInSelectionBox(state);
        $("#museumSelection").off('change');
        $("#museumSelection").on('change', function(e) {
          museum.handleMuseumChange(document, data, state);
        });
      }
      state.setInfo(info);
      return info;
    },
  };
});