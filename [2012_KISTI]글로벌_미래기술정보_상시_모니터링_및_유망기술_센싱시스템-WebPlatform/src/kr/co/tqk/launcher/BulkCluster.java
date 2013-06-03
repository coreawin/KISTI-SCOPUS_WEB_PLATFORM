package kr.co.tqk.launcher;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import kr.co.tqk.analysis.cluster.ClusterResultTree;
import kr.co.tqk.analysis.cluster.Similarity;
import kr.co.tqk.analysis.cluster.SingleLinkage;
import kr.co.tqk.analysis.loader.DataLoader;
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
public class BulkCluster {

	static HashSet<String> xEidList = new HashSet<String>();

	public static final String DELIMITER = "\t";

	/**
	 * @param readFilePath
	 *            클러스터링 분석을 위한 데이터 경로 파일
	 * @param delimeter
	 *            데이터가 구분되어 있는 딜리미터
	 * @param repositoryPath
	 *            RepositoryPath
	 * @param indexFileName
	 * @param fileWriterPath
	 * @param similityCutOff
	 * @param cutPoint
	 * @param clusterCount
	 * @param minClusterCount
	 */
	public BulkCluster(String readFilePath, String delimeter,
			String repositoryPath, String fileWriterPath,
			double similityCutOff, int cutPoint, int clusterCount,
			int minClusterCount) {
		BulkCluster.similityCutoff = Float.parseFloat(String
				.valueOf(similityCutOff));
		BulkCluster.cutPoint = cutPoint;
		BulkCluster.clusterCount = clusterCount;
		BulkCluster.minClusterCount = minClusterCount;

		File readFileDirectory = new File(readFilePath);
		if (readFileDirectory.isDirectory()) {
			File dir = new File(fileWriterPath);
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}

			dir = new File(repositoryPath);
			if (!dir.isDirectory()) {
				dir.mkdirs();
			}

			for (File readFile : readFileDirectory.listFiles()) {
				if (!readFile.isFile())
					continue;
				String fileName = readFile.getName();
				String repositoryFileName = fileName.substring(0,
						fileName.lastIndexOf("."));
				// String repositoryFileName = fileName.split("\\.")[0];
				String indexFileName = repositoryFileName;
				String actualFileWriterPath = fileWriterPath + File.separator
						+ "result_" + similityCutoff + "_" + clusterCount + "_"
						+ minClusterCount + "_" + fileName;
				// System.out.println(fileName);
				// System.out.println(repositoryFileName);
				// System.out.println(indexFileName);

				System.out.println("similityCutoff : " + similityCutoff);
				System.out.println("cutPoint : " + cutPoint);
				System.out.println("clusterCount : " + clusterCount);
				System.out.println("minClusterCount : " + minClusterCount);
				System.out.println("cluster result file : "
						+ actualFileWriterPath);
				cluster(true, readFile.getAbsolutePath(), delimeter,
						repositoryPath, repositoryFileName, indexFileName,
						actualFileWriterPath);
				deleteRepository(repositoryPath);
			}
		}
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
	 * 유사도 컷오프
	 */
	static float similityCutoff = 0.1f;
	/**
	 * 유사도 소수점 컷
	 */
	static int cutPoint = 5;
	/**
	 * 군집당 갯수
	 */
	static int clusterCount = 50;
	/**
	 * 최소 군집 갯수
	 */
	static int minClusterCount = 5;

	static int divSize = 1024 * 1024 * 1024;
	int countPerSegment = 64;
	static int cacheSize = 1024 * 1024 * 64;
	static int nodeSize = 1024 * 4;
	int keyLength = 8;
	static int nodeLen = 4;

	static BTree clusterKeyword = null;
	static RangeSearchBTree rsb = null;

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

	public static String[] orderKeyword(String l, String r)
			throws CoreException {
		byte[] min = ByteArrayUtil.stringToByte(l);
		if (isClusterKeyword(min)) {
			/* 이미 분석이 끝난 항목에 대해서는 분석하지 않는다. */
			return null;
		}
		byte[] max = ByteArrayUtil.stringToByte(l + "!");
		RangeSearchBTreeIterator rsbIter = rsb.findRange(min, max);
		String[] leftMax = findMaxSimility(l, r, rsbIter);

		min = ByteArrayUtil.stringToByte(r);
		if (isClusterKeyword(min)) {
			/* 이미 분석이 끝난 항목에 대해서는 분석하지 않는다. */
			return null;
		}
		max = ByteArrayUtil.stringToByte(r + "!");
		rsbIter = rsb.findRange(min, max);
		String[] rightMax = findMaxSimility(r, l, rsbIter);
		if (Double.parseDouble(leftMax[1]) > Double.parseDouble(rightMax[1])) {
			// keyword는 r->l로 묶인다.
			return new String[] { r, l };
		} else {
			// keyword는 l->r로 묶인다.
			return new String[] { l, r };
		}
	}

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

	public static String[] findMaxSimility(String keyword) throws CoreException {
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

	public static void deleteRepository(String repositoryPath) {
		File repositoryPathFile = new File(repositoryPath);
		if (repositoryPathFile.isDirectory()) {
			for (File file : repositoryPathFile.listFiles()) {
				file.delete();
			}
		}
	}

	public static void main(String[] args) {
		boolean iscreate = true;
		// String readFilePath =
		// "c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/data/authorKeyword_nano.txt";
		// String delimeter = "\t";
		// String repositoryPath =
		// "c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/data/rep";
		// String repositoryFileName = "top10citref";
		// String indexFileName = "top10citrefIdx.tree";
		// String fileWriterPath =
		// "c:/Users/neon/Documents/Project/KISTI/2011_02_나노테크놀러지/data/author_keyword_cosine.txt";

		String readFilePath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/download/KISTI_COUPLING/0.05";
		String delimeter = "\t";
		String repositoryPath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/rep";
		String repositoryFileName = "top10citref";
		String indexFileName = "top10citrefIdx.tree";
		String fileWriterPath = "e:/My Document/PROJECT/KISTI/2011-05_나노_정보검색_플랫폼_및_나노_선도기술_추출을_위한_분석도구_개발/program/cluster/clusterResult/KISTI_COUPLING/0.05/test";

		if (args.length != 0) {
			iscreate = Boolean.parseBoolean(args[0]);
			readFilePath = args[1];
			delimeter = args[2];
			repositoryPath = args[3];
			fileWriterPath = args[4];
			if (args.length == 9) {
				similityCutoff = Float.parseFloat(args[5]);
				cutPoint = Integer.parseInt(args[6]);
				clusterCount = Integer.parseInt(args[7]);
				minClusterCount = Integer.parseInt(args[8]);
			}
		}
		System.out.println("similityCutoff : " + similityCutoff);
		System.out.println("cutPoint : " + cutPoint);
		System.out.println("clusterCount : " + clusterCount);
		System.out.println("minClusterCount : " + minClusterCount);

		new BulkCluster(readFilePath, delimeter, repositoryPath,
				fileWriterPath, similityCutoff, cutPoint, clusterCount,
				minClusterCount);

		// File readFileDirectory = new File(readFilePath);
		// System.out.println("===> " + readFilePath);
		// if (readFileDirectory.isDirectory()) {
		// for (File readFile : readFileDirectory.listFiles()) {
		// if (!readFile.isFile())
		// continue;
		// String fileName = readFile.getName();
		// repositoryFileName = fileName.split("\\.")[0];
		// indexFileName = repositoryFileName;
		// fileWriterPath = args[4] + File.separator + "result_"
		// + similityCutoff + "_" + clusterCount + "_"
		// + minClusterCount + "_" + fileName;
		// File dir = new File(args[4]);
		// if (!dir.isDirectory()) {
		// dir.mkdirs();
		// }
		// System.out.println(fileName);
		// System.out.println(repositoryFileName);
		// System.out.println(indexFileName);
		// System.out.println(fileWriterPath);
		// cluster(iscreate, readFile.getAbsolutePath(), delimeter,
		// repositoryPath, repositoryFileName, indexFileName,
		// fileWriterPath);
		//
		// deleteRepository(repositoryPath);
		// }
		// }

	}

	/**
	 * 클러스터 분석을 시작한다.<br>
	 * 
	 * @param iscreate
	 * @param readFilePath
	 * @param delimeter
	 * @param repositoryPath
	 * @param repositoryFileName
	 * @param indexFileName
	 * @param fileWriterName
	 */
	private static void cluster(boolean iscreate, String readFilePath,
			String delimeter, String repositoryPath, String repositoryFileName,
			String indexFileName, String fileWriterName) {
		DataLoader lak = new DataLoader(iscreate, readFilePath, delimeter,
				repositoryPath, repositoryFileName, indexFileName);

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
			/* 분석 대상 데이터 로드. */
			if (iscreate) {
				lak.load();
				lak.getKmvManager().flush();
			}

			fw = new FileWriter(fileWriterName);
			/* 유사도 계산 시작 */
			Iterator<String> xIter = lak.getIterator();
			LinkedHashMap<String, String[]> tmpMap = new LinkedHashMap<String, String[]>();
			while (xIter.hasNext()) {
				String x = (String) xIter.next();
				tmpMap.put(x, lak.getKmvManager().getVaule(x));
			}
			HashMap<String, Integer> resultMap = new HashMap<String, Integer>();
			System.out.println(" 유사도 분석 시작 " + tmpMap.size());
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
					/* x, y 키워드가 동시에 들어간 문서의 갯수는 w */
					yValues = tmpMap.get(y);
					int w = duplicationData(yValues);
					if (w != 0) {
						/* x, y 키워드가 동시에 들어간 문서의 갯수가 하나 이상이라면. */
						// System.out.println(new Date() + "\t" + x +" | "+y
						// +"\t 두단어가 들어간 문서의 갯수 " + w);
						double result = Similarity.coefficient(
								Similarity.COSINE, xEidList.size(),
								yValues.length, w);
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
						// System.out.println(t +"\t" + x +":" + y);
						// resultMap.put(x +"|"+y, w);
					}
				}
				if (resultMap.size() == 2)
					break;
				if (cnt++ % 1000 == 0) {
					System.out.println(" 유사도 분석 진행 건수 : " + (cnt - 1) + " / "
							+ tmpMap.size());
					// fw.flush();
				}
			}
			System.out.println(" 유사도 분석 완료 " + cnt);
			/* 유사도 계산 끝 */

			System.out.println(" 클러스터링 분석 시작 ");
			rsb.flush();
			sl.flush();
			/* 클러스터링 분석 */
			TreeIterator<String> slIter = sl.getIterator();
			int crtIterCount = 0;
			int clusterKey = 0;
			while (slIter.hasNext()) {
				String s = slIter.next();
				if (crtIterCount++ % 1000 == 0) {
					System.out.println(" 클러스터링 분석 진행 건수 : " + (crtIterCount));
					// fw.flush();
				}
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
					 * 군집대상 데이터인가? 이미 군집대상 데이터에 존재한다면 군집하지 않는다.
					 */
					if (isClusterKeyword(leftKeyByte)
							|| isClusterKeyword(rightKeyByte))
						continue;
					/*
					 * 단어의 순서를 정한다. left-right 일지 right-left일지 정한다. 정하는 방법은 오른쪽
					 * 항에 위치한 키워드의 right->유사도 left->유사도가 더 높을것을 기준으로 삼는다.
					 */

					String[] orderKeyword = orderKeyword(leftKey, rightKey);
					setClusterKeyword(orderKeyword[0]);
					setClusterKeyword(orderKeyword[1]);
					crt.add(String.valueOf(clusterKey), orderKeyword[0].trim());
					crt.add(String.valueOf(clusterKey), orderKeyword[1].trim());
					/*
					 * 단어의 순서가 정해지면 오른쪽 단어 기준으로 유사도가 가장 높은것을 찾는다. (반복)
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
									 * 군집갯수는 사용자 입력에 따라 정해지며, 이 군집의 갯수를 초과하게 되면
									 * 새로운 군집으로 생성된다.
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
						// 오른쪽단어의 유사도를 찾을수 없으므로 이 군집은 종료된다.
						// 다음 클러스터 아이디를 생성.
						clusterKey++;
					}

					fw.flush();
				}
			}
			System.out.println(" 클러스터 분석 결과를 파일에 기록합니다.");
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
					// 최소 군집수에 미달하면 해당 군집을 버린다.
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
						// 최소 군집수에 미달하면 해당 군집을 버린다.
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
				fw.write("[Cluster개수 통계 Info] " + valuesCnt + " : "
						+ list.size() + "\n");

			}
			fw.write("[Info] Read File Name : " + readFilePath + "\n");
			fw.write("[Info] 분석 대상 총 논문의 갯수 : " + tmpMap.size() + "\n");
			fw.write("[Info] Cluster Count : " + generateClusterCount + "\n");
			fw.write("[Info] 핵심 논문의 갯수. : " + documentTotalCount + "\n");
			fw.write("[Info] Threshold. : " + similityCutoff + "\n");
			fw.write("[Info] Max 군집 갯수. : " + clusterCount + "\n");
			fw.write("[Info] Min 군집 갯수. : " + minClusterCount + "\n");
			System.out.println(" 클러스터 분석 완료!!! ");
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
