package kr.co.tqk.web.db.dao.cluster;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import kr.co.tqk.db.ConnectionFactory;
import kr.co.tqk.web.db.bean.cluster.ClusterDataBean;
import kr.co.tqk.web.db.bean.cluster.ClusterRegistBean;
import kr.co.tqk.web.db.bean.cluster.ClusterSimilityDataBean;

import org.apache.commons.collections.keyvalue.MultiKey;

/**
 * 클러스터 관련 DB를 핸들링한다.
 * 
 * @author 정승한
 * 
 */
public class ClusterDao {

	/**
	 * 새로운 클러스터 데이터를 등록한다.
	 * 
	 * @param beans
	 * @throws SQLException
	 */
	public static synchronized void registClusterRegist(ClusterRegistBean bean,
			LinkedList<ClusterDataBean> dataBeans,
			LinkedList<ClusterSimilityDataBean> simBeans) throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;

		try {
			StringBuffer query = new StringBuffer();
			query.append(" insert into CLUSTER_REGIST values(CLUSTER_REGIST_SEQUENCE.Nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_DATE) ");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setString(1, bean.getUserId());
			psmt.setString(2, bean.getTitle());
			psmt.setString(3, bean.getDescription());
			psmt.setString(4, bean.getFilename());
			psmt.setFloat(5, bean.getThreshold());
			psmt.setInt(6, bean.getMaxClusterCnt());
			psmt.setInt(7, bean.getMinClusterCnt());
			psmt.setInt(8, bean.getDocCnt());
			psmt.setInt(9, bean.getTotalDocCnt());
			psmt.execute();
			psmt.close();
			
			query.setLength(0);
			query.append(" insert into CLUSTER_DATA values(CLUSTER_DATA_SEQUENCE.nextVal, CLUSTER_REGIST_SEQUENCE.Currval, ?, ?, ?) ");
			psmt = conn.prepareStatement(query.toString());
			for (ClusterDataBean dataBean : dataBeans) {
				psmt.setString(1, dataBean.getClusterKey());
				psmt.setString(2, dataBean.getEids());
				psmt.setString(3, dataBean.getIsdel());
				psmt.execute();
			}
			psmt.close();

			query.setLength(0);
			query.append(" insert into CLUSTER_SIMILITY_DATA values(CLUSTER_REGIST_SEQUENCE.Currval, ?, ?, ?) ");
			psmt = conn.prepareStatement(query.toString());
			for (ClusterSimilityDataBean simBean : simBeans) {
				for (Object key : simBean.getKeyMap().keySet()) {
					MultiKey mk = (MultiKey) key;
					String word1 = String.valueOf(mk.getKey(0));
					String word2 = String.valueOf(mk.getKey(1));
					psmt.setString(1, word1);
					psmt.setString(2, word2);
					psmt.setString(3,
							String.valueOf(simBean.getSimility(word1, word2)));
					psmt.execute();
				}
			}
			psmt.close();
			conn.commit();
		} catch (SQLException e) {
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * 모든 클러스터 데이터를 삭제한다.
	 * 
	 * @param beans
	 * @throws SQLException
	 */
	public static synchronized void deleteClusterAll(int clusterRegistSeq)
			throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;

		try {

			StringBuffer query = new StringBuffer();
			query.append(" delete from CLUSTER_REGIST where SEQ =?");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.execute();

			query.setLength(0);
			query.append(" delete from CLUSTER_DATA where CLUSTER_REGIST_SEQ = ? ");
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.execute();

			query.setLength(0);
			query.append(" delete from CLUSTER_SIMILITY_DATA where CLUSTER_REGIST_SEQ = ? ");
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.execute();

			conn.commit();
		} catch (SQLException e) {
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}
	
	/**
	 * 모든 클러스터 데이터를 삭제한다.
	 * 
	 * @param beans
	 * @throws SQLException
	 */
	public static synchronized void deleteClusterAll(List<Integer> seqList)
	throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		
		try {
			
			StringBuffer query = new StringBuffer();
			query.append(" delete from CLUSTER_REGIST where SEQ =?");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			for(Integer clusterRegistSeq : seqList){
				psmt.setInt(1, clusterRegistSeq);
				psmt.execute();
			}
			psmt.close();
			
			query.setLength(0);
			query.append(" delete from CLUSTER_DATA where CLUSTER_REGIST_SEQ = ? ");
			psmt = conn.prepareStatement(query.toString());
			for(Integer clusterRegistSeq : seqList){
				psmt.setInt(1, clusterRegistSeq);
				psmt.execute();
			}
			psmt.close();
			
			query.setLength(0);
			query.append(" delete from CLUSTER_SIMILITY_DATA where CLUSTER_REGIST_SEQ = ? ");
			psmt = conn.prepareStatement(query.toString());
			for(Integer clusterRegistSeq : seqList){
				psmt.setInt(1, clusterRegistSeq);
				psmt.execute();
			}
			psmt.execute();
			psmt.close();
			
			conn.commit();
		} catch (SQLException e) {
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * 클러스터 데이터만을 삭제한다.
	 * 
	 * @param beans
	 * @throws SQLException
	 */
	public static synchronized void deleteClusterData(int clusterRegistSeq)
			throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;

		try {
			StringBuffer query = new StringBuffer();
			query.setLength(0);
			query.append(" delete from CLUSTER_DATA where CLUSTER_REGIST_SEQ = ? ");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.execute();

			query.setLength(0);
			query.append(" delete from CLUSTER_SIMILITY_DATA where CLUSTER_REGIST_SEQ = ? ");
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.execute();

			conn.commit();
		} catch (SQLException e) {
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}
	
	/**
	 * 클러스터 데이터만을 삭제한다.
	 * 
	 * @param beans
	 * @throws SQLException
	 */
	public static synchronized void deleteClusterData(int clusterRegistSeq, String ClusterKey)
	throws SQLException {
		ConnectionFactory cf = null;
		Connection conn = null;
		PreparedStatement psmt = null;
		
		try {
			StringBuffer query = new StringBuffer();
			query.setLength(0);
			query.append(" delete from CLUSTER_DATA where CLUSTER_REGIST_SEQ = ? and CLUSTER_KEY = ?");
			cf = ConnectionFactory.getInstance();
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query.toString());
			psmt.setInt(1, clusterRegistSeq);
			psmt.setString(2, ClusterKey);
			psmt.execute();
			
			conn.commit();
		} catch (SQLException e) {
			conn.rollback();
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * CLUSTER_DATA 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ClusterDataBean> selectClusterDataAll(
			int clusterRegistSeq) {
		LinkedList<ClusterDataBean> result = new LinkedList<ClusterDataBean>();
		ClusterDataBean bean = null;
		String query = ""
				+ "	select SEQ, CLUSTER_REGIST_SEQ, CLUSTER_KEY, EIDS, ISDEL from CLUSTER_DATA where CLUSTER_REGIST_SEQ=? order by SEQ, CLUSTER_KEY";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setInt(1, clusterRegistSeq);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ClusterDataBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setClusterRegistSeq(rs.getInt("CLUSTER_REGIST_SEQ"));
				bean.setClusterKey(rs.getString("CLUSTER_KEY"));
				bean.setEids(rs.getString("EIDS"));
				bean.setIsdel(rs.getString("ISDEL"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * CLUSTER_DATA 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static ClusterSimilityDataBean selectClusterSimilityDataAll(
			int clusterRegistSeq) {
		ClusterSimilityDataBean bean = new ClusterSimilityDataBean();
		String query = ""
				+ "	select CLUSTER_REGIST_SEQ, WORD1, WORD2, SIMILITY from CLUSTER_SIMILITY_DATA where CLUSTER_REGIST_SEQ=? ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setInt(1, clusterRegistSeq);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean.setClusterRegistSeq(rs.getInt("CLUSTER_REGIST_SEQ"));
				bean.addSimilityData(rs.getString("WORD1"),
						rs.getString("WORD2"), rs.getString("SIMILITY"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return bean;
	}

	/**
	 * CLUSTER_DATA 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ClusterDataBean> selectClusterDataAll(
			int clusterRegistSeq, String clusterKey) {
		LinkedList<ClusterDataBean> result = new LinkedList<ClusterDataBean>();
		ClusterDataBean bean = null;
		String query = ""
				+ "	select SEQ, CLUSTER_REGIST_SEQ, CLUSTER_KEY, EIDS, ISDEL from CLUSTER_DATA where CLUSTER_REGIST_SEQ=? and CLUSTER_KEY=? order by SEQ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setInt(1, clusterRegistSeq);
			psmt.setString(2, clusterKey.trim());
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ClusterDataBean();
				bean.setClusterRegistSeq(rs.getInt("CLUSTER_REGIST_SEQ"));
				bean.setClusterKey(rs.getString("CLUSTER_KEY"));
				bean.setEids(rs.getString("EIDS"));
				bean.setIsdel(rs.getString("ISDEL"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}
		return result;
	}

	/**
	 * CLUSTER_DATA 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 * @throws SQLException
	 */
	public static void updateClusterDataIsDel(
			int seq, String isDel) throws SQLException {
		String query = ""
			+ "	update CLUSTER_DATA set ISDEL= ? where SEQ=?";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, isDel);
			psmt.setInt(2, seq);
			psmt.executeUpdate();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			cf.release(psmt, conn);
		}
	}

	/**
	 * CLUSTER_REGIST 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ClusterRegistBean> selectClusterRegiAll(
			String userID) {
		LinkedList<ClusterRegistBean> result = new LinkedList<ClusterRegistBean>();
		ClusterRegistBean bean = null;
		String query = "select SEQ, USER_ID, TITLE, DESCRIPTION, FILENAME, THRESHOLD, MAXCLUSTER, MINCLUSTER, DOC_CNT, TOTAL_DOC_CNT, REGIST_DATE from CLUSTER_REGIST where USER_ID=? order by SEQ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID.trim());
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ClusterRegistBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserId(userID);
				bean.setTitle(rs.getString("TITLE"));
				bean.setDescription(rs.getString("DESCRIPTION"));
				bean.setFilename(rs.getString("FILENAME"));
				bean.setThreshold(rs.getFloat("THRESHOLD"));
				bean.setMaxClusterCnt(rs.getInt("MAXCLUSTER"));
				bean.setMinClusterCnt(rs.getInt("MINCLUSTER"));
				bean.setDocCnt(rs.getInt("DOC_CNT"));
				bean.setTotalDocCnt(rs.getInt("TOTAL_DOC_CNT"));
				bean.setRegistDate(rs.getTimestamp("REGIST_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

	/**
	 * CLUSTER_REGIST 테이블에서 데이터를 가져온다.
	 * 
	 * @return
	 */
	public static LinkedList<ClusterRegistBean> selectClusterRegiAll(
			String userID, int pageNumber, int viewDataCount) {
		LinkedList<ClusterRegistBean> result = new LinkedList<ClusterRegistBean>();
		ClusterRegistBean bean = null;
		String query = ""
				+ "	select * from ("
				+ "		select rounum as rnum, A.* from ( "
				+ "			select SEQ, USER_ID, TITLE, DESCRIPTION, FILENAME, THRESHOLD, MAXCLUSTER, MINCLUSTER, REGIST_DATE from CLUSTER_REGIST where USER_ID=?  order by SEQ DESC"
				+ "		) A where rownum <=? "
				+ "	) where rnum >= ? order by SEQ desc ";
		ConnectionFactory cf = ConnectionFactory.getInstance();
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		try {
			conn = cf.getConnection();
			psmt = conn.prepareStatement(query);
			psmt.setString(1, userID.trim());
			psmt.setInt(2, (pageNumber * viewDataCount));
			psmt.setInt(3, (pageNumber - 1) * viewDataCount + 1);
			rs = psmt.executeQuery();
			while (rs.next()) {
				bean = new ClusterRegistBean();
				bean.setSeq(rs.getInt("SEQ"));
				bean.setUserId(userID);
				bean.setTitle(rs.getString("TITLE"));
				bean.setDescription(rs.getString("DESCRIPTION"));
				bean.setFilename(rs.getString("FILENAME"));
				bean.setThreshold(rs.getFloat("THRESHOLD"));
				bean.setMaxClusterCnt(rs.getInt("MAXCLUSTER"));
				bean.setMinClusterCnt(rs.getInt("MINCLUSTER"));
				bean.setDocCnt(rs.getInt("DOC_CNT"));
				bean.setTotalDocCnt(rs.getInt("TOTAL_DOC_CNT"));
				bean.setRegistDate(rs.getTimestamp("REGIST_DATE"));
				result.add(bean);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			cf.release(rs, psmt, conn);
		}

		return result;
	}

}
