package de.oklab.leipzig.cdv.damals.generator.process

import org.geojson.LngLatAlt
import java.text.SimpleDateFormat
import java.util.Date
import kotlin.math.abs

object Functions {

	fun handleMultipleValues(line: String) =
			line.split("$$$").map { it.trim() }.filter { it.isNotEmpty() }.toList()
	
	private const val DATE_REVERSE_STR = "yyyy.MM.dd"
	private const val DATE_STR = "dd.MM.yyyy"
	private const val MONTH_STR = "yyyy.MM"
	private const val YEAR_STR = "yyyy"
	private const val EXIF_DATE_STR = "yyyy:MM:dd"
	
	fun handleDateTimeStr(line: String): String? {
		val dateStr = if(line.contains("-")) interpolateDate(line.split("-")) else line
		val date = handleDateTimeStr(dateStr, 0, DATE_REVERSE_STR, DATE_STR, MONTH_STR, YEAR_STR)
		return if(date !== null) {
			SimpleDateFormat(EXIF_DATE_STR).format(date)
		} else null
	}
	
	private fun interpolateDate(dates: List<String>): String {
		val start = Integer.valueOf(dates[0])
		val end = Integer.valueOf(dates[1])
		return Math.round(start.toDouble() + abs(end - start) / 2).toString()
	}

	private fun handleDateTimeStr(line: String, index: Int, vararg formats: String): Date? {
		return try {
			SimpleDateFormat(formats[index]).parse(line)
		} catch(e: Exception) {
			if(index < formats.toList().size) {
				handleDateTimeStr(line, index+1, *formats)
			} else null
		}
	}

	private const val COORD_STR_START = "POINT "

	fun toLngLatAlt(coord: String): LngLatAlt? {
		if (coord.startsWith(COORD_STR_START)) {
			val sub = coord.substring(COORD_STR_START.length)
			val sub2 = sub.substring(1, sub.length - 1)
			val coords = sub2.split(" ").map { it.toDouble() }
			return LngLatAlt(coords[1], coords[0])
		}
		return null
	}	
}