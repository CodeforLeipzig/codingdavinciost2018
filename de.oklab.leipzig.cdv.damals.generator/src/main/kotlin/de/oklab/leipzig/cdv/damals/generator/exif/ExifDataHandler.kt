package de.oklab.leipzig.cdv.damals.generator.exif

import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.nio.file.Paths
import org.apache.commons.imaging.ImageReadException
import org.apache.commons.imaging.Imaging
import org.apache.commons.imaging.common.RationalNumber
import org.apache.commons.imaging.formats.jpeg.JpegImageMetadata
import org.apache.commons.imaging.formats.jpeg.exif.ExifRewriter
import org.apache.commons.imaging.formats.tiff.constants.ExifTagConstants.EXIF_TAG_DATE_TIME_ORIGINAL
import org.apache.commons.imaging.formats.tiff.constants.ExifTagConstants.EXIF_TAG_USER_COMMENT
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants.GPS_TAG_GPS_ALTITUDE
import org.apache.commons.imaging.formats.tiff.constants.GpsTagConstants.GPS_TAG_GPS_IMG_DIRECTION
import org.apache.commons.imaging.formats.tiff.constants.MicrosoftTagConstants.*
import org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants.TIFF_TAG_ARTIST
import org.apache.commons.imaging.formats.tiff.constants.TiffTagConstants.TIFF_TAG_COPYRIGHT
import org.apache.commons.imaging.formats.tiff.taginfos.TagInfo
import org.apache.commons.imaging.formats.tiff.write.TiffOutputField
import org.apache.commons.imaging.formats.tiff.write.TiffOutputSet
import java.io.FileInputStream

object ExifDataHandler {

    fun setExifData(jpegImageFile: File, dst: File, imgDesc: ImageDescription) {
        val tmp = Paths.get(dst.absolutePath).resolveSibling("_deleteme_tmp.jpeg").toFile()
        editExif(jpegImageFile, tmp) { outputSet ->
            if (imgDesc.coord?.latitude !== null && imgDesc.coord?.longitude !== null) {
                outputSet.setGPSInDegrees(imgDesc.coord!!.longitude, imgDesc.coord!!.latitude)
            }
            jpegImageFile.addField(imgDesc.title, outputSet, EXIF_TAG_XPTITLE)
            jpegImageFile.addField(imgDesc.photographer, outputSet, TIFF_TAG_ARTIST, EXIF_TAG_XPAUTHOR)
            jpegImageFile.addField(imgDesc.imageDescription, outputSet, EXIF_TAG_XPSUBJECT)
            jpegImageFile.addField(imgDesc.dateTime, outputSet, EXIF_TAG_DATE_TIME_ORIGINAL)
            jpegImageFile.addField(imgDesc.comment, outputSet, EXIF_TAG_XPCOMMENT, EXIF_TAG_USER_COMMENT)
            jpegImageFile.addField(imgDesc.tags, outputSet, EXIF_TAG_XPKEYWORDS)
            jpegImageFile.addField(imgDesc.license, outputSet, TIFF_TAG_COPYRIGHT)
        }
        XmpDataHandler.setXmpData(tmp, dst, imgDesc)
        tmp.delete()
    }

    private fun File.addField(content: String?, outputSet: TiffOutputSet, vararg tagInfos: TagInfo) {
        tagInfos.forEach { it.addField(this, content, outputSet) }
    }

    private fun TagInfo.addField(jpegImageFile: File, content: String?, outputSet: TiffOutputSet) {
        val existingField = outputSet.findField(this)
        if (existingField !== null) {
            println(this.name + " already exists for " + jpegImageFile.absolutePath +
                    ", removing it now.")
            outputSet.removeField(this)
        }
        if (content !== null) {
            val bytes = this.encodeValue(this.dataTypes[0], content, outputSet.byteOrder)
            val field = TiffOutputField(this, this.dataTypes[0], bytes.size, bytes)
            outputSet.getOrCreateRootDirectory().add(field)
        }
    }

    fun setExifGPSTag(jpegImageFile: File, dst: File, longitude: Double,
                      latitude: Double) {
        editExif(jpegImageFile, dst) { it.setGPSInDegrees(longitude, latitude) }
    }

    fun setExifAltitude(jpegImageFile: File, dst: File,
                        altitude: Double) {
        editExif(jpegImageFile, dst) {
            it.gpsDirectory.add(
                    GPS_TAG_GPS_ALTITUDE,
                    RationalNumber.valueOf(altitude)
            )
        }
    }

    // value range: 0.00 to 359.99.
    fun setExifImageDirection(jpegImageFile: File, dst: File,
                              imageDirection: Double) {
        editExif(jpegImageFile, dst) {
            it.gpsDirectory.add(
                    GPS_TAG_GPS_IMG_DIRECTION,
                    RationalNumber.valueOf(imageDirection)
            )
        }
    }

    private fun editExif(jpegImageFile: File, dst: File,
                         operation: (TiffOutputSet) -> Unit) {
        BufferedOutputStream(FileOutputStream(dst)).use { os ->
            val jpegMetadata = try {
                FileInputStream(jpegImageFile).use {
                    Imaging.getMetadata(it, jpegImageFile.name) as JpegImageMetadata
                }
            } catch (ire: ImageReadException) {
                System.err.println(ire.message + " for " + jpegImageFile.absolutePath)
                null
            } catch (ioe: IOException) {
                System.err.println(ioe.message + " for " + jpegImageFile.absolutePath)
                null
            }
            val outputSet = jpegMetadata?.exif?.outputSet ?: TiffOutputSet()
            try {
                operation.invoke(outputSet)
                ExifRewriter().updateExifMetadataLossless(jpegImageFile, os, outputSet)
                // org.apache.commons.imaging.formats.jpeg.iptc.JpegIptcRewriter
                // org.apache.commons.imaging.formats.jpeg.xmp.JpegXmpRewriter
            } catch (ioe: IOException) {
                if (ioe.message?.startsWith("Could not read block") == true) {
                    println(ioe.message + " for " + dst.absolutePath + ", trying to update lossy")
                    try {
                        ExifRewriter().updateExifMetadataLossy(jpegImageFile, os, outputSet)
                    } catch (ioe2: IOException) {
                        System.err.println(ioe.message + " for " + dst.absolutePath)
                        if (dst.exists()) {
                            dst.deleteOnExit()
                        }
                    }
                } else {
                    System.err.println(ioe.message + " for " + dst.absolutePath)
                }
            }
        }
    }
}