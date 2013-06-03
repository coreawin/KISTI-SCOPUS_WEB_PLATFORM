package kr.co.topquadrant.db.mybatis;

/**
 * MyBatis ���� �Է� �Ķ���͸� ���� Ŭ����.
 * 
 * @author ������
 * 
 */
public class MyBatisParameter {

	/**
	 * Science, Nature ��ó�� ���� ��ü ��
	 */
	public static final String A = "A";

	/**
	 * Science, Nature ��ó�� ���� �������� �ʾ��� ���.
	 */
	public static final String N = "N";

	/**
	 * Science, Nature ��ó�� ���� ������ ���.
	 */
	public static final String Y = "Y";

	/**
	 * Science, Nature ��ó�� ���� ���� ��
	 */
	public static final String R = "R";

	int seq;
	int consecutiveNumber;
	int update_flag;

	/**
	 * ��û ������ ��ȣ
	 */
	int requestPage = 1;
	/**
	 * ǥ�õǴ� �� ��
	 */
	int rows = 10;
	/**
	 * ���� Į�� ��
	 */
	String orderColumn;
	/**
	 * asc, desc
	 */
	String sord;

	/**
	 * �˻� ������
	 */
	String searchOper;
	/**
	 * �˻���
	 */
	String searchString;
	/**
	 * �˻� Į�� �׸�
	 */
	String searchField;
	/**
	 * Mirian ���� ����.
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
