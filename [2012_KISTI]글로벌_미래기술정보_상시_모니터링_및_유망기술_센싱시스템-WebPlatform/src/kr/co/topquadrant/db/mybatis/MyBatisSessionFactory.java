package kr.co.topquadrant.db.mybatis;

import java.io.IOException;
import java.io.Reader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MyBatisSessionFactory {

	public static SqlSessionFactory sqlSessionFactory = null;

	public static SqlSessionFactory getInstance() {
		if (sqlSessionFactory == null) {
			Reader reader = null;
			try {
				String resource = "myBatis/Configuration.xml";
				reader = Resources.getResourceAsReader(resource);
				sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
				reader.close();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (reader != null)
					try {
						reader.close();
					} catch (IOException e) {
						/* ignore */
					}
			}
		}
		return sqlSessionFactory;
	}
	
	public static void main(String[] args){
	}

}
