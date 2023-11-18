package de.oklab.leipzig.cdv.damals.generator.process

import java.util.*
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap
import org.apache.poi.xssf.usermodel.XSSFWorkbook

object XLSXParser {

	private const val DOWNLOAD_URL = "https://speicherwolke.uni-leipzig.de/index.php/s/Mun52I4EYKuVldn?path=%2Fimages_thumbnails#/images_thumbnails/"

	fun getKeysAndValues(inputFile: String): Pair<List<String>, List<List<String>>> {
		val keys = mutableListOf<String>()
		val values = mutableListOf<List<String>>()
		val intermediateValues = mutableListOf<ArrayListValuedHashMap<String, String>>()
		try {
			FileInputStream(File(inputFile)).use {
				excelFile ->
				XSSFWorkbook(excelFile).use {
					workbook ->
				val sheetIterator = workbook.sheetIterator()
				while (sheetIterator.hasNext()) {
					val datatypeSheet = sheetIterator.next()
					val iterator = datatypeSheet.iterator()
					val keySegments = mutableListOf<String>()
					val multiMap = ArrayListValuedHashMap<String, String>()
					while (iterator.hasNext()) {
						val currentRow = iterator.next()
						val cellIterator = currentRow.iterator()
						if (cellIterator.hasNext()) {
							val currentCell = cellIterator.next()
							val key = currentCell.stringCellValue
							if (key.startsWith("        ")) {
								if (keySegments.size == 3) {
									keySegments[2] = key
								} else {
									keySegments.add(key)
								}
							} else if (key.startsWith("      ")) {
								when (keySegments.size) {
									3 -> {
										keySegments.removeAt(2)
										keySegments[1] = key
									}
									2 -> {
										keySegments[1] = key
									}
									else -> {
										keySegments.add(key)
									}
								}
							} else if (key.startsWith("    ")) {
								if (keySegments.isNotEmpty()) {
									keySegments.clear()
								}
								keySegments.add(key)
							}
						}
						if (cellIterator.hasNext()) {
							val currentCell = cellIterator.next()
							val key = keySegments.joinToString("_") { it.trim() }
							if(currentCell.stringCellValue.trim().isNotEmpty()) {
								if(!keys.contains(key)) {
									keys.add(key)
								}
								multiMap.put(key, currentCell.stringCellValue.trim())
							}
						}
					}
					intermediateValues.add(multiMap)
				}
				}
			}
		} catch (e: FileNotFoundException) {
			e.printStackTrace()
		} catch (e: IOException) {
			e.printStackTrace()
		}
		for(intermediateValue in intermediateValues) {
			val internalList = mutableListOf<String>()
			for(key in keys) {
				internalList.add(toStringValue(intermediateValue.get(key)))
			}
			internalList.add(DOWNLOAD_URL + intermediateValue.get(toStringValue(keys[0]).toOptionalLowerCase()) + ".jpg")
			internalList.add(intermediateValue.get(toStringValue(keys[0])).toString())
			values.add(internalList)
		}
		keys.add("URL")
		keys.add("﻿Archivsignatur")
		return Pair(keys, values)
	}

	private fun String.toOptionalLowerCase() =
		if(!startsWith("S") && "BB045331" != this && "BB047226" != this) {
			lowercase(Locale.getDefault())
		} else {
			this
		}
	
	private fun toStringValue(value: Any) = value.toString()
	
	private fun toStringValue(value: List<String>) = value.joinToString(";")
}
