<%@page import="com.websqrd.fastcat.user.kisti.DWPIQueryConverter"%>
<%@page import="kr.co.tqk.web.util.UtilString"%>
<%@page import="kr.co.tqk.web.util.SearchParamSessionMap"%>
<%@page import="kr.co.tqk.web.db.dao.ScopusTypeDao"%>
<%@page import="kr.co.tqk.web.util.InfoStack.InfoStackType"%>
<%@page
	import="com.sun.org.apache.bcel.internal.generic.StackInstruction"%>
<%@page import="kr.co.tqk.web.db.dao.AuthorInfoDao"%>
<%@page import="kr.co.tqk.web.util.InfoStack"%>
<%@page import="kr.co.tqk.web.db.DescriptionCode"%>
<%@page import="kr.co.tqk.web.db.bean.CitationBean"%>
<%@page import="kr.co.tqk.web.db.dao.CitationDao"%>
<%@page import="kr.co.tqk.web.util.UserUsePlatformDefinition"%>
<%@page import="kr.co.tqk.web.db.dao.UserUsePlatformDao"%>
<%@page import="kr.co.tqk.web.util.FastCatSearchUtil"%>
<%@page import="kr.co.tqk.analysis.util.NumberFormatUtil"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="org.apache.http.*"%>
<%@ page import="org.apache.http.client.*"%>
<%@ page import="org.apache.http.client.entity.*"%>
<%@ page import="org.apache.http.client.methods.*"%>
<%@ page import="org.apache.http.impl.client.*"%>
<%@ page import="org.apache.http.impl.client.*"%>
<%@ page import="org.apache.http.message.*"%>
<%@ page import="org.apache.http.protocol.HTTP"%>

<%@ page import="org.apache.http.params.*"%>

<%@page import="kr.co.tqk.web.db.dao.UserSearchRuleDao"%>
<%@include file="../common/auth.jsp"%>
<%

	Map<String, String> authorNameMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.AUTHOR_NAME));
	Map<String, Integer> authorNameFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.AUTHOR_NAME_FREQ));
	
	Map<String, String> affilationNameMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME));
	Map<String, Integer> affilationNameFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.AFFILATION_NAME_FREQ));
	
	Map<String, String> sourceTitleMap = (Map<String, String>)session.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE));
	Map<String, Integer> sourceTitleFreqMap = (Map<String, Integer>)session.getAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ));
	
	if(authorNameMap==null) authorNameMap = new HashMap<String, String>();
	if(authorNameFreqMap==null) authorNameFreqMap = new HashMap<String, Integer>();
	if(affilationNameMap==null) affilationNameMap = new HashMap<String, String>();
	if(affilationNameFreqMap==null) affilationNameFreqMap = new HashMap<String, Integer>();
	if(sourceTitleMap==null) sourceTitleMap = new HashMap<String, String>();
	if(sourceTitleFreqMap==null) sourceTitleFreqMap = new HashMap<String, Integer>();

	LinkedList<String> doiList = new LinkedList<String>();
	
	boolean searchMain = baseRequest.getBoolean("searchMain", false);
	
	if(searchMain){
		SearchParamSessionMap spsm = new SearchParamSessionMap();
		HashMap hm = new HashMap();
		hm.putAll(request.getParameterMap());
		spsm.setMap(hm);
		//System.out.println(hm);
		String[] tmp = (String[])hm.get("ASJC_text");
		/*if(tmp!=null){
			System.out.println("ASJC_text " + tmp[0]);
		}*/
		session.setAttribute("SEARCH_FORM", spsm);
	}
	
	int currentPage = baseRequest.getInteger("currentPage",1);
	int totalSize = baseRequest.getInteger("totalSize", 0);
	int viewData = baseRequest.getInteger("viewData",20);
	int pagingSize = baseRequest.getInteger("pagingSize", 10);
	boolean insertSearchRule = baseRequest.getBoolean("insertSearchRule", false);
	String searchRule = baseRequest.getParameter("searchRule", "").replaceAll("\n", " ");
	String searchTerm = request.getParameter("searchTerm");
	String dwpiTypeRule = searchRule;

	//System.out.println("========= catresult.jsp : <" + searchRule +">");
	
	boolean advanceRule = baseRequest.getBoolean("advanceRule", false);
	
	if(searchTerm!=null){
		searchTerm = searchTerm.replaceAll(",","\\\\,").replaceAll("&","\\\\&").replaceAll("=","\\\\=").replaceAll(":","\\\\:").replaceAll("\n", " ");
	}
	
	if(searchRule.startsWith("se=") || searchRule.startsWith("ft=")){
		advanceRule = false;
	}else{
		advanceRule = true;
	}
	
	//System.out.println("searchRule " + searchRule);
	//System.out.println("advanceRule " + advanceRule);
	
	if(advanceRule){
		dwpiTypeRule = searchRule.replaceAll("=," , "=");
		try{
			if(searchRule.indexOf("ki.")!=-1 || searchRule.indexOf("ki,")!=-1){
				searchRule = searchRule.replaceAll("ki.", "kw.").replaceAll("ki,", "kw,");
				//System.out.println("더 이상 ki필드는 추천되지 않습니다. kw필드를 사용해 주세요");
				//System.err.println("더 이상 ki필드는 추천되지 않습니다. kw필드를 사용해 주세요");
			}
			searchRule = new DWPIQueryConverter().convToFQuery(searchRule);
			//System.out.println("convert searchRule " + searchRule);
			if(searchRule.indexOf("null")!=-1){
				throw new Exception("지원하지 않는 검색필드명이 입력되었습니다. 검색식을 다시 확인해 주세요.");
			}
			if(searchRule==null){
				throw new Exception("올바른 고급 검색식이 아닙니다.");
			}
		}catch(Exception e){
			e.printStackTrace();
			out.println("<script>");
			out.println("alert(\"올바른 검색식이 아닙니다. "+dwpiTypeRule+" \");");
			out.println("history.back(-1);");
			out.println("</script>");
			//return;
		}
	}else{
		//out.println(searchRule);
		if(insertSearchRule){
			dwpiTypeRule = new DWPIQueryConverter().convToDQuery(searchRule);
			searchRule = new DWPIQueryConverter().convToFQuery(dwpiTypeRule);
		}else{
			dwpiTypeRule = new DWPIQueryConverter().convToDQuery(searchRule);
		}
		
		//out.println("<HR>");
		//out.println(dwpiTypeRule);
	}
	String command = "";

	if(insertSearchRule){
		session.removeAttribute(userBean.getId() + "_selectDocSet");
	}
	String se = "";
	String ft = "";
	String[] rules = searchRule.split("&");
	String fields = "title-abs-keyword";

	for(int i=0;i<rules.length;i++){
	    if(rules[i].startsWith("se=")){
		se = rules[i].substring(3);
		//System.out.println("se ==> " + se);
	    }else if(rules[i].startsWith("ft=")){
            ft = rules[i].substring(3);
        }
	}	
	
	String sort = baseRequest.getParameter("sort", "pubyear:desc,_score_:desc");
	
	int iTotalTotal = 0;
	String cn = "scopus";
	if(se == null || se.length() == 0){
	    //se = "{"+fields+":"+searchTerm+":1:32}";
	}
	
	//out.println("==> " + se);

	String fl = "eid,title,country,authorname,authorid,pubyear,affiliation,sourceid,sourcetitle,citcount,refcount,sourcetype,asjc,_score_,refeid,citeid,doi";
	String sn = ""+((currentPage-1)*20+1);//"1";
	if(ft == null || "".equals(ft)){
		ft = "";
	}
	//String gr = "asjc:freq:freq_desc:50,pubyear:freq:key_desc:50,country:freq:freq_desc:50,sourceid:freq:freq_desc:50,sourcetype:freq:freq_desc:50,afid:freq:freq_desc:50,authorid:freq:freq_desc:50,keyword:freq:freq_desc:50,cittype:freq:freq_desc:50";
	//String gr = "pubyear:freq:key_desc:50,asjc:freq:freq_desc:50,country:freq:freq_desc:50,sourceid:freq:freq_desc:50,sourcetype:freq:freq_desc:50,authorid:freq:freq_desc:50,keyword:freq:freq_desc:50,cittype:freq:freq_desc:50,dafname:freq:freq_desc:50";
	String gr = "pubyear:freq:key_desc:50,asjc:freq:freq_desc:50,country:freq:freq_desc:50,afid:freq:freq_desc:50,sourceid:freq:freq_desc:50,sourcetype:freq:freq_desc:50,authorid:freq:freq_desc:50,keyword:freq:freq_desc:50,cittype:freq:freq_desc:50,dafname:freq:freq_desc:50";
	String ra = sort;
	
	LinkedHashSet<String> selectedDocEIDSet = (LinkedHashSet<String>)session.getAttribute(userBean.getId() + "_selectDocSet");
	
	if(selectedDocEIDSet==null) 
		selectedDocEIDSet = new LinkedHashSet<String>(); 

	searchRule = "se="+se+"&ft="+ft;
	 //String ft = "asjc:match:2200"; // 'nod_subcate_name:prefix:xxx';,asjccode:match:24023104country:match:chn
	 String ht = ""+URLEncoder.encode("<font color\\=red>:</font>");
	 String ud = "";
	if(searchTerm != null && searchTerm.length() > 0)
	    ud = "keyword:"+searchTerm;
	 
	 JSONObject jsonobj = null;
	 ArrayList<NameValuePair> nvps = new ArrayList<NameValuePair>();
		nvps.add(new BasicNameValuePair("cn", cn));
		nvps.add(new BasicNameValuePair("se", se));
		nvps.add(new BasicNameValuePair("fl", fl));
		nvps.add(new BasicNameValuePair("sn", sn));
		nvps.add(new BasicNameValuePair("ln", String.valueOf(viewData)));
		nvps.add(new BasicNameValuePair("gr", gr));
		if(sort != null && !"".equals(sort)){
			nvps.add(new BasicNameValuePair("ra", ra));
		}
		nvps.add(new BasicNameValuePair("ft", ft));
		nvps.add(new BasicNameValuePair("ht", ht));
		nvps.add(new BasicNameValuePair("ud", ud));
		//search option for highlight
		nvps.add(new BasicNameValuePair("so", "highlight"));
		nvps.add(new BasicNameValuePair("timeout", "10000"));
		//Declare for fastcatSearchURL : /common/common.jsp
	
		jsonobj = FastCatSearchUtil.requestURL(fastcatSearchURL, nvps);
		//out.println("<!--");		
		//out.println("test log");		
		//out.println("status " + jsonobj.getInt("status"));
		//out.println("total_count " + jsonobj.getInt("total_count"));
		//out.println("total_count " + jsonobj.getJSONArray("result"));
		
		//out.println("-->");
	
	    //System.out.println(fastcatSearchURL+"****************");	
		if(jsonobj == null){
			//
			//검색에러발생
			//
			//TODO 에러화면을 보여줄수 있는 조치가 필요하다.
			//out.println("검색시 오류가 발견되었습니다.");
		}else{
			if(jsonobj.getInt("status") == 0){
				iTotalTotal = jsonobj.getInt("total_count");
			}
		}

		searchRule = searchRule.replaceAll("\"", "&quot;");
		dwpiTypeRule = dwpiTypeRule.replaceAll("\"", "&quot;");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SCOPUS 정보 검색 플랫폼 - 논문 검색 결과</title>
<link rel="SHORTCUT ICON"
	href="<%=request.getContextPath()%>/images/favicon.ico" />
<link href="<%=contextPath%>/css/nano_style.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery.effects.core.min.js"></script>
<script type="text/javascript">
function goDocumentInfo(eid){
	var form = document.getElementById("viewDocumentParameterForm"); 
	form.eid.value = eid;
	form.action="./viewDocument.jsp";
	form.submit();
}

function goAuthorInfo(authorSeq){
	var form = document.getElementById("parameter");
	form.authorSeq.value = authorSeq;
	form.action="./viewAuthor.jsp";
	form.submit();
}

function exportDoc(){
	var form = document.getElementById("parameter");
	if(form==null) return;
	form.action="./export.jsp";
	form.method="POST";
	form.submit();
}

function sortSearch(sortType){
	var form = document.getElementById("parameter");
	form.sort.value = sortType;
	form.action="./catresult.jsp";
	form.submit();
}

function searchWithLN(ln){
	var form = document.getElementById("parameter");
	//form.lnn.value = ln;
	form.viewData.value = ln;
	form.action="./catresult.jsp";
	form.submit();
}

function limitOrExclude(operation) {
	var searchRuleParamStr = ""; 
	/*
	 * 검색식을 세팅하기 위해 결과내 검색에서 항목 선택시 해당항목을 임시적으로
	 * 저장하는 변수.
	 */
	var form = document.getElementById("parameter");
	var searchRule = form.searchRule.value;
	var filter = "";
	var e = document.countryForm.elements.length;
	var cnt = 0;
	var ft = '<%=ft%>';
	var se = '<%=se%>';
	var hasFilter = false;

	if (ft != "") {
		hasFilter = true;
	}

	//1. country
	var flag = false;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.countryForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	
	if (flag) {
		filter += "country:"+operation+":";
		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.countryForm.elements[cnt].checked) {
				filter += document.countryForm.elements[cnt].value + ";";
			}
		}
		
		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//2. pubyear
	flag = false;
	e = document.yearForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.yearForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "pubyear:"+operation+":";
		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.yearForm.elements[cnt].checked) {
				filter += document.yearForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//3. asjc
	flag = false;
	e = document.asjcForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.asjcForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "asjc:"+operation+":";

		for (cnt = 0; cnt < e; cnt++) {
			if (document.asjcForm.elements[cnt].checked) {
				filter += document.asjcForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//4. sourcetype
	flag = false;
	e = document.sourceTypeForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.sourceTypeForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "sourcetype:"+operation+":";
		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.sourceTypeForm.elements[cnt].checked) {
				filter += document.sourceTypeForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//5. sourceid
	flag = false;
	e = document.sourceIdForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.sourceIdForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "sourceid:"+operation+":";

		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.sourceIdForm.elements[cnt].checked) {
				filter += document.sourceIdForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//6. afid
	flag = false;
	if(document.afidForm){
		e = document.afidForm.elements.length;
		cnt = 0;
		for (cnt = 0; cnt < e; cnt++) {
			if (document.afidForm.elements[cnt].checked) {
				flag = true;
				break;
			}
		}
		if (flag) {
			filter += "afid:"+operation+":";
	
			searchRuleParamStr = "";
			for (cnt = 0; cnt < e; cnt++) {
				if (document.afidForm.elements[cnt].checked) {
					filter += document.afidForm.elements[cnt].value + ";";
				}
			}
	
			if (filter.substring(filter.length - 1) == ";") {
				filter = filter.substring(0, filter.length - 1);
			}
			filter += ",";
		}
	}

	//7. author name 
	flag = false;
	e = document.authorNameForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.authorNameForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "authorid:"+operation+":";

		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.authorNameForm.elements[cnt].checked) {
				filter += document.authorNameForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

	//8. keyword
	flag = false;
	e = document.keywordForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.keywordForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "keyword:"+operation+":";

		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.keywordForm.elements[cnt].checked) {
				filter += document.keywordForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}

		//9. citation
	flag = false;
	e = document.citationForm.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.citationForm.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "cittype:"+operation+":";

		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.citationForm.elements[cnt].checked) {
				filter += document.citationForm.elements[cnt].value + ";";
			}
		}

		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}
	
		//10. delegate affiliation
		/*
	flag = false;
	e = document.dAffiliation.elements.length;
	cnt = 0;
	for (cnt = 0; cnt < e; cnt++) {
		if (document.dAffiliation.elements[cnt].checked) {
			flag = true;
			break;
		}
	}
	if (flag) {
		filter += "dafname:"+operation+":";

		searchRuleParamStr = "";
		for (cnt = 0; cnt < e; cnt++) {
			if (document.dAffiliation.elements[cnt].checked) {
				filter += document.dAffiliation.elements[cnt].value + ";";
			}
		}
		if (filter.substring(filter.length - 1) == ";") {
			filter = filter.substring(0, filter.length - 1);
		}
		filter += ",";
	}
*/

	filter = filter.substring(0, filter.length - 1);

	
	if (hasFilter)
		form.searchRule.value = 'se=' + jQuery.trim(se) + '&ft=' + ft + ','
				+ filter;
	else
		form.searchRule.value = 'se=' + jQuery.trim(se) + '&ft=' + filter;
	
	form.action = "./catresult.jsp";
	form.submit();
}

function searchInResult(){
	var form = document.getElementById("parameter");
	var st = " "+jQuery.trim(document.getElementById("searchTermInResult").value);
	if(""==st){
		alert("Input search term please;");
		document.getElementById("searchTermInResult").focus();
		return;
	}
	//form.searchRule.value = form.searchRule.value + " and ALL("+st+")"
	//form.searchRule.value = "se=<%--=se.substring(0,se.length()-1)--%>"+st+"}";
	form.searchRule.value = 'se={<%=se%>AND{title,abs,keyword:'+jQuery.trim(st)+':1:103}}';
	form.currentPage.value = "1";
	form.searchTerm.value+=" "+st;
	form.action="./catresult.jsp";
	form.submit();
}


function toggleImage(jQueryObj){
	var imgSrc = jQueryObj.attr("src");
	if(imgSrc=="<%=request.getContextPath()%>/images/nn_search_arrow01.gif"){
		jQueryObj.attr("src", "<%=request.getContextPath()%>/images/nn_search_arrow02.gif"); 
	}else{
		jQueryObj.attr("src", "<%=request.getContextPath()%>/images/nn_search_arrow01.gif");
	}
}

function searchRefCit(type, objID){
	var form = document.getElementById("parameter");
	var eidList = $("#"+objID).attr("value");
	if($.trim(eidList) == "")
		return;
	form.searchTerm.value="";
	form.searchRule.value="se={eid:"+eidList+"}";
	form.currentPage.value="1";
	form.action="./catresult.jsp";
	form.submit();
}

function searchRefCitList(type){
	var form = document.getElementById("parameter");
	var list = $("[name=selectDoc]:checked");
	if(list.length == 0)
		return;

	var eidList = "";
	for(i = 0;i<list.length;i++){
		eid = list.get(i).value;
		objID = "temporaryDataSave_"+type+"_"+eid;
		
		eidList += $("#"+objID).attr("value") + " ";
		//console.log(objID+ +"_" + i+"__=> "+eidList);
	}
	//console.log(eidList.length+" => "+eidList);
	if($.trim(eidList) == "")
		return;

	form.searchTerm.value="";
	form.searchRule.value="se={eid:"+eidList+"}";
	form.currentPage.value = "1";
    form.action="./catresult.jsp";
    form.submit();
}

function viewStatics(){
	var form = document.getElementById("parameter");
	form.action="./viewStatics.jsp";
	form.submit();
}

function hiddenT(ids){
	//alert(jQuery("#"+ids));
	jQuery("#"+ids).toggle(); 
	document.getElementById(ids).style.display='none';
}

function foldSearchResultStatistice(){
	/*문서가 로드시 통계항목은 전부 펼쳐지지 않고 검색결과 테이블 크기에 따라 알맞게 펼쳐진다.*/
	var foldCnt = 0;
	var searchResultTableHeight = $("#searchResultTable").height();
	var contentHeight = $("#StaticsContentsView_0").height();
	var openReulstTableCnt = parseInt(Number(searchResultTableHeight) / Number(contentHeight)-1) ;
	$('img[name*=Folding]').each(function(){
		var name = $(this).attr("name").split("_");
		$(this).click(function() {
			jQuery("#morespanid_"+name[1]).text("more...");
			jQuery("#morespan_"+name[1]).hide();
			jQuery("#StaticsContentsView_"+name[1]+" tbody").toggle(); 
			toggleImage($(this));
			return false;
		});
		if(foldCnt++ > openReulstTableCnt){
			jQuery("#morespanid_"+name[1]).text("more...");
			jQuery("#morespan_"+name[1]).hide();
			jQuery("#StaticsContentsView_"+name[1]+" tbody").toggle(); 
			toggleImage($(this));
		}
	});
}

jQuery(document).ready(function(){
	//문서가 준비되었을때
	//체크박스가 체크되면 모든 체크박스를 체크한다.
	 $("#checkAllPageDoc").click(function() {
        if ($("#checkAllPageDoc:checked").length > 0) {
            $("input[name=selectDoc]:checkbox:not(checked)").attr("checked", "checked");
            //$("input[name=selectDoc]:checkbox:checked").attr("checked", "");
        } else {
            $("input[name=*selectDoc]:checkbox:checked").removeAttr("checked");
        }
        
        var parameter = "";
        $('input[name=selectDoc]:checkbox').each(function() {
        	var value = $(this).attr("value");
    		var checked = $(this).attr("checked");
    		parameter += value +"_"+(checked?"1":"0")+";";
        });
  		$.ajax({
		  type: 'POST',
		  url: '../ajax/selectDocCheckAjax.jsp?parameter='+parameter
		});
    });
	
	$("input[name=selectDoc]").click(function() {
		if($("input[name=selectDoc]:checkbox:checked").length == $("input[name=selectDoc]").length){
			$("#checkAllPageDoc").attr("checked", "checked");
		}else{
			$("#checkAllPageDoc").removeAttr("checked");
		}
		var value = $(this).attr("value");
		var checked = $(this).attr("checked");
		var parameter = value +"_"+(checked?"1":"0")+";";
		
		$.ajax({
		  type: 'POST',
		  url: '../ajax/selectDocCheckAjax.jsp?parameter='+parameter
		});
    });
	
	$(window).bind("resize", function(){
	});
	
	$('span[name*=morespan_]').each(function(){
		 var name = $(this).attr("name");
		 $(this).click(function() {
			jQuery("#"+name).toggle();
			if($(this).text()=="folding..."){
				$(this).text("more...");
			}else{
				$(this).text("folding...");
			}
			return false;
		});
	});
	
	
	if("<%=iTotalTotal%>" == "0" && ("<%=command%>"=="listRef"||"<%=command%>"=="listCit")) {
		alert("No search result were selected.\nSelect on or more search results from the list below and click.");
		history.back(-1);
		return;
	}

	$(".tipTipClass").tipTip();
	
	foldSearchResultStatistice();
});
</script>
</head>
<%
	/* 선택 문서를 초기화 한다. 이 아래에는 선택 문서에 관한 어떠한 코드도 넣지 말아라.*/

	//viewReference 와 viewCitation을 한번 실행이 된다면...
	//결과내 재검색이 된다면.
	if (searchTerm == null || searchTerm.trim().length() == 0 || insertSearchRule) {
		session.removeAttribute(userBean.getId() + "_selectDocSet");
	} else {
		//System.out.println("_" + searchTerm + "_");
	}
%>
<body>
	<div class="accessibility">
		<p>
			<a href="#content">메뉴 건너뛰기</a>
		</p>
	</div>

	<div id="wrap">

		<!--top_area-->
		<jsp:include page="../inc/topArea.jsp">
			<jsp:param value="<%=TOP_MENU_SEARCH %>" name="TOP_MENU" />
			<jsp:param value="<%=SUB_MENU_DOCUMENT_SEARCH %>" name="SUB_MENU" />
		</jsp:include>
		<!--top_area-->

		<!--contents_area-->
		<div id="container">

			<div id="content2">
				<!-- 
	    	<div id="search">
	    		<%-- String menuTerm = "Search Result"; %>
	    		<%@include file="../common/quickSearch.jsp" --%>
			</div>
		 -->
				<div id="search_choice2">
					<table class="Table" border="0" cellpadding="0" cellspacing="0"
						style="margin-left: 15px">
						<tr>
							<td valign="top">
								<table class="Table1_1" border="0" cellpadding="0"
									cellspacing="0"
									style="table-layout: fixed; whitespace: wrap; word-wrap: break-word">
									<tr>
										<td class="txt"><span
											style="text-shadow: 1px 1px 2px #999;"><img alt=""
												src="../images/001_40.png" align="bottom" width="16"
												height="16"> Document Search Results : <%=NumberFormatUtil.getDecimalFormat(iTotalTotal)%></span>
										</td>
									</tr>
								</table>
							</td>
							<td valign="middle" width='40%' align="right"><%@include
									file="../common/quickSearch2.jsp"%></td>
							<td valign="middle" width='10' align="right"></td>
						</tr>
						<tr>
							<td colspan='3'
								style="table-layout: fixed; whitespace: wrap; word-wrap: break-word;">
								<span style="margin-left: 38px;" class="txt6" title="<%=dwpiTypeRule%>">
									<%
										if(dwpiTypeRule!=null){
											out.println("Query : ");
											if(dwpiTypeRule.length() > 512){
												out.println(dwpiTypeRule.substring(0, 512));
											}else{
												out.println(dwpiTypeRule);
											}
										}
									%>
									
									<%--=(searchTerm != null && searchTerm.trim().length() > 0) ? "Query : " + dwpiTypeRule:  ""--%>
								</span>
							</td>
						</tr>
					</table>
				</div>
				<%
					JSONArray resultArr = null;
					JSONArray groupResultArr = null;
					ArrayList<String> years = new ArrayList<String>();
					ArrayList<String> authornames = new ArrayList<String>();
					ArrayList<String> asjcs = new ArrayList<String>();
					ArrayList<String> sourcetitles = new ArrayList<String>();
					ArrayList<String> keywords = new ArrayList<String>();
					ArrayList<String> affilations = new ArrayList<String>();
					ArrayList<String> countries = new ArrayList<String>();
					ArrayList<String> sourcetypes = new ArrayList<String>();

					if (jsonobj.getInt("status") == 0) {						
						try {
							iTotalTotal = jsonobj.getInt("total_count");
							totalSize = iTotalTotal;
							resultArr = jsonobj.getJSONArray("result");
							groupResultArr = jsonobj.getJSONArray("group_result");
						} catch (Exception e) {
							//out.println(iTotalTotal);
							e.printStackTrace();
						}
						//out.println("<!-- dwpi rule");
						//out.println(dwpiTypeRule);
						//out.println("-->");
						//System.out.println("dwpiTypeRule " + dwpiTypeRule);
						if (insertSearchRule) {							
							if(dwpiTypeRule!=null){
								try{
									UserSearchRuleDao.insert(userBean.getId(), dwpiTypeRule , totalSize);
								}catch(Exception e){
									e.printStackTrace();
								}
							}
							UserUsePlatformDao.insert(userBean.getId(), UserUsePlatformDefinition.ACTION_SEARCHING);
						}

						String bgColor = "";
						if (Integer.parseInt(jsonobj.getString("total_count")) > 0) {
				%>
				<div id="search_result">
					<table class="Table8" border="0" cellpadding="0" cellspacing="0"
						style="margin-left: 15px">
						<tr>
							<td valign="top">
								<table class="Table9" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="83%" valign="top">
											<table class="Table10" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td valign="top">
														<table width="100%" border="0" cellpadding="0"
															cellspacing="0">
															<tr bgcolor="#ecf8ff">
																<td height="40"
																	style="text-shadow: -1px -1px #f2f2f2, 1px 1px #FFF;">
																	&nbsp;<a href="javascript:exportDoc();"
																	class="tipTipClass" title="export documents"><img
																		src="<%=contextPath%>/images/nn_search_result_icon_Export.gif"
																		border="0" style="vertical-align: middle" /> Export</a>
																	&nbsp;|&nbsp;&nbsp;<a
																	href="javascript:searchRefCitList('CITL')"
																	class="tipTipClass"
																	title="View citations of the selected documents"><img
																		src="<%=contextPath%>/images/nn_search_result_icon_Viewcitation.gif"
																		border="0" style="vertical-align: middle" /> View
																		Cited by</a> &nbsp;|&nbsp;&nbsp;<a
																	href="javascript:searchRefCitList('REFL')"
																	class="tipTipClass"
																	title="View reference of the selected documents"><img
																		src="<%=contextPath%>/images/nn_search_result_icon_Viewreference.gif"
																		border="0" style="vertical-align: middle" /> View
																		References</a> &nbsp;|&nbsp;&nbsp;<a
																	href="javascript:viewStatics();" class="tipTipClass"
																	title="view graph"><img
																		src="<%=contextPath%>/images/nn_search_result_icon_Statistics.gif"
																		border="0" style="vertical-align: middle" /> View Stastisical Charts</a>
																</td>
																<td align="right">Sort by <select name="sortBy"
																	id="sortBy"
																	onchange="javascript:sortSearch(this.options[this.options.selectedIndex].value);">
																		<option value="pubyear:desc,_score_:desc"
																			<%="pubyear:desc,_score_:desc".equals(sort) ? "selected" : ""%>>-
																			Date (Newest) -</option>
																		<option value="pubyear:asc"
																			<%="pubyear:asc".equals(sort) ? "selected" : ""%>>-
																			Date (Oldest) -</option>
																		<option value="citcount:desc"
																			<%="citcount:desc".equals(sort) ? "selected" : ""%>>-
																			Cited by Count -</option>
																		<option value="refcount:desc"
																			<%="refcount:desc".equals(sort) ? "selected" : ""%>>-
																			Reference Count -</option>
																</select>
																</td>
															</tr>
														</table></td>
												</tr>
											</table>
											<table cellspacing="0" cellpadding="0" width="100%" id="searchResultTable" class="SearchResultTable">
												<caption>검색 결과 테이블</caption>
												<colgroup>
													<col width="3%" span="1">
												</colgroup>
												<thead>
													<tr bgcolor="#D5D5D5">
														<th scope="col" width="10"
															style="padding: 2px 2px 2px 2px;"><input
															name="checkAllPageDoc" id="checkAllPageDoc"
															type="checkbox" value="0" title="현재 페이지의 논문을 전체 선택합니다." />
														</th>
														<th scope="col" style="padding: 2px 2px 2px 2px;">Document
															Title</th>
														<th scope="col" width="20%"
															style="padding: 2px 2px 2px 2px;">Author(s)</th>
														<th scope="col" width="65"
															style="padding: 2px 2px 2px 2px;">Date</th>
														<th scope="col" width="20%"
															style="padding: 2px 2px 2px 2px;">Source Title</th>
														<th scope="col" width="65"
															style="padding: 2px 2px 2px 2px;">Cited by</th>
														<th scope="col" width="65"
															style="padding: 2px 2px 2px 2px;">References</th>
													</tr>
												</thead>
												<tbody>
													<%
														for (int i = 0; i < resultArr.length(); i++) {
																	JSONObject jsonrecord = resultArr.getJSONObject(i);

																	if ("".equals(bgColor)) {
																		bgColor = "bgcolor=\"#EFEFEF\"";
																	} else {
																		bgColor = "";
																	}
													%>
													<tr <%=bgColor%>>
														<td valign="top" width="10" scope="row"
															style="padding: 5px 5px;"><input name="selectDoc"
															id="selectDoc" type="checkbox"
															value="<%=jsonrecord.getString("eid")%>"
															<%=selectedDocEIDSet.contains(jsonrecord.getString("eid")) ? "checked" : ""%> />
															<br>
															<sub><%= (((currentPage-1) * viewData) + (i+1))%></sub>
														</td>
														<td valign="top"
															style="padding: 5px 5px; text-align: left;">
															
															<a href="./viewDocument.jsp?eid=<%=jsonrecord.getString("eid")%>">
																<span class="txt_SearchResultTitle"><%=jsonrecord.getString("title")%></span>
															</a>
															<%
																if(!"".equals(UtilString.nullCkeck(jsonrecord.getString("doi"), true))){
																	doiList.add(jsonrecord.getString("doi").trim());																	
															%>
																<div style="vertical-align: bottom;" id="fullText_<%=jsonrecord.getString("doi")%>">
																	<img src="../images/ajax-loader.gif" border="0"/> 
																</div>
															<%
																}
															%>
															<!-- 
															<small><br><%--=jsonrecord.getString("asjc")--%></br></small>
														 	-->
														</td>
														<td valign="top"
															style="padding: 5px 5px; text-align: left;">
															<%
																String str = jsonrecord.getString("authorname");
																String[] list = str.split(" ");
																String authorList = "";
																for (int k = 0; k < list.length; k++) {
																	//authorname를 20개까지만 수집합니다.
																	if (k < 20) {
																		authorList += list[k];

																		if (k != 19)
																			authorList += ", ";
																	}

																}
																//authorname을 20개까지만 짜르고 뒤에 점점점을 붙이고 총개수도 붙입니다.	
																if (list.length > 20) {
																	authorList += "...(" + list.length + ")";
																}
																//authorname이 20개 되지않을 경우 마지막에 붙은 콤마를 제거합니다.
																if (list.length < 20)
																	authorList = authorList.substring(0, authorList.length() - 2);
																String refeidStr = jsonrecord.getString("refeid");
																String citeidStr = jsonrecord.getString("citeid");
																out.println(authorList);
															%>
														</td>
														<td valign="top"><%=jsonrecord.getString("pubyear")%></td>
														<td valign="top"
															style="text-align: left; font-style: italic;"><%=jsonrecord.getString("sourcetitle")%></td>
														<td valign="top" style="color: #005eac;"><a
															href="javascript:searchRefCit('CITL','temporaryDataSave_CITL_<%=jsonrecord.getString("eid")%>');"><%=jsonrecord.getString("citcount")%></a>
														</td>
														<td valign="top" style="color: #005eac;"><a
															href="javascript:searchRefCit('REFL','temporaryDataSave_REFL_<%=jsonrecord.getString("eid")%>');"><%=jsonrecord.getString("refcount")%></a>
														</td>
														<input type="hidden"
															id="temporaryDataSave_REFL_<%=jsonrecord.getString("eid")%>"
															value="<%=jsonrecord.getString("refeid").replaceAll("&#13;&#10;", " ").replaceAll("\n", " ")%>" />
														<input type="hidden"
															id="temporaryDataSave_CITL_<%=jsonrecord.getString("eid")%>"
															value="<%=jsonrecord.getString("citeid").replaceAll("&#13;&#10;", " ").replaceAll("\n", " ")%>" />
													</tr>
													<%
														}
													%>
												</tbody>
											</table> <br /> Display <select name="select" id="select"
											onchange="searchWithLN(this.options[this.options.selectedIndex].value)">
												<option value="20" <%=viewData == 20 ? "selected" : ""%>>-
													20개씩 보기 -</option>
												<option value="40" <%=viewData == 40 ? "selected" : ""%>>-
													40개씩 보기 -</option>
										</select> results per page. <jsp:include page="../common/paging.jsp"
												flush="true">
												<jsp:param value="catresult.jsp" name="url" />
												<jsp:param value="<%=se %>" name="se" />
												<jsp:param value="<%=ft %>" name="ft" />
												<jsp:param name="searchRule" value="<%=searchRule %>" />
												<jsp:param value="<%=searchTerm %>" name="searchTerm" />
												<jsp:param value="<%=totalSize %>" name="totalSize" />
												<jsp:param value="<%=currentPage %>" name="currentPage" />
												<jsp:param value="<%=viewData %>" name="viewData" />
												<jsp:param value="<%=pagingSize %>" name="pagingSize" />
												<jsp:param value="<%=sort%>" name="sort" />
											</jsp:include></td>
										<td width="17%" valign="top">
											<!-- 결과내 재검색을 위한 하단 버튼 표시 Start -->
											<table class="Table13" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td valign="top">
														<table width="100%" border="0" cellpadding="0" cellspacing="0">
															<tr bgcolor="#ecf8ff">
																<td height="55" class="tit">
																	<%
																		out.println("<div>Search within results</div>");
																		if (iTotalTotal != 0) {
																			out.println("<input type='text' id='searchTermInResult' name='searchTermInResult' class='input_txt1' size='15'/>");
																			out.println("<input type='button' value='Search' class='bt1'  onclick='javascript:searchInResult();'/>");

																		} else {
																			out.println("&nbsp;");
																		}
																	%>
																</td>
															</tr>
														</table></td>
												</tr>
												<tr>
													<td height="1" bgcolor="#a5b8ff"></td>
												</tr>
												<tr>
													<td valign="top">
														<table width="100%" border="0" cellpadding="0"
															cellspacing="0">
															<tr bgcolor="#ecf8ff">
																<td height="55" class="tit">
																	<%
																		if (iTotalTotal != 0) {
																					out.println("<strong>Refine</strong><br />");
																					out.println("<input type='button' value='Limit to' class='bt1'  onclick='javascript:limitOrExclude(\"match\");'/>");
																					out.println("<input type='button' value='Exclude' class='bt1'  onclick='javascript:limitOrExclude(\"exclude\");'/>");
																				} else {
																					out.println("&nbsp;");
																				}
																	%>
																</td>
															</tr>
														</table></td>
												</tr>
											</table> <!-- 결과내 재검색을 위한 하단 버튼 표시 End--> <!-- 통계 항목 Start --> <%
 	if (groupResultArr != null) {

 				/*항목에 표시하는 타이틀 명*/
 				String titleName = "Title name";

 				/*limit, exclude와 같은 결과내 재검색을 위함 Form name*/
 				String formName = "";

 				/* 부가정보 */
 				Map<String, String> descriptionMapData = null;

 				/*한번에 보여줄 통계 갯수.*/
 				int groupCount = 7;
 				for (int i = 0; i < groupResultArr.length(); i++) {
 					JSONArray arr = groupResultArr.getJSONArray(i);
 					if (i == 1) {
 						titleName = "ASJC Codes";
 						formName = "asjcForm";
 						descriptionMapData = DescriptionCode.getAsjcTypeKoreaDescription();
 					} else if (i == 0) {
 						titleName = "Years";
 						formName = "yearForm";
 						descriptionMapData = new HashMap<String, String>();
 					} else if (i == 2) {
 						titleName = "Countries";
 						formName = "countryForm";
 						descriptionMapData = DescriptionCode.getCountryType();
 					} else if (i == 4) {
 						titleName = "Source Titles";
 						formName = "sourceIdForm";
 						descriptionMapData = new HashMap<String, String>();
 						Set<String> sourceIDSet = new HashSet<String>();
 						for (int j = 0; j < arr.length(); j++) {
 							if (j > 50) {
 							}
 							JSONObject o = arr.getJSONObject(j);
 							String key = o.getString("key");
 							sourceIDSet.add(key.trim());
 						}
 						descriptionMapData = ScopusTypeDao.getSourceDescription(sourceTitleMap,
 								sourceTitleFreqMap, sourceIDSet);
 					} else if (i == 5) {
 						titleName = "Source Types";
 						formName = "sourceTypeForm";
 						descriptionMapData = DescriptionCode.getSourceTypeDescription();
 					} else if (i == 3) {
 						titleName = "Affiliations";
 						formName = "afidForm";
 						descriptionMapData = new HashMap<String, String>();
 						for (int j = 0; j < arr.length(); j++) {
 							if (j > 50) {
 							}
 							JSONObject o = arr.getJSONObject(j);
 							String key = o.getString("key");
 						}
 						descriptionMapData = new HashMap<String, String>();
 						Set<String> afidSet = new HashSet<String>();
 						for (int j = 0; j < arr.length(); j++) {
 							if (j > 50) {
 							}
 							JSONObject o = arr.getJSONObject(j);
 							String key = o.getString("key");
 							afidSet.add(key.trim());
 						}
 						descriptionMapData = ScopusTypeDao.getAffiliationNameDescription(affilationNameMap,
 								affilationNameFreqMap, afidSet);
 					} else if (i == 6) {
 						titleName = "Authors";
 						formName = "authorNameForm";
 						Set<String> authorIDSet = new HashSet<String>();
 						for (int j = 0; j < arr.length(); j++) {
 							if (j > 50) {
 							}
 							JSONObject o = arr.getJSONObject(j);
 							String key = o.getString("key");
 							authorIDSet.add(key.trim());
 						}
 						descriptionMapData = ScopusTypeDao.getAuthorNameDescription(authorNameMap,
 								authorNameFreqMap, authorIDSet);
 					} else if (i == 7) {
 						titleName = "Keywords";
 						formName = "keywordForm";
 						descriptionMapData = new HashMap<String, String>();
 					} else if (i == 8) {
 						titleName = "Document Types";
 						formName = "citationForm";
 						descriptionMapData = DescriptionCode.getCitationType();
 					}else if (i == 9) {
 						titleName = "Delegate Affiliation";
 						formName = "dAffiliation";
 					}
 %>
											<table cellspacing="0" cellpadding="0" border="0"
												width="100%" class="Table6" id="StaticsContentsView_<%=i%>">
												<caption>검색 테이블</caption>
												<thead>
													<tr bgcolor="#c0defa">
														<td scope="col" class="tit"><%=titleName%></td>
														<td scope="col" class="tit1"><img src="<%=contextPath%>/images/nn_search_arrow02.gif"
															border="0" name="Folding_<%=i%>" style="cursor: pointer;" />
														</td>
													</tr>
													<tr>
														<td height="1" colspan="2" bgcolor="#a5b8ff"></td>
													</tr>
												</thead>
												<form id="<%=formName%>" name="<%=formName%>">
													<tbody>
														<%
															//HashMap<String, String> descSourceType = DescriptionCode.getSourceTypeDescription();
														for (int j = 0; j < arr.length(); j++) {
															if (j > 50) {
																//결과가 50개 이상이면 더 이상 보여주지 않는다.											
																break;
															}

															JSONObject o = arr.getJSONObject(j);
															String key = o.getString("key").trim();
															String freq = o.getString("freq");
															String desc = key;

															if (i == 6) {
																//저자 정보일경우에는.
																String authorName = InfoStack
																		.getValue(authorNameMap, authorNameFreqMap, key.trim());
																desc = authorName == null ? key : authorName;
															} else if (i == 4) {
																//Source ID 인경우.
																String sourceTitle = InfoStack.getValue(sourceTitleMap, sourceTitleFreqMap,
																		key.trim());
																desc = sourceTitle == null ? key : sourceTitle;
															} else if (i == 3) {
																//affiliation 인경우.
																String affiliation = InfoStack.getValue(affilationNameMap, affilationNameFreqMap,key.trim());
																desc = affiliation == null ? key : affiliation;
															} else {
																if (descriptionMapData.containsKey(key.toLowerCase())) {
																	desc = descriptionMapData.get(key.toLowerCase());
																}
																if (descriptionMapData.containsKey(key.toUpperCase())) {
																	desc = descriptionMapData.get(key.toUpperCase());
																}
															}

															if (j == groupCount && arr.length() > groupCount) {
																//continue;
																out.println("<tr><td colspan='2' style='padding:0px 0px 0px 5px;text-align: right;'><span id='morespanid_"
																		+ i
																		+ "' name=\"morespan_"
																		+ i
																		+ "\" style='cursor:pointer;'>more..</span></td></tr>");
																out.println("<tr width='100%'><td colspan='2' width='100%' ><table cellspacing='0' cellpadding='0' border='0' width='100%' id=\"morespan_"
																		+ i + "\" style='display:none'>");

															}
														%>
														<tr class="tipTipClass" title="<%=desc%>">
															<td style="padding: 0px 0px 0px 5px;font-family:'맑은 고딕','Trebuchet MS'; ">
															<%
															if (i == 9) {
																if("".equals(desc.trim())){
																	continue;
																}
															%>
															<input
																name="check1" id='<%=key%>' type="checkbox" disabled="disabled"
																value="<%=key%>" /> <%=desc.length() > 18 ? desc.substring(0, 18) : desc%>
															</td>
															<%
															}else{
															%>
															<input
																name="check1" id='<%=key%>' type="checkbox"
																value="<%=key%>" /> <%=desc.length() > 18 ? desc.substring(0, 18) : desc%>
															</td>
															<%
															}
															%>
															<td
																style="color: #005eac; text-align: right; padding: 0px 5px 0px 0px;">(<%=freq%>)</td>
														</tr>
														<%
															}
															if (arr.length() > groupCount) {
																out.println("</table></td></tr>");
															}
														%>
													</tbody>
												</form>
											</table> <%
 	} //for (int i=0;i<groupResultArr.length();i++) {
 			} //if(groupResultArr != null){
 %> <!-- 통계 항목 End --> <!-- 결과내 재검색을 위한 하단 버튼 표시 Start -->
											<table class="Table13_1" border="0" cellpadding="0"
												cellspacing="0">
												<tr>
													<td valign="top">
														<table width="100%" border="0" cellpadding="0"
															cellspacing="0">
															<tr bgcolor="#ecf8ff">
																<td height="55" class="tit">
																	<%
																		if (iTotalTotal != 0) {
																					out.println("<input type='button' value='Limit to' class='bt1'  onclick='javascript:limitOrExclude(\"match\");'/>");
																					out.println("<input type='button' value='Exclude' class='bt1'  onclick='javascript:limitOrExclude(\"exclude\");'/>");
																				} else {
																					out.println("&nbsp;");
																				}
																	%>
																</td>
															</tr>
														</table></td>
												</tr>
												<tr>
													<td height="1" bgcolor="#a5b8ff"></td>
												</tr>
											</table> <!-- 결과내 재검색을 위한 하단 버튼 표시 End-->
										</td>
									</tr>
								</table></td>
						</tr>
					</table>
				</div>

			</div>
		</div>
		<%
			}
			}
		%>
		<!--contents_area-->

		<form id="viewDocumentParameterForm" method="get">
			<input type="hidden" name="eid" />
		</form>

		<form id="temporaryDataSave" method="post"></form>

		<form id="parameter" method="post">
			<input type="hidden" name="cn" value="<%=cn%>" /> 
			<input type="hidden" name="se" value='<%=se.replaceAll("\"", "&quot;")%>' /> 
			<input type="hidden" name="fl" value="<%=fl%>" /> 
			<input type="hidden" name="sn" value="<%=sn%>" /> 
			<input type="hidden" name="ln" value="<%=viewData%>" /> 
			<input type="hidden" name="gr" value="<%=gr%>" /> 
			<input type="hidden" name="ra" value="<%=ra%>" />
			<input type="hidden" name="ft" value="<%=ft%>" /> 
			<input type="hidden" name="ht" value="<%=ht%>" /> 
			<input type="hidden" name="ud" value="<%=ud%>" /> 
			<input type="hidden" name="authorSeq" />
			<input type="hidden" name="searchTerm" value="<%=searchTerm%>" /> 
			<input type="hidden" name="searchRule" value="<%=searchRule%>" /> 
			<input type="hidden" name="url" value="result.jsp" /> 
			<input type="hidden" name="currentPage" value="<%=currentPage%>" /> 
			<input type="hidden" name="totalSize" value="<%=totalSize%>" /> 
			<input type="hidden" name="viewData" value="<%=viewData%>" /> 
			<input type="hidden" name="pagingSize" value="<%=pagingSize%>" /> 
			<input type="hidden" name="sort" value="<%=sort%>" />
		</form>

		<!--footer_area-->
		<jsp:include page="../inc/bottomArea.jsp" />
		<!--footer_area-->
	</div>
</body>
<script>
	function getFullTextInfo(doi){
		$.ajax({
			type: "POST",
			url: "../common/getDOISource.jsp",
			data: "doi="+encodeURIComponent(doi),
			beforeSend: function(xhr){
			},
			success: function(msg){
				var result = jQuery.trim(msg);
				var doiFormObject = document.getElementById("fullText_" + doi);
				if(result!=""){
					var html = "<a href=\""+result+"\" target=\"_blank\">";
					html+="<img src=\"../images/fullText.png\" border=\"0\" title=\""+doi+"\"/>";
					html+="</a>";
					doiFormObject.innerHTML = html;
				}else{
					doiFormObject.innerHTML = "";
				}
			}
		});
	}	
	//DOI 전자원문링크를 위한 스크립트 실행
	var doiList = [];
	var doiCnt = 0;
<%
	for(String doi : doiList){
		out.println("doiList[doiCnt++] = \"" + doi + "\";");	
	}
%>	

	for(var i=0; i<doiList.length; i++){
		//getFullTextInfo(doiList[i]);
	}
</script>

</html>
<%
	session.setAttribute(String.valueOf(InfoStackType.AUTHOR_NAME), authorNameMap);
	session.setAttribute(String.valueOf(InfoStackType.AUTHOR_NAME_FREQ), authorNameFreqMap);

	session.setAttribute(String.valueOf(InfoStackType.AFFILATION_NAME), affilationNameMap);
	session.setAttribute(String.valueOf(InfoStackType.AFFILATION_NAME_FREQ), affilationNameFreqMap);

	session.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE), sourceTitleMap);
	session.setAttribute(String.valueOf(InfoStackType.SOURCE_TITLE_FREQ), sourceTitleFreqMap);
%>

