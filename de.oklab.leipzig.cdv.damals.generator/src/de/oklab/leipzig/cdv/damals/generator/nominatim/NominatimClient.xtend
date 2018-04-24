package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.core.JsonParseException
import com.fasterxml.jackson.databind.ObjectMapper
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import static extension java.net.URLEncoder.encode
import static java.nio.charset.StandardCharsets.UTF_8

class NominatimClient {
	private static val MAPPER = new ObjectMapper
	
	def static void main(String[] args) {
		val query = "Kleine Fleischergasse".encode(UTF_8.toString)
		val url = new URL('''https://nominatim.leipzig.codefor.de/search?q=«query»&format=json''')
		val nominatim = url.parse([t|t])
		println(nominatim)
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
	
	private def static <T> T parse(URL url, (Nominatim) => T function) {
		val content = url.readResponse
		try {
			val Nominatim [] nominatims = MAPPER.readValue(content, NominatimHelper.nominatimArrayClass)
			if(!nominatims.nullOrEmpty) {
				val	element = nominatims.filter[!lat.nullOrEmpty && !lon.nullOrEmpty].head
				return function.apply(element)				
			}
		} catch(JsonParseException jpe) {
			// ignore
		}
		return null
	}		
}