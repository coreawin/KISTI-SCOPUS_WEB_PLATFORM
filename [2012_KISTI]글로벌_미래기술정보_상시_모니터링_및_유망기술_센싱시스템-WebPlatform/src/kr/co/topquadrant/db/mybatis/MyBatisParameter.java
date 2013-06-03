package kr.co.topquadrant.db.mybatis;

/**
 * MyBatis 에서 입력 파라미터를 위한 클래스.
 * 
 * @author 정승한
 * 
 */
public class MyBatisParameter {

	/**
	 * Science, Nature 출처에 대한 전체 논문
	 */
	public static final String A = "A";

	/**
	 * Science, Nature 출처에 대해 선택하지 않았을 경우.
	 */
	public static final String N = "N";

	/**
	 * Science, Nature 출처에 대해 선택한 경우.
	 */
	public static final String Y = "Y";

	/**
	 * Science, Nature 출처에 대한 관련 논문
	 */
	public static final String R = "R";

	int seq;
	int consecutiveNumber;
	int update_flag;

	/**
	 * 요청 페이지 번호
	 */
	int requestPage = 1;
	/**
	 * 표시되는 줄 수
	 */
	int rows = 10;
	/**
	 * 정렬 칼럼 명
	 */
	String orderColumn;
	/**
	 * asc, desc
	 */
	String sord;

	/**
	 * 검색 연산자
	 */
	String searchOper;
	/**
	 * 검색어
	 */
	String searchString;
	/**
	 * 검색 칼럼 항목
	 */
	String searchField;
	/**
	 * Mirian 서비스 연동.
	 */
	String showMirian;

	public int getRequestPage() {
		return requestPage;
	}

	public void setRequestPage(int requestPage) {
		this.requestPage = requestPage;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public String getOrderColumn() {
		return orderColumn;
	}

	public void setOrderColumn(String orderColumn) {
		this.orderColumn = orderColumn;
	}

	public String getSord() {
		return sord;
	}

	public void setSord(String sord) {
		this.sord = sord;
	}

	public String getSearchOper() {
		return searchOper;
	}

	public void setSearchOper(String searchOper) {
		this.searchOper = searchOper;
	}

	public String getSearchString() {
		return searchString;
	}

	public void setSearchString(String searchString) {
		this.searchString = searchString;
	}

	public String getSearchField() {
		return searchField;
	}

	public void setSearchField(String searchField) {
		this.searchField = searchField;
	}

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public int getConsecutiveNumber() {
		return consecutiveNumber;
	}

	public void setConsecutiveNumber(int consecutiveNumber) {
		this.consecutiveNumber = consecutiveNumber;
	}

	public int getUpdate_flag() {
		return update_flag;
	}

	public void setUpdate_flag(int update_flag) {
		this.update_flag = update_flag;
	}

	public String getShowMirian() {
		return showMirian;
	}

	public void setShowMirian(String showMirian) {
		this.showMirian = showMirian;
	}

}
