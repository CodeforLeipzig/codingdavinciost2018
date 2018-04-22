package de.oklab.leipzig.cdv.damals.generator.process

import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.util.List
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap
import org.apache.poi.xssf.usermodel.XSSFWorkbook

class XLSXParser {

	public static def Pair<List<String>, List<List<String>>> getKeysAndValues(String inputFile) {
		val keys = <String>newArrayList
		val values = <List<String>>newArrayList
		val intermediateValues = <ArrayListValuedHashMap<String, String>>newArrayList
		try {
			val excelFile = new FileInputStream(new File(inputFile))
			val workbook = new XSSFWorkbook(excelFile)
			val sheetIterator = workbook.sheetIterator
			while (sheetIterator.hasNext) {
				val datatypeSheet = sheetIterator.next
				val iterator = datatypeSheet.iterator
				val keySegments = newArrayList
				val multiMap = new ArrayListValuedHashMap<String, String>()
				while (iterator.hasNext) {
					val currentRow = iterator.next
					val cellIterator = currentRow.iterator
					if (cellIterator.hasNext) {
						val currentCell = cellIterator.next
						val key = currentCell.stringCellValue
						if (key.startsWith("        ")) {
							if (keySegments.size == 3) {
								keySegments.set(2, key)
							} else {
								keySegments.add(key)
							}
						} else if (key.startsWith("      ")) {
							if (keySegments.size == 3) {
								keySegments.remove(2)
								keySegments.set(1, key)
							} else if (keySegments.size == 2) {
								keySegments.set(1, key)
							} else {
								keySegments.add(key)
							}
						} else if (key.startsWith("    ")) {
							if (!keySegments.empty) {
								keySegments.clear
							}
							keySegments.add(key)
						}
					}
					if (cellIterator.hasNext) {
						val currentCell = cellIterator.next
						val key = keySegments.map[trim].join("_")
						if(!currentCell.stringCellValue.trim.nullOrEmpty) {
							if(!keys.contains(key)) {
								keys.add(key)
							}
							multiMap.put(key, currentCell.stringCellValue.trim)
						}
					}
				}
				intermediateValues.add(multiMap)
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace
		} catch (IOException e) {
			e.printStackTrace
		}
		for(intermediateValue : intermediateValues) {
			val internalList = <String>newArrayList
			for(key : keys) {
				internalList.add(intermediateValue.get(key).toStringValue)
			} 
			values.add(internalList)
		}
		return Pair.of(keys, values)
	}
	
	private static dispatch def toStringValue(Object value) {
		value.toString
	}
	
	private static dispatch def toStringValue(List<String> value) {
		value.join(";")
	}	
}
