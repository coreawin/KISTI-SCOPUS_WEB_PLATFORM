package kr.co.tqk.web.db.dao.xml;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Set;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import kr.co.tqk.web.db.DescriptionCode;
import kr.co.tqk.web.db.bean.export.ExportBean;
import kr.co.tqk.web.db.dao.export.ExportDao;

import org.xml.sax.SAXException;

public class XMLSaxParser {

	private static XMLSaxParser instance = new XMLSaxParser();

	SAXParserFactory factory = SAXParserFactory.newInstance();
	SAXParser parser = null;

	private XMLSaxParser() {
		factory.setNamespaceAware(false);
		factory.setValidating(false);
		try {
			parser = factory.newSAXParser();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
	}

	public static XMLSaxParser getInstance() {
		return new XMLSaxParser();
//		return instance;
	}

	public ScopusXMLData parse(String xml) throws Exception {
		ScopusXMLData data = null;
		BufferedInputStream bis = null;
		ScopusSaxHandler handler = new ScopusSaxHandler();
		try {
			bis = new BufferedInputStream(new ByteArrayInputStream(xml.getBytes(Charset.forName("UTF-8"))));
			parser.parse(bis, handler);
			data = handler.getData();
		} catch (Exception e) {
			throw e;
		} finally {
			if (bis != null) {
				bis.close();
			}
		}
		return data;
	}

	StringBuffer buf = new StringBuffer();

	public String convertStringToSet(Set<String> set) {
		buf.setLength(0);
		for (String d : set) {
			buf.append(d.trim());
			buf.append(ExportDao.DATA_DELIM);
		}
		if (buf.length() > 0) {
			buf.deleteCharAt(buf.length() - 1);
		}
		return buf.toString();
	}

	public String convertStringToSet(List<String> list) {
		buf.setLength(0);
		for (String d : list) {
			buf.append(d.trim());
			buf.append(ExportDao.DATA_DELIM);
		}
		if (buf.length() > 0) {
			buf.deleteCharAt(buf.length() - 1);
		}
		System.out.println("========================");
		System.out.println(buf.toString());
		return buf.toString();
	}

	public ExportBean convertExportBean(ScopusXMLData xml, ScopusXMLData citXml) {
		ExportBean eb = new ExportBean(xml.getEid());
		eb.setTitle(xml.getTitle());
		eb.setAbs(xml.getAbstractStr());
		eb.setAffiliation_country(convertStringToSet(xml.getAffiliation_country()));
		eb.setAsjcCode(convertStringToSet(xml.getAsjcCode()));
		eb.setAuthor_affilation(convertStringToSet(xml.getOrgName()));
		eb.setAuthor_affilation_info(xml.getAuthorInfo());
		eb.setAuthor_authorName(convertStringToSet(xml.getAuthorName()));
		eb.setAuthor_country(convertStringToSet(xml.getAuthorCountry()));
		eb.setAuthor_email(convertStringToSet(xml.getAuthorEmail()));
		eb.setAuthorKeyword(convertStringToSet(xml.getKeyword()));
		String cType = DescriptionCode.getCitationType().get(xml.getCitType());
		if (cType == null) {
			cType = xml.getCitType();
		}
		eb.setAuthor_delegateName(convertStringToSet(xml.getDelegateAuthorName()));
		eb.setCitation_type(cType);
		eb.setCorr_affilation(xml.getCorr_affilation());
		eb.setCorr_authorName(xml.getCorr_authorName());
		eb.setCorr_country(xml.getCorr_country());
		eb.setCorr_email(xml.getCorr_email());
		eb.setDoi(xml.getDoi());
		eb.setIndexKeyword(convertStringToSet(xml.getIndexKeyword()));
		eb.setCitationList(convertStringToSet(citXml.getCitEids()));
		eb.setNumberOfCitation(Integer.parseInt(citXml.getCitCount()));
		eb.setNumberOfReference(Integer.parseInt(xml.getRefCount()));
		eb.setReferenceList(convertStringToSet(xml.getRefEids()));
		eb.setRefCitList(xml.getRefCitList(xml.getRefEids(), citXml.getCitEids()));
		eb.setSource_country(xml.getSource_country());
		eb.setSource_eissn(xml.getSource_eissn());
		eb.setSource_issue(xml.getSource_issue());
		eb.setSource_page(xml.getSource_page());
		eb.setSource_pissn(xml.getSource_pissn());
		eb.setSource_publisher(xml.getSource_publisher()); /* xml¿¡ ¾ø´Ù. */
		eb.setSource_sourceTitle(xml.getSource_sourceTitle());
		String sType = DescriptionCode.getSourceTypeDescription().get(xml.getSource_type());
		if (sType == null) {
			sType = xml.getSource_type();
		}
		eb.setSource_type(sType);
		eb.setSource_volumn(xml.getSource_volumn());
		eb.setTitle(xml.getTitle());
		eb.setYear(xml.getPublicationYear());

		return eb;
	}

	public static void main(String[] args) throws Exception {
		String file = "t:\\tmp\\scopus\\src\\test\\test\\eids-from-770001-to-780000\\2-s2.0-84877927662\\2-s2.0-84877927662.xml";
		// file = "t:\\tmp\\scopus\\src\\test\\test\\2-s2.0-84857870243.xml";
//		 file = "t:\\tmp\\scopus\\84871864111-search.xml";
//		 file = "t:\\tmp\\scopus\\84874174384.xml";
		String citfile = "t:\\tmp\\scopus\\src\\test\\test\\citedby.xml";
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(file)), "UTF-8"));
		StringBuilder sb = new StringBuilder();
		String l = null;
		while ((l = br.readLine()) != null) {
			for (int i = 0; i < l.length(); i++) {
				if (l.charAt(i) == 0x1a) {
					System.out.println("=================================" + l.charAt(i));
					sb.append('-');
				}
				sb.append(l.charAt(i));
			}
		}
		br.close();
		XMLSaxParser parser = XMLSaxParser.getInstance();
		ScopusXMLData xmld = parser.parse(sb.toString());
		System.out.println("=============> " + xmld.getAuthorSeq());

		br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(citfile))));
		sb.setLength(0);
		l = null;
		while ((l = br.readLine()) != null) {
			sb.append(l);
		}
		br.close();
		ScopusXMLData xmlCit = parser.parse(sb.toString());
		ExportBean eb = parser.convertExportBean(xmld, xmlCit);
		System.out.println(eb.getAuthor_affilation_info());
		System.out.println("=========================================");
		System.out.println(eb.getAuthor_authorName());
		System.out.println("=========================================");
	}
}
