<%@ page contentType="text/html;charset=euc-kr" %>

<html>
	<head></head>
	<body>
<%
	session.invalidate();
%>
	<script>
		location.href="session_test.jsp";
	</script>
	</body>
</html>

