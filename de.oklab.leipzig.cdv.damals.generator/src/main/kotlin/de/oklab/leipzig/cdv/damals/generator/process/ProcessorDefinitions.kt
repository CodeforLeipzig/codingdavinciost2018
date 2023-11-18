package de.oklab.leipzig.cdv.damals.generator.process

import de.oklab.leipzig.cdv.damals.generator.process.Functions.handleMultipleValues
import de.oklab.leipzig.cdv.damals.generator.process.Functions.handleDateTimeStr
import de.oklab.leipzig.cdv.damals.generator.process.Functions.toLngLatAlt

object ProcessorDefinitions {

	val handleMultipleValuesFun = { a: String -> handleMultipleValues(a) }
	val handleDateTimeStr = { a: String -> handleDateTimeStr(a) }
	
	val descriptionProc = Processor("description", "Bezeichnung", handleMultipleValuesFun)
	val buildingsProc = Processor("buildings", "Gebäude", handleMultipleValuesFun)
	val streetsProc = Processor("streets", "Straßen", handleMultipleValuesFun)
	val photographerProc = Processor("photographer", "Fotograf")
	val dateProc = Processor("date", "Datierung")
	val licenseProc = Processor("license", "Lizenz")
	
	val PROP_PROCESSORS_CSV = listOf(
		descriptionProc,
		Processor("location", "Ort"),
		buildingsProc,
		streetsProc,
		photographerProc,
		Processor("dateExtended", "ergänzende Datierung"),
		dateProc,
		Processor("copyright", "Copyright"),
		licenseProc,
		Processor("urlDataset", "URL Datensatz"),
		Processor("urlImage", "URL Datei")
	)

	val PROP_PROCESSORS_XLSX = listOf(
		Processor("description", "Beschreibung des Gegenstandes", handleMultipleValuesFun),
		Processor("location", "Abgebildeter Ort", handleMultipleValuesFun),
		Processor("buildings", "Abgebildete Institution", handleMultipleValuesFun),
		Processor("streets", "Schlagwort-Gruppe_Schlagwort", handleMultipleValuesFun),
		Processor("photographer", "HERSTELLUNG_KÜNSTLER/HERSTELLER_Name", handleMultipleValuesFun),
		Processor("dateExtended", "HERSTELLUNG_DATIERUNG_Datierung verbal"),
		Processor("date", "HERSTELLUNG_DATIERUNG_Datierung Midas (autom.)"),
		Processor("urlImage", "﻿Archivsignatur") {
			pictureNo -> "https://www.stadtmuseum.leipzig.de/media/wmZoom/${pictureNo.subSequence(0, 5)}/$pictureNo.jpg"
		}
	)
	
	val metaDataWithoutImages = listOf(
//		"bb045226", "bb045235", "bb045241", "bb045243", "bb045313",
//		"bb045322", "bb045333", "bb045336", "bb045623", "bb045625",
//		"bb045629", "bb045630", "bb045636", "bb045645", "bb045652",
//		"bb046291", "bb046377", "bb046407", "bb046475", "bb046512",
//		"bb046528", "bb046545", "bb046546", "bb046564", "bb046634",
//		"bb046640", "bb046649", "bb046679", "bb046683", "bb047228"
		"bb046545", "bb046554", "bb047228.jpg"
	)

	val predefined = listOf(
			listOf("bb045248", "Augustplatz, Neues Theater", "1900", "1/14/Bb045248", "51.340517 12.381463"),
			listOf("bb045268", "Reichsgericht, Vordergrund Tauchnitz-Brücke und Pleiße, rechts Villa Vogel, um 1910", "1910", "c/c6/Bb045268", "51.333113 12.369818"),
			listOf("bb045271", "Reichsgericht, Vordergrund Tauchnitz-Brücke und Pleiße, rechts Villa Vogel, um 1910", "1910", "e/ea/Bb045271", "51.333113 12.369818"),
			listOf("bb045339", "Augustusplatz, Paulinerkirche", "1900", "e/ee/Bb045339", "51.338521 12.381647"),
			listOf("bb045620", "Neues Theater, Augustusplatz", "1900", "4/41/Bb045620", "51.340517 12.381463"),
			listOf("bb046340_1", "Grimmaische Straße mit Erker des Fürstenhauses um 1895", "1895", "d/d2/Bb046340_1", "51.339842 12.377804"),
			listOf("bb046571", "Königliches Conservatorium der Musik", "1900", "c/c0/Bb046571", "51.332677 12.366812"),
			listOf("bb046512_1", "Frankfurter Straße, Lortzings Haus mit Garten, vor 1897", "1897", "thumb/7/71/Bb046512_1.tif/lossy-page1-1024px-Bb046512_1.tif", "51.3430719 12.3639554"),
			listOf("bb046628", "Großer Concertsaal im Neuen Gewandhaus", "1900", "1/1f/Bb046628", "51.331849 12.368349"),
			//listOf("bb0466282", "Bismarck-Denkmal auf dem Augustusplatz", "1895", "f/f6/Bb0466282", "51.339907 12.381247"),
			listOf("bb046634_1", "König Albert-Park, Sächsisch-Thüringische Gewerbeausstellung, Eingang, 1897", "1900", "8/86/Bb046634", "51.330505 12.358851"),
			listOf("bb047226", "Petersstraße während der Papiermesse", "1900", "5/50/BB047226", "51.338513 12.3746225")
	)

	val imagesWithoutMetadata = predefined.map {
			(0 .. 44).map { "" }.toMutableList()
		}.mapIndexed { index, elemList ->
			val predef = predefined[index]
			elemList.apply {
				set(43, predef[0])
				set(7, predef[1])
				set(20, predef[2])
				set(42, "https://upload.wikimedia.org/wikipedia/commons/${predef[3]}.jpg")
				set(44, "POINT (${predef[4]})")
			}
			elemList
		}
	
	val ID_PROCESSOR = Processor("﻿Archivsignatur")
	val POINT_PROCESSOR = Processor("GEOKOORDINATEN_MOTIV", proc = { coord: String ->
		toLngLatAlt(coord.replace(",", "."))
	})
}