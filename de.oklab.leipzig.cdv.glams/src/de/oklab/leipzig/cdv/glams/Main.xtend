package de.oklab.leipzig.cdv.glams

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.core.JsonParseException
import com.fasterxml.jackson.databind.ObjectMapper
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.List
import java.util.Map
import java.util.Scanner
import java.util.stream.Collectors
import org.eclipse.xtend.lib.annotations.Accessors
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point

import static extension de.oklab.leipzig.cdv.glams.GeoJSONWriter.*
import static extension de.oklab.leipzig.cdv.glams.AdministrativeBoundaries.*

class Main {
	private static val MAPPER = new ObjectMapper
	
	def static void main(String[] args) {
		val osmExtract = getOsmExtract
		osmExtract.stats
		generateGeoJSON(osmExtract)
	}
	
	private def static void generateGeoJSON(OsmExtract osmExtract) {
		val coll = new FeatureCollection
		osmExtract.elements.stream.parallel().forEach[coll.createFeature(it)]
		coll.writeFile(System.getProperty("user.dir") + "/output/museums.geojson")
	}

	private def static FeatureCollection createFeature(FeatureCollection collection, OsmElement osmElement) {
		new Feature => [
			id = String.valueOf(osmElement.id)
			geometry = if(osmElement.lon !== null) {
				new Point(osmElement.lon, osmElement.lat)
			} else if ("way".equalsIgnoreCase(osmElement.type) && !osmElement.nodes.nullOrEmpty) {
				osmElement.nodes.parsePointsFromNodes.centerPoint
			} else if ("relation".equalsIgnoreCase(osmElement.type) && !osmElement.members.nullOrEmpty) {
				osmElement.members.parsePointsFromMembers.centerPoint
			}
			if(geometry !== null) {
				if(osmElement.tags !== null) properties.putAll(osmElement.tags)
				if(osmElement.tags?.get("name") !== null) {
					if(properties.get("addr:city") === null) {
						properties.put("addr:city", resolveAddress((geometry as Point).coordinates, 1))
					}
					collection.add(it)
				}
			}
		]
		collection
	}

	private def static List<Point> parsePointsFromNodes(List<Long> nodeIds) {
		nodeIds.stream.parallel().map[parsePoint(1)].filter[it !== null].collect(Collectors.toList)
	}

	private def static Iterable<Point> parsePointsFromMembers(List<OsmMember> members) {
		members.stream.parallel().map[ref.parseWays(1)].filter[it !== null].collect(Collectors.toList).flatten
	}
	
	private def static Point parsePoint(Long nodeId, int lastPortNo) {
		if(lastPortNo > 3) return null
		val url = getOverpassRequestURL('''node(«nodeId»)''', lastPortNo)
		val function = [OsmElement element | 
			if(element.lon !== null) return new Point(element.lon, element.lat)
		]
		val point = parse(url, function)
		return point ?: parsePoint(nodeId, lastPortNo + 1)
	}
	
	private def static URL getOverpassRequestURL(String query, int lastPortNo) {
		new URL('''http://localhost:8«lastPortNo»/api/interpreter?data=[out:json][timeout:25];(«query»);out;''')
	}
	
	private def static <T> T parse(URL url, (OsmElement) => T function) {
		val content = url.readResponse
		try {
			val osmExtract = MAPPER.readValue(content, OsmExtract)
			val elements = osmExtract?.elements
			if(!elements.nullOrEmpty) {
				val	element = elements.get(0)
				return function.apply(element)				
			}
		} catch(JsonParseException jpe) {
			// ignore
		}
		return null
	}	

	def static readResponse(URL url) {
		val connection =  url.openConnection as HttpURLConnection
		val in = new BufferedReader(new InputStreamReader(connection.inputStream))
		val sb = new StringBuilder
    	var String inputLine
    	while ((inputLine = in.readLine()) !== null) {
    		sb.append(inputLine).append("\n")
    	} 
    	in.close			
		sb.toString	
	}


	private def static List<Point> parseWays(Long wayId, int lastPortNo) {
		val url = getOverpassRequestURL('''way(«wayId»)''', lastPortNo)
		val function = [OsmElement element | 
			if(!element.nodes.nullOrEmpty) return element.nodes.parsePointsFromNodes
		]
		return parse(url, function)
	}
	
	private def static Point getCenterPoint(Iterable<Point> points) {
		if(!points.nullOrEmpty) {
			val lons = points.map[coordinates.longitude]
			val lats = points.map[coordinates.latitude]
			return new Point(lons.center, lats.center)
		}
		return null
	}
	
	private def static Double getCenter(Iterable<Double> values) {
		val min = values.min	
		min + ((values.max - min) / 2)
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
		MAPPER.readValue(content, OsmExtract)
	}

}

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
class OsmExtract {
	List<OsmElement> elements
}

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
class OsmMember {
	String type
    Long ref
    String role
}

@Accessors
@JsonIgnoreProperties(ignoreUnknown = true)
class OsmElement {
  Long id
  String type
  List<OsmMember> members
  List<Long> nodes
  Double lat
  Double lon
  Map<String, Object> tags	
}