package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.exif.ExifDataHandler.setExifData
import java.nio.file.Files
import java.nio.file.Paths
import org.geojson.Point

import de.oklab.leipzig.cdv.damals.generator.exif.ImageDescription
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.ID_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.POINT_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.buildingsProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.dateProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.descriptionProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.licenseProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.photographerProc
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.streetsProc
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.getKeysAndValues

object ExifDataSetterMain {

	@JvmStatic
	fun main(args: Array<String>) {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		val outputDir = Paths.get(System.getProperty("user.dir") + "/src/main/resources/processed")
		outputDir.toFile().mkdirs()
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		val pathsIterator = Files.list(Paths.get(System.getProperty("user.dir") + "/src/main/resources/photos")).iterator()
		
		while (pathsIterator.hasNext()) {
			val inputPath = pathsIterator.next()
			val inputFileName = inputPath.toFile().name
			val values = valuesList.first { inputFileName.contentEquals(
				ID_PROCESSOR.apply(it, keys).toString() + ".jpeg", true) }
			val outputPath = Paths.get(outputDir.toString(), inputPath.fileName.toString())
			val coordinates = (POINT_PROCESSOR.apply(values, keys) as Point).coordinates
			val imgDesc = ImageDescription().apply {
				coord = coordinates
				title = (descriptionProc.apply(values, keys) as List<*>)[0].toString()
				photographer = photographerProc.apply(values, keys).toString()
				imageDescription = (descriptionProc.apply(values, keys) as List<*>).joinToString(";")
				dateTime = dateProc.apply(values, keys).toString()
				comment = (streetsProc.apply(values, keys) as List<*>).joinToString(";")
				tags = (buildingsProc.apply(values, keys) as List<*>).joinToString(";")
				license = licenseProc.apply(values, keys).toString()
			}
			setExifData(inputPath.toFile(), outputPath.toFile(), imgDesc)
		}
	}	
}