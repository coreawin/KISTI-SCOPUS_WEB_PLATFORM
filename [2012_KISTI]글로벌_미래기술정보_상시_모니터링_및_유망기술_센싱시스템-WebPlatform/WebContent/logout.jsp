<%@include file="./common/common.jsp" %>
<script>
<%
	session.removeAttribute(USER_SESSION);
	out.println("location.href=\""+contextPath+"/login.jsp\";");
%>
</script>