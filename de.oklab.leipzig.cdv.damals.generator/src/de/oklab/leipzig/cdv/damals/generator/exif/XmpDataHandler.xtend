package de.oklab.leipzig.cdv.damals.generator.exif

import java.io.BufferedOutputStream
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Date
import javax.xml.parsers.SAXParserFactory
import org.apache.commons.imaging.ImageReadException
import org.apache.commons.imaging.ImageWriteException
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.formats.jpeg.xmp.JpegXmpRewriter

class XmpDataHandler {

	static def void setXmpData(File jpegImageFile, File dst,
		ImageDescription it) throws IOException, ImageReadException, ImageWriteException {
		val fos = new FileOutputStream(dst)
		val os = new BufferedOutputStream(fos)
		try {
			val xmp = if (it.dateTime !== null) {
					val newDateStr = handleDateTimeStr(it.dateTime)
					val oldXmp = Imaging.getXmpXml(jpegImageFile, null)
					if(oldXmp !== null) {
						val factory = SAXParserFactory.newInstance
						val saxParser = factory.newSAXParser()
						val handler = new XmpXmlHandler()
						saxParser.parse(new ByteArrayInputStream(oldXmp.bytes), handler);
						val modifiedXmp = if(handler.oldOriginal === null) {
							if(oldXmp.contains("xmlns:exif=")) {
								oldXmp.
									replace('''</exif:ExifVersion>''', 
										'''</exif:ExifVersion><exif:DateTimeOriginal>«newDateStr»</exif:DateTimeOriginal>''')
							} else {
								oldXmp.replace('''</rdf:RDF>''', '''«exifSegment(newDateStr)»</rdf:RDF>''')
							}
						} else {
							oldXmp.
								replace('''<exif:DateTimeOriginal>«handler.oldOriginal»</exif:DateTimeOriginal>''', 
									'''<exif:DateTimeOriginal>«newDateStr»</exif:DateTimeOriginal>''')
						}
						if(handler.oldCreate === null) {
							if(modifiedXmp.contains("xmlns:xap=")) {
								modifiedXmp.
									replace('''<xap:CreatorTool>''', 
										'''<xap:CreateDate>«newDateStr»</xap:CreateDate><xap:CreatorTool>''')
							} else {
								modifiedXmp.replace('''</rdf:RDF>''', '''«xapSegment(newDateStr)»</rdf:RDF>''')
							}
						} else {
							modifiedXmp.
								replace('''<xap:CreateDate>«handler.oldCreate»</xap:CreateDate>''', 
									'''<xap:CreateDate>«newDateStr»</xap:CreateDate>''')
						}						
					} else {
						defaultXmp(newDateStr)
					}
				} else {
					Imaging.getXmpXml(jpegImageFile, null)
				}
			new JpegXmpRewriter().updateXmpXml(jpegImageFile, os, xmp)
		} finally {
			if (fos !== null) {
				try {
					fos.close
				} catch (Exception e) {
				}
			}
			if (os !== null) {
				try {
					os.close
				} catch (Exception e) {
				}
			}
		}
	}	
	
	private static String DATE_STR = "yyyy:MM:dd"
	private static String MONTH_STR = "yyyy:MM"
	private static String YEAR_STR = "yyyy"
	private static String XMP_DATE_STR = "yyyy-MM-dd'T'00:00:00'+0000'"
	
	def static String handleDateTimeStr(String line) {
		val date = handleDateTimeStr(line, 0, #[DATE_STR, MONTH_STR, YEAR_STR])
		if(date !== null) {
			new SimpleDateFormat(XMP_DATE_STR).format(date)
		}
	}

	private def static Date handleDateTimeStr(String line, int index, String... formats) {
		try {
			new SimpleDateFormat(formats.get(index)).parse(line)
		} catch(Exception e) {
			if(index < formats.length) {
				handleDateTimeStr(line, index+1, formats)
			}
		}
	}	
	
	private static def String defaultXmp(String dateStr) '''
		<?xpacket begin="?" id="W5M0MpCehiHzreSzNTczkc9d"?>
		<x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="3.1.1-111">
		   <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
		   	  «exifSegment(dateStr)»
		   	  «xapSegment(dateStr)»
		      <rdf:Description rdf:about=""
		            xmlns:dc="http://purl.org/dc/elements/1.1/">
		         <dc:format>image/jpeg</dc:format>
		      </rdf:Description>
		   </rdf:RDF>
		</x:xmpmeta>'''

	private static def String exifSegment(String dateStr) '''
		<rdf:Description rdf:about="" xmlns:exif="http://ns.adobe.com/exif/1.0/">
			<exif:ExifVersion>0220</exif:ExifVersion>
			<exif:DateTimeOriginal>«dateStr»</exif:DateTimeOriginal>
		</rdf:Description>
	'''
		
	private static def String xapSegment(String dateStr) '''
		<rdf:Description rdf:about="" xmlns:xap="http://ns.adobe.com/xap/1.0/">
			<xap:CreateDate>«dateStr»</xap:CreateDate>
		    <xap:ModifyDate>2014-08-05T09:08:27+02:00</xap:ModifyDate>
		    <xap:MetadataDate>2014-08-05T09:08:27+02:00</xap:MetadataDate>
		    <xap:CreatorTool>Adobe Photoshop CS2 Windows</xap:CreatorTool>
		</rdf:Description>
	'''
}