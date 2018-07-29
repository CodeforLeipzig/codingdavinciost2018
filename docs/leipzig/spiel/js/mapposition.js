define([], function () {
	return function() {
		var realMarkerPosition = undefined;
		var markerPosition = undefined;
		
		return {
			setMarkerPosition: function (mp) {
				markerPosition = mp;
			},
			getMarkerPosition: function () {
				return markerPosition;
			},
			setRealMarkerPosition: function (mp) {
				realMarkerPosition = mp;
			},
			getRealMarkerPosition: function () {
				return realMarkerPosition;
			}		
		};	
	};
});