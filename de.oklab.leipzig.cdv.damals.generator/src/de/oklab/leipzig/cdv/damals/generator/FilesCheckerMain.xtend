package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import java.nio.file.Files
import java.nio.file.Paths
import java.util.stream.Collectors

class FilesCheckerMain {
	
	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val files = Files.list(Paths.get("C:\\Users\\Joerg\\Downloads\\images_thumbnails"))
		val fileNames = files.map[last].map[fileName.toFile.name.split("\\.").get(0).toLowerCase].collect(Collectors.toList)
		val numbersInCSV = keysAndValues.value.map[(get(0) as String).toLowerCase]
		println("as file but not in CSV")
		fileNames.filter[!numbersInCSV.contains(it)].sort.forEach[println(it)]
		println
		println("in CSV but not as file: ")
		numbersInCSV.filter[!fileNames.contains(it)].sort.forEach[println(it)]
	}
}