package kr.co.tqk.web.db.dao.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashSet;

import kr.co.tqk.web.db.bean.export.ExportBean;

import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 * 엑셀 형식의 데이터를 다운로드 받는다.
 * 
 * @author 정승한
 * 
 */
public class ExportExcel extends ExportDocumentSax {

	FileOutputStream fs = null;
	FileInputStream inputStream = null;
	XSSFWorkbook workbook;
	XSSFSheet sheet = null;

	int countRowNumber = 0;

	/**
	 * 엑셀형식으로 데이터를 익스포트한다.<br>
	 * 
	 * @param makeFileName
	 *            다운로드할 파일 이름
	 */
	public ExportExcel(String templateExcelFilePath, String makeFileName, HashSet<String> selectedCheck) {
		super(makeFileName, selectedCheck);
		File templateExcelFile = new File(templateExcelFilePath);
		try {
			inputStream = new FileInputStream(templateExcelFile);
			fs = new FileOutputStream(writeFile);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}
		try {
			workbook = new XSSFWorkbook(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public void flush() {
		try {
			workbook.write(fs);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
	}

	public void close() {
		if (fs != null)
			try {
				flush();
				fs.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
	}

	int sheetCnt = 0;

	@Override
	public void write() {
		countRowNumber += 2;
		sheet = workbook.getSheetAt(sheetCnt++); // 첫번째 쉬트
		if (exportDataList != null) {
			for (ExportBean eb : exportDataList) {
				int cellCnt = 0;
				XSSFRow row = sheet.createRow(countRowNumber++);
//				write(row, cellCnt++, "EID", eb.getEid());
				row.createCell(cellCnt++).setCellValue(eb.getEid());
				write(row, cellCnt++, "TITLE", eb.getTitle());
				write(row, cellCnt++, "ABSTRACT", eb.getAbs());
				write(row, cellCnt++, "YEAR", eb.getYear());
				write(row, cellCnt++, "DOI", eb.getDoi());
				write(row, cellCnt++, "KEYWORD", eb.getAuthorKeyword());
				write(row, cellCnt++, "INDEX_KEYWORD", eb.getIndexKeyword());
				write(row, cellCnt++, "ASJC", eb.getAsjcCode());
				write(row, cellCnt++, "NUMBER_CITATION", String.valueOf(eb.getNumberOfCitation()));
				write(row, cellCnt++, "CITATION", eb.getCitationList());
				write(row, cellCnt++, "NUMBER_REFERENCE", String.valueOf(eb.getNumberOfReference()));
				write(row, cellCnt++, "REFERENCE", eb.getReferenceList());
				
				write(row, cellCnt++, "AUTHOR_NAME", eb.getAuthor_authorName());
				write(row, cellCnt++, "AUTHOR_EMAIL", eb.getAuthor_email());
				write(row, cellCnt++, "AUTHOR_COUNTRYCODE", eb.getAuthor_country());
				write(row, cellCnt++, "AUTHOR_COUNTRYCODE", eb.getAuthor_affilation());
				
				write(row, cellCnt++, "SOURCE_SOURCETITLE", eb.getSource_sourceTitle());
				write(row, cellCnt++, "SOURCE_VOLUMN", eb.getSource_volumn());
				write(row, cellCnt++, "SOURCE_ISSUE", eb.getSource_issue());
				write(row, cellCnt++, "SOURCE_PAGE", eb.getSource_page());
				write(row, cellCnt++, "SOURCE_TYPE", eb.getSource_type());
//				write(row, cellCnt++, "", eb.getSource_publisher());
				write(row, cellCnt++, "SOURCE_COUNTRY", eb.getSource_country());
				write(row, cellCnt++, "SOURCE_PISSN", eb.getSource_pissn());
				write(row, cellCnt++, "SOURCE_EISSN", eb.getSource_eissn());

				write(row, cellCnt++, "CORR_AUTHORNAME", eb.getCorr_authorName());
				write(row, cellCnt++, "CORR_COUNTRYCODE", eb.getCorr_country());
				write(row, cellCnt++, "CORR_EMAIL", eb.getCorr_email());
				write(row, cellCnt++, "CORR_AFFILIATION", eb.getCorr_affilation());
			}
		}
		exportDataList = null;
	}
	
	private void write(XSSFRow row, int cellIdx, String field, String contents) {
		if (selectedCheck.contains(field)) {
			row.createCell(cellIdx).setCellValue(contents);
		}
	}
}
