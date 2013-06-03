package kr.co.tqk.launcher;

import java.io.File;
import java.sql.SQLException;
import java.util.LinkedHashMap;

import kr.co.tqk.analysis.cluster.download.ASJCDataDownload;
import kr.co.tqk.analysis.cluster.download.NanoDataDownload;

public class NanoDataDownloader {

	public static void main(String[] args) {
		int year = 2001;
		float ranking = 0.05f;
		int type = ASJCDataDownload.ALL_TYPE;
		LinkedHashMap<String, String> asjcInfo = new LinkedHashMap<String, String>();

		System.out.println(asjcInfo);
		String saveFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/download/KISTI_COUPLING/nano/0.05/";
		File dir = new File(saveFilePath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}

		NanoDataDownload dd = new NanoDataDownload(year, ranking, type,
				saveFilePath);
		try {
			dd.download();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
