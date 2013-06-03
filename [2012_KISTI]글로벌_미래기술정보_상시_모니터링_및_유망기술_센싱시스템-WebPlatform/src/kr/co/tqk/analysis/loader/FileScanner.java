package kr.co.tqk.analysis.loader;

import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * 라인별로 기록된 데이터를 순차적으로 읽는다.<br>
 * 
 * @author neon
 * 
 */
public class FileScanner {

	public String CHARSET = "UTF-8";
	private String filePath;
	Scanner reader = null;

	/**
	 * @param absoluteFilePath
	 *            파일명이 포함된 절대경로.
	 */
	public FileScanner(String absoluteFilePath) {
		this.filePath = absoluteFilePath;
		init();
	}

	public FileScanner(String absoluteFilePath, String charset) {
		this.filePath = absoluteFilePath;
		this.CHARSET = charset;
		init();
	}

	private void init() {
		java.io.FileReader fr;
		try {
			fr = new java.io.FileReader(this.filePath);
			reader = new Scanner(fr);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			reader = null;
		} 
	}

	public String nextLine() {
		if(reader==null) return null;
		return reader.nextLine();
	}

	public boolean hasNextLine() {
		if(reader==null) return false;
		return reader.hasNextLine();
	}
	
	public void close(){
		if(reader!=null) reader.close();
	}

}
