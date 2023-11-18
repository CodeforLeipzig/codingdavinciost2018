package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties(ignoreUnknown = true)
data class Nominatims(
	val  nominatims: Array<Nominatim> = arrayOf()
) {
	override fun equals(other: Any?): Boolean {
		if (this === other) return true
		if (javaClass != other?.javaClass) return false

		other as Nominatims

		return nominatims.contentEquals(other.nominatims)
	}

	override fun hashCode(): Int {
		return nominatims.contentHashCode()
	}
}