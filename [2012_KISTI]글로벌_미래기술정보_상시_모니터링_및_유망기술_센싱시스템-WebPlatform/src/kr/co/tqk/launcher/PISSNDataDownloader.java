package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Scanner;

import kr.co.tqk.analysis.cluster.download.PIssnDataDownload;

public class PISSNDataDownloader {

	public static void main(String[] args) {
		System.out.println("ISSN ���� ������ ����");
		int year = 2001;
		float ranking = 0.05f;
		int type = PIssnDataDownload.CIT_TYPE;
		LinkedHashMap<String, String> issnInfo = new LinkedHashMap<String, String>();
		String readFile = "e:/My Document/PROJECT/KISTI/2011-05_����_�����˻�_�÷���_��_����_�������_������_����_�м�����_����/downloadISSN.txt";

		Scanner s;
		try {
			s = new Scanner(new File(readFile));
			while (s.hasNextLine()) {
				String line = s.nextLine();
				// System.out.println(line);
				if (line.indexOf("skip") != -1)
					continue;
				String[] data = line.split(":");
				issnInfo.put(data[0], data[1]);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		System.out.println(issnInfo);
		String saveFilePath = "e:/My Document/PROJECT/KISTI/2011-05_����_�����˻�_�÷���_��_����_�������_������_����_�м�����_����/program/cluster/download/ISSN/CITATION/0.05/";
		File file = new File(saveFilePath);
		if (!file.isDirectory()) {
			file.mkdirs();
		}
		PIssnDataDownload dd = new PIssnDataDownload(year, ranking, type,
				issnInfo, saveFilePath);
		try {
			dd.download();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
