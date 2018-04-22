package de.oklab.leipzig.cdv.damals.generator.exif

import org.junit.Test

import static de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.*
import static org.junit.Assert.*

class XLSXParserTest {
	
	@Test
	def void testGetKeysAndValues() {
		val values = getKeysAndValues(System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx");
		assertEquals("number of description keys", 42, values.key.size)
		assertEquals("number of photos", 71, values.value.size)
		for(value : values.value) {
			assertEquals("each row with same count as keys", 42, value.size)
		}
	}
}