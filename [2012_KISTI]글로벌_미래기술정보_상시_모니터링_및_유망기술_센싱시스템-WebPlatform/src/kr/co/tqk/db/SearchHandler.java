package kr.co.tqk.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

import kr.co.tqk.db.dao.ASJCDao;
import kr.co.tqk.db.dao.SourceCountryDao;
import kr.co.tqk.db.dao.SourceDao;
import kr.co.tqk.db.dao.SourceTypeDao;
import kr.co.tqk.web.db.dao.CitationDao;

public class SearchHandler {
	public static LinkedList<SourceTypeDao> selectSourceType() throws SQLException{

		String query = "select * from scopus_source_type " ;
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<SourceTypeDao> list=new LinkedList<SourceTypeDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			
			psmt = conn.prepareStatement(query);

			rs = psmt.executeQuery();
			SourceTypeDao article = null;

			while(rs.next()){
				article=new SourceTypeDao();
				article.setCode(rs.getString(1));
				article.setDescription(rs.getString(2));
				
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<SourceTypeDao> selectCitationType() throws SQLException{
		
		String query = "select * from SCOPUS_CITATION_TYPE " ;
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<SourceTypeDao> list=new LinkedList<SourceTypeDao>();
		
		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			
			psmt = conn.prepareStatement(query);
			
			rs = psmt.executeQuery();
			SourceTypeDao article = null;
			
			while(rs.next()){
				article=new SourceTypeDao();
				article.setCode(rs.getString(1));
				article.setDescription(rs.getString(2));
				
				list.add(article);
			}
			
		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<SourceCountryDao>  selectCountry() throws SQLException{
		
		String query = " SELECT DISTINCT UPPER(country_code) AS country_code, description from SCOPUS_COUNTRY_CODE where length(country_code) > 2 ORDER BY country_code " ;
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<SourceCountryDao> list=new LinkedList<SourceCountryDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			psmt = conn.prepareStatement(query);
			rs = psmt.executeQuery();
			SourceCountryDao article = null;

			while(rs.next()){
				article=new SourceCountryDao();
				article.setCountry_code(rs.getString(1));
				article.setCountry_name(rs.getString(2));
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<SourceCountryDao>  selectCountrySearch(String code) throws SQLException{
			
			String query = " SELECT DISTINCT UPPER(country_code) AS country_code, description from SCOPUS_COUNTRY_CODE " +
					" where length(country_code) > 2 and " +
					" (upper(description) like upper('%"+code+"%') or " +
					"	upper(country_code) like upper('%"+code+"%')) order by country_code" ;
			
			Connection conn = null;
			PreparedStatement psmt = null;
			ResultSet rs = null;
			ConnectionFactory factory = null;
			
			LinkedList<SourceCountryDao> list=new LinkedList<SourceCountryDao>();
	
			try {
				factory = ConnectionFactory.getInstance();
				conn = factory.getConnection();
				
				psmt = conn.prepareStatement(query);
	
				rs = psmt.executeQuery();
				SourceCountryDao article = null;
	
				while(rs.next()){
					article=new SourceCountryDao();
					article.setCountry_code(rs.getString(1));
					article.setCountry_name(rs.getString(2));
					
					list.add(article);
				}
	
			} catch (SQLException e) {
				throw new SQLException(e.getMessage());
			} finally {
				if (factory != null)
					factory.release(rs, psmt, conn);
			}
			return list;
		}
	
	public static LinkedList<SourceDao>  selectSource() throws SQLException{
			
			String query = "select * from scopus_source_info " ;
			
			Connection conn = null;
			PreparedStatement psmt = null;
			ResultSet rs = null;
			ConnectionFactory factory = null;
			
			LinkedList<SourceDao> list=new LinkedList<SourceDao>();
	
			try {
				factory = ConnectionFactory.getInstance();
				conn = factory.getConnection();
				
				psmt = conn.prepareStatement(query);
	
				rs = psmt.executeQuery();
				SourceDao article = null;
	
				while(rs.next()){
					article=new SourceDao();
					article.setSource_id(rs.getString(1));
					article.setSource_title(rs.getString(2));
					
					list.add(article);
				}
	
			} catch (SQLException e) {
				throw new SQLException(e.getMessage());
			} finally {
				if (factory != null)
					factory.release(rs, psmt, conn);
			}
			return list;
		}
	
	public static LinkedList<SourceDao>  selectSourceSearch(String title) throws SQLException{
		
		boolean isPrefix = false;
		boolean isPostfix = false;
		if(title.startsWith("*")){
			isPrefix = true;
		}
		if(title.endsWith("*")){
			isPostfix = true;
		}
		
		title = title.replaceAll("\\*", "");
		if(isPrefix){
			title = "%" + title;
		}
		if(isPostfix){
			title = title + "%";
		}
		System.out.println(title);
		String query = "select * from scopus_source_info" +
				" where upper(source_title) like upper(?)" +
						" or upper(source_id) like upper(?) order by source_title " ;
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<SourceDao> list=new LinkedList<SourceDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			psmt = conn.prepareStatement(query);
			psmt.setString(1, title);
			psmt.setString(2, title);

			rs = psmt.executeQuery();
			SourceDao article = null;

			while(rs.next()){
				article=new SourceDao();
				article.setSource_id(rs.getString(1));
				article.setSource_title(rs.getString(2));
				
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<ASJCDao>  selectASJC() throws SQLException{
		
		String query = "select * from scopus_asjc" +
				" order by asjc_code  " ;
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<ASJCDao> list=new LinkedList<ASJCDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			psmt = conn.prepareStatement(query);

			rs = psmt.executeQuery();
			ASJCDao article = null;

			while(rs.next()){
				article=new ASJCDao();
				article.setAsjc_code(rs.getString(1));
				article.setDescription(rs.getString(2));
				
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<ASJCDao>  selectASJC(String code) throws SQLException{
		int code_ch=0;
		code_ch=Integer.parseInt(code)+1000;
		
		String query = "select * from scopus_asjc " +
				"  where  asjc_code >= "+code+" and asjc_code < "+String.valueOf(code_ch)+" " +
				" order by asjc_code  " ;
		
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		
		
		LinkedList<ASJCDao> list=new LinkedList<ASJCDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			psmt = conn.prepareStatement(query);

			rs = psmt.executeQuery();
			ASJCDao article = null;

			while(rs.next()){
				article=new ASJCDao();
				article.setAsjc_code(rs.getString(1));
				article.setDescription(rs.getString(2));
				
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
	
	public static LinkedList<ASJCDao>  selectASJCSearch(String code, String asjc) throws SQLException{
		String query = "";
		int code_ch=0;
		
		if("all".equals(code.trim())){
			query = "select * from scopus_asjc" +
			" where upper(description) like upper('%"+asjc+"%')" +
					" or  upper(asjc_code) like upper('%"+asjc+"%')" +
							" order by asjc_code " ;
		}else{
			code_ch=Integer.parseInt(code)+1000;
			query = "select * from scopus_asjc" +
			" where  asjc_code >= "+code+" and asjc_code < "+String.valueOf(code_ch)+"" +
			" and upper(description) like upper('%"+asjc+"%')" +
					" or  upper(asjc_code) like upper('%"+asjc+"%')" +
							" order by asjc_code " ;
		}
		
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		ConnectionFactory factory = null;
		
		LinkedList<ASJCDao> list=new LinkedList<ASJCDao>();

		try {
			factory = ConnectionFactory.getInstance();
			conn = factory.getConnection();
			
			psmt = conn.prepareStatement(query);

			rs = psmt.executeQuery();
			ASJCDao article = null;

			while(rs.next()){
				article=new ASJCDao();
				article.setAsjc_code(rs.getString(1));
				article.setDescription(rs.getString(2));
				
				list.add(article);
			}

		} catch (SQLException e) {
			throw new SQLException(e.getMessage());
		} finally {
			if (factory != null)
				factory.release(rs, psmt, conn);
		}
		return list;
	}
}
