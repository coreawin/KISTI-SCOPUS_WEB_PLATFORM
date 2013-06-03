package kr.co.topquadrant.db.dao;

import java.util.List;

import kr.co.topquadrant.db.bean.ClusterDocument;
import kr.co.topquadrant.db.bean.ClusterResultSummary;
import kr.co.topquadrant.db.bean.RFAnalysis;
import kr.co.topquadrant.db.bean.RFAnalysisCluster;
import kr.co.topquadrant.db.bean.RFAnalysisOption;
import kr.co.topquadrant.db.mybatis.MyBatisParameter;

public interface IResearchFrontDao {

	/**
	 * 등록된 분석항목을 가져온다.
	 * 
	 * @return
	 */
	List<RFAnalysis> selectAllAnalysis();

	/**
	 * 등록된 분석 항목을 페이징 해서 가져온다.
	 * 
	 * @param requestPage
	 *            요청 페이지 번호
	 * @param rows
	 *            한화면에 출력되는 row개수
	 * @param orderColumn
	 *            정렬 칼럼
	 * @param sord
	 *            정렬 인자.
	 * @return
	 */
	List<RFAnalysis> selectAllAnalysis(MyBatisParameter parameter);

	/**
	 * 등록된 분석항목을 가져온다.
	 * 
	 * @param seq
	 *            분석 항목 아이디.
	 * @return
	 */
	RFAnalysis selectAnalysis(int seq);
	
	/**
	 * 등록된 분석항목의 ASJC 코드를 가져온다.
	 * 
	 * @param seq
	 *            분석 항목 아이디.
	 * @return
	 */
	List<String> selectAnalysisAsjc(int seq); 

	/**
	 * 분석항목을 등록한다.
	 * 
	 * @param bean
	 */
	void insertAnalysis(RFAnalysis bean);

	/**
	 * 분석항목을 삭제한다.
	 * 
	 * @param seq
	 *            분석 일련번호
	 * @param consecutiveNumber
	 *            분석결과 일련번호
	 * @param updateFlag
	 *            분석결과 업데이트번호.
	 */
	void deleteAnalysis(int seq, int consecutiveNumber, int updateFlag);

	/**
	 * 모든 클러스터 분석결과에 대한 요약본을 가져온다
	 * 
	 * @param parameter
	 *            파라미터 정보.
	 * @return
	 */
	List<RFAnalysisCluster> selectAllAnalysisCluster(MyBatisParameter parameter);

	/**
	 * 특정 분석의 모든 클러스터 분석결과에 대한 요약본을 가져온다
	 * 
	 * @param parameter
	 *            파라미터 정보.
	 * @return
	 */
	public List<ClusterResultSummary> selectAllAnaylsisClusterSeq(MyBatisParameter parameter);

	/**
	 * 분석항목을 삭제한다.
	 * 
	 * @param seq
	 */
	void deleteAnalysis(int seq);

	List<RFAnalysisOption> selectAnalysisOptionALL();

	void insertAnalysisOption(RFAnalysisOption option);

	/**
	 * 상세 클러스터 분석 정보를 가져온다.<br>
	 * 
	 * @param seq
	 *            분석 번호
	 * @param consecutiveNumber
	 *            클러스터 일련 번호.
	 * @return
	 */
	ClusterDocument getClusterResultInfo(MyBatisParameter parameter);

	/**
	 * @param parameter
	 *            seq : 분석번호 <br>
	 *            showMirian : Mirian 서비스 여부 <Y, N> <br>
	 */
	void updateShowMirian(MyBatisParameter parameter);

}
