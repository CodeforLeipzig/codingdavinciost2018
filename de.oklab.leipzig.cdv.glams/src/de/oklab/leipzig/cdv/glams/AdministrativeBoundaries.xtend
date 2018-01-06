package de.oklab.leipzig.cdv.glams

import com.fasterxml.jackson.databind.ObjectMapper
import java.net.URL
import java.util.Map

import static extension de.oklab.leipzig.cdv.glams.GeoJSONWriter.*
import com.google.common.io.Files
import java.io.File
import java.nio.charset.Charset
import org.geojson.FeatureCollection
import com.google.common.collect.HashMultimap
import org.geojson.Point
import org.geojson.LngLatAlt
import org.eclipse.xtext.util.Triple
import org.eclipse.xtext.util.Tuples

class AdministrativeBoundaries {
	
	private static val MAPPER = new ObjectMapper
	// remote https://nominatim.openstreetmap.org
	private static val mainURLLocal = "http://localhost:808"
	
	def static void main(String[] args) {
		val museums = MAPPER.readValue(
			Files.readLines(
				new File('''«System.getProperty("user.dir")»/output/museums.geojson'''), 
				Charset.forName("UTF-8")
			).join("\n"), FeatureCollection)
			
		val sb = <String>newArrayList
		sb.add(#["name", "coords", "nextcity"].join(";"))
		
		val triple = findMissingCities(museums)
		val noCityNextCity = triple.first
		val idsToName = triple.second
		val idsNoCity = triple.third
		noCityNextCity.entrySet.forEach[sb.add(#[idsToName.get(key), idsNoCity.get(key).coordinates.toCoordStr, 
			value].join(";"))]
		writeFile(sb.join("\n"), '''«System.getProperty("user.dir")»/output/resolved_cities.csv''')
	}
	
	def static Triple<Map<String, String>, Map<String, String>, Map<String, Point>> findMissingCities(FeatureCollection museums) {	
		val cityToName = HashMultimap.create
		val ids = <String, Point>newHashMap	
		val idsNoCity = <String, Point>newHashMap	
		val idsToName = <String, String>newHashMap	
		val idsToCityName = <String, String>newHashMap	
		museums.features.forEach[
			idsToName.put(id, properties.get("name") as String)
			if(it.properties.get("addr:city") === null) {
				idsNoCity.put(it.id, it.geometry as Point)
			} else {
				ids.put(it.id, it.geometry as Point)
				cityToName.put(properties.get("addr:city"), properties.get("name"))
				idsToCityName.put(id, properties.get("addr:city") as String)
			}
		]		
		
		val noCityNextCity = <String, String>newHashMap	
		for(idNoCity : idsNoCity.entrySet) {
			val noCityPoint = idNoCity.value.coordinates
			noCityNextCity.put(idNoCity.key, resolveAddress(noCityPoint, 1))
		}
		Tuples.create(noCityNextCity, idsToName, idsNoCity)
	}
	
	private static def String toCoordStr(LngLatAlt it) '''«latitude»,«longitude»'''
	
	
	public static def String resolveAddress(LngLatAlt it, int lastPortNo) {
		if(lastPortNo > 3) return null
		val url = '''«mainURLLocal»«lastPortNo»/reverse.php?format=json&lat=«latitude»&lon=«longitude»&zoom=10'''
		println(url)
		val content = Main.readResponse(new URL(url))
		val result = MAPPER.readValue(content, Map)
		val address = result.get("address")
		val city = (address as Map<?,?>)?.get("city") as String
		return city ?: resolveAddress(lastPortNo+1)
	}
}