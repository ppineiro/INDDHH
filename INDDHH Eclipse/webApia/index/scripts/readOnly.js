var FFReadOnlyControls=new Array();

function setBrwsReadOnly(el){
	if(!MSIE){
		for(var i=0;i<FFReadOnlyControls.length;i++){
			if(FFReadOnlyControls[i]==el){
				return;
			}
		}
		FFReadOnlyControls.push(el);
//		el.disabled=true;
		/*if(el.tagName=="INPUT"){
			el.readonly="readonly";
		}*/
	}else{
		if(el.readonlyset!="true"){
			el.readonlyset="true";
			addListener(el,"focus",onReadOnlyFocused);
		}
	}
	if(el.tagName=="SELECT"){
		if(MSIE){
			removeListener(el,"mousedown",setSelectDefaultValue);
			addListener(el,"mousedown",setSelectDefaultValue);
		}else{
			removeListener(el,"focus",setSelectDefaultValue);
			addListener(el,"focus",setSelectDefaultValue);
		}
		removeListener(el,"change",setSelectLostFocus);
		addListener(el,"change",setSelectLostFocus);
		if(el.onchange){
			el.ro_onchange=el.onchange;
			el.onchange=null;
		}
	}
}

function unsetBrwsReadOnly(el){
	if(!MSIE){
		for(var i=0;i<FFReadOnlyControls.length;i++){
			if(FFReadOnlyControls[i]==el){
				FFReadOnlyControls.splice(i,1);
			}
		}
		el.disabled=false;
		/*if(el.tagName=="INPUT"){
			el.readonly="";
		}*/
	}else{
		removeListener(el,"focus",onReadOnlyFocused);
		el.readonlyset="false";
	}
	if(el.tagName=="SELECT"){
		if(MSIE){
			removeListener(el,"mousedown",setSelectDefaultValue);
		}else{
			removeListener(el,"focus",setSelectDefaultValue);
		}
		removeListener(el,"change",setSelectLostFocus);
		if(el.ro_onchange){
			el.onchange=el.ro_onchange;
			el.ro_onchange=null;
		}
	}
}

function prepareReadOnlyToSubmit(){
	for(var i=0;i<FFReadOnlyControls.length;i++){
		FFReadOnlyControls[i].disabled=false;
	}
}

function prepareReadOnlyAfterSubmit(){
	for(var i=0;i<FFReadOnlyControls.length;i++){
		FFReadOnlyControls[i].disabled=true;
	}
}

function setSelectDefaultValue(e){
	e=getEventObject(e);
	var el=getEventSource(e);
	el.setAttribute("defaultValue",el.selectedIndex);
}
function setSelectLostFocus(e){
	e=getEventObject(e);
	var el=getEventSource(e);
	el.selectedIndex=el.getAttribute("defaultValue");
}
function onReadOnlyFocused(e){
	e=getEventObject(e);
	var el=getEventSource(e);
	var shiftOn=e.shiftKey;
	setNextFocus(el,shiftOn);
}

function setNextFocus(el,previous){
	var td=el;
	if(el.tagName!="TD"){
		td=getParentCell(el);
	}
	if(td){
		var next=previous?td.previousSibling:td.nextSibling;
		if(!next){		
			var tr=getParentRow(td);
			tr=previous?tr.previousSibling:tr.nextSibling;
			if(tr){
				next=previous?tr.lastChild:tr.firstChild;
			}
		}
		if(next){
			var controls=next.getElementsByTagName("INPUT");
			var control=null;
			if(controls && controls.length>0){
				control=controls[0];
			}
			controls=next.getElementsByTagName("SELECT");
			if(controls && controls.length>0){
				control=controls[0];
			}
			controls=next.getElementsByTagName("TEXTAREA");
			if(controls && controls.length>0){
				control=controls[0];
			}
			if(control && control.type!="hidden" && next.style.display!="none"){
				try{
				control.focus();
				}catch(e){
					setNextFocus(next,previous);
				}
			}else if(control && control.type!="hidden"){
				setNextFocus(control,previous);
			}else{
				setNextFocus(next,previous);
			}
		}
	}
}
 