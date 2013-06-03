package kr.co.tqk.web.util.file;

public class FileMap {

	private String FileName;
	private String saveFileName;

	public FileMap(String FileName, String saveFileName) {
		this.FileName = FileName;
		this.saveFileName = saveFileName;
	}

	public String getFileName() {
		return FileName;
	}

	public String getSaveFileName() {
		return saveFileName;
	}
}
