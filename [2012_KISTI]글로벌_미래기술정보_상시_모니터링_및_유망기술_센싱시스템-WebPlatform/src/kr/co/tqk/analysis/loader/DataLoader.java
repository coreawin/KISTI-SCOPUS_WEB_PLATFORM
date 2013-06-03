package kr.co.tqk.analysis.loader;

import java.io.File;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTreeVariableKeyNodeFactory;
import com.tqk.ontobase.core.common.btree.RangeSearchBTree;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;

/**
 * ���� ���� Ƚ���� ���ϱ� ���� B+Tree ����<br>
 * 
 * @author neon
 * 
 */
public class DataLoader extends LoaderKMTreeRepository implements WrapTree {

	private RangeSearchBTree KeyRangeSearchTree;

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
	 * @param indexFileName
	 *            �ε��� ���� ���� ��
	 */
	public DataLoader(boolean iscreate, String readFilePath, String delimeter,
			String repositoryPath, String repositoryFileName,
			String indexFileName) {
		super(iscreate, readFilePath, delimeter, repositoryPath,
				repositoryFileName);

		// ���� Ű���忡 ���� B+Tree�� �ʿ��ϴ�.
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
	 * �ش� Ű�� �����ϴ��� Ž���Ѵ�.
	 * 
	 * @param _key
	 * @return Ű�� �̹� �����ϸ� true�� �����Ѵ�.
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
	 * @return �ߺ� ���ŵ� Key Tree
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
