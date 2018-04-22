package de.oklab.leipzig.cdv.damals.generator.process

import org.geojson.Point

import static extension de.oklab.leipzig.cdv.damals.generator.process.Functions.*

interface ProcessorDefinitions {

	val handleMultipleValuesFun = [String a | a.handleMultipleValues] 
	val handleDateTimeStr = [String a | a.handleDateTimeStr] 
	
	val kurzTitelProc = new Processor("kurztitel", "KURZTITEL")
	val titelProc = new Processor("titel", "TITEL")
	val beschreibungMotivProc = new Processor("beschreibungMotiv", "BESCHREIBUNG_MOTIV")
	val fotografProc = new Processor("fotograf", "FOTOGRAF", handleMultipleValuesFun)
	val datierungVonProc = new Processor("datierungVon", "DATIERUNGVON")
	val datierungKonkretProc = new Processor("datierungKonkret", "DATIERUNGKONKRET", handleDateTimeStr)
	val schlagwortProc = new Processor("schlagwort", "SCHLAGWORT", handleMultipleValuesFun)
	val ortzeitbeschreibungProc = new Processor("ortzeitbeschreibung", "ORTZEITBESCHREIBUNG")
	val strassennameMotivProc = new Processor("strassennameMotiv", "STRASSENNAME_MOTIV")
	val lizenzProc = new Processor("lizenz", "LIZENZ")
	
	val PROP_PROCESSORS = newArrayList => [
		add(kurzTitelProc)
		add(titelProc)
		add(fotografProc)
		add(datierungVonProc)
		add(new Processor("datierungBis", "DATIERUNGBIS"))
		add(datierungKonkretProc)
		add(ortzeitbeschreibungProc)
		add(schlagwortProc)
		add(beschreibungMotivProc)
		add(strassennameMotivProc)
		add(new Processor("stadtbezirk", "STADTBEZIRK", handleMultipleValuesFun))
		add(new Processor("url", "URL"))
		add(new Processor("datengeber", "DATENGEBER"))
		add(new Processor("isilDatengeber", "ISIL_DATENGEBER"))
		add(lizenzProc)
	] 
	
	val ID_PROCESSOR = new Processor("﻿Archivsignatur")
	val POINT_PROCESSOR = new Processor("GEOKOORDINATEN_MOTIV", [String a | new Point(a.replace(',', '.').toLngLatAlt)])
	
}