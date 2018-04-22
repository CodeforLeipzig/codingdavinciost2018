package de.oklab.leipzig.cdv.damals.generator.process

import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.util.List
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.apache.poi.ss.usermodel.CellType
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap

class XLSXParser {
	private static val INDENT = "    "

	public static def Pair<List<String>, List<List<String>>> getKeysAndValues(String inputFile) {
		try {
			val excelFile = new FileInputStream(new File(inputFile))
			val workbook = new XSSFWorkbook(excelFile)
			val sheetIterator = workbook.sheetIterator
			while (sheetIterator.hasNext) {
				val datatypeSheet = sheetIterator.next
				val iterator = datatypeSheet.iterator
				val keySegments = newArrayList
				val keys = <String>newArrayList
				val values = <List<String>>newArrayList
				val multiMap = new ArrayListValuedHashMap<String, String>()
				while (iterator.hasNext) {
					val currentRow = iterator.next
					val cellIterator = currentRow.iterator
					if (cellIterator.hasNext) {
						val currentCell = cellIterator.next()
						if (currentCell.cellType == CellType.STRING) {
							val key = currentCell.stringCellValue
							if (key.startsWith(INDENT)) {
								if (!keySegments.empty) {
									keySegments.clear
								}
								keySegments.add(key)
							} else if (key.startsWith(INDENT + INDENT)) {
								if (keySegments.size == 2) {
									keySegments.set(1, key)
								} else {
									keySegments.add(key)
								}
							} else if (key.startsWith(INDENT + INDENT + INDENT)) {
								if (keySegments.size == 3) {
									keySegments.set(2, key)
								} else {
									keySegments.add(key)
								}
							}
							keys.add(keySegments.join("."))
						}
					}
					if (cellIterator.hasNext) {
						val currentCell = cellIterator.next()
						if (currentCell.cellType == CellType.STRING) {
							multiMap.put(keySegments.join("."), currentCell.stringCellValue)
						}
					}
				}
				values.add(multiMap.values.map[toStringValue].toList)
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			return null
		} catch (IOException e) {
			e.printStackTrace();
			return null
		}
	}
	
	private static dispatch def toStringValue(Object value) {
		value.toString
	}
	
	private static dispatch def toStringValue(List<String> value) {
		value.join(";")
	}	
}
