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
	
	val ID_PROCESSOR = new Processor("﻿Archivsignatur")
	val POINT_PROCESSOR = new Processor("GEOKOORDINATEN_MOTIV", [String a | new Point(a.replace(',', '.').toLngLatAlt)])
	
}