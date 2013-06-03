package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileNotFoundException;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.Scanner;

import kr.co.tqk.analysis.cluster.download.ASJCDataDownload;

public class ASJCDataDownloader {

	public static void main(String[] args) {
		int year = 2001;
		float ranking = 0.05f;
		int type = ASJCDataDownload.ALL_TYPE;
		LinkedHashMap<String, String> asjcInfo = new LinkedHashMap<String, String>();
		String readFile = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/downloadASJC.txt";

		Scanner s;
		try {
			s = new Scanner(new File(readFile));
			while (s.hasNextLine()) {
				String line = s.nextLine();
				// System.out.println(line);
				if (line.indexOf("skip") != -1)
					continue;
				String[] data = line.split(":");
				asjcInfo.put(data[0], data[1]);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		System.out.println(asjcInfo);
		String saveFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/download/KISTI_COUPLING/0.05/";
		ASJCDataDownload dd = new ASJCDataDownload(year, ranking, type, asjcInfo,
				saveFilePath);
		try {
			dd.download();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
