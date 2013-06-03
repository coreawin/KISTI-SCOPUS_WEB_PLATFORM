/**
 * 
 */
package kr.co.tqk.web;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * 필터 검색식 자료 구조.
 * 
 * @author coreawin
 * @sinse 2012. 10. 11.
 * @version 1.0
 * @history 2012. 10. 11. : 최초 작성 <br>
 * 
 */
public class FilterSearchRule {
	private Map<String, String> map = new HashMap<String, String>();
	private Set<String> set = new HashSet<String>();
	private final String KEY_TYPE = "_TYPE";
	private final String KEY_VALUE = "_VALUE";

	public FilterSearchRule() {

	}

	/**
	 * @param field
	 *            필드명
	 * @param type
	 *            검색타입
	 * @param value
	 *            검색어.
	 */
	public void add(String field, String type, String value) {
		if (field == null || type == null || value == null)
			throw new NullPointerException("Null입력은 허용하지 않습니다.");
		this.set.add(field);
		this.map.put(field + KEY_TYPE, type);
		this.map.put(field + KEY_VALUE, value);
		System.out.println("field " + field);
		System.out.println("type " + type);
		System.out.println("value " + value);
	}

	public Set<String> getFields() {
		return set;
	}

	public boolean containsField(String field) {
		return set.contains(field);
	}

	public String getType(String field) {
		return this.map.get(field + KEY_TYPE);
	}

	public String getValue(String field) {
		return this.map.get(field + KEY_VALUE);
	}

	public int sizeFields() {
		return set.size();
	}
}