package kr.co.tqk.web.db.dao.export;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;

import kr.co.tqk.web.db.bean.export.ExportBean;

/**
 * Text 파일로 데이터를 Export한다.
 * 
 * @author 정승한
 * 
 */
public class ExportText extends ExportDocument {

	BufferedWriter br = null;

	public ExportText(String makeFileName, HashSet<String> selectedCheck) {
		super(makeFileName, selectedCheck);
		File makeFile = new File(makeFileName);
		try {
			br = new BufferedWriter(new FileWriter(makeFile));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void write(String field, String contents) throws Exception{
		if(selectedCheck.contains(field)){
			w(field, contents);
		}
	}

	@Override
	protected void write() {
		if (exportDataList != null) {
			for (ExportBean eb : exportDataList) {
				try {
					w("EID", eb.getEid());
					write("TITLE", eb.getTitle());
					write("ABSTRACT", eb.getAbstractTitle());
					write("YEAR", eb.getYear());
					write("DOI", eb.getDoi());
					write("KEYWORD", eb.getAuthorKeyword());
					write("INDEX_KEYWORD", eb.getIndexKeyword());
					write("ASJC", eb.getAsjcCode());
					write("NUMBER_CITATION", String.valueOf(eb.getNumberOfCitation()));
					write("CITATION", eb.getCitationList());
					write("NUMBER_REFERENCE", String.valueOf(eb.getNumberOfReference()));
					write("REFERENCE", eb.getReferenceList());
					write("CITATION_TYPE", eb.getCitation_type());
					
					write("AUTHOR_AUTHORINFO", eb.getAuthor_affilation_info());
					write("AUTHOR_NAME", eb.getAuthor_authorName());
					write("AUTHOR_COUNTRYCODE", eb.getAuthor_country());
					write("AUTHOR_EMAIL", eb.getAuthor_email());
					write("AFFILIATION_NAME", eb.getAuthor_affilation());
					write("AFFILIATION_COUNTRY", eb.getAffiliation_country());
					
					write("SOURCE_SOURCETITLE", eb.getSource_sourceTitle());
					write("SOURCE_VOLUMN", eb.getSource_volumn());
					write("SOURCE_ISSUE", eb.getSource_issue());
					write("SOURCE_PAGE", eb.getSource_page());
					write("SOURCE_TYPE", eb.getSource_type());
					write("SOURCE_PUBLICSHERNAME", eb.getSource_publisher());
					write("SOURCE_COUNTRY", eb.getSource_country());
					write("SOURCE_PISSN", eb.getSource_pissn());
					write("SOURCE_EISSN", eb.getSource_eissn());
					write("CORR_AUTHORNAME", eb.getCorr_authorName());
					write("CORR_COUNTRYCODE", eb.getCorr_country());
					write("CORR_EMAIL", eb.getCorr_email());
					write("CORR_AFFILIATION", eb.getCorr_affilation());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	public void w(String field, String contents) throws Exception {
		try {
			if(br!=null){
				br.write(field + "|" + contents + "\r\n");
			}
		} catch (NullPointerException e) {
			throw new Exception(e);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void flush() {
		if (br != null) {
			try {
				br.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public void close() {
		if (br != null) {
			try {
				br.flush();
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

}
