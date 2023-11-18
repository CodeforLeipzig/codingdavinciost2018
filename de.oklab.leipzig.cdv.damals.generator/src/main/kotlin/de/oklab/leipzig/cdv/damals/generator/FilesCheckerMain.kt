package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.CSVParser
import java.nio.file.Files
import java.nio.file.Paths
import java.util.*
import java.util.stream.Collectors

object FilesCheckerMain {

	@JvmStatic
	fun main(args: Array<String>) {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.csv"
		val keysAndValues = CSVParser.getKeysAndValues(input)
		val files = Files.list(Paths.get("C:\\Users\\Joerg\\Downloads\\images_thumbnails"))
		val fileNames = files.map { it.last() }.map { it.toFile().name.split("\\.")[0]
				.lowercase(Locale.getDefault()) }.collect(Collectors.toList())
		val numbersInCSV = keysAndValues.second.map { it[0].lowercase(Locale.getDefault()) }
		println("as file but not in CSV")
		fileNames.filter { !numbersInCSV.contains(it) }.sorted().forEach { println(it) }
		println()
		println("in CSV but not as file: ")
		numbersInCSV.filter {!fileNames.contains(it) }.sorted().forEach { println(it) }
	}
}