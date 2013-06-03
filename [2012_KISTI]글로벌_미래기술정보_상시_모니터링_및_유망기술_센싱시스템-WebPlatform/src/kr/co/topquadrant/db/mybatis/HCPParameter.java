package kr.co.topquadrant.db.mybatis;

public class HCPParameter {

	int tableRanking = 1;
	double ranking = 0;
	String publication_year, asjc_code;

	public int getTableRanking(){
		tableRanking = (int)(getRanking()*100); 
		return tableRanking;
	}

	public double getRanking() {
		return ranking;
	}

	public void setRanking(double ranking) {
		this.ranking = ranking;
	}

	public String getPublication_year() {
		return publication_year;
	}

	public void setPublication_year(String publication_year) {
		this.publication_year = publication_year;
	}

	public String getAsjc_code() {
		return asjc_code;
	}

	public void setAsjc_code(String asjc_code) {
		this.asjc_code = asjc_code;
	}

}
