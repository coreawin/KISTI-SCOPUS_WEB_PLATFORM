package kr.co.tqk.analysis.excel;

import org.apache.poi.ss.usermodel.Cell;

public class AbstractExcelReader {

	public String getCellData(Cell c) {
		switch (c.getCellType()) {
		case Cell.CELL_TYPE_STRING:
			String s = c.getRichStringCellValue().getString();
			s = s.trim().replaceAll("\r", "").replaceAll("\n", "");
			return s;
		case Cell.CELL_TYPE_FORMULA:
			try{
				return String.valueOf(c.getNumericCellValue());
			}catch(Exception e){
				return c.getStringCellValue();
			}
		case Cell.CELL_TYPE_NUMERIC:
			return String.valueOf(c.getNumericCellValue());
		}
		return "";
	}
}
