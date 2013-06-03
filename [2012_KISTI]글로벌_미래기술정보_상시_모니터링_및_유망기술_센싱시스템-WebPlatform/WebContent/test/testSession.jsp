<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="kr.co.tqk.web.util.UtilSearchParameter"%>
<%@page import="java.util.HashMap"%>
<%@page import="kr.co.tqk.web.db.bean.UserBean"%>
<%@page import="java.util.HashSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" session="true" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Export Data</title>
<link href="<%=request.getContextPath() %>/css/nano_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.js"></script>
<script type="text/javascript">



function download(fileName, filePath){
	var form = document.getElementById("parameter");
	form.fileName.value = fileName;
	form.filePath.value = filePath;
	form.action = "./download.jsp";
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
	
	auto_refresh = setInterval(
		function (){
			$.ajax({
			  type: 'POST',
			  url: './testSessionInfo.jsp',
			  success: writeProcessInfo
			});
		}, 1000
	);
	
	auto_refresh = setInterval(
		function (){
			$.ajax({
			  type: 'POST',
			  url: './testSessionAjax.jsp',
			  success: success
			});
		}, 1000
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

function writeProcessInfo(data){
	if(data.indexOf("javascript:download")!=-1){
		clearInterval(auto_refresh);
		$('#downloadImages').html("");
	}
	$('#load_tweets').html(data).fadeIn("slow");
}

function success(data){
	data = jQuery.trim(data);
	if(""!=data){
		alert(data);
	}
}

</script>
</head>

<body  style="background:#FFFFFF;">

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
													Status : <span id="downloadImages"><img src="<%=request.getContextPath() %>/images/fadingSqure.gif" border="0"/></span> <span id="load_tweets">Ready for export.</span>
													
												</td>
                                            </tr>
                                        </table></td>
                                </tr>
                            </table>
                     		</div>
				 	</tr>
				</table></td>
		</tr>
	</table>
</div>
</body>
</html>