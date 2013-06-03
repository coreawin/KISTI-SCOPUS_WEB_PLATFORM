package kr.co.tqk.analysis.cluster;

import java.io.File;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;

import kr.co.tqk.analysis.loader.DataLoader;
import kr.co.tqk.analysis.util.NumberFormatUtil;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTreeVariableNodeFactory;
import com.tqk.ontobase.core.common.btree.RangeSearchBTree;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;

/**
 * ���絵�� ���Ѵ�.
 * 
 * @author neon
 * 
 */
public class Similarity {

	static int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	static int cacheSize = 1024 * 1024 * 64;
	static int nodeSize = 1024 * 4;
	int keyLength = 8;
	static int nodeLen = 4;

	/**
	 * �ڻ��� ���
	 */
	public static final int COSINE = 0;
	/**
	 * ��ī�� ���
	 */
	public static final int JAKAD = 0;

	/**
	 * �ڻ��� ����� ���� ���絵�� ���Ѵ�.
	 * 
	 * @param xTotal
	 *            x �׸� ���� �� ����
	 * @param yTotal
	 *            y �׸� ���� �Ѱ���
	 * @param dup
	 *            x�� y �׸񿡼� ���� ��ø�Ǵ� ����.
	 * @return
	 */
	public static double cosineCoefficient(int xTotal, int yTotal, int dup) {
		return dup / Math.sqrt(xTotal * yTotal);
	}

	/**
	 * ��ī�� ����� ���� ���絵�� ���Ѵ�.
	 * 
	 * @param xTotal
	 *            x �׸� ���� �� ����
	 * @param yTotal
	 *            y �׸� ���� �Ѱ���
	 * @param dup
	 *            x�� y �׸񿡼� ���� ��ø�Ǵ� ����.
	 * @return
	 */
	public static double jakadCoefficient(int xTotal, int yTotal, int dup) {
		return 0;
	}

	/**
	 * ���絵�� ����Ѵ�.
	 * 
	 * @param type
	 *            ���絵 ��� ����
	 * @param xTotal
	 *            x �׸� ���� �� ����
	 * @param yTotal
	 *            y �׸� ���� �Ѱ���
	 * @param dup
	 *            x�� y �׸񿡼� ���� ��ø�Ǵ� ����.
	 * @return
	 */
	public static double coefficient(int type, int xTotal, int yTotal, int dup) {
		if (type == COSINE) {
			return cosineCoefficient(xTotal, yTotal, dup);
		} else {
			return jakadCoefficient(xTotal, yTotal, dup);
		}
	}

	public static void main(String[] args) {
		System.out.println(cosineCoefficient(10, 100, 8));
	}

	HashSet<String> xEidList = new HashSet<String>();

	/**
	 * �ӽú����� ������ HashSet ���·� �����Ѵ�.
	 * 
	 * @param value
	 */
	void setData(String[] value) {
		xEidList.clear();
		if (value == null)
			return;
		if (value.length < 2)
			return;
		for (String v : value) {
			xEidList.add(v);
		}
	}

	/**
	 * �ӽú����� ���� �����͸� �������� �ߺ��� �����Ͱ� � �ִ��� Ȯ���Ѵ�
	 * 
	 * @param value
	 *            �˻� ��� ������.
	 * @return
	 */
	int duplicationData(String[] value) {
		int cnt = 0;
		if (value == null)
			return 0;
		if (value.length < 2)
			return 0;
		if (xEidList.size() < 2)
			return 0;
		for (String v : value) {
			if (xEidList.contains(v)) {
				cnt++;
			}
		}
		return cnt;
	}

	/**
	 * ���絵�� ����Ѵ�.
	 * 
	 * @param iscreate
	 *            ���� ���� ���� ����
	 * @param readFilePath
	 *            ��� ������
	 * @param delimeter
	 *            ��� ������ ������
	 * @param repositoryPath
	 *            �������丮 ���
	 * @param repositoryName
	 *            �������丮 ���� ��
	 * @param indexFileName
	 * 
	 */
	public LinkedHashMap<String, String>  processSilarity(boolean iscreate, String readFilePath,
			String delimeter, String repositoryPath, String repositoryName,
			double similityCutOff, int cutPoint) {

		DataLoader dataLoaderRepository = new DataLoader(iscreate,
				readFilePath, delimeter, repositoryPath, repositoryName,
				repositoryName);

		SingleLinkage singleLinkageRepository = new SingleLinkage(iscreate,
				repositoryPath, repositoryName);
		
		LinkedHashMap<String, String> infoSimilarity = new LinkedHashMap<String, String>(); 

		RangeSearchBTree rsb = null;
		try {
			rsb = new RangeSearchBTree(true, repositoryPath + File.separator
					+ repositoryName + "_rb.tree", divSize, cacheSize,
					new BTreeVariableNodeFactory(nodeSize));
			/* �м� ��� ������ �ε�. */
			if (iscreate) {
				dataLoaderRepository.load();
				dataLoaderRepository.getKmvManager().flush();
			}

			/* ���絵 ��� ���� */
			Iterator<String> xIter = dataLoaderRepository.getIterator();
			LinkedHashMap<String, String[]> tmpMap = new LinkedHashMap<String, String[]>();
			while (xIter.hasNext()) {
				String x = (String) xIter.next();
				tmpMap.put(x, dataLoaderRepository.getKmvManager().getVaule(x));
			}
			HashMap<String, Integer> resultMap = new HashMap<String, Integer>();
			System.out.println(" ���絵 �м� ���� " + tmpMap.size());
			int cnt = 0;
			String[] yValues = null;
			for (String x : tmpMap.keySet()) {
				// String x = (String) xIter.next();
				// Iterator<String> yIter = lak.getIterator(x);
				setData(tmpMap.get(x));
				int skipCount = 0;
				for (String y : tmpMap.keySet()) {
					if (skipCount <= cnt) {
						skipCount++;
						continue;
					}
					skipCount++;

					// if(x.equals(y)) continue;
					// String y = yIter.next();
					/* x, y Ű���尡 ���ÿ� �� ������ ������ w */
					yValues = tmpMap.get(y);
					int w = duplicationData(yValues);
					if (w != 0) {
						/* x, y Ű���尡 ���ÿ� �� ������ ������ �ϳ� �̻��̶��. */
						// System.out.println(new Date() + "\t" + x +" | "+y
						// +"\t �δܾ �� ������ ���� " + w);
						double result = Similarity.coefficient(
								Similarity.COSINE, xEidList.size(),
								yValues.length, w);
						if (result < similityCutOff)
							continue;

						double t = NumberFormatUtil.convertNumberPointFormat(
								1 - result, cutPoint);

						// fw.write(x + "\t" + y + "\t" + t + "\n");
						byte[] fKey = ByteArrayUtil.stringToByte(x.trim()
								+ "\t" + y.trim());
						byte[] sKey = ByteArrayUtil.stringToByte(y.trim()
								+ "\t" + x.trim());
						byte[] value = ByteArrayUtil.stringToByte(String
								.valueOf(t));

						rsb.checkInsert(fKey, 0, fKey.length, value, 0,
								value.length);
						rsb.checkInsert(sKey, 0, sKey.length, value, 0,
								value.length);
						singleLinkageRepository.add(String.valueOf(t), x.trim()
								+ "\t" + y.trim());
						
						infoSimilarity.put(x.trim()+ "_" + y.trim(), xEidList.size() +":"+ yValues.length +":"+w+":" + result);
					}
				}
				if (resultMap.size() == 2)
					break;
				if (cnt++ % 1000 == 0) {
					System.out.println(" ���絵 �м� ���� �Ǽ� : " + (cnt - 1) + " / "
							+ tmpMap.size());
				}
			}
			System.out.println(" ���絵 �м� �Ϸ� " + cnt);
			/* ���絵 ��� �� */
			rsb.flush();
			singleLinkageRepository.flush();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dataLoaderRepository.closeResource();
			singleLinkageRepository.closeResource();
			try {
				rsb.close();
			} catch (CoreException e1) {
				e1.printStackTrace();
			}
		}
		return infoSimilarity;
	}

}
