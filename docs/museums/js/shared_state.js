define({
  state: () => {
    var museumMap;
    var lastSelectedMuseum;
    var lastCoordinates;
    var lastMuseumLayer;
    var selectedMuseum;
    var museums = [ " " ];
    var lastHoveredCoords;
    var info;
    var layerPopup;
    var matchCount = 0;

    return {
      getMuseumMap: () => { return museumMap },
      getLastSelectedMuseum: () => { return lastSelectedMuseum },
      getLastCoordinates: () => { return lastCoordinates },
      getLastMuseumLayer: () => { return lastMuseumLayer },
      getSelectedMuseum: () => { return selectedMuseum },
      getLastHoveredCoords: () => { return lastHoveredCoords },
      getInfo: () => { return info },
      getMuseums: ()  => { return museums.sort() },
      getMatchCount: () => { return matchCount },
      getLayerPopup: () => { return layerPopup },

      setMuseumMap: (newMuseumMap) => { museumMap = newMuseumMap },
      setLastSelectedMuseum: (newLastSelectedMuseum) => { lastSelectedMuseum = newLastSelectedMuseum },
      setLastCoordinates: (newLastCoordinates) => { lastCoordinates = newLastCoordinates },
      setLastMuseumLayer: (newLastMuseumLayer) => { lastMuseumLayer = newLastMuseumLayer },
      setSelectedMuseum: (newSelectedMuseum) => { selectedMuseum = newSelectedMuseum },
      setLastHoveredCoords: (newLastHoveredCoords) => { lastHoveredCoords = newLastHoveredCoords },
      setInfo: (newInfo) => { info = newInfo },
      setLayerPopup: (newLayerPopup) => { layerPopup = newLayerPopup },
      addMuseum: (museum) => { if (museums.indexOf(museum) < 0) museums.push(museum) },
      resetMuseums: () => { museums = [ " " ] },
      setMatchCount: (newMatchCount) => { matchCount = newMatchCount},
    }
  }
});


