package kr.co.tqk.analysis.cluster;

import java.io.File;

import kr.co.tqk.analysis.loader.TreeIterator;
import kr.co.tqk.analysis.loader.WrapTree;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.mvaule.KeyMultiValueManager;

/**
 * 싱글 링키지 분석용 데이터.
 * 
 * @author neon
 * 
 */
public class SingleLinkage implements WrapTree {

	private String repositoryPath;
	private String repositoryFileName;

	private KeyMultiValueManager singleLinkageTreeManager;
	
	
	int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	int cacheSize = 1024 * 1024 * 64;
	int nodeSize = 1024 * 4;
	int keyLength = 8;
	int valueLength = 4;

	/**
	 * 생성자
	 * 
	 * @param repositoryPath
	 *            리파지토리 파일이 생성될 경로
	 * @param repositoryFileName
	 *            리파지토리 생성 파일 명
	 */
	public SingleLinkage(boolean iscreate, String repositoryPath,
			String repositoryFileName) {
		this.repositoryPath = repositoryPath;
		this.repositoryFileName = repositoryFileName;
		try {
			singleLinkageTreeManager = new KeyMultiValueManager(iscreate,
					repositoryPath + File.separator + repositoryFileName
							+ "_SingleLinkage", divSize, countPerSegment,
					cacheSize, nodeSize, keyLength, valueLength);
			if (iscreate)
				singleLinkageTreeManager.clear();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void add(String _key, String values) throws Exception {
		singleLinkageTreeManager.add(_key, values);
	}

	public KeyMultiValueManager getSingleLinkageTreeManager() {
		return singleLinkageTreeManager;
	}

	public void closeResource() {
		if (singleLinkageTreeManager != null)
			try {
				singleLinkageTreeManager.flush();
				singleLinkageTreeManager.close();
			} catch (CoreException e) {
				e.printStackTrace();
			}
	}
	
	public void flush() {
		if (singleLinkageTreeManager != null)
			try {
				
				singleLinkageTreeManager.flush();
			} catch (CoreException e) {
				e.printStackTrace();
			}
	}

	public TreeIterator<String> getIterator(){
		if(singleLinkageTreeManager==null) return null;
		return new TreeIterator<String>(singleLinkageTreeManager.getKeyTr());
	}

}
