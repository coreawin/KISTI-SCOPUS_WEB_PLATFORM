package kr.co.topquadrant.db.dao;

import java.util.List;

import kr.co.topquadrant.db.bean.HCP;
import kr.co.topquadrant.db.bean.HCPDocument;
import kr.co.topquadrant.db.bean.HCPYearInfo;
import kr.co.topquadrant.db.mybatis.HCPParameter;
import kr.co.topquadrant.db.mybatis.MyBatisSessionFactory;

import org.apache.ibatis.session.SqlSession;

public class HCPDao implements IHCPDao {

	public List<HCP> selectHCPAllData(HCPParameter hcpParam) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("HCPMapper.selectHCP", hcpParam);
		} finally {
			session.close();
		}
	}

	public List<HCP> selectHCPLargeAllData(HCPParameter hcpParam) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("HCPMapper.selectLargeHCP", hcpParam);
		} finally {
			session.close();
		}
	}

	public List<HCPDocument> selectHCPDocument(HCPParameter hcpParam) {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("HCPMapper.selectDocument", hcpParam);
		} finally {
			session.close();
		}
	}

	public List<HCPYearInfo> selectHCPYearInfo() {
		SqlSession session = MyBatisSessionFactory.getInstance().openSession();
		try {
			return session.selectList("HCPMapper.yearInfo");
		} finally {
			session.close();
		}
	}

}
