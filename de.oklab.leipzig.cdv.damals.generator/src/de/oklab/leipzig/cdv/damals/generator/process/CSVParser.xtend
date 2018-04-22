package de.oklab.leipzig.cdv.damals.generator.process

import java.io.File
import java.util.List
import java.util.Scanner

class CSVParser {

	static def Pair<List<String>, List<List<String>>> getKeysAndValues(String inputFile) {
		val scanner = new Scanner(new File(inputFile), "UTF-8")
		scanner.useDelimiter("\n")
		val headline = if(scanner.hasNext) scanner.next else ""
		val keys = headline.split(';').map[replaceAll('\r', "")]
		val valuesList = newArrayList
		while (scanner.hasNext) {
			val newLine = processSubColums(scanner.next) 
			val valuesProcessed = newLine.split(";")
				.map[replace("\"", "").replaceAll('\r', "").trim]
			valuesList.add(valuesProcessed)
		}
		scanner.close
		Pair.of(keys, valuesList)
	}
	
	private static def String processSubColums(String line) {
		val startIndex = line.indexOf(";\"")
		val endIndex = line.indexOf("\";")
		if(startIndex >= 0 && endIndex > startIndex) {
			line.substring(0, startIndex+1) + 
			line.substring(startIndex+2, endIndex).replace(";", "$$$") +
			processSubColums(line.substring(endIndex+1))
		} else {
			line
		}
	}	
}