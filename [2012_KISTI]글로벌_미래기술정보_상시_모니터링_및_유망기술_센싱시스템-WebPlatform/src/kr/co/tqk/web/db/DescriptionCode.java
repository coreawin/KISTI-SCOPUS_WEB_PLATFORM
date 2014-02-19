package kr.co.tqk.web.db;

import java.util.HashMap;
import java.util.Map;

import kr.co.tqk.web.db.bean.ScopusSourceInfoBean;
import kr.co.tqk.web.db.dao.ScopusTypeDao;

public class DescriptionCode {

	private static Map<String, String> citationType = null;
	private static Map<String, String> sourceType = null;

	private static Map<String, String> asjcTypeKorea = null;
	private static Map<String, String> asjcTypeEng = null;

	private static Map<String, String> countryType = null;

	private static Map<String, String> affiliationName = null;

	private static Map<String, ScopusSourceInfoBean> sourceInfo = null;

	private Map<String, String> affilationCodeMap = new HashMap<String, String>(100);

	static {
		sourceType = ScopusTypeDao.getSourceTypeList();
		citationType = ScopusTypeDao.getCitationTypeList();
		asjcTypeKorea = ScopusTypeDao.getAsjcDescription(true);
		countryType = ScopusTypeDao.getCountryCodeDescription();
		affiliationName = ScopusTypeDao.getKistiAffiliation();
		sourceInfo = ScopusTypeDao.getSourceInfoList();
	}

	public static Map<String, String> getSourceTypeDescription() {
		return sourceType;
	}

	public static Map<String, String> getAsjcTypeKoreaDescription() {
		if (asjcTypeKorea == null) {
			asjcTypeKorea = ScopusTypeDao.getAsjcDescription(true);
		}
		return asjcTypeKorea;
	}

	public static Map<String, String> getAsjcTypeEngDescription() {
		if (asjcTypeEng == null) {
			asjcTypeEng = ScopusTypeDao.getAsjcDescription(false);
		}
		return asjcTypeEng;
	}

	public static Map<String, String> getCountryType() {
		if (countryType == null) {
			countryType = ScopusTypeDao.getCountryCodeDescription();
			countryType.put("", "");
		}
		return countryType;
	}

	public static Map<String, String> getCitationType() {
		if (citationType == null) {
			citationType = new HashMap<String, String>();
		}
		return citationType;
	}

	public Map<String, String> getAffilationInfo() {
		return affilationCodeMap;
	}

	public static void setAffilationInfo(String k, String v) {
	}

	public static final String[] ALPHABET = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "l", "o", "p", "q", "r", "s", "t", "u", "v",
			"w", "x", "y", "z" };

	public static void main(String[] args) {
		System.out.println(DescriptionCode.getCountryType());

	}

	public Map<String, String> getAffilationCodeMap() {
		return affilationCodeMap;
	}

	/**
	 * 대표화된 기관정보를 DB에서 가져온다. <br>
	 * 최초 한번 로딩
	 * 
	 * @return
	 */
	public static Map<String, String> getAffiliationName() {
		return affiliationName;
	}

	public static Map<String, ScopusSourceInfoBean> getSourceInfo() {
		return sourceInfo;
	}

}
