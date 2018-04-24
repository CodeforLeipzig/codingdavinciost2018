package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import org.eclipse.xtend.lib.annotations.Accessors

@JsonIgnoreProperties(ignoreUnknown = true)
class Nominatims {
	@Accessors val Nominatim [] nominatims = newArrayList
}