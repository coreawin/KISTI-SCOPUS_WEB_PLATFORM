package kr.co.tqk.db;

import kr.co.topquadrant.common.db.connection.AConnectionPoolFactory;
import kr.co.topquadrant.common.db.connection.exception.TQKCommonDBException;
import kr.co.topquadrant.common.db.connection.prop.AConnectionPoolProperties;
import kr.co.topquadrant.common.db.connection.prop.ConnectionPropertiesCommon;

/**
 * @author neon
 * 
 *         2009. 06. 16
 */
public class ConnectionFactoryBak extends AConnectionPoolFactory {

	private static ConnectionFactoryBak instance = null;

	public static synchronized ConnectionFactoryBak getInstance()
			throws TQKCommonDBException {
		if (instance == null) {
			instance = new ConnectionFactoryBak();
		}
		return instance;
	}
	
	private ConnectionFactoryBak() throws TQKCommonDBException {
		super();
	}

	protected AConnectionPoolProperties createConnectionProperty() {
//		 return new ConnectionPropertiesCommon("kisti", "kisti",
//		 "jdbc:oracle:thin:@192.168.0.60:1521:ORCL",
//		 getOracleDBDriverName());
//		 return new ConnectionPropertiesCommon("scopuskisti", "scopuskistitqk",
//		 "jdbc:oracle:thin:@192.168.0.60:1521:ORCL",
//		 getOracleDBDriverName());
		return new ConnectionPropertiesCommon("scopus", "scopus+11",
				"jdbc:oracle:thin:@203.250.196.44:1551:KISTI5",
				getOracleDBDriverName());
	}
}
