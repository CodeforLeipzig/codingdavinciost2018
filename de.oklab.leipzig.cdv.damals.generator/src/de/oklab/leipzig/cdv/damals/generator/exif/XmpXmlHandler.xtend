package de.oklab.leipzig.cdv.damals.generator.exif

import org.xml.sax.helpers.DefaultHandler
import org.xml.sax.Attributes
import org.xml.sax.SAXException

class XmpXmlHandler extends DefaultHandler {
	private var String oldOriginal = null
	private var String oldCreate = null

	var boolean foundOriginal = false
	var boolean foundCreate = false

	override startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		if (qName.equalsIgnoreCase("exif:DateTimeOriginal")) {
			foundOriginal = true
		} else if (qName.equalsIgnoreCase("xap:CreateDate")) {
			foundCreate = true
		}
	}

	override characters(char [] ch, int start, int length) throws SAXException {
		if (foundOriginal) {
			oldOriginal = new String(ch, start, length)
			foundOriginal = false
		} else if (foundCreate) {
			oldCreate = new String(ch, start, length)
			foundCreate = false
		}
	}

	def getOldOriginal() {
		oldOriginal
	}
	
	def getOldCreate() {
		oldCreate
	}	
}
