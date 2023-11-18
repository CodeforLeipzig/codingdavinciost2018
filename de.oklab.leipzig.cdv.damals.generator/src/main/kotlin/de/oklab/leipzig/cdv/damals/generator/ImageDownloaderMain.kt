package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.Processor
import java.io.File
import java.net.URL
import org.apache.commons.io.FileUtils

import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.ID_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.predefined
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser
import java.io.FileNotFoundException

object ImageDownloaderMain {

	@JvmStatic
	fun main(args: Array<String>) {
		//downloadPhotosFromExcel()
		//downloadPhotosFromCSV()
		downloadPredefined()
	}
	
	private fun downloadPhotosFromCSV() {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		val urlProcessor = Processor("URL")
		for (values in valuesList) {
			val url = URL(urlProcessor.apply(values, keys) as String)
			val fileName = "src/main/resources/csv-photos/" + (ID_PROCESSOR.apply(values, keys) as String) + ".jpeg"
			try {
				Thread.sleep(3000)
				FileUtils.copyURLToFile(url, File(fileName))
				println("Downloaded $fileName")
			} catch(fnfe: FileNotFoundException ) {
				println("$url not available")
			}
		}
	}
	
	private fun downloadPhotosFromExcel() {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		val keysAndValues = XLSXParser.getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		val urlProcessor = Processor("URL", "Bildnummer") {
			pictureNo -> "https://www.stadtmuseum.leipzig.de/media/wmZoom/${pictureNo.subSequence(0, 5)}/$pictureNo.jpg"
		}
		val idProcessor = Processor("Bildnummer")
		for (values in valuesList) {
			val url = URL(urlProcessor.apply(values, keys) as String)
			val fileName = "src/main/resources/xlsx-photos/" + (idProcessor.apply(values, keys) as String) + ".jpeg"
			try {
				FileUtils.copyURLToFile(url, File(fileName))
				println("Downloaded $fileName")
			} catch(fnfe: FileNotFoundException ) {
				println("$url not available")
			}
		}
	}

	private fun downloadPredefined() {
		for (atts in predefined) {
			val key = atts[0]
			val url = URL("https://www.stadtmuseum.leipzig.de/media/wmZoom/${key.subSequence(0, 5)}/$key.jpg")
			val fileName = "src/main/resources/predefined-photos/$key.jpeg"
			try {
				FileUtils.copyURLToFile(url, File(fileName))
				println("Downloaded $fileName")
			} catch(fnfe: FileNotFoundException ) {
				println("$url not available")
			}
		}
	}
}
