package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.eclipse.xtend.lib.annotations.Data

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
class Nominatim {

    private String place_id = "";
    private String[] boundingbox = newArrayList;
    private String lat = "";
    private String lon = "";
    private String type = "";

	new () {
		
	}
}