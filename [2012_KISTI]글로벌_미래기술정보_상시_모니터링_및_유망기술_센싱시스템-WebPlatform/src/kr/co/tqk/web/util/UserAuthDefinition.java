package kr.co.tqk.web.util;

/**
 * 사용자 권한 정의 파라미터
 * 
 * @author coreawin
 * @sinse 2012. 8. 31.
 * @version 1.0
 * @history 나노 용역 : 최초 작성 <br>
 *          2012. 8. 31 : 승인대기 필드 추가 및 enum타입으로 변경.
 */
public class UserAuthDefinition {

	/**
	 * AUTH_SUPER : 최고 관리자 권한<br>
	 * AUTH_POWER : 파워 사용자 권한 - 10000건의 Export 제약사항을 없앤 권한<br>
	 * AUTH_GENERAL : 일반 사용자 권한<br>
	 * AUTH_WAITING ; 승인 대기 사용자<br>
	 * 
	 * @author coreawin
	 * @sinse 2012. 9. 12.
	 * @version 1.0
	 * @history 2012. 9. 12. : 최초 작성 <br>
	 * 
	 */
	public enum UserAuthEnum {
		AUTH_SUPER("A"), AUTH_GENERAL("G"), AUTH_WAITING("W"), AUTH_ALL("F"), AUTH_POWER("P");
		private String authCode = null;

		UserAuthEnum(String authCode) {
			this.authCode = authCode;
		}

		public String getAuth() {
			return authCode;
		}
	}

	/**
	 * 슈퍼 관리자.
	 */
	// public static final String AUTH_SUPER = "A";
	/**
	 * 일반 사용자
	 */
	// public static final String AUTH_GENERAL = "G";
	/**
	 * 사용자 승인 대기 필드
	 */
	// public static final String AUTH_WAITING = "W";
	// public static final String AUTH_ALL = "ALL";

}
