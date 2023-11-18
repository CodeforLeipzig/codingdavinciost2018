# Preparation of IDE
1. Download / Install [IntelliJ](https://www.jetbrains.com/idea/download) 
2. Import this project into workspace (as Gradle project)

# Features
## Image Download
Execute `de.oklab.leipzig.cdv.damals.generator.ImageDownloaderMain` to download all photos 
from [Fotothek Hermann Vogel-Sammlung ](https://www.stadtmuseum.leipzig.de) 
as listed as ids in tabs of `src/main/resources/Metadaten_SGM.xlsx` to local folder `src/main/resources/photos`.

## Exif meta data setter
Execute `de.oklab.leipzig.cdv.damals.generator.ExifDataSetterMain` to process all photos 
in local folder `src/main/resources/photos` to set meta data extracted from `src/main/resources/Metadaten_SGM.xlsx`
and store those photos to local folder `src/main/resources/processed`.

### Meta data
There are several standards around plus vendor extensions introducing additional tag fields, see also
 * [Exchangeable_Image_File_Format](https://de.wikipedia.org/wiki/Exchangeable_Image_File_Format)
   * [Wikimedia Commons Exif](https://commons.wikimedia.org/wiki/Commons:Exif)
   * [Standard Exif Tags reference](http://www.exiv2.org/tags.html)
 * [Extensible Metadata Platform](https://de.wikipedia.org/wiki/Extensible_Metadata_Platform)
 * [IPTC](https://de.wikipedia.org/wiki/IPTC-IIM-Standard)
 * [metadataworkinggroup.org](http://www.metadataworkinggroup.org/)

Viewers in operating systems and hand held devices allow displaying and editing of some of those tags
 * [ExifTool by Phil Harvey](https://sno.phy.queensu.ca/~phil/exiftool/)
 * [exifdata.com](http://www.exifdata.com/)
 * [ViewExif](https://itunes.apple.com/de/app/viewexif/id945320815?mt=8)
 * [View Photo EXIF Metadata on iPhone, Mac, and Windows](https://helpdeskgeek.com/how-to/view-photo-exif-metadata-on-iphone-mac-and-windows/)

Note, that editing one field in the viewer may set the value to multiple tag fields in the image and some tags have higher priority than others (and thus hide the values of the those with lower priority).

| name in XLSX | meta data standard | vendor | TIFF directory / namespace | tag name | comments |
| ------------- | ------------------ | ------ | -------------------------- | -------- | -------- |
|Laufende Nummer|EXIF|Microsoft|IFD0|XPTitle|caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|HERSTELLUNG.KÜNSTLER/HERSTELLER.Name|EXIF|Microsoft|IFD0|XPAuthor|multiple authors are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|HERSTELLUNG.KÜNSTLER/HERSTELLER.Name|EXIF|Adobe|IFD0|Artist|-|
|Beschreibung des Gegenstand|EXIF|Microsoft|IFD0|XPSubject|caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|HERSTELLUNG.DATIERUNG.Datierung Anfang (autom.)|EXIF|Adobe|Exif IFD|DateTimeOriginal|expected date format: yyyy:MM:dd|
|HERSTELLUNG.DATIERUNG.Datierung Anfang (autom.)|XMP|Adobe|http://ns.adobe.com/exif/1.0/|DateTimeOriginal|expected date format: yyyy-MM-dd'T'HH:mm:SSZ|
|HERSTELLUNG.DATIERUNG.Datierung Anfang (autom.)|XMP|Adobe|http://ns.adobe.com/xap/1.0/|CreateDate|expected date format: yyyy-MM-dd'T'HH:mm:SSZ|
|Abgebildete Institution + Abgebildeter Ort|EXIF|Microsoft|IFD0|XPComment|multiple comments are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|Abgebildete Institution + Abgebildeter Ort|EXIF|Adobe|Exif IFD|UserComment|multiple comments are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer|
|Schlagwort-Gruppe.Schlagwort|EXIF|Microsoft|IFD0|XPKeywords|multiple keywords are separated by semicolon; caller have to decoded it back to UTF-8; used in MS Windows Explorer (Markierung in German)|
|manually set resp. from Nominatim service|EXIF|Adobe|GPS IFD|GPSLongitude|split up in degrees, minutes, and seconds|
|manually set resp. from Nominatim service|EXIF|Adobe|GPS IFD|GPSLatitude|split up in degrees, minutes, and seconds|
|by default set to CC0|EXIF|Adobe|IFD0|Copyright|caller have to decoded it back to UTF-8; also shown in MS Windows Explorer|

## JSON generator
Execute `de.oklab.leipzig.cdv.damals.generator.PhotoLocationJSONGenerator` to process all entries from 
`src/main/resources/Metadaten_SGM.xlsx` to have the associations between Geo coordinates and image IDs 
stored as `src/main/resources/photolocations.json`. 

## GeoJSON generator
Run `de.oklab.leipzig.cdv.damals.generator.DamalsGeoJSONGeneratorMain` to generate `src/main/resources/leipzig_photos.geojson`
out of of `src/main/resources/Metadaten_SGM.xlsx`

