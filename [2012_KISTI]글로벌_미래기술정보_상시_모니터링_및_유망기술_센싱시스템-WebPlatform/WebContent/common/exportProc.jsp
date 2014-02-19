<%@page import="java.util.Date"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="kr.co.tqk.web.util.UtilSearchParameter"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="java.util.HashSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" 
    pageEncoding="UTF-8"%>
<%@include file="./auth.jsp" %>      
<%
	//out.println(request.getHeader("REFERER"));
	HashMap<String, String> searchParameter = UtilSearchParameter.getSearchParameter(baseRequest);
	String sessionID = request.getSession().getId() + System.currentTimeMillis() + userBean.getId();
	
	String info = String.valueOf(session.getAttribute(request.getSession().getId() + "_EXPORT_INFO"));
	if(info.indexOf("javascript:download")!=-1){
		session.removeAttribute(request.getSession().getId() + "_EXPORT_INFO");
	}
	String exportFormat = baseRequest.getParameter("exportType");
	int totalSize = baseRequest.getInteger("totalSize", 0);
	int selectDocSize = baseRequest.getInteger("selectDocSize", 0);
	
	int data_range = baseRequest.getInteger("data_range", 0);
	int startNumber = 1;
	int endNumber = data_range;
	if(data_range < 0){
		
	}else{
		startNumber = baseRequest.getInteger("start_data_range", 0);
		endNumber = baseRequest.getInteger("end_data_range", 0);
	}
	
	String[] BASIC_CHECK = baseRequest.getParameterValues("BASIC_CHECK", new String[]{});
	String[] AUTHOR_CHECK = baseRequest.getParameterValues("AUTHOR_CHECK", new String[]{});
	String[] SOUCRCE_CHECK = baseRequest.getParameterValues("SOUCRCE_CHECK", new String[]{});
	String[] CORRES_CHECK = baseRequest.getParameterValues("CORRES_CHECK", new String[]{});
	
	StringBuffer checkList = new StringBuffer();
	for(String s : BASIC_CHECK){
		checkList.append(s);
		checkList.append(";");
	}
	for(String s : AUTHOR_CHECK){
		checkList.append(s);
		checkList.append(";");
	}
	for(String s : SOUCRCE_CHECK){
		checkList.append(s);
		checkList.append(";");
	}
	for(String s : CORRES_CHECK){
		checkList.append(s);
		checkList.append(";");
	}
	//System.out.println("=========> " + checkList);
	
	String saveFileName = System.currentTimeMillis() +"_" + request.getSession().getId() +".xlsx";
	
	if("excel".equalsIgnoreCase(exportFormat)){
		saveFileName = System.currentTimeMillis() +"_" + request.getSession().getId() +".xlsx";
	}else{
		saveFileName = System.currentTimeMillis() +"_" + request.getSession().getId() +".txt";
	}
	
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Export Data</title>
<link href="<%=contextPath %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript">

function download(fileName, filePath){
	var form = document.getElementById("parameter");
	form.fileName.value = fileName;
	form.filePath.value = filePath;
	form.action = "./download.jsp";
	form.target="_blank";
	form.method ="post";
	form.submit();
}
var auto_refresh = null;
var ajaxRe = null;

function cancel(){
	if(ajaxRe){
		//ajaxRe.abort();
	}
}

$(document).ready(function() {
	
	ajaxRe = $.ajax({
	  type: 'POST',
	  url: './exportAjax.jsp',
	  data: $("#parameter").serialize(),
	  success: success
	});
	
	auto_refresh = setInterval(
		function (){
			$.ajax({
			  type: 'POST',
			  url: './exportInfo.jsp',
			  data: $("#parameter").serialize(),
			  success: writeProcessInfo
			});
		}, 2000
	);
	
	
	 document.onkeydown = noEvent;   
	 
});
function noEvent() { 
     if (event.keyCode == 116) {
          event.keyCode= 2;
           return false;
    }
    else if(event.ctrlKey && (event.keyCode==78 || event.keyCode == 82))
    {
           return false;
     }
}
var xhr = null;
function writeProcessInfo(data){
	if(data.indexOf("javascript:download")!=-1){
		clearInterval(auto_refresh);
		$('#downloadImages').html("");
		xhr = $.ajax({
		  type: 'POST',
		  data: $("#parameter2").serialize(),
		  url: './removeExportSession.jsp',
		  success: success
		});
	}
	$('#load_tweets').html(data).fadeIn("slow");
}

function success(data){
	//data = jQuery.trim(data);
	//if(""!=data){
	//	alert(data);
	//}
}

function unload(){
	try{
		if(auto_refresh!=null){
			//auto_refresh.abort();
		}
		if(ajaxRe!=null){
			ajaxRe.abort();
		}
		if(xhr!=null){
			xhr.abort();
		}
	}finally{
		self.close();
	}
}

</script>
</head>

<body  style="background:#FFFFFF;" onunload="javascript:unload();">

<div id="content_popup">
<input type="hidden" id="asjc_select" name="asjc_select"  >
<input type="hidden" id="firstVal"  name="firstVal" />

	<table cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="640" cellpadding="0" cellspacing="0">
					<tr>
						<td background="../images/nn_search_popup_bg.gif" width="640" height="17"></td>
				 	</tr>
					<tr>
					 	<td>
                        	<div><h1 class="tit_txt_3"> Export Status</h1></div>

                       	 	<div class="viewA">
                          	<table class="Table" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <table class="Table1_1" border="0" cellpadding="0" cellspacing="0" align="center" summary="ASJC 선택 테이블">
                                            <tr>
												<td height="25" valign="middle" class="txt">
													Status : <span id="downloadImages"><img src="<%=contextPath %>/images/fadingSqure.gif" border="0"/></span> <span id="load_tweets" style="vertical-align: middle;">Ready for export.</span>
												</td>
                                            </tr>
                                            <!-- 
                                            <tr>
												<td height="25" valign="middle" class="txt">
													<a href="javascript:unload();" > 취 소</a>
												</td>
                                            </tr>
                                             -->
                                        </table></td>
                                </tr>
                            </table>
                     		</div>
				 	</tr>
				</table></td>
		</tr>
	</table>
</div>
<form id="parameter">
	<input type="hidden" name="filePath" />
	<input type="hidden" name="fileName" />
	<input type="hidden" name="totalSize" value="<%=totalSize%>"/>
	<input type="hidden" name="selectDocSize" value="<%=selectDocSize%>"/>
	<input type="hidden" name="cn" value="<%=searchParameter.get("cn") %>" />
   	<input type="hidden" name="se" value="<%=searchParameter.get("se").replaceAll("\"", "&quot;") %>" />
   	<input type="hidden" name="fl" value="<%=searchParameter.get("fl") %>" />
   	<input type="hidden" name="sn" value="<%=searchParameter.get("sn") %>" />
   	<input type="hidden" name="ln" value="<%=searchParameter.get("ln") %>" />
   	<input type="hidden" name="gr" value="<%=searchParameter.get("gr") %>" />
   	<input type="hidden" name="ra" value="<%=searchParameter.get("ra") %>" />
   	<input type="hidden" name="ft" value="<%=searchParameter.get("ft") %>" />
   	<input type="hidden" name="ht" value="<%=searchParameter.get("ht") %>" />
   	<input type="hidden" name="ud" value="<%=searchParameter.get("ud") %>" />
	<input type="hidden" name="userID" value="<%=userBean.getId()%>"/>
	<input type="hidden" name="data_range" value="<%=data_range%>"/>
	<input type="hidden" name="startNumber" value="<%=startNumber%>"/>
	<input type="hidden" name="endNumber" value="<%=endNumber%>"/>
	<input type="hidden" name="checkList" value="<%=checkList.toString()%>"/>
	<input type="hidden" name="exportFormat" value="<%=exportFormat%>"/>
	<input type="hidden" name="sessionID" value="<%=sessionID%>"/>
</form>

<form id="parameter2">
	<input type="hidden" name="sessionID" value="<%=sessionID%>"/>
</form>

</body>
</html>