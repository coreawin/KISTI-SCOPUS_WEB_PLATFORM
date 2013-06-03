package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Scanner;

import kr.co.tqk.analysis.cluster.download.ASJCDataDownload;
import kr.co.tqk.analysis.cluster.download.IDataDownload;
import kr.co.tqk.analysis.cluster.download.NanoDataDownload;
import kr.co.tqk.analysis.cluster.download.PIssnDataDownload;

/**
 * 클러스터링 분석 툴에서 사용할 데이터 다운로더 Wrapper class 이다.
 * 
 * @author 정승한
 * 
 */
public class DataDownloaderGUI {

	/**
	 * 분류별 (ASJC)
	 */
	public static final int TYPE_ASJC = 1;
	/**
	 * 저널별 (ISSN)
	 */
	public static final int TYPE_ISSN = 10;
	/**
	 * 나노데이터 (Nano)
	 */
	public static final int TYPE_NANO = 100;

	/**
	 * 
	 * @param type
	 *            Data Type (ASJC, ISSN, NANO) <br>
	 *            DataDownloaderGUI.TYPE_ASJC
	 * @param dataType
	 *            서지결합법, 동시인용분석, Kisti coupling <br>
	 *            IDataDownload.ALL_TYPE
	 * @param fromYear
	 *            발행연도
	 * @param ranking
	 *            상위 인용 % <br>
	 *            30보다 클수는 없다.
	 * @param readFile
	 *            분류 정보를 담고 있는 파일 경로 패스
	 * @param outputPath
	 *            결과 파일을 저장할 패스
	 * @throws FileNotFoundException
	 * @throws SQLException
	 */
	public DataDownloaderGUI(int type, int _dataType, int _year, int _ranking,
			String readFile, String outputPath) throws FileNotFoundException,
			SQLException {

		if (_ranking > 30)
			_ranking = 30;

		int year = 2001;
		float ranking = _ranking / 100f;

		IDataDownload dataDownload = null;

		if (type == TYPE_NANO) {
			dataDownload = new NanoDataDownload(year, ranking, _dataType, outputPath);
		} else {
			LinkedHashMap<String, String> dataInfo = new LinkedHashMap<String, String>();
			Scanner s;
			try {
				s = new Scanner(new File(readFile));
				while (s.hasNextLine()) {
					String line = s.nextLine();
					if (line.indexOf("skip") != -1)
						continue;
					String[] data = line.split(":");
					dataInfo.put(data[0], data[1]);
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				throw e;
			}
			if (type == TYPE_ASJC) {
				dataDownload = new ASJCDataDownload(year, ranking, _dataType,
						dataInfo, outputPath);
			} else if (type == TYPE_ISSN) {
				dataDownload = new PIssnDataDownload(year, ranking, _dataType,
						dataInfo, outputPath);
			}
		}

		dataDownload.download();

	}
	
	/**
	 * 
	 * @param type
	 *            Data Type (ASJC, ISSN, NANO) <br>
	 *            DataDownloaderGUI.TYPE_ASJC
	 * @param dataType
	 *            서지결합법, 동시인용분석, Kisti coupling <br>
	 *            IDataDownload.ALL_TYPE
	 * @param _fromYear
	 *            발행 시작 연도
	 * @param _toYear
	 *            발행 종료 연도
	 * @param ranking
	 *            상위 인용 % <br>
	 *            30보다 클수는 없다.
	 * @param readFile
	 *            분류 정보를 담고 있는 파일 경로 패스
	 * @param outputPath
	 *            결과 파일을 저장할 패스
	 * @throws FileNotFoundException
	 * @throws SQLException
	 */
	public DataDownloaderGUI(int type, int _dataType, int _fromYear, int _toYear, int _ranking,
			String readFile, String outputPath) throws FileNotFoundException,
			SQLException {
		
		if (_ranking > 30)
			_ranking = 30;
		
		float ranking = _ranking / 100f;
		
		IDataDownload dataDownload = null;
		
		if (type == TYPE_NANO) {
			dataDownload = new NanoDataDownload(_fromYear, _toYear, ranking, _dataType, outputPath);
		} else {
			LinkedHashMap<String, String> dataInfo = new LinkedHashMap<String, String>();
			Scanner s;
			try {
				s = new Scanner(new File(readFile));
				while (s.hasNextLine()) {
					String line = s.nextLine();
					if (line.indexOf("skip") != -1)
						continue;
					String[] data = line.split(":");
					dataInfo.put(data[0], data[1]);
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				throw e;
			}
			if (type == TYPE_ASJC) {
				dataDownload = new ASJCDataDownload(_fromYear, _toYear, ranking, _dataType,
						dataInfo, outputPath);
			} else if (type == TYPE_ISSN) {
				dataDownload = new PIssnDataDownload(_fromYear, _toYear, ranking, _dataType,
						dataInfo, outputPath);
			}
		}
		
		dataDownload.download();
		
	}
}
