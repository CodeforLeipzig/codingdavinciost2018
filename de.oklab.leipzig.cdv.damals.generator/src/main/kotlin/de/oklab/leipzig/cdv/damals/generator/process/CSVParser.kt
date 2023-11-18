package de.oklab.leipzig.cdv.damals.generator.process

import java.io.File
import kotlin.text.Charsets.UTF_8

object CSVParser {

	fun getKeysAndValues(inputFile: String): Pair<List<String>, List<List<String>>> {
		val lines = File(inputFile).readLines(UTF_8)
		val headline = if (lines.isNotEmpty()) lines[0] else ""
		val keys = headline.split(';').map { it.replace("\r", "") }
		val valuesList = lines.drop(1).map {
			val newLine = processSubColums(it)
			val valuesProcessed = newLine.split(";")
					.map { seg -> seg.replace("\"", "").replace("\r", "").trim() }
			valuesProcessed
		}
		return Pair(keys, valuesList)
	}
	
	private fun processSubColums(line: String): String {
		val startIndex = line.indexOf(";\"")
		val endIndex = line.indexOf("\";")
		return if(startIndex in 0 until endIndex) {
			line.substring(0, startIndex+1) + 
			line.substring(startIndex+2, endIndex).replace(";", "$$$") +
			processSubColums(line.substring(endIndex+1))
		} else {
			line
		}
	}	
}