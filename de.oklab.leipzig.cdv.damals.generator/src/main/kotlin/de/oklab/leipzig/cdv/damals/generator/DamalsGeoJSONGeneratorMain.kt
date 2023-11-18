package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.ID_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.POINT_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.PROP_PROCESSORS_CSV
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.PROP_PROCESSORS_XLSX
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.imagesWithoutMetadata
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.metaDataWithoutImages
import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import de.oklab.leipzig.cdv.damals.generator.process.GeoJSONWriter.writeFile
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser
import java.time.ZoneId
import java.time.ZonedDateTime
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point
import java.io.FileWriter
import java.io.File
import de.oklab.leipzig.cdv.damals.generator.process.Processor
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.dateProc
import org.geojson.GeoJsonObject
import org.geojson.LngLatAlt
import java.util.*

object DamalsGeoJSONGeneratorMain {

	@JvmStatic
	fun main(args: Array<String>) {
		generate()
	}

	fun generate() {
		FeatureCollection().apply {
			//generateFromCSV()
			generateFromExcel()
			writeFile("src/main/resources/photos.geojson")
		}
	}

	private fun FeatureCollection.generateFromCSV() {
		val input = System.getProperty("user.dir") + "/src/main/resources/StadtAL_CodingDaVinci.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		fillFeatureCollection(this, keysAndValues, PROP_PROCESSORS_CSV)
	}

	private fun FeatureCollection.generateFromExcel() {
		//val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		//val keysAndValues = XLSXParser.getKeysAndValues(input)
		//writeCSV(keysAndValues, System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.csv")
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val filteredValues = keysAndValues.second.filter {
			!metaDataWithoutImages.contains(it[0].lowercase(Locale.getDefault()))
		}.toMutableList()
		filteredValues.addAll(imagesWithoutMetadata)
		val filteredKeysAndValues = Pair(keysAndValues.first, filteredValues)
		fillFeatureCollection(this, filteredKeysAndValues, PROP_PROCESSORS_XLSX)
	}

	private fun writeCSV(keysAndValues: Pair<List<String>, List<List<String>>>, fileName: String) {
		val header = keysAndValues.first
		val values = keysAndValues.second
		val sb = StringBuilder()
		sb.append(header.joinToString(";")).append("\n")
		values.forEach {
			value -> sb.append(
				value.map { it.replace("\"", "'") }
						.joinToString(";") {
							if (it.contains(";"))
								"\"$it\""
							else it
						}
			).append("\n") }
		FileWriter(File(fileName)).use {
			it.write(sb.toString())
		}
	}
		
	private fun fillFeatureCollection(
			newFeatureCollection: FeatureCollection,
			keysAndValues: Pair<List<String>, List<List<String>>>,
			processors: List<Processor>
	): FeatureCollection {
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		val dateProc = Processor("HERSTELLUNG_DATIERUNG_Datierung Anfang (autom.)")
		for (values in valuesList) {
			val newFeature = Feature().apply {
				id = ID_PROCESSOR.apply(values, keys).toString()
				processors.forEach { proc -> proc.apply(properties, values, keys) }
				geometry = (POINT_PROCESSOR.apply(values, keys) as LngLatAlt?)?.let { Point(it) }
				val datierungVon = dateProc.apply(values, keys)
				this.properties["coordTimes"] = listOf(toMilliseconds(datierungVon))
			}
			if(newFeature.geometry != null && (newFeature.geometry as Point).coordinates !== null
				&& newFeature.properties.containsKey("date")) {
				newFeatureCollection.add(newFeature)
			}
		}
		return newFeatureCollection
	}
	
	private fun toMilliseconds(datierungVon: Any?): Long {
		if(datierungVon === null) return 0
		return try {
			val year = Integer.valueOf(datierungVon.toString())
			ZonedDateTime.of(year, 1, 1, 0, 0, 0, 0,
					ZoneId.of("UTC")).toInstant().toEpochMilli()
		} catch(_: NumberFormatException) {
			0
		}
	}
}
