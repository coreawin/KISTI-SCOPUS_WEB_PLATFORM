package kr.co.tqk.analysis.cluster;

import java.io.File;

import kr.co.tqk.analysis.loader.TreeIterator;
import kr.co.tqk.analysis.loader.WrapTree;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.mvaule.KeyMultiValueManager;

/**
 * Ŭ������ ����� ���� B+Tree �̴�.
 * 
 * @author neon
 * 
 */
public class ClusterResultTree implements WrapTree {

	private String repositoryPath;
	private String repositoryFileName;

	private KeyMultiValueManager clusterTreeManager;

	int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	int cacheSize = 1024 * 1024 * 64;
	int nodeSize = 1024 * 4;
	int keyLength = 8;
	int valueLength = 4;

	/**
	 * ������
	 * 
	 * @param repositoryPath
	 *            �������丮 ������ ������ ���
	 * @param repositoryFileName
	 *            �������丮 ���� ���� ��
	 */
	public ClusterResultTree(boolean iscreate, String repositoryPath,
			String repositoryFileName) {
		this.repositoryPath = repositoryPath;
		this.repositoryFileName = repositoryFileName;
		try {
			clusterTreeManager = new KeyMultiValueManager(iscreate,
					repositoryPath + File.separator + repositoryFileName
							+ "_Cluster", divSize, countPerSegment, cacheSize,
					nodeSize, keyLength, valueLength);
			if (iscreate)
				clusterTreeManager.clear();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void add(String _key, String values) throws Exception {
		clusterTreeManager.add(_key, values);
	}

	public KeyMultiValueManager getKeyMultiValueManager() {
		return clusterTreeManager;
	}

	public void closeResource() {
		if (clusterTreeManager != null)
			try {
				clusterTreeManager.flush();
				clusterTreeManager.close();
			} catch (CoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

	public TreeIterator<String> getIterator() {
		if (clusterTreeManager == null)
			return null;
		return new TreeIterator<String>(clusterTreeManager.getKeyTr());
	}
}
