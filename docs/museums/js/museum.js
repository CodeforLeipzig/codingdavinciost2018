define(["jquery"], ($) => ({
  museumSelectionBox: (state) => {
    var htmlCode = '<select id="museumSelection">';
    for (var index in state.getMuseums()) {
      var museum = state.getMuseums()[index];
      if (museum) {
        htmlCode += '<option id="' + index + '">' + museum + '</option>';
      }
    }
    htmlCode += '</select>';
    return htmlCode;
  },

  selectedMuseum: () => {
    var selectionBox = document.getElementById("museumSelection");
    if (selectionBox && selectionBox.selectedIndex != -1) {
      var option = selectionBox.options[selectionBox.selectedIndex];
      if (option) {
        return option.attributes["id"].value;
      } else {
        ''
      }
    } else {
      ''
    }
  },
  setMuseumInSelectionBox: (state) => {
    var selectionBox = document.getElementById('museumSelection');
    if (selectionBox) {
      for (var option, index = 0; option = selectionBox.options[index]; index++) {
        if (option.attributes["id"].value == state.getLastSelectedMuseum()) {
          selectionBox.selectedIndex = index;
          break;
        }
      }
    }
  },
  handleMuseumChange: (document, data, state) => {
    var museumSelectionBox = document.getElementById("museumSelection");
    if (museumSelectionBox && museumSelectionBox.selectedIndex != -1) {
      var selectedMuseum = museumSelectionBox.options[museumSelectionBox.selectedIndex].attributes["id"].value;
      state.setLastSelectedMuseum(selectedMuseum);
      if (selectedMuseum != "") {
        state.setLastCoordinates(undefined);
        state.setSelectedMuseum(undefined);
        state.getMuseumMap().removeLayer(state.getLastMuseumLayer());
        data.loadData(state);
      }
    }
  }
}));