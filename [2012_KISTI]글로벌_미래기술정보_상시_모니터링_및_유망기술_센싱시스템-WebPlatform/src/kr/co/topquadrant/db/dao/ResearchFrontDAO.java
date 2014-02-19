package kr.co.topquadrant.db.dao;

import java.util.List;
import java.util.Map;

import kr.co.topquadrant.db.bean.ClusterDocument;
import kr.co.topquadrant.db.bean.ClusterResultSummary;
import kr.co.topquadrant.db.bean.RFAnalysis;
import kr.co.topquadrant.db.bean.RFAnalysisCluster;
import kr.co.topquadrant.db.bean.RFAnalysisOption;
import kr.co.topquadrant.db.bean.RFClusterInfo;
import kr.co.topquadrant.db.mybatis.MyBatisParameter;
import kr.co.topquadrant.db.mybatis.MyBatisSessionFactory;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;

/**
 * ResearchFront Table에서 데이터를 추가,수정,삭제작업을 하는 DAO클래스
 * 
 * @author 정승한
 * 
 */
public class ResearchFrontDAO implements IResearchFrontDao {

	public List<RFAnalysis> selectAllAnalysis() {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisMapper.selectAllAnaylsis", new MyBatisParameter());
		} finally {
			session.close();
		}
	}

	public RFAnalysis selectAnalysis(int seq) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectOne("RFAnalysisMapper.selectOneAnaylsis", seq);
		} finally {
			session.close();
		}
	}

	public List<String> selectAnalysisAsjc(int seq) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisMapper.selectAnaylsisASJC", seq);
		} finally {
			session.close();
		}
	}
	
	public void insertAnalysis(RFAnalysis bean) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			session.insert("RFAnalysisMapper.insertAnaylsis", bean);
			session.insert("RFAnalysisMapper.insertAnaylsisAsjc", bean);
			session.commit();
		} finally {
			session.close();
		}
	}

	public void deleteAnalysis(int seq) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			session.delete("RFAnalysisMapper.deleteAnaylsis", seq);
			session.commit();
		} finally {
			session.close();
		}
	}

	public List<RFAnalysis> selectAllAnalysis(MyBatisParameter parameter) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisMapper.selectAllAnaylsis", parameter);
		} finally {
			session.close();
		}
	}

	public List<RFAnalysisCluster> selectAllAnalysisCluster(MyBatisParameter parameter) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisClusterMapper.selectAllAnaylsisCluster", parameter);
		} finally {
			session.close();
		}
	}
	
	public List<ClusterResultSummary> selectAllAnaylsisClusterSeq(MyBatisParameter parameter) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisClusterMapper.selectAllAnaylsisClusterSeq", parameter);
		} finally {
			session.close();
		}
	}

	public List<RFAnalysisOption> selectAnalysisOptionALL() {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("RFAnalysisMapper.selectAllAnaylsisOption");
		} finally {
			session.close();
		}
	}

	public void insertAnalysisOption(RFAnalysisOption option) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			session.insert("RFAnalysisMapper.insertAnaylsisOption", option);
			session.commit();
		} finally {
			session.close();
		}
	}
	
	public ClusterDocument getClusterResultInfo(MyBatisParameter parameter) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			RFClusterInfo info = session.selectOne("RFAnalysisClusterMapper.selectOneAnaylsisResultInfo", parameter);
			ClusterDocument cd = new Gson().fromJson(info.getData(), ClusterDocument.class);
			cd.setUpdateFlag(info.getUpdateFlag());
			return cd;
		} finally {
			session.close();
		}
	}

	public void deleteAnalysis(int seq, int consecutiveNumber, int update_flag) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			MyBatisParameter parameter = new MyBatisParameter();
			parameter.setSeq(seq);
			parameter.setConsecutiveNumber(consecutiveNumber);
			parameter.setUpdate_flag(update_flag);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisClusterDocument", parameter);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisClusterASJC", parameter);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisClusterDomestic", parameter);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisClusterInfo", parameter);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisClusterKeyword", parameter);
			session.delete("RFAnalysisClusterMapper.deleteAnaylsisCluster", parameter);
			session.commit();
		} finally {
			session.close();
		}
	}

	/* (non-Javadoc)
	 * @see kr.co.topquadrant.db.dao.IResearchFrontDao#updateShowMirian(kr.co.topquadrant.db.mybatis.MyBatisParameter)
	 */
	public void updateShowMirian(MyBatisParameter parameter) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			session.update("RFAnalysisMapper.updateAnaylsisShowMirian", parameter);
			session.commit();
		} finally {
			session.close();
		}
	}

	@Override
	public void deleteStopWord(int seq) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertStopWord(String keyword) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Map<Integer, String> selectStopWord(MyBatisParameter parameter) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int selectTotalStopWord() {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
