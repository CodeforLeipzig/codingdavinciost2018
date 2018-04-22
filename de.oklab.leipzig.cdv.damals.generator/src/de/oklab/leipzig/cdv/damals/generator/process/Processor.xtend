package de.oklab.leipzig.cdv.damals.generator.process

import java.util.List
import java.util.Map

class Processor {
	private String geoJsonPropName
	private String csvName
	private (String) => Object proc

	new(String csvName) {
		this(csvName, csvName, [String a | a])
	}

	new(String csvName, (String) => Object proc) {
		this(csvName, csvName, proc)
	}
	
	new(String geoJsonPropName, String csvName) {
		this(geoJsonPropName, csvName, [String a | a])
	}

	new(String geoJsonPropName, String csvName, (String) => Object proc) {
		this.geoJsonPropName = geoJsonPropName
		this.csvName = csvName
		this.proc = proc
	}
	
	def void apply(Map<String, Object> features, List<String> values, List<String> keys) {
		features.put(geoJsonPropName, values.apply(keys))		
	}

	def Object apply(List<String> values, List<String> keys) {
		proc.apply(values.getValueForKey(keys, csvName))		
	}
	
	private def static getValueForKey(List<String> values, List<String> keys, String key) {
		val index = keys.indexOf(key)
		if (index >= 0) {
			return values.get(index)?.trim
		} else {
			return "unknown"
		}
	}	
}