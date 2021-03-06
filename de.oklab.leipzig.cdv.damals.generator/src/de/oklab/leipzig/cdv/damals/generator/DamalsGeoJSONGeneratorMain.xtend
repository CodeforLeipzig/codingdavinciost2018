package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser
import java.time.ZoneId
import java.time.ZonedDateTime
import java.util.Arrays
import java.util.List
import org.geojson.Feature
import org.geojson.FeatureCollection
import org.geojson.Point

import static extension de.oklab.leipzig.cdv.damals.generator.process.GeoJSONWriter.*
import java.io.FileWriter
import java.io.File
import de.oklab.leipzig.cdv.damals.generator.process.Processor

class DamalsGeoJSONGeneratorMain implements ProcessorDefinitions {

	def static void main(String[] args) {
		generate
	}

	private def static void generate() {
		new FeatureCollection => [
			generateFromCSV
			generateFromExcel
			writeFile("res/photos.geojson")
		]
	}

	private def static void generateFromCSV(FeatureCollection featureCollection) {
		val input = System.getProperty("user.dir") + "/res/StadtAL_CodingDaVinci.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		featureCollection.fillFeatureCollection(keysAndValues, PROP_PROCESSORS_CSV)
	}

	private def static void generateFromExcel(FeatureCollection featureCollection) {
		//val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		//val keysAndValues = XLSXParser.getKeysAndValues(input)
		//writeCSV(keysAndValues, System.getProperty("user.dir") + "/res/Metadaten_SGM.csv")		
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val filteredValues = keysAndValues.value.filter[!metaDataWithoutImages.contains(it.get(0).toLowerCase)].toList
		filteredValues.addAll(imagesWithoutMetadata)
		val filteredKeysAndValues = Pair.of(keysAndValues.key, filteredValues)
		featureCollection.fillFeatureCollection(filteredKeysAndValues, PROP_PROCESSORS_XLSX)
	}
	
	private def static void writeCSV(Pair<List<String>, List<List<String>>> keysAndValues, String fileName) {
		val header = keysAndValues.key
		val values = keysAndValues.value
		val sb = new StringBuilder
		sb.append(header.join(";")).append("\n")
		values.forEach(value | sb.append(value.map[it.replace("\"", "'")].map[if(it.contains(";")) '''"«it»"''' else it].join(";")).append("\n"))
		val fileWriter = new FileWriter(new File(fileName))
		fileWriter.write(sb.toString)
		fileWriter.close
	}

	protected def static FeatureCollection fillFeatureCollection(Pair<List<String>, List<List<String>>> keysAndValues, 
		List<Processor> processors) {
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val newFeatureCollection = new FeatureCollection
		for (values : valuesList) {
			val newFeature = new Feature => [
				id = String.valueOf(ID_PROCESSOR.apply(values, keys))
				processors.forEach(proc|proc.apply(properties, values, keys))
				geometry = POINT_PROCESSOR.apply(values, keys) as Point
				val datierungVon = dateProc.apply(values, keys)
				it.properties.put("coordTimes", Arrays.asList(toMilliseconds(datierungVon)))
			]
			if((newFeature.geometry as Point).coordinates !== null && newFeature.properties.containsKey("date")) {
				newFeatureCollection.add(newFeature)
			}
		}
		newFeatureCollection
	}
		
	protected def static FeatureCollection fillFeatureCollection(FeatureCollection newFeatureCollection, 
		Pair<List<String>, List<List<String>>> keysAndValues, List<Processor> processors) {
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		for (values : valuesList) {
			val newFeature = new Feature => [
				id = String.valueOf(ID_PROCESSOR.apply(values, keys))
				processors.forEach(proc|proc.apply(properties, values, keys))
				geometry = POINT_PROCESSOR.apply(values, keys) as Point
				val datierungVon = dateProc.apply(values, keys)
				it.properties.put("coordTimes", Arrays.asList(toMilliseconds(datierungVon)))
			]
			if((newFeature.geometry as Point).coordinates !== null && newFeature.properties.containsKey("date")) {
				newFeatureCollection.add(newFeature)
			}
		}
	}
	
	protected def static long toMilliseconds(Object datierungVon) {
		if(datierungVon === null) return 0
		try {
			val year = Integer.valueOf(String.valueOf(datierungVon))
			ZonedDateTime.of(year, 1, 1, 0, 0, 0, 0, ZoneId.of("UTC")).toInstant.toEpochMilli
		} catch(NumberFormatException nfe) {
			0		
		}
	}
}
