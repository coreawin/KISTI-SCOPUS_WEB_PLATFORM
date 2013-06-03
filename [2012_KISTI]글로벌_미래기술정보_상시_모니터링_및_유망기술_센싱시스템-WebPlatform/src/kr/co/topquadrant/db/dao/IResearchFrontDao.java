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
	 * ��ϵ� �м��׸��� �����´�.
	 * 
	 * @return
	 */
	List<RFAnalysis> selectAllAnalysis();

	/**
	 * ��ϵ� �м� �׸��� ����¡ �ؼ� �����´�.
	 * 
	 * @param requestPage
	 *            ��û ������ ��ȣ
	 * @param rows
	 *            ��ȭ�鿡 ��µǴ� row����
	 * @param orderColumn
	 *            ���� Į��
	 * @param sord
	 *            ���� ����.
	 * @return
	 */
	List<RFAnalysis> selectAllAnalysis(MyBatisParameter parameter);

	/**
	 * ��ϵ� �м��׸��� �����´�.
	 * 
	 * @param seq
	 *            �м� �׸� ���̵�.
	 * @return
	 */
	RFAnalysis selectAnalysis(int seq);
	
	/**
	 * ��ϵ� �м��׸��� ASJC �ڵ带 �����´�.
	 * 
	 * @param seq
	 *            �м� �׸� ���̵�.
	 * @return
	 */
	List<String> selectAnalysisAsjc(int seq); 

	/**
	 * �м��׸��� ����Ѵ�.
	 * 
	 * @param bean
	 */
	void insertAnalysis(RFAnalysis bean);

	/**
	 * �м��׸��� �����Ѵ�.
	 * 
	 * @param seq
	 *            �м� �Ϸù�ȣ
	 * @param consecutiveNumber
	 *            �м���� �Ϸù�ȣ
	 * @param updateFlag
	 *            �м���� ������Ʈ��ȣ.
	 */
	void deleteAnalysis(int seq, int consecutiveNumber, int updateFlag);

	/**
	 * ��� Ŭ������ �м������ ���� ��ົ�� �����´�
	 * 
	 * @param parameter
	 *            �Ķ���� ����.
	 * @return
	 */
	List<RFAnalysisCluster> selectAllAnalysisCluster(MyBatisParameter parameter);

	/**
	 * Ư�� �м��� ��� Ŭ������ �м������ ���� ��ົ�� �����´�
	 * 
	 * @param parameter
	 *            �Ķ���� ����.
	 * @return
	 */
	public List<ClusterResultSummary> selectAllAnaylsisClusterSeq(MyBatisParameter parameter);

	/**
	 * �м��׸��� �����Ѵ�.
	 * 
	 * @param seq
	 */
	void deleteAnalysis(int seq);

	List<RFAnalysisOption> selectAnalysisOptionALL();

	void insertAnalysisOption(RFAnalysisOption option);

	/**
	 * �� Ŭ������ �м� ������ �����´�.<br>
	 * 
	 * @param seq
	 *            �м� ��ȣ
	 * @param consecutiveNumber
	 *            Ŭ������ �Ϸ� ��ȣ.
	 * @return
	 */
	ClusterDocument getClusterResultInfo(MyBatisParameter parameter);

	/**
	 * @param parameter
	 *            seq : �м���ȣ <br>
	 *            showMirian : Mirian ���� ���� <Y, N> <br>
	 */
	void updateShowMirian(MyBatisParameter parameter);

}
