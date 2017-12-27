package de.oklab.leipzig.cdv.glams

import com.fasterxml.jackson.databind.ObjectMapper
import java.io.File
import com.google.common.io.Files
import java.nio.charset.Charset
import org.geojson.FeatureCollection

import static extension de.oklab.leipzig.cdv.glams.GeoJSONWriter.*

class MergeMain {
	private static val MAPPER = new ObjectMapper
	
	def static void main(String[] args) {
		val fileContents = #["sachsen-anhalt", "sachsen", "thueringen"]
			.map[Files.readLines(new File('''«System.getProperty("user.dir")»/output/museums_«it».geojson'''), 
				Charset.forName("UTF-8")).join("\n")]
			.map[MAPPER.readValue(it, FeatureCollection)]
		val newFeatureCollection = fileContents.fold(new FeatureCollection, [coll, elem | coll.addAll(elem.features); coll])		
		newFeatureCollection.writeFile(System.getProperty("user.dir") + "/output/museums.geojson")
	}
}