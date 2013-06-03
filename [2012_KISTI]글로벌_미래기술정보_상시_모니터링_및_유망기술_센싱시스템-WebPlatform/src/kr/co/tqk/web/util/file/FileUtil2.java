package kr.co.tqk.web.util.file;

import java.text.SimpleDateFormat;
import java.util.Date;

public class FileUtil2 {
	private String upfilename;

	/**
	 * 업로드할 파일명을 로드한다.<br>
	 * 
	 * @param fileName
	 * @return
	 */
	public String uploadFileName(String fileName) {
		String tail = token(fileName);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
		Date currentTime = new Date();
		synchronized (this) {
			try {
				Thread.sleep(300);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		String dTime = formatter.format(currentTime);
		upfilename = "excelInsert" + tail;
		return upfilename;
	}

	private String token(String fileName) {
		int tmp = fileName.lastIndexOf(".");
		String tail = fileName.substring(tmp);
		return tail;
	}
}
