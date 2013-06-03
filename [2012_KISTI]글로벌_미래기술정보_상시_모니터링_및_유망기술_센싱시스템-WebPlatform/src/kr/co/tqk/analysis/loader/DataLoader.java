package kr.co.tqk.analysis.loader;

import java.io.File;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTreeVariableKeyNodeFactory;
import com.tqk.ontobase.core.common.btree.RangeSearchBTree;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;

/**
 * 동시 출현 횟수를 구하기 위한 B+Tree 구축<br>
 * 
 * @author neon
 * 
 */
public class DataLoader extends LoaderKMTreeRepository implements WrapTree {

	private RangeSearchBTree KeyRangeSearchTree;

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
	 * @param indexFileName
	 *            인덱스 생성 파일 명
	 */
	public DataLoader(boolean iscreate, String readFilePath, String delimeter,
			String repositoryPath, String repositoryFileName,
			String indexFileName) {
		super(iscreate, readFilePath, delimeter, repositoryPath,
				repositoryFileName);

		// 저자 키워드에 대한 B+Tree가 필요하다.
		try {
			String path = repositoryPath + File.separator + indexFileName;
			KeyRangeSearchTree = new RangeSearchBTree(iscreate, path, divSize,
					cacheSize, new BTreeVariableKeyNodeFactory(nodeSize, 1));
			if (iscreate)
				KeyRangeSearchTree.clear();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 해당 키가 존재하는지 탐색한다.
	 * 
	 * @param _key
	 * @return 키가 이미 존재하면 true를 리턴한다.
	 * @throws CoreException
	 */
	public boolean exist(String _key) throws CoreException {
		byte[] key = ByteArrayUtil.stringToByte(_key);
		return KeyRangeSearchTree.exist(key, 0, key.length);
	}

	public void closeResource() {
		try {
			KeyRangeSearchTree.close();
			close();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	public void flush() {
		try {
			KeyRangeSearchTree.flush();
			super.flush();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * @return 중복 제거된 Key Tree
	 */
	public RangeSearchBTree getKeyTree() {
		return KeyRangeSearchTree;
	}

	public TreeIterator<String> getIterator() {
		return new TreeIterator<String>(getKeyTree());
	}

	public TreeIterator<String> getIterator(String _nextKey) {
		return new TreeIterator<String>(getKeyTree(), _nextKey);
	}

	@Override
	void additionLoad(String[] _data) throws Exception {
		if (KeyRangeSearchTree != null) {
			byte[] data = ByteArrayUtil.stringToByte(_data[0].trim());
			byte[] value = new byte[] { 0 };
			KeyRangeSearchTree.checkInsert(data, 0, data.length, value, 0, 1);
		}
	}

}
