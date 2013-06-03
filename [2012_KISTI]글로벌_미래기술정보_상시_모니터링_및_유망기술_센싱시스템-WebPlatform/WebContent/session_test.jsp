<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%
	InetAddress inet = InetAddress.getLocalHost();
	String IP = inet.getHostAddress();
	out.println("IP : " + IP);
%>
<%
	System.out.println("=========== Session Test ==============");

	String s_name = request.getParameter("s_name");
	String s_value = request.getParameter("s_value");

	if (s_name != null && s_name.length() > 0 &&
		s_value != null && s_value.length() > 0)
	{
		session.setAttribute(s_name, s_value+" ("+IP+")");
	}
%>
<html>
<head>
	<title>Session Test</title>
</head>
<body>
<br/>
<br/>
Cookies:
<br/>
<%
   Cookie[] cookies = request.getCookies();
   if (cookies != null) {
      for (int i = 0; i < cookies.length; i++) {
      out.println(cookies[i].getName() + ":" + cookies[i].getValue() + "<br>");
      }
   }
%>


<br/>
<br/>
Sessions:
<br/>
<%

	Enumeration en = session.getAttributeNames();
	while (en.hasMoreElements())
	{
		String name = (String)en.nextElement();
		String value = (String)session.getAttribute(name);
%>
<%=name%>=<%=value%>
<br>
<%
	}
%>
<br>
<hr>
<br>

<form name="s_form" method="post" action="session_test.jsp">
    <table border="1">
        <tr>
            <td width="200">
                <p>session name</p>
            </td>
            <td width="200">
                <p>session value</p>
            </td>
        </tr>
        <tr>
            <td width="200">
                <p><input type="text" name="s_name"></p>
            </td>
            <td width="200">
                <p><input type="text" name="s_value"></p>
            </td>
        </tr>
    </table>
    <p><input type="submit" name="send_btn" value="세션저장"></p>
</form>

<form name="clear_form" method="post" action="session_clear.jsp">
	<p><input type="submit" value="session.invalidate()"></p>	
</form>

</body>
</html>

