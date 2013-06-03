package kr.co.tqk.web.util;

/**
 * 플랫폼 이용에 관한 플래그 클래스.
 * 
 * @author 정승한
 * 
 */
public class UserUsePlatformDefinition {
	/**
	 * 정보검색 플랫폼에서 EXPORT 할경우.
	 */
	public static final int ACTION_EXPORT = 200;
	
	/**
	 * 사용자가 로그인한 횟수.
	 */
	public static final int ACTION_LOGIN = 300;

	/**
	 * 사용자가 검색한 횟수.(퀵 검색은 제외하고, 논문 검색, 저자검색, 기관검색을 했을 경우)
	 */
	public static final int ACTION_SEARCHING = 400;
}
