package kr.co.topquadrant.db.dao;

import java.util.List;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.db.bean.HCPDocument;
import kr.co.topquadrant.db.bean.HCPYearInfo;
import kr.co.topquadrant.db.mybatis.HCPParameter;

public interface IHCPDao {

	/**
	 * HCP �м� �����͸� �����´�.
	 * 
	 * @param hcpParam
	 *            ranking
	 * @return
	 */
	List<HCP> selectHCPAllData(HCPParameter hcpParam);

	/**
	 * ���� ������ �����´�.<br>
	 * 
	 * @param hcpParam
	 *            year, asjc, ranking
	 * @return
	 */
	public List<HCPDocument> selectHCPDocument(HCPParameter hcpParam);

	/**
	 * ���� ������ �����´�.<br>
	 * 
	 * @param hcpParam
	 *            year, asjc, ranking
	 * @return
	 */
	public List<HCPYearInfo> selectHCPYearInfo();

}
