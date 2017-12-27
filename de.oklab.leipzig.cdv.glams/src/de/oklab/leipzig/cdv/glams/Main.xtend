package de.oklab.leipzig.cdv.glams

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.databind.ObjectMapper
import java.io.File
import java.util.List
import java.util.Map
import java.util.Scanner
import org.eclipse.xtend.lib.annotations.Accessors
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point

import static extension de.oklab.leipzig.cdv.glams.GeoJSONWriter.*

class Main {
	
	// http://wiki.openstreetmap.org/wiki/Java_Access_Example
	def static void main(String[] args) {
		val osmExtract = getOsmExtract
		//osmExtract.stats
		generateGeoJSON(osmExtract)
	}
	
	private def static void generateGeoJSON(OsmExtract osmExtract) {
		osmExtract.elements
			.fold(new FeatureCollection, [coll, elem | coll.createFeature(elem)])
			.writeFile("museums.geojson")
	}

	private def static FeatureCollection createFeature(FeatureCollection collection, OsmElement osmElement) {
		new Feature => [
			id = String.valueOf(osmElement.id)
			if(osmElement.lon !== null) {
				geometry = new Point(osmElement.lon, osmElement.lat)
				if(osmElement.tags !== null) properties.putAll(osmElement.tags)
				if(osmElement.tags?.get("name") !== null) {
					collection.add(it)
				}
			}
		]
		collection
	}
	
	private def static void stats(OsmExtract osmExtract) {
		println(osmExtract.elements.size)
		println(osmExtract.elements.filter[lon !== null].size)
		val names = osmExtract.elements.map[tags?.get("name")?.toString].filterNull.sort
		println(names.size)
		names.forEach[println(it)]
	}
	
	private def static OsmExtract getOsmExtract() {
		val extracts = #["saxony", "thuringia", "saxony-anhalt"].map[internalGetOsmExtract]
		new OsmExtract => [
			elements = extracts.fold(newArrayList, [list, elem | list.addAll(elem.elements); list])
		]		
	}

	private def static OsmExtract internalGetOsmExtract(String state) {
		val file = new File('''«System.getProperty("user.dir")»/input/museum_«state».txt''')
		val scanner = new Scanner(file, "UTF-8").useDelimiter("\\Z")
		val content = scanner.next
		scanner.close
		val mapper = new ObjectMapper
		mapper.readValue(content, OsmExtract);
	}

}

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
class OsmExtract {
	
	List<OsmElement> elements
}

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
class OsmElement {
  Long id
  Double lat
  Double lon
  Map<String, Object> tags	
}