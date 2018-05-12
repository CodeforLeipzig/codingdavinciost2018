package de.oklab.leipzig.cdv.damals.generator.process

import org.geojson.LngLatAlt
import java.text.SimpleDateFormat
import java.util.Date
import java.util.List

class Functions {

	def static handleMultipleValues(String line) {
		line.split("\\$\\$\\$").map[trim].filter[length>0].toList
	}
	
	private static String DATE_REVERSE_STR = "yyyy.MM.dd"
	private static String DATE_STR = "dd.MM.yyyy"
	private static String MONTH_STR = "yyyy.MM"
	private static String YEAR_STR = "yyyy"
	private static String EXIF_DATE_STR = "yyyy:MM:dd"
	
	def static String handleDateTimeStr(String line) {
		val dateStr = if(line.contains("-")) interpolateDate(line.split("-")) else line
		val date = handleDateTimeStr(dateStr, 0, #[DATE_REVERSE_STR, DATE_STR, MONTH_STR, YEAR_STR])
		if(date !== null) {
			new SimpleDateFormat(EXIF_DATE_STR).format(date)
		}
	}
	
	private def static interpolateDate(List<String> dates) {
		val start = Integer.valueOf(dates.get(0))
		val end = Integer.valueOf(dates.get(1))
		String.valueOf(Math.round(start + Math.abs(end - start) / 2))
	}

	private def static Date handleDateTimeStr(String line, int index, String... formats) {
		try {
			new SimpleDateFormat(formats.get(index)).parse(line)
		} catch(Exception e) {
			if(index < formats.length) {
				handleDateTimeStr(line, index+1, formats)
			}
		}
	}

	private static String COORD_STR_START = "POINT "

	static def toLngLatAlt(String coord) {
		if (coord.startsWith(COORD_STR_START)) {
			var changed = coord.substring(COORD_STR_START.length)
			changed = changed.substring(1, changed.length - 1)
			val coords = changed.split(" ").map[Double.valueOf(it)]
			return new LngLatAlt(coords.get(1), coords.get(0))
		}
		return null
	}	
}