<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Map parameterMap = request.getParameterMap();

%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
function send(){
	var form = document.getElementById("parameter");
	form.submit();
}
</script>
</head>
<body onload="javascript:send();">
	<form action="" method="get" name="parameter" id="parameter">
<%
	for(Object key : parameterMap.keySet()){
		out.println("<input type=\"hidden\" name=\""+key+"\" value=\""+parameterMap.get(key)+"\"/>");
	}
%>		
	</form>
</body>
</html>