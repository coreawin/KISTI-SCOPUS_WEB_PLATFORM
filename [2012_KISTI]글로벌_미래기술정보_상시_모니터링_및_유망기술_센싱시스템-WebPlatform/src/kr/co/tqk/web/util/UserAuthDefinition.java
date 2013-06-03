package kr.co.tqk.web.util;

/**
 * ����� ���� ���� �Ķ����
 * 
 * @author coreawin
 * @sinse 2012. 8. 31.
 * @version 1.0
 * @history ���� �뿪 : ���� �ۼ� <br>
 *          2012. 8. 31 : ���δ�� �ʵ� �߰� �� enumŸ������ ����.
 */
public class UserAuthDefinition {

	/**
	 * AUTH_SUPER : �ְ� ������ ����<br>
	 * AUTH_POWER : �Ŀ� ����� ���� - 10000���� Export ��������� ���� ����<br>
	 * AUTH_GENERAL : �Ϲ� ����� ����<br>
	 * AUTH_WAITING ; ���� ��� �����<br>
	 * 
	 * @author coreawin
	 * @sinse 2012. 9. 12.
	 * @version 1.0
	 * @history 2012. 9. 12. : ���� �ۼ� <br>
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
	 * ���� ������.
	 */
	// public static final String AUTH_SUPER = "A";
	/**
	 * �Ϲ� �����
	 */
	// public static final String AUTH_GENERAL = "G";
	/**
	 * ����� ���� ��� �ʵ�
	 */
	// public static final String AUTH_WAITING = "W";
	// public static final String AUTH_ALL = "ALL";

}
