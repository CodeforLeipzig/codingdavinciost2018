package de.oklab.leipzig.cdv.damals.generator.exif

import org.geojson.LngLatAlt

data class ImageDescription(
		var coord: LngLatAlt? = null,
		var title: String? = null,
		var photographer: String? = null,
		var imageDescription: String? = null,
		var dateTime: String? = null,
		var tags: String? = null,
		var comment: String? = null,
		var license: String? = null,
)