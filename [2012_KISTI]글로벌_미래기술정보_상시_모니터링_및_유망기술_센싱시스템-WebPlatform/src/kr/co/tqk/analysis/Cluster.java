package kr.co.tqk.analysis;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;

import kr.co.tqk.analysis.cluster.ClusterResultTree;
import kr.co.tqk.analysis.cluster.Similarity;
import kr.co.tqk.analysis.cluster.SingleLinkage;
import kr.co.tqk.analysis.loader.DataLoader;
import kr.co.tqk.analysis.loader.TreeIterator;
import kr.co.tqk.analysis.util.NumberFormatUtil;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTree;
import com.tqk.ontobase.core.common.btree.BTreeVariableNodeFactory;
import com.tqk.ontobase.core.common.btree.RangeSearchBTree;
import com.tqk.ontobase.core.common.btree.RangeSearchBTreeIterator;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;

/**
 * Ŭ�����͸� Ŭ����
 * 
 * @author neon
 */
public class Cluster {

	static HashSet<String> xEidList = new HashSet<String>();

	public static void setData(String[] value) {
		xEidList.clear();
		if (value == null)
			return;
		if (value.length < 2)
			return;
		for (String v : value) {
			xEidList.add(v);
		}
	}

	public static int duplicationData(String[] value) {
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
	 * ���絵 �ƿ���
	 */
	static double similityCutoff = 0.025;
	/**
	 * ���絵 �Ҽ��� ��
	 */
	static int cutPoint = 5;
	/**
	 * ������ ����
	 */
	static int clusterCount = 7;
	/**
	 * �ּ� ���� ����
	 */
	static int minClusterCount = 10;

	/**
	 * ������ ���� ���� ����
	 */
	boolean iscreate = true;
	/**
	 * �о�帱 �м� ��� ������.
	 */
	String readFilePath = "c:/Users/neon/Documents/Project/KISTI/2011_02_������ũ���/data/authorKeyword_nano.txt";
	/**
	 * �о�帱 �м� �������� ������.
	 */
	String delimeter = "\t";
	/**
	 * �������͸� ��� �н�.
	 */
	String repositoryPath = "c:/Users/neon/Documents/Project/KISTI/2011_02_������ũ���/data/rep";
	/**
	 * �������͸� ���� ���� ��
	 */
	String repositoryFileName = "top10citref";
	/**
	 * �ε��� ���ϸ�
	 */
	String indexFileName = "top10citrefIdx.tree";
	/**
	 * ��� ���� ��.
	 */
	String clusterResultFileName = "c:/Users/neon/Documents/Project/KISTI/2011_02_������ũ���/data/author_keyword_cosine.txt";

	static int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	static int cacheSize = 1024 * 1024 * 64;
	static int nodeSize = 1024 * 4;
	int keyLength = 8;
	static int nodeLen = 4;

	static BTree clusterKeyword = null;
	static RangeSearchBTree rsb = null;

	public static void cluster(RangeSearchBTree rbtree, String lkey, String rkey) {

	}

	public static boolean isClusterKeyword(String keyword) throws CoreException {
		byte[] key = ByteArrayUtil.stringToByte(keyword);
		return clusterKeyword.exist(key, 0, key.length);
	}

	public static boolean isClusterKeyword(byte[] key) throws CoreException {
		return clusterKeyword.exist(key, 0, key.length);
	}

	public static boolean setClusterKeyword(byte[] key) throws CoreException {
		return clusterKeyword.checkInsert(key, 0, key.length, new byte[] { 0 },
				0, 1);
	}

	public static boolean setClusterKeyword(String _key) throws CoreException {
		byte[] key = ByteArrayUtil.stringToByte(_key);
		return clusterKeyword.checkInsert(key, 0, key.length, new byte[] { 0 },
				0, 1);
	}

	/**
	 * SingleLinkage �м��� �ش� Ű�� ���絵�� ���� ������ ��ġ�Ѵ�.
	 * 
	 * @param l
	 *            Ű1
	 * @param r
	 *            Ű2
	 * @return ���̰� 2�� ��Ʈ�� �迭 <BR>
	 *         new String[]{���絵�� ���� Ű, ���絵�� ū Ű}
	 * 
	 * @throws CoreException
	 */
	public static String[] orderKeyword(String l, String r)
			throws CoreException {
		byte[] min = ByteArrayUtil.stringToByte(l);
		if (isClusterKeyword(min)) {
			/* �̹� �м��� ���� �׸� ���ؼ��� �м����� �ʴ´�. */
			return null;
		}
		byte[] max = ByteArrayUtil.stringToByte(l + "!");
		RangeSearchBTreeIterator rsbIter = rsb.findRange(min, max);
		String[] leftMax = findMaxSimility(l, r, rsbIter);

		min = ByteArrayUtil.stringToByte(r);
		if (isClusterKeyword(min)) {
			/* �̹� �м��� ���� �׸� ���ؼ��� �м����� �ʴ´�. */
			return null;
		}
		max = ByteArrayUtil.stringToByte(r + "!");
		rsbIter = rsb.findRange(min, max);
		String[] rightMax = findMaxSimility(r, l, rsbIter);
		if (Double.parseDouble(leftMax[1]) > Double.parseDouble(rightMax[1])) {
			// keyword�� r->l�� ���δ�.
			return new String[] { r, l };
		} else {
			// keyword�� l->r�� ���δ�.
			return new String[] { l, r };
		}
	}

	/**
	 * �� Ű�� ���� ���絵 ����߿��� ���� ū ���絵�� ���� Ű�� ã�Ƽ� �����Ѵ�.
	 * 
	 * @param l
	 *            Ű�� 1
	 * @param r
	 *            Ű�� 2
	 * @param rsbIter
	 *            ��� �������͸�
	 * @return ���̰� 2�� ��Ʈ�� �迭<br>
	 *         String[]{Ű, ���絵}
	 * @throws CoreException
	 */
	public static String[] findMaxSimility(String l, String r,
			RangeSearchBTreeIterator rsbIter) throws CoreException {
		double compareSimility = 0;
		String nextMaxK = null;
		while (rsbIter.hasNext()) {
			byte[] abs = rsbIter.next();
			String k = ByteArrayUtil.readString(abs, 0, abs.length);

			String[] kvs = k.split("\t");
			String leftKvs = kvs[0];
			String rightKvs = kvs[1];
			if (l.equals(leftKvs) && r.equals(rightKvs))
				continue;

			if (isClusterKeyword(rightKvs))
				continue;
			if (isClusterKeyword(leftKvs))
				continue;

			byte[] va = rsb.find(abs, 0, abs.length);
			double afterSimility = 1 - Double.parseDouble(ByteArrayUtil
					.readString(va, 0, va.length));

			if (afterSimility > compareSimility) {
				compareSimility = afterSimility;
				nextMaxK = rightKvs;
			}
		}
		return new String[] {
				nextMaxK,
				String.valueOf(NumberFormatUtil.convertNumberPointFormat(
						compareSimility, cutPoint)) };
	}

	/**
	 * �ش� Ű�� ���� �ִ� ���絵 �ܾ ���Ѵ�.<br>
	 * 
	 * @param key
	 *            Ű��
	 * @return ���̰� 2�� ��Ʈ�� �迭<br>
	 *         String[]{Ű, ���絵}
	 * @throws CoreException
	 */
	public static String[] findMaxSimility(String key) throws CoreException {
		double compareSimility = 0;
		String nextMaxK = null;
		byte[] min = ByteArrayUtil.stringToByte(key);
		byte[] max = ByteArrayUtil.stringToByte(key + "!");
		RangeSearchBTreeIterator rsbIter = rsb.findRange(min, max);
		while (rsbIter.hasNext()) {
			byte[] abs = rsbIter.next();
			String k = ByteArrayUtil.readString(abs, 0, abs.length);

			String[] kvs = k.split("\t");
			String rightKvs = kvs[1];
			if (key.equals(rightKvs))
				continue;

			if (isClusterKeyword(rightKvs))
				continue;

			byte[] va = rsb.find(abs, 0, abs.length);
			double afterSimility = 1 - Double.parseDouble(ByteArrayUtil
					.readString(va, 0, va.length));

			if (afterSimility > compareSimility) {
				compareSimility = afterSimility;
				nextMaxK = rightKvs;
			}
		}
		return new String[] {
				nextMaxK,
				String.valueOf(NumberFormatUtil.convertNumberPointFormat(
						compareSimility, cutPoint)) };
	}

	public Cluster() {
		DataLoader lak = new DataLoader(iscreate, readFilePath, delimeter,
				repositoryPath, repositoryFileName, indexFileName);
		SingleLinkage sl = new SingleLinkage(true, repositoryPath,
				repositoryFileName);
		ClusterResultTree crt = new ClusterResultTree(true, repositoryPath,
				repositoryFileName);
		FileWriter clusterResultWriter = null;

		try {
			rsb = new RangeSearchBTree(true, repositoryPath + File.separator
					+ repositoryFileName + "_rb.tree", divSize, cacheSize,
					new BTreeVariableNodeFactory(nodeSize));
			clusterKeyword = new BTree(true, repositoryPath + File.separator
					+ repositoryFileName + "_cluster.tree", divSize, cacheSize,
					new BTreeVariableNodeFactory(nodeSize));
			/* �м� ��� ������ �ε�. */
			if (iscreate) {
				lak.load();
				lak.getKmvManager().flush();
			}

			clusterResultWriter = new FileWriter(clusterResultFileName);
			/* ���絵 ��� ���� */
			Iterator<String> xIter = lak.getIterator();
			LinkedHashMap<String, String[]> tmpMap = new LinkedHashMap<String, String[]>();
			while (xIter.hasNext()) {
				String x = (String) xIter.next();
				tmpMap.put(x, lak.getKmvManager().getVaule(x));
			}
			HashMap<String, Integer> resultMap = new HashMap<String, Integer>();
			System.out.println(new Date() + " �м� ���� " + tmpMap.size());
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
						if (result < similityCutoff)
							continue;

						double t = NumberFormatUtil.convertNumberPointFormat(
								1 - result, cutPoint);

						clusterResultWriter.write(x + "\t" + y + "\t" + t
								+ "\n");
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
						sl.add(String.valueOf(t), x.trim() + "\t" + y.trim());
						// System.out.println(t +"\t" + x +":" + y);
						// resultMap.put(x +"|"+y, w);
					}
				}
				if (resultMap.size() == 2)
					break;
				if (cnt++ % 10 == 0) {
					System.out.println(new Date() + " �м� �Ǽ� : " + (cnt - 1));
					clusterResultWriter.flush();
				}
			}
			/* ���絵 ��� �� */

			rsb.flush();
			sl.flush();
			/* Ŭ�����͸� �м� */
			TreeIterator<String> slIter = sl.getIterator();
			int crtIterCount = 0;
			int clusterKey = 0;
			while (slIter.hasNext()) {
				String s = slIter.next();
				double currentSimility = NumberFormatUtil
						.convertNumberPointFormat((1 - Double.parseDouble(s)),
								5);
				// fw.write("=> "
				// + NumberFormatUtil.convertNumberPointFormat(
				// (1 - Double.parseDouble(s)), 5) + "\t");
				for (String value : sl.getSingleLinkageTreeManager()
						.getVaule(s)) {
					String[] vs = value.split("\t");
					String leftKey = vs[0];
					String rightKey = vs[1];

					byte[] leftKeyByte = ByteArrayUtil.stringToByte(leftKey);
					byte[] rightKeyByte = ByteArrayUtil.stringToByte(rightKey);

					/*
					 * ������� �������ΰ�? �̹� ������� �����Ϳ� �����Ѵٸ� �������� �ʴ´�.
					 */
					if (isClusterKeyword(leftKeyByte)
							|| isClusterKeyword(rightKeyByte))
						continue;
					/*
					 * �ܾ��� ������ ���Ѵ�. left-right ���� right-left���� ���Ѵ�. ���ϴ� ����� ������
					 * �׿� ��ġ�� Ű������ right->���絵 left->���絵�� �� �������� �������� ��´�.
					 */

					String[] orderKeyword = orderKeyword(leftKey, rightKey);
					setClusterKeyword(orderKeyword[0]);
					setClusterKeyword(orderKeyword[1]);
					crt.add(String.valueOf(clusterKey), orderKeyword[0].trim());
					crt.add(String.valueOf(clusterKey), orderKeyword[1].trim());
					/*
					 * �ܾ��� ������ �������� ������ �ܾ� �������� ���絵�� ���� �������� ã�´�. (�ݺ�)
					 */
					while (orderKeyword[1] != null) {
						String[] keywordSimility = findMaxSimility(orderKeyword[1]);
						if (keywordSimility == null) {
						} else {
							if (keywordSimility[0] != null) {
								int clusterCurSize = crt
										.getKeyMultiValueManager().getVaule(
												String.valueOf(clusterKey)).length;
								if (clusterCurSize >= clusterCount) {
									/*
									 * ���������� ����� �Է¿� ���� ��������, �� ������ ������ �ʰ��ϰ� �Ǹ�
									 * ���ο� �������� �����ȴ�.
									 */
									clusterKey++;
								}
								crt.add(String.valueOf(clusterKey),
										keywordSimility[0].trim());
								setClusterKeyword(keywordSimility[0]);
							}
							orderKeyword[1] = keywordSimility[0];
						}
					}

					if (orderKeyword[1] == null) {
						// �����ʴܾ��� ���絵�� ã���� �����Ƿ� �� ������ ����ȴ�.
						// ���� Ŭ������ ���̵� ����.
						clusterKey++;
					}

					clusterResultWriter.flush();
				}
			}
			crt.getKeyMultiValueManager().flush();
			// fw.write("======================= \n\n\n");
			TreeIterator<String> crtIter = crt.getIterator();
			while (crtIter.hasNext()) {
				String key = crtIter.next();
				String[] values = crt.getKeyMultiValueManager().getVaule(key);
				if (values.length < minClusterCount) {
					// �ּ� �������� �̴��ϸ� �ش� ������ ������.
					continue;
				}
				clusterResultWriter.write(key + "\n");
				for (String v : values) {
					clusterResultWriter.write("\t" + v + "\n");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			lak.closeResource();
			sl.closeResource();
			try {
				rsb.close();
				clusterKeyword.close();
			} catch (CoreException e1) {
				e1.printStackTrace();
			}
			if (clusterResultWriter != null) {
				try {
					clusterResultWriter.flush();
					clusterResultWriter.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}
}
