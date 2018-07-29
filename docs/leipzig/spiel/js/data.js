define({
	geojsonFile: "https://damals.in/leipzig/photos.geojson",
	mapConfig: {
		center: [51.3399028, 12.3742236],
		zoom: 14,
		attribution: 'Map data &#64; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors</a>'
	},
	gameData: function() {
		var index = 0;
		var roundInit = false;
		var alreadyPlayed = [];
		var data = undefined;
		var imageUrl = "https://opendata.leipzig.de/dataset/b6345cf9-f6d4-5d46-acb2-54b2fb5f44a8/resource/c56862da-d905-4413-bd84-8fa88300c6e8/download/tmparchivba198110690.jpg";
		var imageGeoPosition = [51.34112905, 12.3739930321092];
		
		return {
			setData: function(newData) {
				data = newData;
			},
			setRoundInit: function(init) {
				roundInit = init;
			},
			isRoundInit: function() {
				return roundInit;
			},
			nextPhoto: function() {
				if (alreadyPlayed.indexOf(index) != -1) {
					alreadyPlayed.push(index);
				}
				var newIndex = Math.floor(Math.random() * Math.floor(data.features.length))
				if (alreadyPlayed.indexOf(newIndex) == -1) {
					index = newIndex;
					return true;
				} else {
					return false;
				}
			},
			getImageUrl: function() {
				if (data) {
					return data.features[index].properties["urlImage"] || imageUrl;
				} else {
					return imageUrl;
				}
			},
			getImageGeoPosition: function() {
				if (data) {
					var coords = data.features[index].geometry.coordinates;
					return coords ? [coords[1], coords[0]] : imageGeoPosition;
				} else {
					return imageGeoPosition;
				}
			}
		}
	}
});
