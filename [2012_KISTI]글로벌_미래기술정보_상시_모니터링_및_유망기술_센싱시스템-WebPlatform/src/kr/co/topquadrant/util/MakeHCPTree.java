package kr.co.topquadrant.util;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.db.bean.HCPYearInfo;
import kr.co.topquadrant.db.dao.HCPDao;
import kr.co.topquadrant.db.dao.IHCPDao;
import kr.co.tqk.web.db.DescriptionCode;
import kr.co.tqk.web.util.NumberFormatUtil;

import com.google.common.base.Supplier;
import com.google.common.collect.Maps;
import com.google.common.collect.Table;
import com.google.common.collect.Tables;

public class MakeHCPTree {
	private Table<String, Integer, String> tableData = null;
	static Map<String, String> asjcData = DescriptionCode.getAsjcTypeKoreaDescription();

	public MakeHCPTree(List<HCP> data) {
		tableData = makeDataSet(data);
	}

	private Table<String, Integer, String> makeDataSet(List<HCP> datas) {
		int maxPublicationYear = Integer.MIN_VALUE;
		int minPublicationYear = Integer.MAX_VALUE;
		
		IHCPDao hcpdao = new HCPDao();
		List<HCPYearInfo> yearInfo = hcpdao.selectHCPYearInfo();
		for(HCPYearInfo yi : yearInfo){
			maxPublicationYear = Math.max(maxPublicationYear, yi.getPublication_year());
			minPublicationYear = Math.min(minPublicationYear, yi.getPublication_year());
		}
//		System.out.println("maxPublicationYear " + maxPublicationYear);
//		System.out.println("minPublicationYear " + minPublicationYear);
		/*
		for (HCP hcp : datas) {
			String pby = hcp.getPublication_year();
			if (pby == null) {
				continue;
			}
			int pub = Integer.parseInt(pby);
			maxPublicationYear = Math.max(maxPublicationYear, pub);
			minPublicationYear = Math.min(minPublicationYear, pub);
		}
		*/
		Table<String, Integer, String> dataSet = createDataSet(minPublicationYear, maxPublicationYear);
		Map<String, Integer> totalSum = new HashMap<String, Integer>();
		Map<String, Integer> documentCntSum = new HashMap<String, Integer>();
		Map<String, Float> thresholdSum = new HashMap<String, Float>();
		for (HCP hcp : datas) {
			values.setLength(0);
			String pby = hcp.getPublication_year();
			
			String asjc = hcp.getAsjc_code();
			if (asjc == null) {
				continue;
			}
			if (pby == null) {
				continue;
			}
			String firstString = asjc.substring(0, 2);
			String lastString = asjc.substring(2, asjc.length());
			int pub = Integer.parseInt(pby);
			dataSet.put(
					asjc,
					pub,
					getDataSetValue(asjc, String.valueOf(pub), hcp.getTotal(), hcp.getDocument_count(),
							hcp.getThreshold()));

			String sumKey = asjc + pub;
			if ("1000".equals(asjc)) {
				sumKey = "1000_TOTAL-" + pub;
			} else {
				sumKey = firstString + "00_TOTAL-" + pub;
			}
			// if ("1000".equals(asjc) || "1100".equals(asjc) ||
			// "11".equals(firstString)) {
			// sumKey = "1000_TOTAL-" + pub;
			// } else {
			// sumKey = firstString + "00_TOTAL-" + pub;
			// }
			// System.out.println(sumKey);
			int totalsum = hcp.getTotal();
			int documentcntsum = hcp.getDocument_count();
			float thresholdsum = hcp.getThreshold();
			if (totalSum.containsKey(sumKey)) {
				totalsum += totalSum.get(sumKey);
				documentcntsum += documentCntSum.get(sumKey);
				thresholdsum += thresholdSum.get(sumKey);
				thresholdsum = thresholdsum/2;
			}
			totalSum.put(sumKey, totalsum);
			documentCntSum.put(sumKey, documentcntsum);
			thresholdSum.put(sumKey, thresholdsum);
		}
		Set<String> totalSet = totalSum.keySet();
		for (String total : totalSet) {
			String[] sumKeySet = total.split("-");
			String sumkey = sumKeySet[0];
			int year = Integer.parseInt(sumKeySet[1]);
			dataSet.put(
					sumkey,
					year,
					getDataSetValue(total.split("_")[0], String.valueOf(year), totalSum.get(total),
							documentCntSum.get(total), thresholdSum.get(total)));
		}
		return dataSet;
	}

	private StringBuffer values = new StringBuffer();

	private String getDataSetValue(String asjc, String year, int total, int documentCount, float threshold) {
		values.setLength(0);
		values.append(total);
		values.append("_");
		values.append(asjc);
		values.append(";");
		values.append(documentCount);
		values.append(";");
		values.append(year);
		values.append("_");
		values.append(NumberFormatUtil.getDecimalFormat(threshold, 2));
		return values.toString();
	}

	@Deprecated
	private String getDataSetValue(int total, int documentCount, int threshold) {
		values.setLength(0);
		values.append(total);
		values.append("_");
		values.append(documentCount);
		values.append("_");
		values.append(threshold);
		return values.toString();
	}

	/**
	 * guava create Custom table
	 * 
	 * @return
	 */
	Table<String, Integer, String> createLinkedHashMap() {
		return Tables.newCustomTable(Maps.<String, Map<Integer, String>> newLinkedHashMap(),
				new Supplier<Map<Integer, String>>() {
					public Map<Integer, String> get() {
						return Maps.newLinkedHashMap();
					}
				});
	}

	private Table<String, Integer, String> createDataSet(int startYearParam, int endYearParam) {
		Table<String, Integer, String> t = createLinkedHashMap();
		Set<String> asjcSet = asjcData.keySet();
		int startYear = Math.min(1995, startYearParam);
		int endYear = Math.max(endYearParam, GregorianCalendar.getInstance().get(Calendar.YEAR));
//		System.out.println("startYear " + startYear);
//		System.out.println("endYear " + endYear);
		for (String asjc : asjcSet) {
			for (int year = startYear; year <= endYear; year++) {
				String firstString = asjc.substring(0, 2);
				String lastString = asjc.substring(2, asjc.length());
				if ("1000".equals(asjc)) {
					t.put(asjc + "_TOTAL", year, getDataSetValue(asjc, String.valueOf(year),0, 0, 0));
				} else {
					if (lastString.equals("00")) {
						t.put(asjc + "_TOTAL", year, getDataSetValue(asjc, String.valueOf(year),0, 0, 0));
					}
				}

				// if ("1000".equals(asjc)) {
				// t.put(asjc + "_TOTAL", year, getDataSetValue(0, 0, 0));
				// } else {
				// if (!"1100".equals(asjc)) {
				// if (lastString.equals("00")) {
				// t.put(asjc + "_TOTAL", year, getDataSetValue(0, 0, 0));
				// }
				// }
				// }
//				System.out.println(asjc + "_" + year + "_" + getDataSetValue(asjc, String.valueOf(year), 0, 0, 0));
				t.put(asjc, year, getDataSetValue(asjc, String.valueOf(year), 0, 0, 0));
			}
		}
		return t;
	}

	public List<HCPTree> makeTreeData(Set<String> largeASJCSet) {
		List<HCPTree> result = new LinkedList<HCPTree>();
		if (tableData == null)
			return result;
		Set<String> rowKeySet = tableData.rowKeySet();
		for (String rowASJC : rowKeySet) {
			Map<Integer, String> rowData = tableData.row(rowASJC);
			// String rowASJC = String.valueOf(asjcS);
			// System.out.println(rowASJC);
			Set<Integer> yearSet = rowData.keySet();
			List<String> makeTreeData = new LinkedList<String>();

			String firstString = rowASJC.substring(0, 2);
			// String lastString = rowASJC.substring(2, rowASJC.length());
			String parent = "null";
			boolean isLeaf = false;
			boolean expand = true;
			int level = 0;
			if (largeASJCSet != null) {
				if (largeASJCSet.size() > 0) {
					String largeASJC = firstString + "00";
					if (firstString.equals("10")) {
						largeASJC = "1000";
					}
					// if (firstString.equals("11") || firstString.equals("10"))
					// {
					// largeASJC = "1000";
					// if (largeASJCSet.contains("1000")) {
					// largeASJCSet.add("1100");
					// }

					// if (largeASJCSet.contains("1100")) {
					// largeASJCSet.add("1000");
					// }
					// }
					if (!largeASJCSet.contains(largeASJC)) {
						// asjc 대분류 필터.
						continue;
					}
				}
			}

			String asjcKorea = "";
			if (rowASJC.indexOf("_TOTAL") != -1) {
				/*
				 * jqGrid에서 사용할때 parent가 없으면 null로 인식되어야 한다.
				 */
				parent = "null";
				isLeaf = false;
				expand = true;
				asjcKorea = asjcData.get(firstString + "00").replaceAll("\\(전체\\)", "").trim() + " (Total)";
			} else {
				// 중분류
				// if(firstString.equals("11")){
				// firstString = "10";
				// }
				parent = firstString + "00_TOTAL";
				isLeaf = true;
				expand = false;
				level = 1;
				asjcKorea = asjcData.get(rowASJC).trim() + " (" + rowASJC + ")";
			}

			makeTreeData.add(asjcKorea);
			for (int year : yearSet) {
				String value = rowData.get(year);
//				System.out.println("===== " + value);
				String[] valuea = value.split("_");
				for (String va : valuea) {
					makeTreeData.add(va);
				}
			}
			makeTreeData.add(String.valueOf(level));
			makeTreeData.add(parent);
			makeTreeData.add(String.valueOf(isLeaf));
			makeTreeData.add(String.valueOf(expand));
//			System.out.println("=> " + makeTreeData);
			HCPTree tree = new HCPTree(rowASJC, makeTreeData);
			result.add(tree);
		}
		return result;
	}
	
	public static void main(String[] args){
		System.out.println(String.valueOf(GregorianCalendar.getInstance().get(Calendar.YEAR)));
	}

}
