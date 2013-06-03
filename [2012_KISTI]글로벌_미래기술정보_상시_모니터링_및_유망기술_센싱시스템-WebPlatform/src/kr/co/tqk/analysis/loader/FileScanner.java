package kr.co.tqk.analysis.loader;

import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * ���κ��� ��ϵ� �����͸� ���������� �д´�.<br>
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
	 *            ���ϸ��� ���Ե� ������.
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
