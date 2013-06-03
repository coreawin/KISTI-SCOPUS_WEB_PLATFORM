package kr.co.tqk.analysis.excel.bulkCluster;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.SortedSet;
import java.util.TreeSet;

import kr.co.tqk.analysis.excel.AbstractExcelReader;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

public class ExcelReader extends AbstractExcelReader {

	public static final char REFERENCE = 'r';
	public static final char CITATION = 'c';
	public static final char KISTI = 'k';
	public static final char KISTI_MAX = 'm';

	String fileName = null;
	InputStream inp = null;
	Workbook wb = null;
	Sheet sheet = null;
	char option;
	SortedSet<Integer> dataColumnIndex = null;
	int dataRowIndex = 0;

	HashMap<String, ExcelVO> excelData = new HashMap<String, ExcelVO>();

	public ExcelReader(String excelFile) {
		this.fileName = excelFile;
		dataColumnIndex = new TreeSet<Integer>();
	}

	/**
	 * @return 읽은 전체 PI 셋
	 * @throws Exception
	 */
	public HashMap<String, ExcelVO> execute() throws Exception {
		try {
			File file = new File(fileName);
			System.out.println(file.getAbsolutePath());
			inp = new FileInputStream(fileName);
			wb = WorkbookFactory.create(inp);
			sheet = wb.getSheetAt(0);
			setUpColumnIndex(sheet);
			readData();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw e;
//		} catch (InvalidFormatException e) {
//			e.printStackTrace();
//			throw e;
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (inp != null)
				try {
					inp.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return excelData;
	}

	private void readData() {
		for (int idx = dataRowIndex + 1; idx <= sheet.getLastRowNum(); idx++) {
			Row r = sheet.getRow(idx);
			String key = getCellData(r.getCell(0));
			String[] keys = key.split("_");
			ExcelVO vo = new ExcelVO();
			vo.key = key;
			vo.xKey = keys[0];
			vo.yKey = keys[1];
			for (int cIdx : dataColumnIndex) {
				Cell c = r.getCell(cIdx);
				if(c!=null){
					vo.simility = getCellData(c);
					if(vo.simility.equals("")){
						System.out.println(key + " line " +  idx);
						continue;
					}
					excelData.put(key, vo);
				}
				break;
			}
		}
	}

	private void setUpColumnIndex(Sheet s) {
		switch (option) {
		case REFERENCE:
			dataColumnIndex.add(8);
			break;

		case CITATION:
			dataColumnIndex.add(4);
			break;

		case KISTI:
			dataColumnIndex.add(12);
			break;
			
		case KISTI_MAX:
			dataColumnIndex.add(13);
			break;

		default:
			break;
		}
	}

	public void setOption(char o) {
		option = o;
	}

	public char getOption() {
		return option;
	}

	public static void main(String[] args) throws Exception {
		args = new String[] {
				"./data/나노_1퍼센트_유사도(0.01)_데이터분절_0909.xlsx",
				"-o1" };
		if (args.length == 2) {
			String option = args[1];
			ExcelReader excel = new ExcelReader(args[0]);
			if ("-o1".equalsIgnoreCase(option)) {
				excel.setOption('r');
			} else if ("-o2".equalsIgnoreCase(option)) {
				excel.setOption('c');
			} else if ("-o3".equalsIgnoreCase(option)) {
				excel.setOption('k');
			}else if ("-o4".equalsIgnoreCase(option)) {
				excel.setOption('m');
			}
			System.out.println(excel.execute());
		}

	}
}
