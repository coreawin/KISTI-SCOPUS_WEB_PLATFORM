package kr.co.topquadrant.util;

/**
 * 저자의 이름을 [Kim YB] 와 같은 형태로 표준화 시킨다. <br>
 * 2012년 7월 4일 KISTI 회의결과에 따른 내용. 
 * 
 * @author coreawin
 * @since 2012.07.09
 */
public class AuthorNameCleansing {

//	Kupich R.W.
//	Bingol H.
//	Akgemci E.G.
//	Wang S.S.-S.
//	Liang Y.-T.
//	van der Wal G.
//	Sanguinetti Ferreira R.A.
//	Ouwe-Missi-Oukem-Boyer O.N.
//	Alvarez de Mon Soto M.
//	Wainwright-De La Cruz S.E.
//	Davidson-Arnott R.G.D.
	
	public static String cleansing(String s){
		return s.replaceAll("\\.-", "").replaceAll("\\.", "").replaceAll("-", " ");
	}
	
	public static void main(String[] args){
		System.out.println(AuthorNameCleansing.cleansing("Kupich R.W."));
		System.out.println(AuthorNameCleansing.cleansing("Bingol H."));
		System.out.println(AuthorNameCleansing.cleansing("Wang S.S.-S."));
		System.out.println(AuthorNameCleansing.cleansing("Liang Y.-T."));
		System.out.println(AuthorNameCleansing.cleansing("Sanguinetti Ferreira R.A."));
		System.out.println(AuthorNameCleansing.cleansing("Ouwe-Missi-Oukem-Boyer O.N."));
		System.out.println(AuthorNameCleansing.cleansing("Wainwright-De La Cruz S.E."));
		System.out.println(AuthorNameCleansing.cleansing("Davidson-Arnott R.G.D."));
		System.out.println(AuthorNameCleansing.cleansing("van Eerd-Vismale J."));
	}
	
}
