package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.analysis.cluster.ClusterResultTree;
import kr.co.tqk.analysis.cluster.SingleLinkage;
import kr.co.tqk.analysis.excel.bulkCluster.ExcelReader;
import kr.co.tqk.analysis.excel.bulkCluster.ExcelVO;
import kr.co.tqk.analysis.loader.TreeIterator;
import kr.co.tqk.analysis.util.NumberFormatUtil;

import org.apache.commons.collections.map.MultiValueMap;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTree;
import com.tqk.ontobase.core.common.btree.BTreeVariableNodeFactory;
import com.tqk.ontobase.core.common.btree.RangeSearchBTree;
import com.tqk.ontobase.core.common.btree.RangeSearchBTreeIterator;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;

/**
 * @author neon
 * 
 */
public class BulkClusterForExcel {
	
	static HashSet<String> xEidList = new HashSet<String>();

	public static final String DELIMITER = "\t";
	
	static HashMap<String, ExcelVO> readExcelData = new HashMap<String, ExcelVO>();

	/**
	 * @param excelFile
	 *            Ŭ�����͸� �м��� ���� ������ ��� ����
	 * @param delimeter
	 *            �����Ͱ� ���еǾ� �ִ� ��������
	 * @param repositoryPath
	 *            RepositoryPath
	 * @param indexFileName
	 * @param fileWriterPath
	 * @param similityCutOff
	 * @param cutPoint
	 * @param clusterCount
	 * @param minClusterCount
	 */
	public BulkClusterForExcel(String excelFile,
			String repositoryPath, String fileWriterPath) {
		
		File dir = new File(repositoryPath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		
		try {
			ExcelReader er = new ExcelReader(excelFile);
			er.setOption(option);
			readExcelData = er.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		cluster(true, excelFile, repositoryPath, fileWriterPath);
		deleteRepository(repositoryPath);
		dir.delete();
	}

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
	static float similityCutoff = 0.1f;
	/**
	 * ���絵 �Ҽ��� ��
	 */
	static int cutPoint = 5;
	/**
	 * ������ ����
	 */
	static int clusterCount = 50;
	/**
	 * �ּ� ���� ����
	 */
	static int minClusterCount = 5;
	/**
	 * �ּ� ���� ����
	 */
	static char option = 'r';

	static final int divSize = 1024 * 1024 * 1024;
	static final int countPerSegment = 64;
	static final int cacheSize = 1024 * 1024 * 64;
	static final int nodeSize = 1024 * 4;
	static final int keyLength = 8;
	static final int nodeLen = 4;
	static final int valueLength = 4;

	static BTree clusterKeyword = null;
	static RangeSearchBTree rsb = null;

	public boolean isClusterKeyword(String keyword) throws CoreException {
		byte[] key = ByteArrayUtil.stringToByte(keyword);
		return clusterKeyword.exist(key, 0, key.length);
	}

	public boolean isClusterKeyword(byte[] key) throws CoreException {
		return clusterKeyword.exist(key, 0, key.length);
	}

	public boolean setClusterKeyword(byte[] key) throws CoreException {
		return clusterKeyword.checkInsert(key, 0, key.length, new byte[] { 0 },
				0, 1);
	}

	public boolean setClusterKeyword(String _key) throws CoreException {
		byte[] key = ByteArrayUtil.stringToByte(_key);
		return clusterKeyword.checkInsert(key, 0, key.length, new byte[] { 0 },
				0, 1);
	}

	public String[] orderKeyword(String l, String r)
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

	public String[] findMaxSimility(String l, String r,
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

	public String[] findMaxSimility(String keyword) throws CoreException {
		double compareSimility = 0;
		String nextMaxK = null;
		byte[] min = ByteArrayUtil.stringToByte(keyword);
		byte[] max = ByteArrayUtil.stringToByte(keyword + "!");
		RangeSearchBTreeIterator rsbIter = rsb.findRange(min, max);
		while (rsbIter.hasNext()) {
			byte[] abs = rsbIter.next();
			String k = ByteArrayUtil.readString(abs, 0, abs.length);

			String[] kvs = k.split("\t");
			String rightKvs = kvs[1];
			if (keyword.equals(rightKvs))
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

	public void deleteRepository(String repositoryPath) {
		File repositoryPathFile = new File(repositoryPath);
		if (repositoryPathFile.isDirectory()) {
			for (File file : repositoryPathFile.listFiles()) {
				file.delete();
			}
		}
	}

	public static void main(String[] args) {
		String excelFilePath = null;
		String fileWriterPath = null;
		
		String home = "../";
		
		args = new String[]{
			"home",
			"./script/bulkClusterForExcel/����_1�ۼ�Ʈ_���絵(0.01)_�����ͺ���_0909.xlsx",
			"./script/bulkClusterForExcel/result/result.txt",
			"0.01",
			"5",
			"50",
			"5",
			"c"
		};

		if (args.length != 0) {
			home = args[0];
			excelFilePath = args[1];
			fileWriterPath = args[2];
			similityCutoff = Float.parseFloat(args[3]);
			cutPoint = Integer.parseInt(args[4]);
			clusterCount = Integer.parseInt(args[5]);
			minClusterCount = Integer.parseInt(args[6]);
			option = args[7].charAt(0);
			System.out.println("Simility cut off value : " + similityCutoff);
			System.out.println("Simility decimal rounding : " + cutPoint);
			System.out.println("Max number of articles per cluster : " + clusterCount);
			System.out.println("Min number Cof articles per cluster : " + minClusterCount);
			String repositoryPath = home + "temp/";
			new BulkClusterForExcel(excelFilePath, repositoryPath, fileWriterPath);
		}else{
			System.out.println("�Ķ���͸� �Է��� �ּ���.");
		}
	}

	/**
	 * Ŭ������ �м��� �����Ѵ�.<br>
	 * 
	 * @param iscreate
	 * @param excelFile
	 * @param delimeter
	 * @param repositoryPath
	 * @param repositoryFileName
	 * @param indexFileName
	 * @param fileWriterName
	 */
	private void cluster(boolean iscreate, String excelFile, String repositoryPath, String fileWriterName) {
		String repositoryFileName = "rep"+String.valueOf(System.currentTimeMillis());
		String indexFileName = "index"+String.valueOf(System.currentTimeMillis());
		
		SingleLinkage sl = new SingleLinkage(true, repositoryPath,
				repositoryFileName);

		ClusterResultTree crt = new ClusterResultTree(true, repositoryPath,
				repositoryFileName);

		FileWriter fw = null;

		try {
			rsb = new RangeSearchBTree(true, repositoryPath + File.separator
					+ repositoryFileName + "_rb.tree", divSize, cacheSize,
					new BTreeVariableNodeFactory(nodeSize));
			clusterKeyword = new BTree(true, repositoryPath + File.separator
					+ repositoryFileName + "_cluster.tree", divSize, cacheSize,
					new BTreeVariableNodeFactory(nodeSize));

			fw = new FileWriter(fileWriterName);
			System.out.println("write file name " + fileWriterName);
			//���絵�� �̹� ���Ǿ� ���Ͽ� �ԷµǾ� �ִ�.
			/* ���絵 ��� ���� */
			System.out.println(" ���絵 �м� ���� " + readExcelData.size());
			
			int cnt = 0;
			for(ExcelVO vo : readExcelData.values()){
				String x = vo.xKey;
				String y = vo.yKey;
				double result = 0;
				try{
					result = Double.parseDouble(vo.simility);
				}catch(NumberFormatException nfe){
					System.out.println("vo.simility " + vo.simility);
					continue;
				}
				
				if (result < similityCutoff)
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
				sl.add(String.valueOf(t), x.trim() + "\t" + y.trim());
				
				if (cnt++ % 1000 == 0) {
					System.out.println(" ���絵 �м� ���� �Ǽ� : " + (cnt - 1) + " / "
							+ readExcelData.size());
					// fw.flush();
				}
			}
			
			System.out.println(" ���絵 �м� �Ϸ� " + cnt);
			/* ���絵 ��� �� */

			System.out.println(" Ŭ�����͸� �м� ���� ");
			rsb.flush();
			sl.flush();
			/* Ŭ�����͸� �м� */
			TreeIterator<String> slIter = sl.getIterator();
			int crtIterCount = 0;
			int clusterKey = 0;
			while (slIter.hasNext()) {
				String s = slIter.next();
				if (crtIterCount++ % 1000 == 0) {
					System.out.println(" Ŭ�����͸� �м� ���� �Ǽ� : " + (crtIterCount));
					// fw.flush();
				}
				double currentSimility = NumberFormatUtil
						.convertNumberPointFormat((1 - Double.parseDouble(s)),
								5);
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

					fw.flush();
				}
			}
			System.out.println(" Ŭ������ �м� ����� ���Ͽ� ����մϴ�.");
			crt.getKeyMultiValueManager().flush();
			// fw.write("======================= \n\n\n");
			TreeIterator<String> crtIter = crt.getIterator();
			int generateClusterCount = 0;
			int documentTotalCount = 0;

			MultiValueMap mvm = new MultiValueMap();
			while (crtIter.hasNext()) {
				String key = crtIter.next();
				String[] values = crt.getKeyMultiValueManager().getVaule(key);
				// for(String v : values){
				// System.out.println(key +"\t" + v);
				// }
				if (values.length < minClusterCount) {
					// �ּ� �������� �̴��ϸ� �ش� ������ ������.
					continue;
				}
				mvm.put(values.length, key);
			}
			SortedMap<Integer, List> sortedMap = new TreeMap<Integer, List>(
					Collections.reverseOrder());
			for (Object key : mvm.keySet()) {
				sortedMap.put(Integer.parseInt(String.valueOf(key)),
						(List) mvm.get(key));
			}
			// System.out.println(sortedMap);
			for (Integer valuesCnt : sortedMap.keySet()) {
				List<String> clusterMapKey = (List<String>) sortedMap
						.get(valuesCnt);
				for (String key : clusterMapKey) {
					String[] values = crt.getKeyMultiValueManager().getVaule(
							key);
					if (values.length < minClusterCount) {
						// �ּ� �������� �̴��ϸ� �ش� ������ ������.
						continue;
					}
					fw.write(repositoryFileName + "_" + key + ":");
					for (String v : values) {
						fw.write(v + ",");
					}
					documentTotalCount += values.length;
					generateClusterCount++;
					fw.write("\n");
				}
			}

			fw.write("\n");

			for (Integer valuesCnt : sortedMap.keySet()) {
				if (mvm.get(valuesCnt) == null)
					continue;
				List list = (List) mvm.get(valuesCnt);
				fw.write("[Cluster���� ��� Info] " + valuesCnt + " : "
						+ list.size() + "\n");

			}
			fw.write("[Info] Read File Name : " + excelFile + "\n");
			fw.write("[Info] �м� ��� �� ���� ���� : " + readExcelData.size() + "\n");
			fw.write("[Info] Cluster Count : " + generateClusterCount + "\n");
			fw.write("[Info] �ٽ� ���� ����. : " + documentTotalCount + "\n");
			fw.write("[Info] Threshold. : " + similityCutoff + "\n");
			fw.write("[Info] Max ���� ����. : " + clusterCount + "\n");
			fw.write("[Info] Min ���� ����. : " + minClusterCount + "\n");
			System.out.println(" Ŭ������ �м� �Ϸ�!!! ");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sl.closeResource();
			try {
				rsb.close();
				clusterKeyword.close();
			} catch (CoreException e1) {
				e1.printStackTrace();
			}
			if (fw != null) {
				try {
					fw.flush();
					fw.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
