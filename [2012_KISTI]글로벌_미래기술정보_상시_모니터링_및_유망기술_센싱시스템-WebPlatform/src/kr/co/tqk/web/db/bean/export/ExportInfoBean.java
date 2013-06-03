package kr.co.tqk.web.db.bean.export;

import java.io.Serializable;
import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

/**
 * 제우스에서 세션에 올바른 값을 넣어주기 위해서는 Serializable이 필수이다.
 * 
 * @author 정승한
 * 
 */
public class ExportInfoBean implements Serializable {

	private static final long serialVersionUID = -8459542921428621357L;

	private String ids, contents;

	public String getIds() {
		return UtilString.nullCkeck(ids);
	}

	public void setIds(String ids) {
		this.ids = ids;
	}

	public String getContents() {
		return UtilString.nullCkeck(contents);
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public Timestamp getINSERT_DATE() {
		return UtilString.nullCkeck(INSERT_DATE);
	}

	public void setINSERT_DATE(Timestamp iNSERT_DATE) {
		INSERT_DATE = iNSERT_DATE;
	}

	Timestamp INSERT_DATE;

	public ExportInfoBean(String info) {
		contents = info;
	}

}
