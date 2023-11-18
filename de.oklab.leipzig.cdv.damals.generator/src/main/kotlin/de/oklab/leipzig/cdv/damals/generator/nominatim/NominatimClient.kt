package de.oklab.leipzig.cdv.damals.generator.nominatim

import com.fasterxml.jackson.core.JsonParseException
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder
import kotlin.text.Charsets.UTF_8

object NominatimClient {
	private val MAPPER = jacksonObjectMapper()

	@JvmStatic
	fun main(args: Array<String>) {
		val query = URLEncoder.encode("Kleine Fleischergasse", UTF_8)
		val url = URL("https://nominatim.leipzig.codefor.de/search?q=${query}&format=json")
		val nominatim = url.parse { it }
		println(nominatim)
	}
	
	private fun URL.readResponse(): String {
		val connection =  this.openConnection() as HttpURLConnection
		return BufferedReader(InputStreamReader(connection.inputStream)).use {
			val sb = StringBuilder()
			var inputLine: String?
			while ((readlnOrNull().also { inputLine = it }) !== null) {
				sb.append(inputLine).append("\n")
			}
			sb.toString()
		}
	}
	
	private fun <T> URL.parse(function: (Nominatim) -> T): T? {
		val content = this.readResponse()
		try {
			val nominatims = MAPPER.readValue(content, NominatimHelper.getNominatimArrayClass())
			if(!nominatims.isNullOrEmpty()) {
				val	element = nominatims.first { !it.lat.isNullOrEmpty() && !it.lon.isNullOrEmpty() }
				return function.invoke(element)
			}
		} catch(jpe: JsonParseException) {
			// ignore
		}
		return null
	}		
}