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
 * Ŭ�����͸� �м� ������ ����� ������ �ٿ�δ� Wrapper class �̴�.
 * 
 * @author ������
 * 
 */
public class DataDownloaderGUI {

	/**
	 * �з��� (ASJC)
	 */
	public static final int TYPE_ASJC = 1;
	/**
	 * ���κ� (ISSN)
	 */
	public static final int TYPE_ISSN = 10;
	/**
	 * ���뵥���� (Nano)
	 */
	public static final int TYPE_NANO = 100;

	/**
	 * 
	 * @param type
	 *            Data Type (ASJC, ISSN, NANO) <br>
	 *            DataDownloaderGUI.TYPE_ASJC
	 * @param dataType
	 *            �������չ�, �����ο�м�, Kisti coupling <br>
	 *            IDataDownload.ALL_TYPE
	 * @param fromYear
	 *            ���࿬��
	 * @param ranking
	 *            ���� �ο� % <br>
	 *            30���� Ŭ���� ����.
	 * @param readFile
	 *            �з� ������ ��� �ִ� ���� ��� �н�
	 * @param outputPath
	 *            ��� ������ ������ �н�
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
	 *            �������չ�, �����ο�м�, Kisti coupling <br>
	 *            IDataDownload.ALL_TYPE
	 * @param _fromYear
	 *            ���� ���� ����
	 * @param _toYear
	 *            ���� ���� ����
	 * @param ranking
	 *            ���� �ο� % <br>
	 *            30���� Ŭ���� ����.
	 * @param readFile
	 *            �з� ������ ��� �ִ� ���� ��� �н�
	 * @param outputPath
	 *            ��� ������ ������ �н�
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
