package de.oklab.leipzig.cdv.damals.generator.process

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.io.OutputStreamWriter
import org.geojson.FeatureCollection

object GeoJSONWriter {

	fun FeatureCollection.writeFile(fileName: String) {
		val json = jacksonObjectMapper().writeValueAsString(this)
		json.writeFile(fileName)
	}	
	
	fun String.writeFile(fileName: String) {
		BufferedWriter(OutputStreamWriter(FileOutputStream(File(fileName)), "UTF-8")).use {
			it.write(this)
		}
	}	
}