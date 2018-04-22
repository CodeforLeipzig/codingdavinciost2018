package de.oklab.leipzig.cdv.damals.generator.exif

import de.oehme.xtend.contrib.Buildable
import org.eclipse.xtend.lib.annotations.Data
import org.geojson.LngLatAlt

@Data
@Buildable
class ImageDescription {
	private val LngLatAlt coord
	private val String title
	private val String photographer
	private val String imageDescription
	private val String dateTime
	private val String tags
	private val String comment
	private val String license
}