package kr.co.tqk.web;

import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import kr.co.tqk.web.util.UtilString;

/**
 * @author 정승한
 * 
 */
public class MakeSearchRule {

	/**
	 * 문서 EID로 검색한다.
	 * 
	 * @param searchRule
	 *            0번은 총 검색 개수 추출 <br>
	 *            1번은 실 페이징 검색 결과 추출<br>
	 * @return
	 */
	public static String[] makeGetEIDQuery(String searchRule) {
		String[] result = new String[2];
		Set<String> eidSet = new HashSet<String>();
		StringBuffer sql = new StringBuffer();
		String[] queryDelim = searchRule.split(" ");
		for (String q : queryDelim) {
			q = q.trim();
			if ("".equals(q))
				continue;
			eidSet.add(q);
		}
		sql.append(" select count(*) from ( ");
		sql.append(" 	select /*+ INDEX_DESC(A INDEX_DOCUMENT_CIT_COUNT) */ rownum as rnum, A.* from ( ");
		sql.append(" 		select * from scopus_document where ");
		sql.append(UtilString.whereContidionSetData(eidSet, "EID", true));
		sql.append(" 		) A ");
		sql.append(" 	)");
		result[0] = sql.toString();

		sql.setLength(0);
		sql.append(" select * from ( ");
		sql.append(" 	select /*+ INDEX_DESC(A INDEX_DOCUMENT_CIT_COUNT) */ rownum as rnum, A.* from ( ");
		sql.append(" 		select * from scopus_document where ");
		sql.append(UtilString.whereContidionSetData(eidSet, "EID", true));
		sql.append(" 		) A where rownum <= ? ");
		sql.append(" 	) where rnum >= ? ");

		result[1] = sql.toString();
		return result;
	}

	/**
	 * 일반 검색을 위한 검색식을 SQL 질의로 변환한다.<BR>
	 * 
	 * @param searchRule
	 *            검색식
	 * @return
	 */
	public static String[] makeSearchQuery(String searchRule) {
		String[] result = new String[2];
		StringBuffer hintQuery = new StringBuffer();
		LinkedList<String> joinQueryList = new LinkedList<String>();
		LinkedList<String> whereQueryList = new LinkedList<String>();
		LinkedList<String> fromQueryList = new LinkedList<String>();
		fromQueryList.add(" SCOPUS_DOCUMENT sd ");
		LinkedList<String> selectQueryList = new LinkedList<String>();
		selectQueryList.add(" sd.eid, sd.title, sd.publication_year, sd.ref_count, sd.cit_count ");
		StringBuffer sql = new StringBuffer();

		// 일반 검색 쿼리
		String[] queryDelim = searchRule.toUpperCase().split("AND");
		String[] data = null;
		String orderBy = " INDEX_DOCUMENT_REF_COUNT ";
		for (String q : queryDelim) {
			q = q.trim();
			if (q.startsWith("PUBYEAR")) {
				q = q.replaceAll("PUBYEAR", "").replaceAll("\\(", "").replaceAll("\\)", "");
				System.err.println("문서 검색식 : " + q);
				data = q.split("\\-");
				// sql.append("(");
				sql.append("PUBLICATION_YEAR BETWEEN ");
				sql.append(" '");
				sql.append(data[0].trim());
				sql.append("'");
				sql.append(" AND ");
				sql.append(" '");
				sql.append(data[1].trim());
				sql.append("'");
				// sql.append(")");
				whereQueryList.add(sql.toString());
				sql.setLength(0);
			} else if (q.startsWith("ASJC")) {
				q = q.replaceAll("ASJC", "").replaceAll("\\(", "").replaceAll("\\)", "");
				System.err.println("문서 검색식 : " + q);
				data = q.split("\\-");

				sql.append("(");
				for (int idx = 0; idx < data.length; idx++) {
					String d = data[idx].trim();
					sql.append(" ASJC_CODE = ");
					sql.append(d);
					sql.append(" OR ");
				}
				sql.setLength(sql.length() - 4);
				sql.append(")");
				whereQueryList.add(sql.toString());
				fromQueryList.add(" , SCOPUS_CLASSIFICATION_ASJC asjc ");
				joinQueryList.add(" sd.eid = asjc.eid ");
				sql.setLength(0);
			} else if (q.startsWith("COUNTRY")) {
				// TODO 미완성.
				q = q.replaceAll("COUNTRY", "").replaceAll("\\(", "").replaceAll("\\)", "");
				data = q.split("\\-");
				for (int idx = 0; idx < data.length - 1; idx++) {
					String d = data[idx].trim();
					sql.append(" COUNTRY_CODE = '");
					sql.append(d);
					sql.append("'");
					sql.append(" OR ");
				}
				sql.setLength(sql.length() - 4);
				fromQueryList.add(sql.toString());
				sql.setLength(0);
			} else if (q.startsWith("SOURCE")) {
				q = q.replaceAll("SOURCE", "").replaceAll("\\(", "").replaceAll("\\)", "");
				data = q.split("\\-");
				sql.append("(");
				for (int idx = 0; idx < data.length - 1; idx++) {
					String d = data[idx].trim();
					sql.append(" SOURCE_ID = '");
					sql.append(d);
					sql.append("'");
					sql.append(" OR ");
				}
				sql.setLength(sql.length() - 4);
				sql.append(")");
				whereQueryList.add(sql.toString());
				sql.setLength(0);
			} else if (q.startsWith("SOURCETYPE")) {
				q = q.replaceAll("SOURCETYPE", "").replaceAll("\\(", "").replaceAll("\\)", "");
				data = q.split("\\-");
				for (int idx = 0; idx < data.length - 1; idx++) {
					String d = data[idx].trim();
					sql.append(" SOURCETYPE = '");
					sql.append(d);
					sql.append("'");
					sql.append(" OR ");
				}
				sql.setLength(sql.length() - 4);
				fromQueryList.add(sql.toString());
				sql.setLength(0);
			} else {
				if (q.length() > 2) {
					q = q.substring(1, q.length()).trim();
					q = q.substring(0, q.length() - 1).trim();
					System.err.println("문서 검색식 : " + q);
					data = q.split("\\)");
					for (int idx = 0; idx < data.length; idx++) {
						String[] da = data[idx].split("\\(");
						String searchData = da[1].trim();

						String[] column = da[0].trim().split("-");
						if (column[0].indexOf("and") != -1) {
							sql.append(" AND ");
							column[0] = column[0].replaceAll("and", "");
						} else if (column[0].indexOf("or") != -1) {
							sql.append(" OR ");
							column[0] = column[0].replaceAll("or", "");
						}
						// sql.append(" ( ");
						for (int colIdx = 0; colIdx < column.length; colIdx++) {
							if (column[colIdx].startsWith("TITLE")) {
								// 논문 타이틀 검색
								sql.append(" contains(title, ?) > 0");
								// sql.append(" contains(title, '");
								// sql.append(searchData);
								// sql.append("') > 0");
							} else if (column[colIdx].startsWith("ABS")) {
								sql.append(" abstract like ?");
								// sql.append(" abstract like '");
								// sql.append(searchData);
								// sql.append("%' ");
							} else {
								sql.append(column[colIdx]);
								sql.append(" = '");
								sql.append(searchData);
								sql.append("' ");
							}
							sql.append(" OR ");
						}
						sql.setLength(sql.length() - 4);
						// sql.append(") ");
					}
					whereQueryList.add(sql.toString());
					sql.setLength(0);
				}
			}
		}
		// TODO 화면 출력을 위하여 검색식 쿼리가 아닌 일반 쿼리를 사용한다.

		sql.append(" select ");
		for (String select : selectQueryList) {
			sql.append(select);
		}
		sql.append(" from ");
		for (String from : fromQueryList) {
			sql.append(from);
		}
		sql.append(" where ");
		for (String joinQuery : joinQueryList) {
			sql.append("(");
			sql.append(joinQuery);
			sql.append(") AND");
		}
		if (whereQueryList.size() == 0) {
			sql.setLength(sql.length() - 4);
		}
		for (String whereQuery : whereQueryList) {
			sql.append(" (");
			sql.append(whereQuery);
			sql.append(") AND");
		}
		sql.setLength(sql.length() - 4);

		hintQuery.append(" /*+ FIRST_ROWS(50) ");
		if (joinQueryList.size() > 0) {
			for (String from : fromQueryList) {
				String[] a = from.split(" ");
				hintQuery.append(" use_nl(");
				hintQuery.append(a[a.length - 1].trim());
				hintQuery.append(" )");
			}
		}
		hintQuery.append(" */ ");

		String query = " select " + hintQuery.toString() + " * from (" + "	select /*+ INDEX_DESC(A " + orderBy
				+ ") */ rownum as rnum, A.* from ( " + sql.toString() + " )A where rownum <= ? " + ") where rnum >= ? ";

		result[0] = " select /* INDEX(XPKSCOPUS_DOCUMENT) */ count(eid) from (" + sql.toString() + " )";
		result[1] = query;
		System.out.println(result[0]);
		return result;
	}

	/**
	 * 저자 검색 쿼리를 만든다.
	 * 
	 * @param searchRule
	 * @param exactMatch
	 *            일치해야 하는것인가?
	 * @return 0번은 총 검색 개수 추출 <br>
	 *         1번은 실 페이징 검색 결과 추출<br>
	 */
	public static String[] makeAuthorSearchQuery(String searchRule, boolean exactMatch) {
		String[] result = new String[2];
		StringBuffer whereCondition = new StringBuffer();
		StringBuffer sql = new StringBuffer();

		if (exactMatch) {
			whereCondition.append(" ( author_name like '");
			whereCondition.append(searchRule);
			whereCondition.append("' OR delegate_author_name like '");
			whereCondition.append(searchRule);
			whereCondition.append("' )");
		} else {
			whereCondition.append(" ( CONTAINS(author_name, '");
			whereCondition.append(searchRule.replaceAll("\\,", " "));
			whereCondition.append("') > 0 OR CONTAINS(delegate_author_name, '");
			whereCondition.append(searchRule.replaceAll("\\,", " "));
			whereCondition.append("') > 0 )");
		}

		sql.append(" select count(*) from ( ");
		sql.append(" 	select rownum as rnum, A.* from ( ");
		sql.append(" 		select * from SCOPUS_AUTHOR where ");
		sql.append(whereCondition.toString());
		sql.append(" 		) A ");
		sql.append(" 	)");
		result[0] = sql.toString();

		sql.setLength(0);
		sql.append("select * from ( ");
		sql.append("	select rownum as rnum, A.* from ( ");
		sql.append("		select * from scopus_author sa where ");
		sql.append(whereCondition.toString());
		sql.append("		order by eid_count desc ) A where rownum <= ? ");
		sql.append("	) where rnum >= ? ");
		result[1] = sql.toString();
		return result;
	}

	/**
	 * Fast cat 검색엔진에서 필터에 해당하는 검색식을 추출한다.
	 * 
	 * @param searchRule
	 * @return
	 */
	public static FilterSearchRule extractSearchRuleFilter(String searchRule) {
		FilterSearchRule fsr = new FilterSearchRule();

		Pattern p = Pattern.compile("(?<=\\&ft\\=).+");
		Matcher m = p.matcher(searchRule);
		String r = "";
		while (m.find()) {
			r = m.group();
		}

		StringTokenizer st = new StringTokenizer(r, "\\,");
		while (st.hasMoreTokens()) {
			String filter = st.nextToken();
			int lidx = filter.lastIndexOf(":");
			String keys = filter.substring(0, lidx);
			String values = filter.substring(lidx + 1, filter.length());
			String[] keyarray = keys.split(":");
			fsr.add(keyarray[0], keyarray[1], values);
		}

		return fsr;
	}

}

