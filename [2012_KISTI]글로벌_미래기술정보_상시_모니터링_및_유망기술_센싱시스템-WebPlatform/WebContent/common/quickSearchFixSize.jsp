<form id="quickSearchParameter" method="post">
   	<input type="hidden" name="authorSeq"/>
   	<input type="hidden" name="searchRule"/>
   	<input type="hidden" name="currentPage"/>
   	<input type="hidden" name="searchTerm"/>
</form>
<link href="<%=request.getContextPath() %>/js/plugin/tipTipv13/tipTip.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath() %>/js/plugin/tipTipv13/jquery.tipTip.minified.js"></script>    
<script type="text/javascript">
function quicksearch(){
	var form = document.getElementById("quickSearchParameter");
	var keyword = jQuery.trim(document.getElementById("quickword").value);
	if(""==keyword){
		alert("Input search term please;");
		document.getElementById("quickword").focus();
		return;
	}
	form.currentPage.value = "1";
	form.searchRule.value = "se={title,abs,keyword:"+keyword+":1:32}&ft=";
	//(TITLE-ABS-KEY("+keyword+"))";
	form.searchTerm.value = keyword;
	//form.searchRule.value = "(TITLE-ABS-KEY("+keyword+"))";
	//form.searchTerm.value = keyword;
	form.action="<%=request.getContextPath()%>/documentSearch/catresult.jsp";
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
<table class="search" border="0" cellpadding="0" cellspacing="0" >
	<tr height="40">
		<td valign="middle">
			<span class="txt7" style="text-shadow: 1px 1px 2px #999; margin-left: 10px" ><img alt="" src="../images/001_40.png" align="bottom" width="16" height="16"> <%=menuTerm %></span>
		</td>
		<td width="47%" align="right" class="e-tit">
     		Quick Search : <input type="text" id="quickword" class="input_txt" name="quickword" onkeypress="javascript:enterCheck();" title="제목, 초록, 키워드를 대상으로 빠르게 검색합니다." />
			<input type="button" class="bt5 tipTipClass" value="Search"  onclick="javascript:quicksearch();" title="제목, 초록, 키워드를 대상으로 빠르게 검색합니다."/>  		 
     	</td>
		<td valign="middle" width='10' align="right"></td>
	</tr>
</table>