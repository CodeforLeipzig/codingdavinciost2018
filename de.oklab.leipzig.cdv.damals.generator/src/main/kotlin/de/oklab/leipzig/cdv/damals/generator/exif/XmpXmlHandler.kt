package de.oklab.leipzig.cdv.damals.generator.exif

import org.xml.sax.helpers.DefaultHandler
import org.xml.sax.Attributes
import org.xml.sax.SAXException

class XmpXmlHandler (
		var oldOriginal: String? = null,
		var oldCreate: String? = null,
		private var foundOriginal: Boolean = false,
		private var foundCreate: Boolean = false
) : DefaultHandler() {

	override fun startElement(uri: String?, localName: String?, qName: String?, attributes: Attributes?) {
		if (qName.contentEquals("exif:DateTimeOriginal", true)) {
			foundOriginal = true
		} else if (qName.contentEquals("xap:CreateDate", true)) {
			foundCreate = true
		}
	}

	override fun characters(ch: CharArray, start: Int, length: Int) {
		if (foundOriginal) {
			oldOriginal = String(ch, start, length)
			foundOriginal = false
		} else if (foundCreate) {
			oldCreate = String(ch, start, length)
			foundCreate = false
		}
	}
}
