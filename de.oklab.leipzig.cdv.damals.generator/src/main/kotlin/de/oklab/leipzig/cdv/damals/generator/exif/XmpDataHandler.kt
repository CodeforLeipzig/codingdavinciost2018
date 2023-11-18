package de.oklab.leipzig.cdv.damals.generator.exif

import java.io.BufferedOutputStream
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date
import javax.xml.parsers.SAXParserFactory
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.formats.jpeg.xmp.JpegXmpRewriter
import java.io.FileInputStream

object XmpDataHandler {

	fun setXmpData(jpegImageFile: File, dst: File,
				   imgDesc: ImageDescription) {
		BufferedOutputStream(FileOutputStream(dst)).use { os ->
				val xmp = if (imgDesc.dateTime !== null) {
					val newDateStr = handleDateTimeStr(imgDesc.dateTime!!)
					val oldXmp = FileInputStream(jpegImageFile).use {
						Imaging.getXmpXml(it, null)
					}
					if(oldXmp !== null) {
						val factory = SAXParserFactory.newInstance()
						val saxParser = factory.newSAXParser()
						val handler = XmpXmlHandler()
						saxParser.parse(ByteArrayInputStream(oldXmp.toByteArray()), handler)
						val modifiedXmp = if(handler.oldOriginal === null) {
							if(oldXmp.contains("xmlns:exif=")) {
								oldXmp.
								replace("</exif:ExifVersion>",
										"</exif:ExifVersion><exif:DateTimeOriginal>${newDateStr}</exif:DateTimeOriginal>")
							} else {
								oldXmp.replace("</rdf:RDF>", "${exifSegment(newDateStr)}</rdf:RDF>")
							}
						} else {
							oldXmp.
							replace("<exif:DateTimeOriginal>${handler.oldOriginal}</exif:DateTimeOriginal>",
									"<exif:DateTimeOriginal>${newDateStr}</exif:DateTimeOriginal>")
						}
						if(handler.oldCreate === null) {
							if(modifiedXmp.contains("xmlns:xap=")) {
								modifiedXmp.
								replace("<xap:CreatorTool>",
										"<xap:CreateDate>${newDateStr}</xap:CreateDate><xap:CreatorTool>")
							} else {
								modifiedXmp.replace("</rdf:RDF>", "${xapSegment(newDateStr)}</rdf:RDF>")
							}
						} else {
							modifiedXmp.
							replace("<xap:CreateDate>${handler.oldCreate}</xap:CreateDate>",
									"<xap:CreateDate>${newDateStr}</xap:CreateDate>")
						}
					} else {
						defaultXmp(newDateStr)
					}
				} else {
					FileInputStream(jpegImageFile).use {
						Imaging.getXmpXml(it, null)
					}
				}
				JpegXmpRewriter().updateXmpXml(jpegImageFile, os, xmp)

		}
	}
	
	private const val DATE_STR = "yyyy:MM:dd"
	private const val MONTH_STR = "yyyy:MM"
	private const val YEAR_STR = "yyyy"
	private const val XMP_DATE_STR = "yyyy-MM-dd'T'00:00:00'+0000'"
	
	fun handleDateTimeStr(line: String): String? {
		val date = handleDateTimeStr(line, 0, DATE_STR, MONTH_STR, YEAR_STR)
		return if(date !== null) {
			SimpleDateFormat(XMP_DATE_STR).format(date)
		} else null
	}

	private fun handleDateTimeStr(line: String, index: Int, vararg formats: String): Date? {
		return try {
			SimpleDateFormat(formats[index]).parse(line)
		} catch(e: Exception) {
			if(index < formats.toList().size) {
				handleDateTimeStr(line, index+1, *formats)
			} else null
		}
	}	
	
	private fun defaultXmp(dateStr: String?) = """
		<?xpacket begin="?" id="W5M0MpCehiHzreSzNTczkc9d"?>
		<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="3.1.1-111">
		   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		   	  ${exifSegment(dateStr)}
		   	  ${xapSegment(dateStr)}
		      <rdf:Description rdf:about=""
		            xmlns:dc="http://purl.org/dc/elements/1.1/">
		         <dc:format>image/jpeg</dc:format>
		      </rdf:Description>
		   </rdf:RDF>
		</x:xmpmeta>"""

	private fun exifSegment(dateStr: String?) = """
		<rdf:Description rdf:about="" xmlns:exif="http://ns.adobe.com/exif/1.0/">
			<exif:ExifVersion>0220</exif:ExifVersion>
			<exif:DateTimeOriginal>${dateStr}</exif:DateTimeOriginal>
		</rdf:Description>
	"""
		
	private fun xapSegment(dateStr: String?) = """
		<rdf:Description rdf:about="" xmlns:xap="http://ns.adobe.com/xap/1.0/">
			<xap:CreateDate>${dateStr}</xap:CreateDate>
		    <xap:ModifyDate>2014-08-05T09:08:27+02:00</xap:ModifyDate>
		    <xap:MetadataDate>2014-08-05T09:08:27+02:00</xap:MetadataDate>
		    <xap:CreatorTool>Adobe Photoshop CS2 Windows</xap:CreatorTool>
		</rdf:Description>
	"""
}