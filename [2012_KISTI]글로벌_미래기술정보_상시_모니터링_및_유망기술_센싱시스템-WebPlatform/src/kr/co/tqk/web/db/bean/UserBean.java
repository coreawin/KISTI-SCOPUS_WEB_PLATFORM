package kr.co.tqk.web.db.bean;

import java.io.Serializable;
import java.sql.Timestamp;

import kr.co.tqk.web.util.UtilString;

/**
 * @author Á¤½ÂÇÑ
 * 
 */
public class UserBean implements Serializable{

	private static final long serialVersionUID = -7593509949291945872L;
	Timestamp regist;
	String id, pwd, names, email, department, auth;

	public Timestamp getRegist() {
		return regist;
	}

	public void setRegist(Timestamp regist) {
		this.regist = regist;
	}

	public String getId() {
		return UtilString.nullCkeck(id);
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPwd() {
		return UtilString.nullCkeck(pwd);
	}

	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	public String getNames() {
		return UtilString.nullCkeck(names);
	}

	public void setNames(String names) {
		this.names = names;
	}

	public String getEmail() {
		return UtilString.nullCkeck(email);
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getDepartment() {
		return UtilString.nullCkeck(department);
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getAuth() {
		return UtilString.nullCkeck(auth);
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

}
