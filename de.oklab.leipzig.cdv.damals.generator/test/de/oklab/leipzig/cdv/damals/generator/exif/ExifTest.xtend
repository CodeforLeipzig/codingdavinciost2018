package de.oklab.leipzig.cdv.damals.generator.exif

import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import java.io.File
import java.nio.file.Paths
import java.util.List
import org.geojson.LngLatAlt
import org.geojson.Point
import org.junit.Test

import static de.oklab.leipzig.cdv.damals.generator.exif.ExifDataHandler.*
import static de.oklab.leipzig.cdv.damals.generator.process.CVSParser.*
import static org.junit.Assert.assertEquals

class ExifTest implements ProcessorDefinitions {
	
	@Test
	def void testWhenExisting() {
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-015005.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/processed/_deleteme.jpeg")
		val imgDesc = (ImageDescription.builder => [
				coord = new LngLatAlt(51.0, 12.0)
				title = "Tütel"
				photographer = "Fotogräf"
				imageDescription = "Beßchreibung"
				dateTime = "2017:08:12 00:00:00"
				comment = "Testkömmentar"
				license = "Unlicence"
			]).build
		setExifData(inputPath, outputPath, imgDesc)	
	}

	@Test
	def void testWhenUsingCSV() {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val outputDir = Paths.get(System.getProperty("user.dir") + "/res/processed")
		outputDir.toFile.mkdirs
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-015005.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/processed/_deleteme.jpeg")

		val inputFileName = inputPath.name
		val values = valuesList.findFirst[v|inputFileName.equalsIgnoreCase(
			String.valueOf(ID_PROCESSOR.apply(v, keys)) + ".jpeg")]
		val coordinates = (POINT_PROCESSOR.apply(values, keys) as Point)?.coordinates
		val imgDesc = (ImageDescription.builder => [
			coord = coordinates
			title = String.valueOf(titelProc.apply(values, keys))
			photographer = (fotografProc.apply(values, keys) as List<String>).join(";")
			imageDescription = String.valueOf(beschreibungMotivProc.apply(values, keys))
			dateTime = String.valueOf(datierungKonkretProc.apply(values, keys))
			comment = String.valueOf(strassennameMotivProc.apply(values, keys))
			tags = (schlagwortProc.apply(values, keys) as List<String>).join(";")
			license = String.valueOf(lizenzProc.apply(values, keys))
		]).build
		setExifData(inputPath, outputPath, imgDesc)
	}

	@Test
	def void testLicense() {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-015005.jpeg")

		val inputFileName = inputPath.name
		val values = valuesList.findFirst[v|inputFileName.equalsIgnoreCase(
			String.valueOf(ID_PROCESSOR.apply(v, keys)) + ".jpeg")]
		val licenses = lizenzProc.apply(values, keys)
		assertEquals("https://creativecommons.org/licenses/by-sa/4.0/", licenses)	
	}
		
	@Test
	def void testWhenNotExisting() {
		val inputPath = new File(System.getProperty("user.dir") + "/res/photos/F-020001.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/processed/_deleteme.jpeg")
		val imgDesc = (ImageDescription.builder => [
				coord = new LngLatAlt(12.0, 51.0)
				title = "Tütel"
				photographer = "Fotogräf"
				imageDescription = "Beßchreibung"
				dateTime = "2017:08:12 05:00:00"
				comment = "Testkömmentar"
				tags = "MeinSchlagwort1;MeinSchlagwort2"
				license = "Unlicence"
			]).build
		setExifData(inputPath, outputPath, imgDesc)	
	}	
	
	@Test
	def void testWhenAlreadyProcessed() {
		val inputPath = new File(System.getProperty("user.dir") + "/res/processed/F-020001.jpeg")
		val outputPath = new File(System.getProperty("user.dir") + "/res/processed/_deleteme.jpeg")
		val imgDesc = (ImageDescription.builder => [
				coord = new LngLatAlt(12.0, 51.0)
				title = "Tütel"
				photographer = "Fotogräf"
				imageDescription = "Beßchreibung"
				dateTime = "2017:08:12 05:00:00"
				comment = "Testkömmentar"
				tags = "MeinSchlagwort1;MeinSchlagwort2"
				license = "Unlicence"
			]).build
		setExifData(inputPath, outputPath, imgDesc)	
	}	
}