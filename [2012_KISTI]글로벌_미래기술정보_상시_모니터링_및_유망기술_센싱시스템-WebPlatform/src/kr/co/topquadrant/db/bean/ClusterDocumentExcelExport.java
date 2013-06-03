package kr.co.topquadrant.db.bean;

import java.util.Map;
import java.util.Set;

import kr.co.topquadrant.util.MapValueSort;
import kr.co.tqk.analysis.util.NumberFormatUtil;

/**
 * DataBean Ŭ������ Excel ���ø� ���·� �����ϱ� ���� ������ Ŭ����.<br>
 * 
 * @author coreawin
 * 
 */
public class ClusterDocumentExcelExport {

	/**
	 * ��з� ����
	 */
	public String largeAsjc = "";

	/**
	 * �з��ڵ� ����.
	 */
	public String asjc = "";

	/**
	 * Ű���� ����.
	 */
	public String keyword = "";

	/**
	 * Top �ٽ� �� ����.
	 */
	public String documentTop = "";

	/**
	 * �ٽ� �� ����.
	 */
	public String documentInfoTop = "";

	/**
	 * ���� �� ����.
	 */
	public String documentInfoKorea = "";

	public ClusterDocument document;

	public ClusterDocumentExcelExport(ClusterDocument cd) {
		this.document = cd;
		setup();
	}

	private void setup() {
		printExcelLargeAsjc();
		printExcelAsjc();
		printExcelKeyword(10);
		printTopDocument(Integer.MAX_VALUE);
		printKoreaDocument();
		printDocument();
	}

	/**
	 * ���� ��¿� �з� �ڵ� ����.
	 * 
	 */
	private void printExcelAsjc() {
		Map<String, Float> asjcInfo = document.getAsjcInfo();
		Set<String> set = asjcInfo.keySet();
		int cnt = 0;
		for (String s : set) {
			asjc += s + "(" + NumberFormatUtil.convertNumberPointFormat(asjcInfo.get(s), 2) + ")";
			if (cnt != set.size() - 1) {
				asjc += "  ";
			}
			cnt++;
		}
	}

	/**
	 * ���� ��¿� ��з� ����.
	 * 
	 */
	private void printExcelLargeAsjc() {
		Map<String, Float> largeAsjcInfo = document.getLargeAsjcInfo();
		Set<String> set = largeAsjcInfo.keySet();
		for (String s : set) {
			largeAsjc += s + "  ";
		}
	}

	/**
	 * ���� ��¿� Ű���� ����.
	 * 
	 * @param topIndex
	 *            Top Ranking
	 * @return
	 */
	private String printExcelKeyword(int topIndex) {
		StringBuffer keywordSB = new StringBuffer();
		Map<String, Integer> keywordMap = MapValueSort.topValueData(document.getKeywordInfo(), topIndex);
		Set<String> keywordSet = keywordMap.keySet();
		int cnt = 0;
		for (String kw : keywordSet) {
			keywordSB.append(kw.trim());
			keywordSB.append("(");
			keywordSB.append(keywordMap.get(kw));
			keywordSB.append(")");
			if ((keywordSet.size() - 1 != cnt)) {
				keywordSB.append(", ");
			}
			cnt++;
		}
		keyword = keywordSB.toString();
		return keyword;
	}

	private String printTopDocument(int topIndex) {
		Map<String, Integer> citationDocInfoMap = document.getDocumentCitationCountLinked();
		Map<String, String> docTitleInfoMap = document.getDocumentList();
		StringBuffer topDocumentSB = new StringBuffer();
		Set<String> eidSet = citationDocInfoMap.keySet();
		int cnt = 0;
		for (String eid : eidSet) {
			topDocumentSB.append(eid.trim());
			topDocumentSB.append(" (" + citationDocInfoMap.get(eid) + ")");
			topDocumentSB.append(" : ");
			topDocumentSB.append(docTitleInfoMap.get(eid));
			if (cnt < topIndex) {
				topDocumentSB.append("\n");
			}
			if (cnt == topIndex) {
				break;
			}
			cnt++;
		}
		documentTop = topDocumentSB.toString();
		return documentTop;
	}

	private String printDocument() {
		Map<String, String> docTitleInfoMap = document.getDocumentList();
		StringBuffer topDocumentSB = new StringBuffer();
		Set<String> eidSet = docTitleInfoMap.keySet();
		for (String eid : eidSet) {
			topDocumentSB.append(eid.trim());
			topDocumentSB.append(" : ");
			topDocumentSB.append(docTitleInfoMap.get(eid));
			topDocumentSB.append("\n");
		}
		documentInfoTop = topDocumentSB.toString();
		return documentInfoTop;
	}

	private String printKoreaDocument() {
		Map<String, String> map = document.getKoreaDocumentEidSet();
		StringBuffer sb = new StringBuffer();
		Set<String> s = map.keySet();
		for (String eid : s) {
			sb.append(eid.trim());
			sb.append(" : ");
			sb.append(map.get(eid));
			sb.append("\n");
		}
		documentInfoKorea = sb.toString();
		return documentInfoKorea;
	}
}
