package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import java.nio.file.Files
import java.nio.file.Paths
import org.geojson.Point

import static de.oklab.leipzig.cdv.damals.generator.exif.ExifDataHandler.*
import de.oklab.leipzig.cdv.damals.generator.exif.ImageDescription
import java.util.List
import static de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.*

class ExifDataSetterMain implements ProcessorDefinitions {

	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val outputDir = Paths.get(System.getProperty("user.dir") + "/res/processed")
		outputDir.toFile.mkdirs
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val pathsIterator = Files.list(Paths.get(System.getProperty("user.dir") + "/res/photos")).iterator
		
		while (pathsIterator.hasNext) {
			val inputPath = pathsIterator.next
			val inputFileName = inputPath.toFile.name
			val values = valuesList.findFirst[v|inputFileName.equalsIgnoreCase(
				String.valueOf(ID_PROCESSOR.apply(v, keys)) + ".jpeg")]
			val outputPath = Paths.get(outputDir.toString, inputPath.fileName.toString)
			val coordinates = (POINT_PROCESSOR.apply(values, keys) as Point)?.coordinates
			val imgDesc = (ImageDescription.builder => [
				coord = coordinates
				title = String.valueOf((descriptionProc.apply(values, keys) as List<String>).get(0))
				photographer = String.valueOf(photographerProc.apply(values, keys))
				imageDescription = (descriptionProc.apply(values, keys) as List<String>).join(";")
				dateTime = String.valueOf(dateProc.apply(values, keys))
				comment = (streetsProc.apply(values, keys) as List<String>).join(";")
				tags = (buildingsProc.apply(values, keys) as List<String>).join(";")
				license = String.valueOf(licenseProc.apply(values, keys))
			]).build
			setExifData(inputPath.toFile, outputPath.toFile, imgDesc)
		}
	}	
}