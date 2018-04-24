package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.eclipse.xtend.lib.annotations.Data
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
class Nominatim {

    private String place_id = null
    private String[] boundingbox = newArrayList
    private String lat = null
    private String lon = null
    private String type = null
	private String licence = null
	private String osm_type = null
	private String osm_id = null
	private String display_name = null
	@JsonProperty("class")
	private String _class = null
	private Double importance = null

	new () {
		
	}
}