package kr.co.tqk.web.db.dao.export;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.regex.Pattern;

import kr.co.tqk.web.db.bean.export.ExportBean;
import kr.co.tqk.web.db.dao.xml.ScopusXMLData;
import kr.co.tqk.web.db.dao.xml.XMLSaxParser;

/**
 * @author coreawin
 * @since 2013-10-01
 * 
 */
public class ExportSax {

	public static final int CLUSTER_DATA_EXPORT = 1;
	public static final int DATA_EXPORT = 100;

	Map<String, String> xmlDatas;
	Map<String, String> citXmlDatas;
	LinkedHashSet<String> eidSet = null;
	LinkedHashMap<String, ExportBean> exportList = new LinkedHashMap<String, ExportBean>();
	StringBuffer query = new StringBuffer();
	HashMap<ExportField, Boolean> exportField = null;

	public static final String DATA_DELIM = ";";

	/**
	 * 임시 변수용
	 */
	StringBuffer tmpSB = new StringBuffer();
	StringBuffer tmpSB2 = new StringBuffer();
	ExportBean bean = null;

	public ExportSax(Map<String, String> xmlDatas, Map<String, String> citXmlDatas, HashMap<ExportField, Boolean> exportField) {
		this(xmlDatas, citXmlDatas, exportField, DATA_EXPORT);
	}

	/**
	 * 정보분석 플랫폼에서 데이터를 다운로드 하기 위해서 검색엔진의 XML로부터 데이터를 파싱한다.
	 * 
	 * @param xmlDatas
	 *            SCOPUS RAW-DATA XML
	 * @param citXmlDatas
	 *            SCOPUS RAW-DATA 인용 정보 XML
	 * @param exportField
	 *            정보분석 플랫폼에서 선택한 export할 데이터.
	 * @param type
	 *            클러스터 분석 데이터인지, 엑셀 포맷의 분석 데이터인지 다운도르될 데이터의 유형 <BR>
	 * @see ExportDao.CLUSTER_DATA_EXPORT, ExportDao.DATA_EXPORT
	 */
	public ExportSax(Map<String, String> xmlDatas, Map<String, String> citXmlDatas, HashMap<ExportField, Boolean> exportField, int type) {
		this.xmlDatas = xmlDatas;
		this.citXmlDatas = citXmlDatas;
		this.exportField = exportField;
		parse();
	}

	/**
	 * 계량 분석을 위한 Export 데이터 가져오기.
	 * 
	 * @param conn
	 *            DB 커넥션
	 * @param eidSet
	 *            데이터를 다운로드할 문서 ID set
	 */
	public ExportSax(Map<String, String> xmlDatas, Map<String, String> citXmlDatas) {
		this.xmlDatas = xmlDatas;
		this.citXmlDatas = citXmlDatas;
		parse();
	}

	static final Pattern INVALID_XML_CHARS = Pattern.compile("[^\\u0009\\u000A\\u000D\\u0020-\\uD7FF\\uE000-\\uFFFD\uD800\uDC00-\uDBFF\uDFFF]");
	/**
	 * XML을 SAX 파싱한다.
	 */
	private void parse() {
		exportList = new LinkedHashMap<String, ExportBean>();
		Set<Entry<String, String>> xmlDataE = this.xmlDatas.entrySet();
		XMLSaxParser parser = XMLSaxParser.getInstance();
		StringBuffer buf = new StringBuffer();
		for (Entry<String, String> e : xmlDataE) {
			String eid = e.getKey();
			String xml = e.getValue().replaceAll("[\\x00-\\x1F]", "");
			String citXml = this.citXmlDatas.get(eid).replaceAll("[\\x00-\\x1F]", "");
			try {
				ScopusXMLData xmld = parser.parse(xml);
				ScopusXMLData citXmld = parser.parse(citXml);
				ExportBean eb = parser.convertExportBean(xmld, citXmld);
				exportList.put(eid, eb);
			} catch (Exception e1) {
				System.out.println("parse error eid : " + eid);
//				String file = "t:/tmp/scopus/"+eid+".xml";
//				BufferedWriter bw =null;
//				try {
//					bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"));
//					bw.write(xml);
//				} catch (IOException e2) {
//					e2.printStackTrace();
//				} finally{
//					if(bw!=null){
//						try {
//							bw.flush();
//							bw.close();
//						} catch (IOException e2) {
//							e2.printStackTrace();
//						}
//					}
//				}
				e1.printStackTrace();
			}
		}
	}

	/**
	 * 데이터를 가져온다.<br>
	 * 
	 * @return
	 */
	public LinkedList<ExportBean> getExportData() {
		LinkedList<ExportBean> result = new LinkedList<ExportBean>();
		for (ExportBean eb : exportList.values()) {
			result.add(eb);
		}
		exportList = null;
		return result;
	}
}
