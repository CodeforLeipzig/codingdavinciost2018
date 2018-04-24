package de.oklab.leipzig.cdv.damals.generator.nominatim

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties(ignoreUnknown = true)
class Nominatims {
	@Accessors val List<Nominatim> nominatims = newArrayList
}