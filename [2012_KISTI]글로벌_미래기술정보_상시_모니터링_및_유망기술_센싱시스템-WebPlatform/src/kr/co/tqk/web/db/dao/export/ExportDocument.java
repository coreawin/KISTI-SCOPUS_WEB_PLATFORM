package kr.co.tqk.web.db.dao.export;

import java.io.File;
import java.sql.Connection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.Set;

import kr.co.tqk.web.db.bean.export.ExportBean;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author ������
 * 
 */
public abstract class ExportDocument {

	Logger logger = LoggerFactory.getLogger(ExportDocument.class);
	
	protected HashMap<ExportField, Boolean> exportField = new HashMap<ExportField, Boolean>();
	protected File writeFile = null;
	/**
	 * Export ��� �����Ͱ� ����ִ�.
	 */
	protected LinkedList<ExportBean> exportDataList = null;
	protected HashSet<String> selectedCheck = null;

	int dataType = ExportDao.DATA_EXPORT;

	public ExportDocument(String makeFileName, int dataType) {
		this.writeFile = new File(makeFileName);
		this.dataType = dataType;
		setFieldInit();
	}

	public ExportDocument(String makeFileName, HashSet<String> selectedCheck) {
		this.writeFile = new File(makeFileName);
		this.selectedCheck = selectedCheck;

		setFieldInit();
		setExportField();
	}

	private void setFieldInit() {
		exportField.put(ExportField.TITLE, false);
		exportField.put(ExportField.ABSTRACT, false);
		exportField.put(ExportField.YEAR, false);
		exportField.put(ExportField.DOI, false);
		exportField.put(ExportField.KEYWORD, false);
		exportField.put(ExportField.INDEX_KEYWORD, false);
		exportField.put(ExportField.ASJC, false);
		exportField.put(ExportField.NUMBER_CITATION, false);
		exportField.put(ExportField.CITATION, false);
		exportField.put(ExportField.NUMBER_REFERENCE, false);
		exportField.put(ExportField.REFERENCE, false);
		exportField.put(ExportField.CITATION_TYPE, false);

		exportField.put(ExportField.AUTHOR_AUTHORINFO, false);
		exportField.put(ExportField.AUTHOR_NAME, false);
		exportField.put(ExportField.AUTHOR_COUNTRYCODE, false);
		exportField.put(ExportField.AUTHOR_EMAIL, false);
		exportField.put(ExportField.AFFILIATION_NAME, false);
		exportField.put(ExportField.AFFILIATION_COUNTRY, false);

		exportField.put(ExportField.SOURCE_SOURCETITLE, false);
		exportField.put(ExportField.SOURCE_VOLUMN, false);
		exportField.put(ExportField.SOURCE_ISSUE, false);
		exportField.put(ExportField.SOURCE_PAGE, false);
		exportField.put(ExportField.SOURCE_TYPE, false);
		exportField.put(ExportField.SOURCE_PUBLICSHERNAME, false);
		exportField.put(ExportField.SOURCE_COUNTRY, false);
		exportField.put(ExportField.SOURCE_PISSN, false);
		exportField.put(ExportField.SOURCE_EISSN, false);

		exportField.put(ExportField.CORR_AUTHORNAME, false);
		exportField.put(ExportField.CORR_COUNTRYCODE, false);
		exportField.put(ExportField.CORR_EMAIL, false);
		exportField.put(ExportField.CORR_AFFILIATION, false);
	}

	/**
	 * �ͽ���Ʈ�� �ʵ带 �����Ѵ�.
	 */
	void setExportField() {
		Set<ExportField> keySet = exportField.keySet();
		for(ExportField ef : keySet){
			if(selectedCheck.contains(ef.name().toUpperCase())){
				exportField.put(ef, true);
			}
		}
//		for (String checkKey : selectedCheck) {
//			if (exportField.containsKey(checkKey)) {
//				exportField.put(checkKey, true);
//			}
//		}
//		logger.debug("selectedCheck : " + selectedCheck.toString());
//		logger.debug("exportField : " + exportField.toString());
	}

	public void exportData(Connection conn, LinkedHashSet<String> eidSet) {
		exportDataList = null;
		System.gc();
		exportDataList = new ExportDao(conn, eidSet, exportField, dataType)
				.getExportData();
		write();
	}

	/**
	 * �� ���˿� �µ��� �ش� �����͸� ����Ѵ�.
	 */
	protected abstract void write();

	/**
	 * ���� �����͸� ����Ѵ�.<br>
	 */
	public abstract void flush();

	/**
	 * ���� stream�� �ݴ´�.<br>
	 */
	public abstract void close();
}
