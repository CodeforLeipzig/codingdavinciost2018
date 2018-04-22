package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.Processor
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import java.io.File
import java.net.URL
import org.apache.commons.io.FileUtils

import static de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.*

class ImageDownloaderMain implements ProcessorDefinitions {

	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val urlProcessor = new Processor("URL")
		for (values : valuesList) {
			val url = new URL(urlProcessor.apply(values, keys) as String)
			val fileName = "res/photos/" + (ID_PROCESSOR.apply(values, keys) as String) + ".jpeg"
			FileUtils.copyURLToFile(url, new File(fileName))
			println("Downloaded " + fileName)
		}
		
	}
}
