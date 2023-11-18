package de.oklab.leipzig.cdv.damals.generator.exif

import de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.getKeysAndValues
import kotlin.test.Test
import kotlin.test.assertEquals

class XLSXParserTest {
	
	@Test
	fun testGetKeysAndValues() {
		val values = getKeysAndValues(System.getProperty("user.dir") + "/src/main/resources/Metadaten_SGM.xlsx");
		assertEquals(44, values.first.size, "number of description keys")
		assertEquals(71, values.second.size, "number of photos")
		for(value in values.second) {
			assertEquals(44, value.size, "each row with same count as keys")
		}
	}
}