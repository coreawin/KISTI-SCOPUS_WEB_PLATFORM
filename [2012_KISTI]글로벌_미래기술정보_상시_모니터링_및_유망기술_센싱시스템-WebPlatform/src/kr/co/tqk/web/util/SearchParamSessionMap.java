/**
 * 
 */
package kr.co.tqk.web.util;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * @author coreawin
 * @sinse 2012. 10. 10.
 * @version 1.0
 * @history 2012. 10. 10. : 최초 작성 <br>
 * 
 */
public class SearchParamSessionMap implements Serializable {

	private static final long serialVersionUID = 4090139317199899223L;

	HashMap map = null;

	public SearchParamSessionMap() {
	}

	public HashMap getMap() {
		return map;
	}

	public void setMap(HashMap map) {
		this.map = map;
	}

}
