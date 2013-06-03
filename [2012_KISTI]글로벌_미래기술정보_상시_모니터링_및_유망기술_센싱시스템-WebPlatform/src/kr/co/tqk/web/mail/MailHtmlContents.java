package kr.co.tqk.web.mail;

/**
 * ë©?? ê´?????´ë???
 * 
 * @author neon
 * 
 */
public class MailHtmlContents {

	private String mailHtmlContents = "";

	/**
	 * @param imgSrc
	 *            ë°°ê²½??©´ ?´ë?ì§?
	 * @param contents
	 *            ë§¤ì? ?´ì?.
	 */
	public MailHtmlContents(String imgSrc, String contents) {
		mailHtmlContents = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"> "
				+ "	<head>"
				+ "	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
				+ "	<title>Mail</title>"
				+ "	<style>"
				+ "	<!--"
				+ "		body { font-family:\"NanumGothic\", \"???ê³??\", \"Malgun Gothic\", \"ë§?? ê³??\", \"AppleGothic\", \"Lucida Grande\", gulim, \"êµ´ë¦¼\", dotum, \"???\", verdana, serif;"
				+ "		font-size: 13px;"
				+ "		line-height: 150%;"
				+ "		scrollbar-face-color: F2F2F2;"
				+ "		scrollbar-shadow-color:C9D3D8;"
				+ "		scrollbar-highlight-color: C9D3D8;"
				+ "		scrollbar-3dlight-color: #FFFFFF;"
				+ "		scrollbar-darkshadow-color: #FFFFFF;"
				+ "		scrollbar-track-color: F2F2F2;"
				+ "		scrollbar-arrow-color: C9D3D8;"
				+ "		scrollbar-base-color:E9E8E8;"
				+ "		td { font-family:\"NanumGothic\", \"???ê³??\", \"Malgun Gothic\", \"ë§?? ê³??\", \"AppleGothic\", \"Lucida Grande\", gulim, \"êµ´ë¦¼\", dotum, \"???\", verdana, serif; font-size:13px; color:#333333; line-height:230%;}"
				+ "	-->"
				+ "	</style>"
				+ "	</head>"
				+ "	<body bgcolor=\"#FFFFFF\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+ "	<table width=\"700\" height=\"900\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
				+ "	 	<tr>"
				+ "			<td align=\"center\" valign=\"top\" style=\"background:url("
				+ imgSrc
				+ ")\">"
				+ "				<table width=\"600\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
				+ "   				<tr>"
				+ "	    				<td height=\"120\"></td>"
				+ "	   				</tr>"
				+ "   				<tr>"
				+ "	    				<td>"
				+ "	    					<table width=\"570\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
				+ "	                         	<tr>"
				+ "	                          		<td width=\"15\"></td>"
				+ "	                          		<td width=\"555\" align=\"left\" valign=\"top\">"
				+ contents
				+ "                                   </td>"
				+ "								</tr>"
				+ "	                        </table>"
				+ "						</td>"
				+ "   				</tr>"
				+ "	  			</table>"
				+ "			</td>" + "	 	</tr>" + "	</table>" + "</body>" + "";
	}

	public String getHTMLContents() {
		return mailHtmlContents;
	}

}
