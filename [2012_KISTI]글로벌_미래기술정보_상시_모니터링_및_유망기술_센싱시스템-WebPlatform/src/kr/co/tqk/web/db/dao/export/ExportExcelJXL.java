package kr.co.tqk.web.db.dao.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashSet;

import kr.co.tqk.web.db.bean.export.ExportBean;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

/**
 * 엑셀 형식의 데이터를 다운로드 받는다.
 * 
 * @author 정승한
 * 
 */
public class ExportExcelJXL extends ExportDocument {

	FileOutputStream fs = null;
	FileInputStream inputStream = null;
	SXSSFWorkbook workbook;
	SXSSFSheet sheet = null;

	int countRowNumber = 2;

	/**
	 * 엑셀형식으로 데이터를 익스포트한다.<br>
	 * 
	 * @param makeFileName
	 *            다운로드할 파일 이름
	 */
	public ExportExcelJXL(String templateExcelFilePath, String makeFileName, HashSet<String> selectedCheck) {
		super(makeFileName, selectedCheck);
		File templateExcelFile = new File(templateExcelFilePath);
		try {
			inputStream = new FileInputStream(templateExcelFile);
			fs = new FileOutputStream(writeFile);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}

		workbook = new SXSSFWorkbook();
		sheet = (SXSSFSheet) workbook.createSheet();
		initCell();
		// sheet = (XSSFSheet) workbook.getSheetAt(sheetCnt); // 첫번째 쉬트
	}

	private void initCell() {
		SXSSFRow row = (SXSSFRow) sheet.createRow(0);
		
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 12));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 13, 18));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 19, 27));
		sheet.addMergedRegion(new CellRangeAddress(0, 0, 28, 31));
		row.setHeightInPoints(20);
		createCell(row, 0, getDefaultHeaderCellStyle(CellStyle.ALIGN_CENTER), "Scopus Document Basic Info");
		createCell(row, 13, getDefaultHeaderCellStyle(CellStyle.ALIGN_CENTER), "Author Info");
		createCell(row, 19, getDefaultHeaderCellStyle(CellStyle.ALIGN_CENTER), "Source Info");
		createCell(row, 28, getDefaultHeaderCellStyle(CellStyle.ALIGN_CENTER), "Correspond Author Info");
		sheet.setZoom(4, 5);
		row = (SXSSFRow) sheet.createRow(1);
		int cellCnt = 0;
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "eid");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Title");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Abstract");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Publication Year");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "DOI");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Author Keyword");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Index Keyword");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "ASJC Code");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Number of Citation");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Citation List");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Number of Reference");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Reference List");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Document Type");
		
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Author Info");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Author Name");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Author Email");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Author Country");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Affiliation Name");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Affiliation Country");
		
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Source Title");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Volumn");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Issue");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Page");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Source Type");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Publisher Name");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Country");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "P-ISSN");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "E-ISSN");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Correspond Author Name");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Country");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Email");
		createCell(row, cellCnt++, getDefaultHeaderCellStyle(CellStyle.ALIGN_GENERAL), "Affiliation Name");
	}

	private Cell createCell(SXSSFRow row, int column, CellStyle style, String value) {
		Cell cell = row.createCell(column);
		cell.setCellStyle(style);
		cell.setCellValue(value);
		return cell;
	}

	protected CellStyle getDefaultCellStyle() {
		return getDefaultCellStyle(CellStyle.ALIGN_GENERAL);
	}

	protected CellStyle getDefaultCellStyle(short align) {
		Font font = workbook.createFont();
		font.setFontName("Consolas");

		CellStyle style = workbook.createCellStyle();
		style.setFillForegroundColor((short) 2);
		style.setAlignment(align);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setFont(font);
		return style;
	}

	protected CellStyle getDefaultHeaderCellStyle(short align) {
		return getDefaultHeaderCellStyle(align, (short) -1);
	}

	protected CellStyle getDefaultHeaderCellStyle(short align, short color) {
		Font font = workbook.createFont();
		font.setFontName("Consolas");
		CellStyle style = workbook.createCellStyle();
		style.setBorderBottom(CellStyle.BORDER_THIN);
		style.setBorderLeft(CellStyle.BORDER_THIN);
		style.setBorderRight(CellStyle.BORDER_THIN);
		style.setBorderTop(CellStyle.BORDER_THIN);
		style.setAlignment(align);
		if (color != -1) {
			style.setFillBackgroundColor(color);
		}
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		style.setFont(font);
		return style;
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
		if (exportDataList != null) {
			for (ExportBean eb : exportDataList) {
				int cellCnt = 0;
				SXSSFRow row = (SXSSFRow) sheet.createRow(countRowNumber++);
				row.createCell(cellCnt++).setCellValue(eb.getEid());
				row.createCell(cellCnt++).setCellValue(eb.getTitle());
				row.createCell(cellCnt++).setCellValue(eb.getAbstractTitle());
				row.createCell(cellCnt++).setCellValue(eb.getYear());
				row.createCell(cellCnt++).setCellValue(eb.getDoi());
				row.createCell(cellCnt++).setCellValue(eb.getAuthorKeyword());
				row.createCell(cellCnt++).setCellValue(eb.getIndexKeyword());
				row.createCell(cellCnt++).setCellValue(eb.getAsjcCode());
				row.createCell(cellCnt++).setCellValue(String.valueOf(eb.getNumberOfCitation()));
				row.createCell(cellCnt++).setCellValue(eb.getCitationList());
				row.createCell(cellCnt++).setCellValue(String.valueOf(eb.getNumberOfReference()));
				row.createCell(cellCnt++).setCellValue(eb.getReferenceList());
				row.createCell(cellCnt++).setCellValue(eb.getCitation_type());

				row.createCell(cellCnt++).setCellValue(eb.getAuthor_affilation_info());
				row.createCell(cellCnt++).setCellValue(eb.getAuthor_authorName());
				row.createCell(cellCnt++).setCellValue(eb.getAuthor_email());
				row.createCell(cellCnt++).setCellValue(eb.getAuthor_country());
				row.createCell(cellCnt++).setCellValue(eb.getAuthor_affilation());
				row.createCell(cellCnt++).setCellValue(eb.getAffiliation_country());

				row.createCell(cellCnt++).setCellValue(eb.getSource_sourceTitle());
				row.createCell(cellCnt++).setCellValue(eb.getSource_volumn());
				row.createCell(cellCnt++).setCellValue(eb.getSource_issue());
				row.createCell(cellCnt++).setCellValue(eb.getSource_page());
				row.createCell(cellCnt++).setCellValue(eb.getSource_type());
				row.createCell(cellCnt++).setCellValue(eb.getSource_publisher());
				row.createCell(cellCnt++).setCellValue(eb.getSource_country());
				row.createCell(cellCnt++).setCellValue(eb.getSource_pissn());
				row.createCell(cellCnt++).setCellValue(eb.getSource_eissn());

				row.createCell(cellCnt++).setCellValue(eb.getCorr_authorName());
				row.createCell(cellCnt++).setCellValue(eb.getCorr_country());
				row.createCell(cellCnt++).setCellValue(eb.getCorr_email());
				row.createCell(cellCnt++).setCellValue(eb.getCorr_affilation());
			}
		}
		exportDataList = null;
	}
}
