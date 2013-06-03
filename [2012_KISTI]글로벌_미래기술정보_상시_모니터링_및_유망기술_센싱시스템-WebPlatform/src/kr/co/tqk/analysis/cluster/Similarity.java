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
 * 유사도를 구한다.
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
	 * 코사인 계수
	 */
	public static final int COSINE = 0;
	/**
	 * 자카드 계수
	 */
	public static final int JAKAD = 0;

	/**
	 * 코사이 계수를 통한 유사도를 구한다.
	 * 
	 * @param xTotal
	 *            x 항목에 대한 총 갯수
	 * @param yTotal
	 *            y 항목에 대한 총갯수
	 * @param dup
	 *            x와 y 항목에서 서로 중첩되는 갯수.
	 * @return
	 */
	public static double cosineCoefficient(int xTotal, int yTotal, int dup) {
		return dup / Math.sqrt(xTotal * yTotal);
	}

	/**
	 * 자카드 계수를 통한 유사도를 구한다.
	 * 
	 * @param xTotal
	 *            x 항목에 대한 총 갯수
	 * @param yTotal
	 *            y 항목에 대한 총갯수
	 * @param dup
	 *            x와 y 항목에서 서로 중첩되는 갯수.
	 * @return
	 */
	public static double jakadCoefficient(int xTotal, int yTotal, int dup) {
		return 0;
	}

	/**
	 * 유사도를 계산한다.
	 * 
	 * @param type
	 *            유사도 계산 형태
	 * @param xTotal
	 *            x 항목에 대한 총 갯수
	 * @param yTotal
	 *            y 항목에 대한 총갯수
	 * @param dup
	 *            x와 y 항목에서 서로 중첩되는 갯수.
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
	 * 임시변수에 데이터 HashSet 형태로 세팅한다.
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
	 * 임시변수에 담은 데이터를 기준으로 중복된 데이터가 몇개 있는지 확인한다
	 * 
	 * @param value
	 *            검색 대상 데이터.
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
	 * 유사도를 계산한다.
	 * 
	 * @param iscreate
	 *            관련 파일 생성 여부
	 * @param readFilePath
	 *            대상 데이터
	 * @param delimeter
	 *            대상 데이터 구분자
	 * @param repositoryPath
	 *            리파지토리 경로
	 * @param repositoryName
	 *            리파지토리 파일 명
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
			/* 분석 대상 데이터 로드. */
			if (iscreate) {
				dataLoaderRepository.load();
				dataLoaderRepository.getKmvManager().flush();
			}

			/* 유사도 계산 시작 */
			Iterator<String> xIter = dataLoaderRepository.getIterator();
			LinkedHashMap<String, String[]> tmpMap = new LinkedHashMap<String, String[]>();
			while (xIter.hasNext()) {
				String x = (String) xIter.next();
				tmpMap.put(x, dataLoaderRepository.getKmvManager().getVaule(x));
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
					System.out.println(" 유사도 분석 진행 건수 : " + (cnt - 1) + " / "
							+ tmpMap.size());
				}
			}
			System.out.println(" 유사도 분석 완료 " + cnt);
			/* 유사도 계산 끝 */
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
