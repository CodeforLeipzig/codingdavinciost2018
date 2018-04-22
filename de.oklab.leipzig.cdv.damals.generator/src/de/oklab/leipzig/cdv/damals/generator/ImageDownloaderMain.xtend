package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.Processor
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import java.io.File
import java.net.URL
import org.apache.commons.io.FileUtils

import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser
import java.io.FileNotFoundException

class ImageDownloaderMain implements ProcessorDefinitions {

	def static void main(String[] args) {
		//downloadPhotosFromExcel
		downloadPhotosFromCSV
	}
	
	def static void downloadPhotosFromCSV() {
		val input = System.getProperty("user.dir") + "/res/StadtAL_CodingDaVinci.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val urlProcessor = new Processor("URL Datei")
		for (values : valuesList) {
			val url = new URL(urlProcessor.apply(values, keys) as String)
			val fileName = "res/csv-photos/" + (ID_PROCESSOR.apply(values, keys) as String) + ".jpeg"
			FileUtils.copyURLToFile(url, new File(fileName))
			println("Downloaded " + fileName)
		}
	}
	
	def static void downloadPhotosFromExcel() {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val keysAndValues = XLSXParser.getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val urlProcessor = new Processor("URL")
		for (values : valuesList) {
			val url = new URL(urlProcessor.apply(values, keys) as String)
			val fileName = "res/xlsx-photos/" + (ID_PROCESSOR.apply(values, keys) as String) + ".jpeg"
			try {
				FileUtils.copyURLToFile(url, new File(fileName))
				println("Downloaded " + fileName)
			} catch(FileNotFoundException fnfe) {
				println(url + " not available")
			}
		}
	}
}
