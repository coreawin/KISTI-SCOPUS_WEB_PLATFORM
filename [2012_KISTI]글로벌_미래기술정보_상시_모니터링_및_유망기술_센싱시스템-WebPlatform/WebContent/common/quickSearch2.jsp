<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="<%=request.getContextPath() %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath() %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<script type="text/javascript">
function quicksearch(){
	var form = document.getElementById("quickSearch2Parameter");
	var keyword = jQuery.trim(document.getElementById("quickword2").value);
	if(""==keyword){
		alert("Input search term please;");
		document.getElementById("quickword2").focus();
		return;
	}
	form.currentPage.value = "1";
	//form.searchRule.value = "(TITLE-ABS-KEY("+keyword+"))";
	form.searchRule.value = "se={title,abs,keyword:"+keyword+":1:32}&ft=";
	//(TITLE-ABS-KEY("+keyword+"))";
	form.searchTerm.value = keyword;
	form.action="./catresult.jsp";
	form.submit();
}

function enterCheck() {
	getEvent=event.keyCode;
	if (getEvent == "13") {			
		quicksearch();
	}
}
$(document).ready(function() {
	$(".bt5").tipTip({maxWidth: "auto", edgeOffset: 10});
	$(".input_txt").tipTip({maxWidth: "auto", edgeOffset: 10});
});
</script>
<link href="<%=request.getContextPath() %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath() %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>
<span>
Quick Search : <input type="text" id="quickword2" class="input_txt" name="quickword2" onkeypress="javascript:enterCheck();" title="제목, 초록, 키워드를 대상으로 빠르게 검색합니다." />
<input type="button" class="bt5 tipTipClass" value="Search"  onclick="javascript:quicksearch();" title="제목, 초록, 키워드를 대상으로 빠르게 검색합니다."/> 
</span>
<form id="quickSearch2Parameter" method="post">
   	<input type="hidden" name="authorSeq"/>
   	<input type="hidden" name="searchRule"/>
   	<input type="hidden" name="currentPage"/>
   	<input type="hidden" name="searchTerm"/>
   </form>