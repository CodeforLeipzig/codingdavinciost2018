package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
data class Nominatim(
		@JsonProperty("place_id")
	val placeId: String? = null,
		@JsonProperty("boundingbox")
		val boundingBox: Array<String> = arrayOf(),
		val lat: String? = null,
		val lon: String? = null,
		val type: String? = null,
		val licence: String? = null,
		@JsonProperty("osm_type")
	val osmType: String? = null,
		@JsonProperty("osm_id")
	val osmId: String? = null,
		@JsonProperty("display_name")
		val displayName: String? = null,
		@JsonProperty("class")
	val clazz: String? = null,
		val importance: Double? = null
) {
	override fun equals(other: Any?): Boolean {
		if (this === other) return true
		if (javaClass != other?.javaClass) return false

		other as Nominatim

		if (placeId != other.placeId) return false
		if (!boundingBox.contentEquals(other.boundingBox)) return false
		if (lat != other.lat) return false
		if (lon != other.lon) return false
		if (type != other.type) return false
		if (licence != other.licence) return false
		if (osmType != other.osmType) return false
		if (osmId != other.osmId) return false
		if (displayName != other.displayName) return false
		if (clazz != other.clazz) return false
		if (importance != other.importance) return false

		return true
	}

	override fun hashCode(): Int {
		var result = placeId?.hashCode() ?: 0
		result = 31 * result + boundingBox.contentHashCode()
		result = 31 * result + (lat?.hashCode() ?: 0)
		result = 31 * result + (lon?.hashCode() ?: 0)
		result = 31 * result + (type?.hashCode() ?: 0)
		result = 31 * result + (licence?.hashCode() ?: 0)
		result = 31 * result + (osmType?.hashCode() ?: 0)
		result = 31 * result + (osmId?.hashCode() ?: 0)
		result = 31 * result + (displayName?.hashCode() ?: 0)
		result = 31 * result + (clazz?.hashCode() ?: 0)
		result = 31 * result + (importance?.hashCode() ?: 0)
		return result
	}
}