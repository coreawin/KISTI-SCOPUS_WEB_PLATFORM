/**
 * 
 */
package kr.co.tqk.web.mail;

import java.net.MalformedURLException;
import java.util.Properties;

import kr.co.tqk.web.util.UtilString;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.HtmlEmail;

/**
 * 아파치 이메일 컴포넌트를 이용하여<br>
 * scopus.kisti.re.kr시스템에 신규 사용자가 가입을 하게 되면 <br>
 * 등록된 관리자계정의 이메일 주소로 가입한 사용자 정보를 이메일로 보낸다..<br>
 * 
 * @author coreawin
 * @sinse 2012. 10. 4.
 * @version 1.0
 * @history 2012. 10. 4. : 최초 작성 <br>
 * 
 */
public class MailSender {

	/**
	 * @param host
	 *            SMTP host name
	 * @param receiveEmails
	 *            받는 사람 이메일
	 * @param receiveNames
	 *            받는 사람이름
	 * @param sendEmail
	 *            보내는 사람 메일
	 * @param sendName
	 *            보내는 사람
	 * @param title
	 *            보내는 메일 제목
	 * @param id
	 *            가입자 ID
	 * @param name
	 *            가입자명
	 * @param email
	 *            가입자 이메일
	 * @param department
	 *            가입자 기타 정보
	 * @param date
	 *            가입일.
	 * @throws EmailException
	 * @throws MalformedURLException
	 */
	public MailSender(String host, String[] receiveEmails, String[] receiveNames, String sendEmail, String sendName,
			String title, String id, String name, String email, String department, String date) throws EmailException,
			MalformedURLException {
		Properties props = new Properties();
		props.put("mail.smtp.auth", "true");
		HtmlEmail mail = new HtmlEmail();
		mail.setCharset("UTF-8");
		// mail.setHostName("150.183.95.93");
		mail.setHostName(host);
		for (int i = 0; i < receiveEmails.length; i++) {
			String em = UtilString.nullCkeck(receiveEmails[i], true);
			if(!"".equals(em)){
				mail.addTo(em, receiveNames[i]);
			}
		}
		mail.setFrom(sendEmail, sendName);
		// mail.setFrom("scopus@kisti.re.kr", "scopus admin");
		mail.setSubject(title);
		mail.setHtmlMsg(getHTMLContents(id, name, email, department, date));
		mail.setTextMsg("Your email client does not support HTML messages");
		mail.send();
	}

	/**
	 * 보내는 메일 내용을 HTML형식으로 채운다.
	 * 
	 * @param id
	 *            가입자 ID
	 * @param name
	 *            가입자명
	 * @param email
	 *            가입자 이메일
	 * @param department
	 *            가입자 기타 정보
	 * @param date
	 *            가입일.
	 * @return
	 */
	public String getHTMLContents(String id, String name, String email, String department, String date) {
		StringBuffer sb = new StringBuffer();
		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
		sb.append("<html><head>");
		sb.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
		sb.append("<title>SCOPUS 정보검색 플랫폼</title>");
		sb.append("</head><body>");
		sb.append("다음 사용자가 <a href=\"http://scopus.kisti.re.kr\">http://scopus.kisti.re.kr</a> 사이트에 가입하셨습니다. <br>");
		sb.append("이 메일을 받으신 분은 scopus 정보검색 플랫폼의 관리자입니다.<br>");
		sb.append("Administrator 메뉴를 통해 해당 사용자의 사이트 사용유무를 결정해 주세요.<br>");
		sb.append("<hr>");
		sb.append("<b>ID</b> : " + id + " <br>");
		sb.append("<b>Name</b> : " + name + " <br>");
		sb.append("<b>E-Mail</b> : " + email + " <br>");
		sb.append("<b>Department</b> : " + department + " <br>");
		sb.append("<hr>");
		sb.append("<b>요청일</b> : " + date + " <br>");
		sb.append("</body><hr></html>");

		return sb.toString();
	}

}
