package kr.co.topquadrant.db.dao;

import java.util.List;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.db.bean.HCPDocument;
import kr.co.topquadrant.db.bean.HCPYearInfo;
import kr.co.topquadrant.db.mybatis.HCPParameter;

public interface IHCPDao {

	/**
	 * HCP 분석 데이터를 가져온다.
	 * 
	 * @param hcpParam
	 *            ranking
	 * @return
	 */
	List<HCP> selectHCPAllData(HCPParameter hcpParam);

	/**
	 * 문서 정보를 가져온다.<br>
	 * 
	 * @param hcpParam
	 *            year, asjc, ranking
	 * @return
	 */
	public List<HCPDocument> selectHCPDocument(HCPParameter hcpParam);

	/**
	 * 문서 정보를 가져온다.<br>
	 * 
	 * @param hcpParam
	 *            year, asjc, ranking
	 * @return
	 */
	public List<HCPYearInfo> selectHCPYearInfo();

}
