package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.GeoJSONWriter.writeFile
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.ID_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions.POINT_PROCESSOR
import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.getKeysAndValues
import org.geojson.Point

object PhotoLocationJSONGenerator {

	@JvmStatic
	fun main(args: Array<String>) {
		val input = System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.first
		val valuesList = keysAndValues.second
		val json = """
			{
				${valuesList.map { Pair(it, (POINT_PROCESSOR.apply(it, keys) as Point).coordinates) }.filter { it.second !== null }.joinToString(",") { values ->
					""""${ID_PROCESSOR.apply(values.first, keys)}": [${values.second.latitude},${values.second.longitude}]"""
				}
			}
		"""
		json.writeFile("src/main/resources/photolocations.json")
	}
}