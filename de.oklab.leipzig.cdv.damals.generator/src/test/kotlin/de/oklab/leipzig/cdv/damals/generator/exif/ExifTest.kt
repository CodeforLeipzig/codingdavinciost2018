package de.oklab.leipzig.cdv.damals.generator.exif

import de.oklab.leipzig.cdv.damals.generator.exif.ExifDataHandler.setExifData
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.ID_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.POINT_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.buildingsProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.dateProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.descriptionProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.licenseProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.photographerProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.streetsProc
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.getKeysAndValues
import java.io.File
import java.nio.file.Paths
import org.geojson.LngLatAlt
import org.geojson.Point
import kotlin.test.Test
import kotlin.test.assertEquals

class ExifTest {
	
	@Test
	fun testWhenExisting() {
		val inputPath = File(System.getProperty("user.dir") + "/src/main/resources/photos/F-015005.jpeg")
		val outputPath = File(System.getProperty("user.dir") + "/src/main/resources/processed/_deleteme.jpeg")
		val imgDesc = ImageDescription().apply {
			coord = LngLatAlt(51.0, 12.0)
			title = "Tütel"
			photographer = "Fotogräf"
			imageDescription = "Beßchreibung"
			dateTime = "2017:08:12 00:00:00"
			comment = "Testkömmentar"
			license = "Unlicence"
		}
		setExifData(inputPath, outputPath, imgDesc)	
	}

	@Test
	fun testWhenUsingCSV() {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		val outputDir = Paths.get(System.getProperty("user.dir") + "/src/main/resources/processed")
		outputDir.toFile().mkdirs()
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		
		val inputPath = File(System.getProperty("user.dir") + "/src/main/resources/photos/F-015005.jpeg")
		val outputPath = File(System.getProperty("user.dir") + "/src/main/resources/processed/_deleteme.jpeg")

		val inputFileName = inputPath.name
		val values = valuesList.first { inputFileName.contentEquals(
			ID_PROCESSOR.apply(it, keys).toString() + ".jpeg", true) }
		val coordinates = (POINT_PROCESSOR.apply(values, keys) as Point).coordinates
		val imgDesc = ImageDescription().apply {
			coord = coordinates
			title = descriptionProc.apply(values, keys).toString()
			photographer = (photographerProc.apply(values, keys) as List<*>).joinToString(";")
			imageDescription = descriptionProc.apply(values, keys).toString()
			dateTime = dateProc.apply(values, keys).toString()
			comment = streetsProc.apply(values, keys).toString()
			tags = (buildingsProc.apply(values, keys) as List<*>).joinToString(";")
			license = licenseProc.apply(values, keys).toString()
		}
		setExifData(inputPath, outputPath, imgDesc)
	}

	@Test
	fun testLicense() {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		
		val inputPath = File(System.getProperty("user.dir") + "/src/main/resources/photos/F-015005.jpeg")

		val inputFileName = inputPath.name
		val values = valuesList.first {inputFileName.contentEquals(
			ID_PROCESSOR.apply(it, keys).toString() + ".jpeg", true) }
		val licenses = licenseProc.apply(values, keys)
		assertEquals("https://creativecommons.org/licenses/by-sa/4.0/", licenses)	
	}
		
	@Test
	fun testWhenNotExisting() {
		val inputPath = File(System.getProperty("user.dir") + "/src/main/resources/photos/F-020001.jpeg")
		val outputPath = File(System.getProperty("user.dir") + "/src/main/resources/processed/_deleteme.jpeg")
		val imgDesc = ImageDescription().apply {
			coord = LngLatAlt (12.0, 51.0)
			title = "Tütel"
			photographer = "Fotogräf"
			imageDescription = "Beßchreibung"
			dateTime = "2017:08:12 05:00:00"
			comment = "Testkömmentar"
			tags = "MeinSchlagwort1;MeinSchlagwort2"
			license = "Unlicence"
		}
		setExifData(inputPath, outputPath, imgDesc)	
	}	
	
	@Test
	fun testWhenAlreadyProcessed() {
		val inputPath = File(System.getProperty("user.dir") + "/src/main/resources/processed/F-020001.jpeg")
		val outputPath = File(System.getProperty("user.dir") + "/src/main/resources/processed/_deleteme.jpeg")
		val imgDesc = ImageDescription().apply {
			coord = LngLatAlt (12.0, 51.0)
			title = "Tütel"
			photographer = "Fotogräf"
			imageDescription = "Beßchreibung"
			dateTime = "2017:08:12 05:00:00"
			comment = "Testkömmentar"
			tags = "MeinSchlagwort1;MeinSchlagwort2"
			license = "Unlicence"
		}
		setExifData(inputPath, outputPath, imgDesc)	
	}	
}