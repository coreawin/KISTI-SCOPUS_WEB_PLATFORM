package kr.co.tqk.analysis.loader;

import java.io.File;
import java.util.Date;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.mvaule.KeyMultiValueManager;

/**
 * 구축 대상 데이터는 line별로 구분되어 있으며 각 라인은 특정 구분자에 의해 key와 value로 나뉘어져 있다.<br>
 * 
 * 구축 대상 데이터를 key-multiVaule 자료구조에 저장하는 클래스 <br>
 * 
 * @author neon
 * 
 */
public abstract class LoaderKMTreeRepository {

//	private String readFilePath;
//	private String repositoryPath;
//	private String repositoryFileName;
	private String delimeter;

	private KeyMultiValueManager kmvManager;
	private FileScanner scanner = null;

	int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	int cacheSize = 1024 * 1024 * 64;
	int nodeSize = 1024 * 4;
	int keyLength = 8;
	int valueLength = 4;

	/**
	 * 생성자
	 * 
	 * @param readFilePath
	 *            데이터 파일의 절대경로 (파일명 포함)
	 * @param delimeter
	 *            데이터파일의 key,value 구분자
	 * @param repositoryPath
	 *            리파지토리 파일이 생성될 경로
	 * @param repositoryFileName
	 *            리파지토리 생성 파일 명
	 */
	public LoaderKMTreeRepository(boolean iscreate, String readFilePath,
			String delimeter, String repositoryPath, String repositoryFileName) {
		// this.readFilePath = readFilePath;
		// this.repositoryPath = repositoryPath;
		// this.repositoryFileName = repositoryFileName;
		this.delimeter = delimeter;
		try {
			kmvManager = new KeyMultiValueManager(iscreate, repositoryPath
					+ File.separator + repositoryFileName, divSize,
					countPerSegment, cacheSize, nodeSize, keyLength,
					valueLength);
			if (iscreate)
				kmvManager.clear();
			scanner = new FileScanner(readFilePath);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * key - multi value 항목을 읽어들여 B+Tree 데이터를 구축한다.
	 * 
	 * @throws Exception
	 */
	public void load() throws Exception {
		if (scanner != null) {
			String line = "";
			String[] data;
			int cnt = 0;
			while (scanner.hasNextLine()) {
				line = scanner.nextLine();
				if("EID".indexOf(line)!=-1) continue;
				data = line.split(delimeter);
				if (data != null) {
					kmvManager.add(data[0], data[1]);
					additionLoad(data);
					if (cnt++ % 100000 == 0) {
						System.out.println(new Date()
								+ " : read and add count : " + (cnt - 1));

					}
				}
			}
		}
	}

	public void close() {
		try {
			kmvManager.close();
			scanner.close();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}
	
	public void flush() {
		try {
			kmvManager.flush();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 추가로 로드할 것이 있으면 아래 메소드를 구현한다.
	 * 
	 * @throws Exception
	 */
	abstract void additionLoad(String[] data) throws Exception;

	/**
	 * Key에 대한 다중 값 B+Tree를 구한다.
	 * 
	 * @return
	 */
	public KeyMultiValueManager getKmvManager() {
		return kmvManager;
	}

}
