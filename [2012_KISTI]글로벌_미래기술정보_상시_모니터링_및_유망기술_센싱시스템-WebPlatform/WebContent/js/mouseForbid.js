/**
 * 
 */

function mouseForbid(){
	if(event.button==2){
		alert("마우스는 오른쪽 버튼이 사용금지되어 있습니다.");
		return;
	}
}

function mouseForbidSelect(){
	return false;
}

document.onmousedown = mouseForbid;
document.onselectstart = mouseForbidSelect;
document.ondragstart = mouseForbidSelect;
document.oncontextmenu = mouseForbidSelect;