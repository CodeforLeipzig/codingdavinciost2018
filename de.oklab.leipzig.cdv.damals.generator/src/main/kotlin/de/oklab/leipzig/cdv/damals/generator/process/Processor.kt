package de.oklab.leipzig.cdv.damals.generator.process

data class Processor (
		val geoJsonPropName: String,
		val csvName: String = geoJsonPropName,
		val proc: (String) -> Any? = { input: String -> input }
) {
	
	fun apply(features: MutableMap<String, Any?>, values: List<String>, keys: List<String>) {
		features[geoJsonPropName] = apply(values, keys)
	}

	fun apply(values: List<String>, keys: List<String>): Any? {
		return proc.invoke(getValueForKey(values, keys, csvName))
	}

	companion object {
		private fun getValueForKey(values: List<String>, keys: List<String>, key: String): String {
			val index = keys.indexOf(key)
			return if (index >= 0) {
				values[index].trim()
			} else {
				"unknown"
			}
		}
	}
}