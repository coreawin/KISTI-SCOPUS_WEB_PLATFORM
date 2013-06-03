package kr.co.tqk.analysis.report;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * 보고서에 들어갈 데이터를 DB 항목에서 추출한다. <br>
 * 결과는 피인용수 기준으로 오름차순으로 정렬되어야 한다.<br>
 * 
 * 
 * @author 정승한
 * 
 */
public class GenerateReportData {

	/**
	 * 보고서 데이터 Bean
	 */
	private ReportBean rb = null;

	/**
	 * 보고서 데이터를 생성한다.<br>
	 * 
	 * @param hashMap
	 * 
	 * @param eidSet
	 *            문서 EID 셋
	 */
	public GenerateReportData(LinkedHashMap<String, DocumentBean> resultData,
			HashMap<String, String> asjcInfo) {
		rb = new ReportBean(asjcInfo);
		for (DocumentBean bean : resultData.values()) {
			rb.addDocument(bean);
		}
		// for (DocumentBean bean : rb.getDocumentList()) {
		// System.out
		// .println(bean.getEid() + "\t" + bean.getCitationCount()
		// + "\t" + bean.getTitle() + "\t"
		// + bean.getPublicationYear());
		// }

//		System.out.println(rb.getDocumentCount());
//		System.out.println("핵심논문 발행연도 " + rb.getPublicationYearInfo());
//		System.out.println("핵심논문의 인용논문들에 대한 발행연도"
//				+ rb.getCitationPublicationYearInfo() + "\t"
//				+ rb.getAverageCitationPublicationYear());
//		 System.out.println(rb.getAsjcLargeList());
//		 System.out.println(rb.getAsjcList());
//		 System.out.println(rb.getKeywordList());
//		 System.out.println(rb.getKoreaOrgNameList());
		// SortedMap<String, String> sm = rb.getAsjcList();
		// System.out.println(sm.firstKey() + " @ " + sm);
		// System.out.println(rb.getAveragePublicationYear());
		// System.out.println(rb.getCitationCount());
	}

	/**
	 * @return 리포트에 작성될 데이터를 리턴한다.
	 */
	public ReportBean getReportData() {
		return rb;
	}

}
