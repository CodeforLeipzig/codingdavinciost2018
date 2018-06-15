var createInfobox = function(map) {
	// control that shows state info on hover
	var info = L.control();

	info.update = updateInfobox;
	info.onAdd = addInfobox;

	info.addTo(map);
}

var addInfobox = function(map) {
    this._div = L.DomUtil.create('div', 'info');
    this.update();
    return this._div;
}

var realMarkerPosition = undefined;

var updateInfobox = function(id, props) {
    var htmlInner = '<div style="width: 300px;"><h4>Fotos</h4>';
    htmlInner += '<h4>Finde den Standort des angezeigten Fotos</h4>'
	htmlInner += '<button onclick="checkLocation()">Prüfe Position</button>'
    htmlInner += '<br /><br /><div id="damalsPhotoContainer"><img src="https://opendata.leipzig.de/dataset/b6345cf9-f6d4-5d46-acb2-54b2fb5f44a8/resource/c56862da-d905-4413-bd84-8fa88300c6e8/download/tmparchivba198110690.jpg" style="width:295px" /></div>'
	realMarkerPosition = L.latLng(51.34112905, 12.3739930321092)
	this._div.innerHTML = htmlInner;
}