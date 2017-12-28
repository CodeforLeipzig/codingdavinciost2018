package de.oklab.leipzig.cdv.glams

import org.jsoup.Jsoup

import static extension de.oklab.leipzig.cdv.glams.GeoJSONWriter.*

class MuseumDigitalMain {
	private static val HEADER = #["Name", "Ort", "InstNr", "Homepage", "Sammlungen", "Objekte"]
	private static val INSTR_NR_STR = "instnr="
	private static val INSTR_NR_STR_LEN = INSTR_NR_STR.length

	def static void main(String[] args) {
		val states = #{"st" -> "saxony-anhalt", "sachsen" -> "sachsen", "thue" -> "thuringia"}
		states.entrySet.forEach[writeCSV(key, value)]
	}	
	
	def static void writeCSV(String stateId, String stateName) {
		val doc = Jsoup.connect('''https://www.museum-digital.de/«stateId»/index.php?t=museum''').get
		val trs = doc.select(".overviewtable tr").tail
		val sb = <String>newArrayList
		sb.add(HEADER.join(";"))
		for(tr : trs) {
			val linkElem = tr.child(0).select("a[href]").first
			val city = tr.child(1).select("a").first.text
			val name = linkElem.text.trim 
			val instNr = linkElem.attr("href").substring(linkElem.attr("href").indexOf(INSTR_NR_STR) + INSTR_NR_STR_LEN)
			val homepage = tr.child(2)?.select("a[href]")?.first?.attr("href")
			val colls = tr.child(3)?.select("a")?.first?.text
			val objs = tr.child(4)?.select("a")?.first?.text
			val entry = #[name, city, instNr, homepage, colls, objs]
			sb.add(entry.join(";"))
		}
		writeFile(sb.join("\n"), '''«System.getProperty("user.dir")»/output/museum-digital_«stateName».csv''')
	}
}