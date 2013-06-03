package kr.co.tqk.analysis.report;

import java.util.HashMap;
import java.util.LinkedHashMap;

/**
 * ������ �� �����͸� DB �׸񿡼� �����Ѵ�. <br>
 * ����� ���ο�� �������� ������������ ���ĵǾ�� �Ѵ�.<br>
 * 
 * 
 * @author ������
 * 
 */
public class GenerateReportData {

	/**
	 * ���� ������ Bean
	 */
	private ReportBean rb = null;

	/**
	 * ���� �����͸� �����Ѵ�.<br>
	 * 
	 * @param hashMap
	 * 
	 * @param eidSet
	 *            ���� EID ��
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
//		System.out.println("�ٽɳ� ���࿬�� " + rb.getPublicationYearInfo());
//		System.out.println("�ٽɳ��� �ο���鿡 ���� ���࿬��"
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
	 * @return ����Ʈ�� �ۼ��� �����͸� �����Ѵ�.
	 */
	public ReportBean getReportData() {
		return rb;
	}

}
