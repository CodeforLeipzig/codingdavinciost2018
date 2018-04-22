package de.oklab.leipzig.cdv.damals.generator.exif

import org.junit.Test
import static de.oklab.leipzig.cdv.damals.generator.process.XLSXParser.*

class XLSXParserTest {
	
	@Test
	def test() {
		getKeysAndValues(System.getProperty("user.dir") + "/res/Metadaten_SGM.xlsx");
	}
}