package de.oklab.leipzig.cdv.damals.generator.process

import org.geojson.Point

import static extension de.oklab.leipzig.cdv.damals.generator.process.Functions.*

interface ProcessorDefinitions {

	val handleMultipleValuesFun = [String a | a.handleMultipleValues] 
	val handleDateTimeStr = [String a | a.handleDateTimeStr] 
	
	val descriptionProc = new Processor("description", "Bezeichnung", handleMultipleValuesFun)
	val buildingsProc = new Processor("buildings", "Gebäude", handleMultipleValuesFun)
	val streetsProc = new Processor("streets", "Straßen", handleMultipleValuesFun)
	val photographerProc = new Processor("photographer", "Fotograf")
	val dateProc = new Processor("date", "Datierung")
	val licenseProc = new Processor("license", "Lizenz")
	
	val PROP_PROCESSORS_CSV = newArrayList => [
		add(descriptionProc)
		add(new Processor("location", "Ort"))
		add(buildingsProc)
		add(streetsProc)
		add(photographerProc)
		add(new Processor("dateExtended", "ergänzende Datierung"))
		add(dateProc)
		add(new Processor("copyright", "Copyright"))
		add(licenseProc)
		add(new Processor("urlDataset", "URL Datensatz"))
		add(new Processor("urlImage", "URL Datei"))
	] 

	val PROP_PROCESSORS_XLSX = newArrayList => [
		add(new Processor("description", "Beschreibung des Gegenstandes", handleMultipleValuesFun))
		add(new Processor("location", "Abgebildeter Ort"))
		add(new Processor("buildings", "Abgebildete Institution", handleMultipleValuesFun))
		add(new Processor("streets", "Schlagwort-Gruppe_Schlagwort", handleMultipleValuesFun))
		add(new Processor("photographer", "HERSTELLUNG_KÜNSTLER/HERSTELLER_Name"))
		add(new Processor("dateExtended", "HERSTELLUNG_DATIERUNG_Datierung verbal"))
		add(new Processor("date", "Dargestellte Zeit"))
		add(new Processor("urlImage", "URL"))
	] 
	
	val metaDataWithoutImages = #[
		"bb045226", "bb045235", "bb045241", "bb045243", "bb045313",
		"bb045322", "bb045333", "bb045336", "bb045623", "bb045625",
		"bb045629", "bb045630", "bb045636", "bb045645", "bb045652",
		"bb046291", "bb046377", "bb046407", "bb046475", "bb046512",
		"bb046528", "bb046545", "bb046546", "bb046564", "bb046634",
		"bb046640", "bb046649", "bb046679", "bb046683", "bb047228"
	]

	val imagesWithoutMetadata = newArrayList() => [
		(0..12).map[<String>newArrayList((0..44).map[""])].forEach(list | it.add(list))
		val predefined = #[
			#["bb045248", "Augustplatz, Neues Theater", "1900", "1/14/Bb045248", "51.340517 12.381463"],
			#["bb045268", "Reichsgericht, Vordergrund Tauchnitz-Brücke und Pleiße, rechts Villa Vogel, um 1910", "1910", "c/c6/Bb045268", "51.333113 12.369818"],
			#["bb045271", "Reichsgericht, Vordergrund Tauchnitz-Brücke und Pleiße, rechts Villa Vogel, um 1910", "1910", "e/ea/Bb045271", "51.333113 12.369818"],
			#["bb045339", "Augustusplatz, Paulinerkirche", "1900", "e/ee/Bb045339", "51.338521 12.381647"],
			#["bb045620", "Neues Theater, Augustusplatz", "1900", "4/41/Bb045620", "51.340517 12.381463"],
			#["bb046340_1", "Grimmaische Straße mit Erker des Fürstenhauses um 1895", "1895", "d/d2/Bb046340_1", "51.339842 12.377804"],
			#["bb046571", "Königliches Conservatorium der Musik", "1900", "c/c0/Bb046571", "51.332677 12.366812"],
			#["bb046512_1", "Frankfurter Straße, Lortzings Haus mit Garten, vor 1897", "1897", "thumb/7/71/Bb046512_1.tif/lossy-page1-1024px-Bb046512_1.tif", "52.0 12.0"],
			#["bb046628", "Großer Concertsaal im Neuen Gewandhaus", "1900", "1/1f/Bb046628", "51.331849 12.368349"],
			#["bb0466282", "Bismarck-Denkmal auf dem Augustusplatz", "1895", "f/f6/Bb0466282", "51.339907 12.381247"],
			#["bb046634_1", "König Albert-Park, Sächsisch-Thüringische Gewerbeausstellung, Eingang, 1897", "1900", "8/86/Bb046634", "51.330505 12.358851"],
			#["bb047226", "Petersstraße während der Papiermesse", "1900", "5/50/BB047226", "51.338513 12.3746225"]
		]
		predefined.forEach(elem|
			it.get(predefined.indexOf(elem)) => [
				set(43, elem.get(0))
				set(7, elem.get(1))
				set(20, elem.get(2))
				set(42, '''https://upload.wikimedia.org/wikipedia/commons/«elem.get(3)».jpg''')
				set(44, '''POINT («elem.get(4)»)''')
			]
		)
	]
	
	val ID_PROCESSOR = new Processor("﻿Archivsignatur")
	val POINT_PROCESSOR = new Processor("GEOKOORDINATEN_MOTIV", [String a | new Point(a.replace(',', '.').toLngLatAlt)])
	
}