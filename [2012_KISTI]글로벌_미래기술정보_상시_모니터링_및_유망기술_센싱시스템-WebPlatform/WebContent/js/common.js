/*
입력된 길이를 체크한다.
	value : 문자열 - 입력된 값.
	allowSize : 자연수 - 허용 사이즈.
*/
function checkSize(value, allowSize){

}

/*
문자열 공백을 체크한다.
	obj : 객체.
	alarmMsg : 문자열 - 공백일경우 발생하는 메시지.
*/
function checkBlank(obj, alarmMsg){
	if(obj!=null){
		if(obj.value=='' || obj.value=='null'){
			alert(alarmMsg);
			obj.focus();
			return true;
		}
		return false;
	}else{
		return false;
	}
}

/*
	obj : 객체.
	limitSize : 제한 크기, 0이면 제한 없음.
*/
function checkNumber(obj, limitSize){
	if(obj!=null){
		if(limitSize==0) return true;
		else{
			if(obj.value==''){
				alert("Enter value.");
				obj.focus();
				return false;
			}
			if(obj.value > limitSize){
				alert("It is in excess of the limited size. Enter again.");
				obj.focus();
				return false;
			}
		}
		return true;
	}else{
		return false;
	}
}
function check_number(obj){
	if(obj.value.match(/[^0-9]/)) { 
		alert('Enter only number.'); 
		obj.value = ''; 
		return false; 
	}
}

/* ---------------------------------------------
 * 함수명 : check_blank
 * 설  명 : 문자열 중간의 공백 문자 체크
 * 예) if(!check_blank()) return;
 ---------------------------------------------*/
function check_blank(_obj){
	if(_obj==null) return false;
	
	var value = _obj.value;
	for (var i=0; i<value.length; i++) {
		var char = value.charAt(i);
		if(value.charAt(i) == ' '){
			alert("Remove blank from the string.");
			_obj.select();
			_obj.focus();
			return false;
		}
	}
	return true;
}

/* ---------------------------------------------
 * 함수명 : checkSpecialChar
 * 설  명 : 특수문자 체크
 * 예) if(!checkSpecialChar()) return;
 ---------------------------------------------*/
function checkSpecialChar(_obj){
	if(_obj.value.search(/[\[\]`@\;\:+&\\=!#$%\-\_~*,.\{\}|/?><\'\"^]/g) >= 0) {
    	alert("특수문자를 제거해 주세요.");
		_obj.select();
		_obj.focus();
		return false;
    }
    return true;
}

/* ---------------------------------------------
 * 함수명 : checkSpecialChar2
 * 설  명 : 특수문자 체크
 * 예) if(!checkSpecialChar()) return;
 ---------------------------------------------*/
function checkSpecialChar2(_obj){
	if(_obj.value.search(/[\[\]`@\;\:+&\\=!#$%~*,.\{\}|/?><\'\"^]/g) >= 0) {
    	alert("Remove special character from entered string.");
		_obj.select();
		_obj.focus();
		return false;
    }
    return true;
}

/* ---------------------------------------------
 * 함수명 : checkSpecialCharSetting
 * 설  명 : 특수문자 체크 * 기호만 통과.
 * 예) if(!checkSpecialChar()) return;
 ---------------------------------------------*/
function checkSpecialCharSetting(_obj){
	if(_obj.value.search(/[\[\]`@\;\:+&\\=!#$%\-\_~,.\{\}|/?><\'\"^]/g) >= 0) {
    	alert("Remove special character from entered string.");
		_obj.select();
		_obj.focus();
		return false;
    }
    return true;
}

/* ---------------------------------------------
 * 함수명 : checkSpecialCharSetting1
 * 설  명 : 특수문자 체크 . 기호만 통과.
 * 예) if(!checkSpecialChar()) return;
 ---------------------------------------------*/
function checkSpecialCharSetting1(_obj){
	if(_obj.value.search(/[\[\]`@\;\:+&\\=!#$%\-\_~,*\{\}|/?><\'\"^]/g) >= 0) {
    	alert("Remove special character from entered string.");
		_obj.select();
		_obj.focus();
		return false;
    }
    return true;
}

/* ---------------------------------------------
 * 함수명 : checkSpecialCharSetting2
 * 설  명 : 특수문자 체크 - _ 기호만 통과.
 * 예) if(!checkSpecialChar()) return;
 ---------------------------------------------*/
function checkSpecialCharSetting2(_obj){
	if(_obj.value.search(/[\[\]`@\;\:+&\\=!#$%\-\_~,.*\{\}|/?><\'\"^]/g) >= 0) {
    	alert("Remove special character from entered string.");
		_obj.select();
		_obj.focus();
		return false;
    }
    return true;
}

/*---------------------------------------------
 * String 문자 자르기.
 ---------------------------------------------*/
String.prototype.cut = function(len) {
 var str = this;
 var l = 0;
 for (var i=0; i<str.length; i++) {
  l += (str.charCodeAt(i) > 128) ? 2 : 1;
  if (l > len) return str.substring(0,i);
 }
 return str;
}
 
/*---------------------------------------------
 * String 공백 지우기.
 ---------------------------------------------*/
String.prototype.trim = function(){
 // Use a regular expression to replace leading and trailing
 // spaces with the empty string
 return this.replace(/(^s*)|(s*$)/g, "");
}

/*---------------------------------------------
 * String 총 바이트 수 구하기.
 ---------------------------------------------*/
String.prototype.bytes = function() {
 var str = this;
 var l = 0;
 for (var i=0; i<str.length; i++) l += (str.charCodeAt(i) > 128) ? 2 : 1;
 return l;
}
 
/*---------------------------------------------
 * iframe의 height를 body의 내용만큼 자동으로 늘려줌.
 ---------------------------------------------*/
function resizeRetry(){
 if(ifrContents.document.body.readyState == "complete"){
  clearInterval(ifrContentsTimer);
 }
 else{
  resizeFrame(ifrContents.name);
 }
}
var ifrContentsTimer;
var ifrContents;
function resizeFrame(name){
        var oBody = document.body;
        var oFrame = parent.document.all(name);
  ifrContents = oFrame;
        var min_height = 613; //iframe의 최소높이(너무 작아지는 걸 막기위함, 픽셀단위, 편집가능)
        var min_width = 540; //iframe의 최소너비
        var i_height = oBody.scrollHeight + 10;
        var i_width = oBody.scrollWidth + (oBody.offsetWidth-oBody.clientWidth);
        if(i_height < min_height) i_height = min_height;
        if(i_width < min_width) i_width = min_width;
        oFrame.style.height = i_height;
        ifrContentsTimer = setInterval("resizeRetry()",100);
}

/*---------------------------------------------
 * 클립보드에 해당 내용을 복사함.
 ---------------------------------------------*/
function setClipBoardText(strValue){
 window.clipboardData.setData('Text', strValue);
 alert("" + strValue +" nn위 내용이 복사되었습니다.nnCtrl + v 키를 사용하여, 붙여 넣기를 사용하실 수 있습니다.");
}

/*---------------------------------------------
 * select 에서 기존의 선택 값이 선택되게
 ----------------------------------------------*/
function selOrign(frm,val){
 for(i=0; i < frm.length ; i++){
  if(frm.options[i].value == val){
   frm.options.selectedIndex = i ;
   return;
  }
 }
}
/*---------------------------------------------
 * checkbox 에서 기존의 선택 값이 선택되게
 ----------------------------------------------*/
function chkboxOrign(frm,val){
 if(frm.length == null){
  if(frm.value == val)
   frm.checked = true;
 }else{
  for(i=0;i<frm.length;i++){
   if(frm[i].value == val){
    frm[i].checked = true;
   }
  }
  return;
 }
}
function chkboxOrign_multi(frm,objchk,val){
 var i = 0;
 for(i=0;i<frm.elements.length;i++){
  if(frm.elements[i].name == objchk){
   if(frm.elements[i].value == val){
    frm.elements[i].checked = true;
   }
  }
 }
}
 
/*---------------------------------------------
 * radio 에서 기존의 선택 값이 선택되게
 ----------------------------------------------*/
function radioOrign(frm,val){
 for(i=0; i < frm.length ; i++){
  if(frm[i].value == val){
   frm[i].checked = true ;
   return ;
  }
 }
}
/*---------------------------------------------
 * 숫자만 입력받기
 * 예) omKeyDown="return onlyNum();"
----------------------------------------------*/
function onlyNum(){
 if(
  (event.keyCode >= 48 && event.keyCode <=57) ||
  (event.keyCode >= 96 && event.keyCode <=105) ||
  (event.keyCode >= 37 && event.keyCode <=40) ||
  event.keyCode == 9 ||
  event.keyCode == 8 ||
  event.keyCode == 46
  ){
  //48-57(0-9)
  //96-105(키패드0-9)
  //8 : backspace
  //46 : delete key
  //9 :tab
  //37-40 : left, up, right, down
  event.returnValue=true;
 }
 else{
  //alert('숫자만 입력 가능합니다.');
  event.returnValue=false;
 }
}
/*---------------------------------------------
 * 지정된 길이반큼만 입력받기
 * 예) omKeyUp="return  checkAllowLength(현재숫자보여지는객체,숫자셀객체 ,80);" 
 * omKeyDown="return checkAllowLength(현재 숫자보여지는객체,숫자셀객체 ,80);"
----------------------------------------------*/
function checkAllowLength(objView, objTar, max_cnt){
 if(event.keyCode > 31 || event.keyCode == "") {
  if(objTar.value.bytes() > max_cnt){
   alert("Maximum size is " + max_cnt + " byte.");
   objTar.value = objTar.value.cut(max_cnt);
  }
 }
 objView.value = objTar.value.bytes();
}

/*--------------------------------------------
 * 이미지 리사이즈
 ---------------------------------------------*/
function resizeImg(imgObj, max_width, max_height){
 var dst_width;
 var dst_height;
 var img_width;
 var img_height;
 img_width = parseInt(imgObj.width);
 img_height = parseInt(imgObj.height);
 if(img_width == 0 || img_height == 0){
  imgObj.style.display = '';
  return false;
 }
    // 가로비율 우선으로 시작
    if(img_width > max_width || img_height > max_height) {
        // 가로기준으로 리사이즈
        dst_width = max_width;
        dst_height = Math.ceil((max_width / img_width) * img_height);
        // 세로가 max_height 를 벗어났을 때
        if(dst_height > max_height) {
   dst_height = max_height;
   dst_width = Math.ceil((max_height / img_height) * img_width);
        }
        imgObj.width = dst_width;
        imgObj.height = dst_height;
    }
    // 가로비율 우선으로 끝
 imgObj.style.display = '';
 return true;
}
/*---------------------------------------------
 * xml data 읽어오기
 ----------------------------------------------*/
function getXmlHttpRequest(_url, _param){
    var objXmlConn;
    try{objXmlConn = new ActiveXObject("Msxml2.XMLHTTP.3.0");}
    catch(e){try{objXmlConn = new ActiveXObject("Microsoft.XMLHTTP");}catch(oc){objXmlConn = null;}}
    if(!objXmlConn && typeof XMLHttpRequest != "undefined") objXmlConn = new XMLHttpRequest();
    objXmlConn.open("GET", _url + "?" + _param, false);
    objXmlConn.send(null);
 
 //code|message 형태로 리턴
    return objXmlConn.responseText.trim().split("|");
}

/*---------------------------------------------------
 * cookie 설정
 -------------------------------------------------------*/
function getCookieVal (offset) {
   var endstr = document.cookie.indexOf (";", offset);
   if (endstr == -1) endstr = document.cookie.length;
   return unescape(document.cookie.substring(offset, endstr));
}
function GetCookie (name) {
   var arg = name + "=";
   var alen = arg.length;
   var clen = document.cookie.length;
   var i = 0;
   while (i < clen) { //while open
      var j = i + alen;
      if (document.cookie.substring(i, j) == arg)
         return getCookieVal (j);
      i = document.cookie.indexOf(" ", i) + 1;
      if (i == 0) break;
   } //while close
   return null;
}
function SetCookie (name, value) {
   var argv = SetCookie.arguments;
   var argc = SetCookie.arguments.length;
   var expires = (2 < argc) ? argv[2] : null;
   var path = (3 < argc) ? argv[3] : null;
   var domain = (4 < argc) ? argv[4] : null;
   var secure = (5 < argc) ? argv[5] : false;
   document.cookie = name + "=" + escape (value) +
      ((expires == null) ? "" :
         ("; expires=" + expires.toGMTString())) +
      ((path == null) ? "" : ("; path=" + path)) +
      ((domain == null) ? "" : ("; domain=" + domain)) +
      ((secure == true) ? "; secure" : "");
} 

