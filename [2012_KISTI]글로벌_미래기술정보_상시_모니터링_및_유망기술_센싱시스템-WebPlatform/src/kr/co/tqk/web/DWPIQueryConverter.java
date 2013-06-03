package kr.co.tqk.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.websqrd.fastcat.ir.query.Clause;
import com.websqrd.fastcat.ir.query.Clause.Operator;
import com.websqrd.fastcat.ir.query.Filter;
import com.websqrd.fastcat.ir.query.Filters;
import com.websqrd.fastcat.ir.query.Query;
import com.websqrd.fastcat.ir.query.QueryParseException;
import com.websqrd.fastcat.ir.query.QueryParser;
import com.websqrd.fastcat.ir.query.Term;

/**
 * 
 * @pyb<=1970
 * @pyb>=1998<=1999
 * @pyb=2003 2003.pib.
 * @pyb>=1998<=1999 G06F015-00.ti. Jane.au. (h01q001 or h01q003).icm.
 * 
 * */
public class DWPIQueryConverter {

	protected static Logger logger = LoggerFactory.getLogger(DWPIQueryConverter.class);
	private static Map<String, String> toFastcatMap = new HashMap<String, String>();
	private static Map<String, String> toDWPIMap = new HashMap<String, String>();

	static {
		/*
		 * 필드명 추가시 이쪽에 추가바람.
		 */

		String[][] fieldMapping = new String[][] { { "sourceid", "sourceid" }, { "eid", "eid" },
				{ "affiliation", "affiliation" }, { "doi", "doi" }, { "sourcetitle", "sourcetitle" },
				{ "sourcetype", "sourcetype" }, { "cittype", "cittype" }, { "ti", "title" }, { "au", "authorname" },
				{ "kw", "keyword" }, { "ab", "abs" }, { "pby", "pubyear" }, { "asjc", "asjc" },
				{ "country", "country" } };
		for (int i = 0; i < fieldMapping.length; i++) {
			String[] info = fieldMapping[i];
			toFastcatMap.put(info[0], info[1]);
			toFastcatMap.put(info[0].toUpperCase(), info[1]);
			toDWPIMap.put(info[1], info[0]);
			toDWPIMap.put(info[1].toUpperCase(), info[0]);
		}
	}

	public static void main(String[] args) {
		String dQuery = "@pby>=1998<=1999 G06F015-00.ti. Jane.au. ((h01q001 or h01q003).icm. not ( Jane and Aire ).au.) and (nano display*).ti.";
		dQuery = "@pby>=1998<1999 (G06F015 -00).ti,ki,ab. Jane.au.";
		dQuery = "display.ti. Kim.au.";
		dQuery = "(Ba8Cux Si23-x Ge23 (4.5 d x d 7)).ti.";
		dQuery = "ips dislplay.ti. @pby>=1998<1999 @au!=1234";
		// dQuery = "not nano.ab,ki,ti.  kim.au. or park.au. not lee.au.";
		logger.info("DWPI Query >> {}", dQuery);
		logger.info("FastCat Query >> {}", new DWPIQueryConverter().convToFQuery(dQuery));
		//
		// String fQuery =
		// "se={{title:dislplay:1:32}AND{author:kim d:1:32}}&ft=country:match:USA,pubyear:section:2010~2012,asjc:match:1234;3456,keyword:exclude:NANO;ELECTRIC";
		// fQuery =
		// "se={{{{abs,keyword,title:nano:1:32}AND{authorname:kim:1:32}}OR{authorname:park:1:32}}NOT{authorname:lee:1:32}}";
		// logger.info("FastCat Query >> {}", fQuery);
		// logger.info("DWPI Query >> {}", new
		// DWPIQueryConverter().convToDQuery(fQuery));

		System.out.println(new DWPIQueryConverter()
				.convToDQuery("se={eid,title,abs,keyword:torrents:1:32}&ft=pubyear:section:2010~2012 "));
		System.out.println(new DWPIQueryConverter().convToFQuery("torrents.ti. @country=KOR"));
	}

	public String convToDQuery(String dQuery) {
		try {
			Query q = QueryParser.getInstance().parseQuery(dQuery);
			Clause clause = q.getClause();
			StringBuilder sb = new StringBuilder();
			if (clause != null) {
				getDWPISearchEntry(clause, sb);
			}
			// logger.debug("search query => {}", sb.toString());

			// search entry가 존재하면 한칸 띄워준다.
			if (sb.length() > 0) {
				sb.append(" ");
			}

			Filters filters = q.getFilters();
			if (filters != null) {
				List<Filter> filterList = filters.getFilterList();
				for (int i = 0; i < filterList.size(); i++) {
					Filter filter = filterList.get(i);
					if (i > 0) {
						sb.append(" ");
					}
					getDWPIFilterEntry(filter, sb);
				}
			}
			return sb.toString();
		} catch (QueryParseException e) {
			logger.error("쿼리파싱에러.", e);
		}
		return "";
	}

	public void getDWPISearchEntry(Object obj, StringBuilder sb) {

		if (obj instanceof Term) {
			Term term = (Term) obj;
			String fieldList = "";
			String[] fieldname = term.fieldname();
			for (int i = 0; i < fieldname.length; i++) {
				fieldList += toDWPIMap.get(fieldname[i]);
				if (i < fieldname.length - 1) {
					fieldList += ",";
				}
			}
			if (term.termString().indexOf(" ") > 0) {
				sb.append("(").append(term.termString()).append(").").append(fieldList).append(".");
			} else {
				sb.append(term.termString()).append(".").append(fieldList).append(".");
			}
		} else {
			Clause clause = (Clause) obj;
			Object obj1 = clause.operand1();
			Object obj2 = clause.operand2();
			Operator operator = clause.operator();

			getDWPISearchEntry(obj1, sb);

			if (operator != null) {
				if (operator == Clause.Operator.OR) {
					sb.append(" or ");
				} else if (operator == Clause.Operator.AND) {
					sb.append(" and ");
				} else if (operator == Clause.Operator.NOT) {
					sb.append(" not ");
				}
			}

			if (obj2 != null) {
				getDWPISearchEntry(obj2, sb);
			}
		}

	}

	public void getDWPIFilterEntry(Filter filter, StringBuilder sb) {
		String fieldName = filter.fieldname();
		sb.append("@").append(getDField(fieldName));

		int function = filter.function();

		if (function == Filter.MATCH || function == Filter.EXCLUDE) {
			if (function == Filter.EXCLUDE) {
				sb.append("!");
			}
			sb.append("=");
			int count = filter.patternLength();
			for (int i = 0; i < count; i++) {
				sb.append(filter.pattern(i));
				if (i < count - 1) {
					sb.append(",");
				}
			}
		} else if (function == Filter.SECTION) {
			sb.append(">=");
			sb.append(filter.pattern(0));
			if (filter.isEndPatternExist()) {
				sb.append("<=");
				sb.append(filter.endPattern(0));
			}
		}
	}

	public String convToFQuery(String dQuery) {
		List<String> filterEntry = new ArrayList<String>();
		List<String> searchEntry = new ArrayList<String>();

		String[] elist = dQuery.split(" ");
		int braceDepth = 0;

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < elist.length; i++) {
			String entry = elist[i];
			// System.out.println((i+1) +">>"+ entry);
			if (entry.startsWith("@")) {
				filterEntry.add(entry);
			} else {
				int pos = -1;
				// System.out.println("-> "+entry);

				while ((pos = entry.indexOf("(", pos + 1)) >= 0) {
					braceDepth++;
					// System.out.println("open pos = "+pos+", depth="+braceDepth);
				}
				while ((pos = entry.indexOf(")", pos + 1)) >= 0) {
					// System.out.println("close pos = "+pos+", depth="+braceDepth);
					braceDepth--;
				}

				if (sb.length() > 0) {
					sb.append(" ");
				}
				sb.append(entry);

				if (braceDepth == 0) {
					String se = sb.toString();
					// System.out.println("SE >> "+se);
					searchEntry.add(se);
					sb = new StringBuilder();
				}

			}

			// parseEntry(entry);
		}

		String filterQuery = null;
		String searchQuery = null;

		for (int i = 0; i < filterEntry.size(); i++) {
			String entry = filterEntry.get(i);
			// logger.debug("filter-{} >> {}", i, entry);
			FilterEntry fe = parseFilterEntry(entry);
			if (fe == null) {
				continue;
			} else if (fe.fieldName.length() == 0) {
				logger.error("필터필드가 없습니다. entry={}", entry);
				continue;
			} else if (fe.bound1.length() == 0 || fe.op1.length() == 0) {
				logger.error("필터조건이 없습니다. entry={}", entry);
				continue;
			}

			String tmp = getFField(fe.fieldName) + ":";
			if (fe.op1.equals("=")) {
				tmp += "match:" + fe.bound1;
			} else if (fe.op1.equals("!=")) {
				tmp += "exclude:" + fe.bound1;
			} else {
				if (fe.op1.equals(">=")) {
					tmp += "section:";
				} else if (fe.op1.equals(">")) {
					tmp += "section:";
				} else if (fe.op1.equals("<=")) {
					tmp += "section:";
				} else if (fe.op1.equals("<")) {
					tmp += "section:";
				}
				//
				tmp += fe.bound1 + "~" + fe.bound2;
			}

			if (filterQuery == null) {
				filterQuery = tmp;
			} else {
				filterQuery += "," + tmp;
			}
		}

		boolean hasOperator = false;

		for (int i = 0; i < searchEntry.size(); i++) {
			String entry = searchEntry.get(i);
			// logger.debug("search-{} >> {}", i, entry);
			if (entry.equalsIgnoreCase("and")) {
				if (searchQuery != null) {
					searchQuery += "AND";
					hasOperator = true;
				}
				continue;
			} else if (entry.equalsIgnoreCase("or")) {
				if (searchQuery != null) {
					searchQuery += "OR";
					hasOperator = true;
				}
				continue;
			} else if (entry.equalsIgnoreCase("not")) {
				if (searchQuery == null) {
					searchQuery = "";
				}
				searchQuery += "NOT";
				hasOperator = true;
				continue;
			}
			SearchEntry se = parseSearchEntry(entry);

			if (se == null) {
				continue;
			}

			String fieldListStr = "";
			for (int j = 0; j < se.fieldList.length; j++) {
				if (j > 0) {
					fieldListStr += ",";
				}
				fieldListStr += getFField(se.fieldList[j]);
			}

			String tmp = "{" + fieldListStr + ":" + se.keyword + ":1:32}";

			if (searchQuery == null) {
				searchQuery = tmp;
			} else {
				// searchQuery += "AND" + tmp;
				if (!hasOperator) {
					searchQuery = "{" + searchQuery + "AND" + tmp + "}";
				} else {
					searchQuery = "{" + searchQuery + tmp + "}";
				}
			}

			// 다음 loop의 search entry에서 사용된다.
			hasOperator = false;
		}

		// logger.debug("## searchQuery = {}", searchQuery);
		// logger.debug("## filterQuery = {}", filterQuery);

		String fastcatQuery = null;
		if (searchQuery != null) {
			fastcatQuery = "se={" + searchQuery + "}";
		}
		if (filterQuery != null) {
			if (fastcatQuery != null) {
				fastcatQuery += "&ft=" + filterQuery;
			} else {
				fastcatQuery = "ft=" + filterQuery;
			}
		}

		return fastcatQuery;
	}

	private SearchEntry parseSearchEntry(String entry) {
		String searchTerm = null;
		int pos = 0;
		int posField = 0;
		if (entry.startsWith("(")) {
			pos = entry.lastIndexOf(")");
			posField = pos + 2;
			searchTerm = entry.substring(1, pos);
		} else {
			pos = entry.indexOf(".");
			if (pos != -1) {
				posField = pos + 1;
				// logger.debug("entry={}, pos={}", entry, pos);
				searchTerm = entry.substring(0, pos);
			} else {
				return null;
			}
		}

		searchTerm = escapeKeyword(searchTerm);

		String fieldString = entry.substring(posField, entry.length() - 1);
		// logger.debug("searchTerm >> {}, fieldString >> {}", searchTerm,
		// fieldString);
		String[] fieldList = fieldString.split("\\,");
		// logger.debug("fieldList >>{}", fieldList);

		return new SearchEntry(fieldList, searchTerm);
	}

	private String escapeKeyword(String keyword) {
		// .replaceAll(",","\\\\,").replaceAll("&","\\\\&").replaceAll("=","\\\\=").replaceAll(":","\\\\:");
		return keyword.replaceAll("=", "\\\\=").replaceAll("&", "\\\\&").replaceAll(":", "\\\\:")
				.replaceAll("=", "\\\\=").replaceAll("~", "\\\\~").replaceAll(";", "\\\\;");
	}

	String[] filterOpType = new String[] { ">=", ">", "=", "<=", "<" };

	private FilterEntry parseFilterEntry(String entry) {
		if (entry.startsWith("@")) {
			try {
				String fieldName = "";
				String bound1 = "";
				String op1 = "";
				String bound2 = "";
				String op2 = "";
				int parseProcess = 0;

				int prevCharType = -1;
				for (int i = 1; i < entry.length(); i++) {
					char ch = entry.charAt(i);

					if (ch == '>' || ch == '<' || ch == '=' || ch == '!') {
						// 기호처리.

						if (prevCharType > 0) {
							// 문자에서 기호로 바뀌었다면 프로세스 단계 증가.
							parseProcess++;
						}

						if (parseProcess == 1) {
							op1 += ch;
						} else if (parseProcess == 2) {
							op2 += ch;
						}
						prevCharType = 0;
					} else {
						// 문자처리.
						if (parseProcess == 0) {
							fieldName += ch;
						} else if (parseProcess == 1) {
							bound1 += ch;
						} else if (parseProcess == 2) {
							bound2 += ch;
						}
						prevCharType = 1;
					}

				}// for

				// logger.debug("parsed /"+fieldName+"/"+op1+"/"+bound1+"/"+op2+"/"+bound2+"/");
				return new FilterEntry(fieldName, op1, bound1, op2, bound2);
			} catch (Exception e) {
				logger.error("Filter entry={}, err={}", entry, e);
				return null;
			}
		} else {
			return null;
		}

	}

	private String getFField(String name) {
		String tmp = toFastcatMap.get(name);
		if (tmp == null) {
			return name;
		} else {
			return tmp;
		}
	}

	private String getDField(String name) {
		String tmp = toDWPIMap.get(name);
		if (tmp == null) {
			return name;
		} else {
			return tmp;
		}
	}

	class SearchEntry {
		String[] fieldList;
		String keyword;

		public SearchEntry(String[] fieldList, String keyword) {
			this.fieldList = fieldList;
			this.keyword = keyword;
		}
	}

	class FilterEntry {
		String fieldName;
		String op1;
		String bound1;
		String op2;
		String bound2;

		public FilterEntry(String fieldName, String op1, String bound1, String op2, String bound2) {
			this.fieldName = fieldName;
			this.op1 = op1;
			this.bound1 = bound1;
			this.op2 = op2;
			this.bound2 = bound2;
		}
	}
}
