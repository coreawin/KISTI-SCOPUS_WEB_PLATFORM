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
public class ExportExcel extends ExportDocument {

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
				row.createCell(cellCnt++).setCellValue(eb.getEid());
				row.createCell(cellCnt++).setCellValue(exportField.get("TITLE") ? eb.getTitle() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("ABSTRACT") ? eb.getAbstractTitle() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("YEAR") ? eb.getYear() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("DOI") ? eb.getDoi() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("KEYWORD") ? eb.getAuthorKeyword() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("INDEX_KEYWORD") ? eb.getIndexKeyword() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("ASJC") ? eb.getAsjcCode() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("NUMBER_CITATION") ? String.valueOf(eb.getNumberOfCitation()) : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("CITATION") ? eb.getCitationList() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("NUMBER_REFERENCE") ? String.valueOf(eb.getNumberOfReference()) : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("REFERENCE") ? eb.getReferenceList() : "");

				row.createCell(cellCnt++).setCellValue(exportField.get("AUTHOR_AUTHORNAME") ? eb.getAuthor_authorName() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("AUTHOR_EMAIL") ? eb.getAuthor_email() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("AUTHOR_COUNTRYCODE") ? eb.getAuthor_country() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("AUTHOR_AFFILIATION") ? eb.getAuthor_affilation() : "");

				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_SOURCETITLE") ? eb.getSource_sourceTitle() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_VOLUMN") ? eb.getSource_volumn() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_ISSUE") ? eb.getSource_issue() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_PAGE") ? eb.getSource_page() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_TYPE") ? eb.getSource_type() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_PUBLICSHERNAME") ? eb.getSource_publisher() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_COUNTRY") ? eb.getSource_country() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_PISSN") ? eb.getSource_pissn() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("SOURCE_EISSN") ? eb.getSource_eissn() : "");

				row.createCell(cellCnt++).setCellValue(exportField.get("CORR_AUTHORNAME") ? eb.getCorr_authorName() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("CORR_COUNTRYCODE") ? eb.getCorr_country() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("CORR_EMAIL") ? eb.getCorr_email() : "");
				row.createCell(cellCnt++).setCellValue(exportField.get("CORR_AFFILIATION") ? eb.getCorr_affilation() : "");
			}
		}
		exportDataList = null;
	}
}
