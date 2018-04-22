package de.oklab.leipzig.cdv.damals.generator.exif

import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.nio.file.Paths
import java.util.HashMap
import java.util.Map
import org.apache.commons.imaging.ImageReadException
import org.apache.commons.imaging.ImageWriteException
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.ImagingConstants
import org.apache.commons.imaging.common.RationalNumber
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfo
import org.apache.commons.imaging.formats.tiff.write.TiffOutputField
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet

import static de.oklab.leipzig.cdv.damals.generator.exif.XmpDataHandler.setXmpData
import static org.apache.commons.imaging.formats.tiff.constants.ExifTagConstants.*
import static org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants.*
import static org.apache.commons.imaging.formats.tiff.constants.MicrosoftTagConstants.*
import static org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants.*

class ExifDataHandler {

	static def void setExifData(File jpegImageFile, File dst,
		ImageDescription it) throws IOException, ImageReadException, ImageWriteException {
		val tmp = Paths.get(dst.absolutePath).resolveSibling("_deleteme_tmp.jpeg").toFile
		editExif(jpegImageFile, tmp, [ outputSet |
			if (coord !== null) {
				outputSet.setGPSInDegrees(coord.longitude, coord.latitude)
			}
			jpegImageFile.addField(title, outputSet, EXIF_TAG_XPTITLE)
			jpegImageFile.addField(photographer, outputSet, TIFF_TAG_ARTIST, EXIF_TAG_XPAUTHOR)
			jpegImageFile.addField(imageDescription, outputSet, EXIF_TAG_XPSUBJECT)
			jpegImageFile.addField(dateTime, outputSet, EXIF_TAG_DATE_TIME_ORIGINAL)
			jpegImageFile.addField(comment, outputSet, EXIF_TAG_XPCOMMENT, EXIF_TAG_USER_COMMENT)
			jpegImageFile.addField(tags, outputSet, EXIF_TAG_XPKEYWORDS)
			jpegImageFile.addField(license, outputSet, TIFF_TAG_COPYRIGHT)
		])
		setXmpData(tmp, dst, it)
		tmp.delete
	}

	private def static void addField(File jpegImageFile, String content, TiffOutputSet outputSet, TagInfo... tagInfos) {
		tagInfos.forEach[it.addField(jpegImageFile, content, outputSet)]
	}

	private def static void addField(TagInfo tagInfo, File jpegImageFile, String content, TiffOutputSet outputSet) {
		val existingField = outputSet.findField(tagInfo)
		if (existingField !== null) {
			System.out.println(tagInfo.name + " already exists for " + jpegImageFile.absolutePath +
				", removing it now.")
			outputSet.removeField(tagInfo)
		}
		if (content !== null) {
			val bytes = tagInfo.encodeValue(tagInfo.dataTypes.get(0), content, outputSet.byteOrder);
			val field = new TiffOutputField(tagInfo, tagInfo.dataTypes.get(0), bytes.size, bytes);
			outputSet.getOrCreateRootDirectory().add(field)
		}
	}

	static def void setExifGPSTag(File jpegImageFile, File dst, double longitude,
		double latitude) throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [outputSet|outputSet.setGPSInDegrees(longitude, latitude)])
	}

	static def void setExifAltitude(File jpegImageFile, File dst,
		double altitude) throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [ outputSet |
			outputSet.GPSDirectory.add(
				GPS_TAG_GPS_ALTITUDE,
				RationalNumber.valueOf(altitude)
			)
		])
	}

	// value range: 0.00 to 359.99.
	static def void setExifImageDirection(File jpegImageFile, File dst,
		double imageDirection) throws IOException, ImageReadException, ImageWriteException {
		editExif(jpegImageFile, dst, [ outputSet |
			outputSet.GPSDirectory.add(
				GPS_TAG_GPS_IMG_DIRECTION,
				RationalNumber.valueOf(imageDirection)
			)
		])
	}

	private static def void editExif(File jpegImageFile, File dst,
		(TiffOutputSet)=>void operation) throws IOException, ImageReadException, ImageWriteException {
		val fos = new FileOutputStream(dst)
		val os = new BufferedOutputStream(fos)
		val jpegMetadata = try {
				val Map<String, Object> params = new HashMap
				params.put(ImagingConstants.PARAM_KEY_READ_THUMBNAILS, Boolean.FALSE)
				Imaging.getMetadata(jpegImageFile, params) as JpegImageMetadata
			} catch (ImageReadException ire) {
				System.err.println(ire.message + " for " + jpegImageFile.absolutePath)
				null
			} catch (IOException ioe) {
				System.err.println(ioe.message + " for " + jpegImageFile.absolutePath)
				null
			}
		val outputSet = {
			val set = jpegMetadata?.exif?.outputSet
			if(set !== null) set else new TiffOutputSet()
		}
		try {
			operation.apply(outputSet)
			new ExifRewriter().updateExifMetadataLossless(jpegImageFile, os, outputSet)
		// org.apache.commons.imaging.formats.jpeg.iptc.JpegIptcRewriter
		// org.apache.commons.imaging.formats.jpeg.xmp.JpegXmpRewriter
		} catch (IOException ioe) {
			if (ioe.message.startsWith("Could not read block")) {
				System.out.println(ioe.message + " for " + dst.absolutePath + ", trying to update lossy")
				try {
					new ExifRewriter().updateExifMetadataLossy(jpegImageFile, os, outputSet)
				} catch (IOException ioe2) {
					System.err.println(ioe.message + " for " + dst.absolutePath)
					if (dst.exists) {
						dst.deleteOnExit
					}
				}
			} else {
				System.err.println(ioe.message + " for " + dst.absolutePath)
			}
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
}
