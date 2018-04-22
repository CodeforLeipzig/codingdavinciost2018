package de.oklab.leipzig.cdv.damals.generator

import de.oklab.leipzig.cdv.damals.generator.process.ProcessorDefinitions
import org.geojson.Point


import static extension de.oklab.leipzig.cdv.damals.generator.process.GeoJSONWriter.*
import static de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.*

class PhotoLocationJSONGenerator implements ProcessorDefinitions {

	def static void main(String[] args) {
		val input = System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx"
		val keysAndValues = getKeysAndValues(input)
		val keys = keysAndValues.key
		val valuesList = keysAndValues.value
		val json = '''
			{
				«FOR values : valuesList.map[Pair.of(it, (POINT_PROCESSOR.apply(it, keys) as Point).coordinates)].filter[it.value !== null] SEPARATOR ","»
					"«ID_PROCESSOR.apply(values.key, keys) as String»": [«values.value.latitude»,«values.value.longitude»]
				«ENDFOR»
			}
		'''
		json.toString.writeFile("res/photolocations.json")
	}
}