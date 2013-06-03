package kr.co.tqk.analysis.loader;

import java.io.File;
import java.util.Date;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.mvaule.KeyMultiValueManager;

/**
 * ���� ��� �����ʹ� line���� ���еǾ� ������ �� ������ Ư�� �����ڿ� ���� key�� value�� �������� �ִ�.<br>
 * 
 * ���� ��� �����͸� key-multiVaule �ڷᱸ���� �����ϴ� Ŭ���� <br>
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
	 * ������
	 * 
	 * @param readFilePath
	 *            ������ ������ ������ (���ϸ� ����)
	 * @param delimeter
	 *            ������������ key,value ������
	 * @param repositoryPath
	 *            �������丮 ������ ������ ���
	 * @param repositoryFileName
	 *            �������丮 ���� ���� ��
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
	 * key - multi value �׸��� �о�鿩 B+Tree �����͸� �����Ѵ�.
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
	 * �߰��� �ε��� ���� ������ �Ʒ� �޼ҵ带 �����Ѵ�.
	 * 
	 * @throws Exception
	 */
	abstract void additionLoad(String[] data) throws Exception;

	/**
	 * Key�� ���� ���� �� B+Tree�� ���Ѵ�.
	 * 
	 * @return
	 */
	public KeyMultiValueManager getKmvManager() {
		return kmvManager;
	}

}
