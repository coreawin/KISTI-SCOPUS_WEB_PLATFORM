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
 * ����ġ �̸��� ������Ʈ�� �̿��Ͽ�<br>
 * scopus.kisti.re.kr�ý��ۿ� �ű� ����ڰ� ������ �ϰ� �Ǹ� <br>
 * ��ϵ� �����ڰ����� �̸��� �ּҷ� ������ ����� ������ �̸��Ϸ� ������..<br>
 * 
 * @author coreawin
 * @sinse 2012. 10. 4.
 * @version 1.0
 * @history 2012. 10. 4. : ���� �ۼ� <br>
 * 
 */
public class MailSender {

	/**
	 * @param host
	 *            SMTP host name
	 * @param receiveEmails
	 *            �޴� ��� �̸���
	 * @param receiveNames
	 *            �޴� ����̸�
	 * @param sendEmail
	 *            ������ ��� ����
	 * @param sendName
	 *            ������ ���
	 * @param title
	 *            ������ ���� ����
	 * @param id
	 *            ������ ID
	 * @param name
	 *            �����ڸ�
	 * @param email
	 *            ������ �̸���
	 * @param department
	 *            ������ ��Ÿ ����
	 * @param date
	 *            ������.
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
	 * ������ ���� ������ HTML�������� ä���.
	 * 
	 * @param id
	 *            ������ ID
	 * @param name
	 *            �����ڸ�
	 * @param email
	 *            ������ �̸���
	 * @param department
	 *            ������ ��Ÿ ����
	 * @param date
	 *            ������.
	 * @return
	 */
	public String getHTMLContents(String id, String name, String email, String department, String date) {
		StringBuffer sb = new StringBuffer();
		sb.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">");
		sb.append("<html><head>");
		sb.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
		sb.append("<title>SCOPUS �����˻� �÷���</title>");
		sb.append("</head><body>");
		sb.append("���� ����ڰ� <a href=\"http://scopus.kisti.re.kr\">http://scopus.kisti.re.kr</a> ����Ʈ�� �����ϼ̽��ϴ�. <br>");
		sb.append("�� ������ ������ ���� scopus �����˻� �÷����� �������Դϴ�.<br>");
		sb.append("Administrator �޴��� ���� �ش� ������� ����Ʈ ��������� ������ �ּ���.<br>");
		sb.append("<hr>");
		sb.append("<b>ID</b> : " + id + " <br>");
		sb.append("<b>Name</b> : " + name + " <br>");
		sb.append("<b>E-Mail</b> : " + email + " <br>");
		sb.append("<b>Department</b> : " + department + " <br>");
		sb.append("<hr>");
		sb.append("<b>��û��</b> : " + date + " <br>");
		sb.append("</body><hr></html>");

		return sb.toString();
	}

}
