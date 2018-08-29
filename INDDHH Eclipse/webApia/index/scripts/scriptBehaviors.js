// JavaScript Document
// SCRIPT BEHAVIOR ATTACHER
var loaded=false;
function setScriptBehaviors(isAjax){
	var doc=document;
	if(isAjax!=null){
		doc=isAjax;
	}

	if(window.name == "iframeAjax"){
		return;
	}

	var toGrids=new Array();
	var toImageBrowsers=new Array();
	var divs=doc.getElementsByTagName("div");
	for(var i=0;i<divs.length;i++){
		if(divs[i].getAttribute("type")=="grid"){
			toGrids.push(divs[i]);
		}else if(divs[i].getAttribute("type")=="imageBrowser"){
			toImageBrowsers.push(divs[i]);
		}
	}
	//try{
		if(MSIE6){
			fixTextAreas();
		}
	//}catch(e){}
	try{
	setFilter();
	}catch(e){}
	try{
	setGrids(toGrids);
	}catch(e){}
	try{
	setImageBrowsers(toImageBrowsers);
	}catch(e){}
	try{
	setSelBinds();
	}catch(e){}
	var inputs=doc.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if((inputs[i].name!="" && inputs[i].name!=undefined) && (inputs[i].id=="" || inputs[i].id==undefined)){
			inputs[i].id=inputs[i].name;
		}
		if(inputs[i].getAttribute("p_required")=="true"){
			setRequiredField(inputs[i]);
		}
		if(inputs[i].getAttribute("onpropertychange")!=null && (!MSIE)){
			setPropertyChanged(inputs[i]);
		}
		if(inputs[i].getAttribute("p_calendar")=='true'){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
			setDTPicker(inputs[i]);
		}else if(inputs[i].getAttribute("p_mask")!=null){
			setMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
		if(inputs[i].getAttribute("p_email")=="true"){
			addListener(inputs[i],"blur",isEMail);
		}
		if(inputs[i].getAttribute("p_numeric")=="true"){
			setNumeric(inputs[i]);
		}
		if(inputs[i].getAttribute("readOnly")==true || inputs[i].getAttribute("readOnly")=="true" || inputs[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(inputs[i]);
		}
		if(CHROME && inputs[i].type=="radio"){
			addListener(inputs[i],"click",function(e){
				e.target.onblur();
			});
		}
	}
	var textAreas=doc.getElementsByTagName("TEXTAREA");
	for(var i=0;i<textAreas.length;i++){
		if((textAreas[i].name!="" && textAreas[i].name!=undefined) && (textAreas[i].id=="" || textAreas[i].id==undefined)){
			textAreas[i].id=textAreas[i].name;
		}
		if(textAreas[i].getAttribute("p_maxlength")!=null){
			setMaxLength(textAreas[i]);
		}
		if(textAreas[i].getAttribute("p_numeric")!=null){
			setNumeric(textAreas[i]);
		}
		if(textAreas[i].getAttribute("p_required")=="true"){
			setRequiredField(textAreas[i]);
		}
		if(textAreas[i].getAttribute("readOnly")==true || textAreas[i].getAttribute("readOnly")=="true" || textAreas[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(textAreas[i]);
		}
	}
	var selects=doc.getElementsByTagName("SELECT");
	for(var i=0;i<selects.length;i++){
		if((selects[i].name!="" && selects[i].name!=undefined) && (selects[i].id=="" || selects[i].id==undefined)){
			selects[i].id=selects[i].name;
		}
		if(selects[i].getAttribute("p_required")=="true"){
			setRequiredField(selects[i]);
		}
		if(selects[i].getAttribute("readOnly")==true || selects[i].getAttribute("readOnly")=="true" || selects[i].getAttribute("readOnly")=="readonly"){
			setBrwsReadOnly(selects[i]);
		}
	}
	try{
	setTabs();
	}catch(e){}
	try{
	initWinSizer();
	}catch(e){}
	window.close=function(){
		var win=this;
		var modal=win.parent.document.getElementById(this.name);
		while(modal.parentNode.closeModal==undefined){
			win=win.parent;
			modal=win.parent.document.getElementById(win.name);
		}
		modal.parentNode.closeModal();
	}
	if(document.body.className!="listBody"){
		try{
			if(isAjax!="true"){
			
		 	hideResultFrame();
			} else {
				var win=window;
				while((!win.document.getElementById("iframeMessages") || !win.document.getElementById("workArea") || !win.document.getElementById("iframeResult")) && (win!=win.parent) ){
					win=win.parent;
				}
				if(win.document.getElementById("iframeMessages") && win.document.getElementById("iframeResult")){
					win.document.getElementById("iframeResult").hideResultFrame();
				}
			}
		}catch(e){};
	}
	loaded=true;
	try{
	//if(isAjax!="true"){ showDefaultContents(); }
	}catch(e){}
	//verify if the docFrame exists on the screen, otherwise include it	
	if(!document.getElementById("docFrame")){
		var htmlIframe = document.createElement("IFRAME");
		htmlIframe.id = "docFrame";
		htmlIframe.style.display="none";
		document.body.appendChild(htmlIframe);
	}
	if(!isAjax){
		setFirstFocus();
	}
}


function unsetScriptBehaviors(isAjax){
	var doc=document;
	if(isAjax!=null){
		doc=isAjax;
	}

	if(window.name == "iframeAjax"){
		return;
	}

	var toGrids=new Array();
	var toImageBrowsers=new Array();
	var selBinds=new Array();
	var divs=doc.getElementsByTagName("div");
	for(var i=0;i<divs.length;i++){
		if(divs[i].getAttribute("type")=="grid"){
			toGrids.push(divs[i]);
		}else if(divs[i].getAttribute("type")=="imageBrowser"){
			toImageBrowsers.push(divs[i]);
		}else if(divs[i].getAttribute("TYPE")=="selbind"){
			selBinds.push(divs[i]);
		}
	}

	try{
	unsetGrids(toGrids);
	}catch(e){}
	try{
	unsetSelBinds(binds);
	}catch(e){}
	
	var inputs=doc.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if((inputs[i].name!="" && inputs[i].name!=undefined) && (inputs[i].id=="" || inputs[i].id==undefined)){
			inputs[i].id=inputs[i].name;
		}
		if(inputs[i].getAttribute("p_required")=="true"){
			unsetRequiredField(inputs[i]);
		}
		if(inputs[i].getAttribute("onpropertychange")!=null && (!MSIE)){
			unsetPropertyChanged(inputs[i]);
		}
		if(inputs[i].getAttribute("p_mask")!=null){
			unsetMask(inputs[i],inputs[i].getAttribute("p_mask"));
		}
		if(inputs[i].getAttribute("p_email")=="true"){
			removeListener(inputs[i],"blur",isEMail);
		}
		if(inputs[i].getAttribute("p_numeric")=="true"){
			unsetNumeric(inputs[i]);
		}
		if(inputs[i].getAttribute("readOnly")=="true"){
			unsetBrwsReadOnly(inputs[i]);
		}
	}
	var textAreas=doc.getElementsByTagName("TEXTAREA");
	for(var i=0;i<textAreas.length;i++){
		if((textAreas[i].name!="" && textAreas[i].name!=undefined) && (textAreas[i].id=="" || textAreas[i].id==undefined)){
			textAreas[i].id=textAreas[i].name;
		}
		if(textAreas[i].getAttribute("p_maxlength")!=null){
			setMaxLength(textAreas[i]);
		}
		if(textAreas[i].getAttribute("p_numeric")!=null){
			unsetNumeric(textAreas[i]);
		}
		if(textAreas[i].getAttribute("p_required")=="true"){
			unsetRequiredField(textAreas[i]);
		}
		if(textAreas[i].getAttribute("readOnly")=="true"){
			unsetBrwsReadOnly(textAreas[i]);
		}
	}
	var selects=doc.getElementsByTagName("SELECT");
	for(var i=0;i<selects.length;i++){
		if(selects[i].getAttribute("p_required")=="true"){
			unsetRequiredField(selects[i]);
		}
		if(selects[i].getAttribute("readOnly")=="true"){
			unsetBrwsReadOnly(selects[i]);
		}
	}
	
}

function reloadScriptBehaviors(){
	clearRequired();
	//clearMasked();
	unsetScriptBehaviors();
	setScriptBehaviors();
}

var firstFocusSet=false;



function setFirstFocus(){
	
	try{
		if(DONT_SET_FOCUS)
			return;
	} catch(e) {}
	
	if(!firstFocusSet){
		firstFocusSet=true;
		var id=getDispatcherId();
		var index=getDispatcherIndex()
		/*if(index!=null){
			index++;
		}*/
		try{
			if(id){
				var el=document.getElementById(id);
				if(index){
					var els=document.getElementsByTagName(el.tagName);
					var elIndex=0;
					for(var i=0;i<els.length;i++){
						if(els[i].id==id){
							elIndex++;
							if(index==elIndex){
								el=els[i];
								break;
							}
						}
					}
				}
				//if(el.type=="hidden"){
				var inputs=el.parentNode.parentNode.getElementsByTagName("INPUT");
				//for(var i=0;i<inputs.length;i++){
					//if(inputs[i].id=="hiddenFile"){
						var pos=getAbsolutePosition(el.parentNode);
						//divContent.scrollTop=pos.y+30;
						var divContent=document.getElementById("divContent");
						if(!getDispatcherScroll() && (divContent.scrollTop+divContent.scrollHeight)<(pos.y+30)){
							document.getElementById("divContent").scrollTop=pos.y+30;
						}else if(getDispatcherScroll()){
							document.getElementById("divContent").scrollTop=getDispatcherScroll();
						}
						if(index!=null){
							var grd=el.parentNode;
							while(grd.getAttribute("type")!="grid" && grd.tagName!="BODY"){
								grd=grd.parentNode;
							}
							if(grd.getAttribute("type")=="grid"){
								grd.firstChild.firstChild.scrollTop=getLocalPosition(el,grd.firstChild.firstChild).y;
							}
						}
						if(el.type=="hidden"){
							return;
						}
					//}
				//}
				el.focus();
				if(el.createTextRange && (el.type=="text" || el.tagName=="TEXTAREA")){
					var range = el.createTextRange();
					range.collapse(true);
					range.moveEnd('character', el.value.length);
					range.moveStart('character', el.value.length);
					range.select();
				}
				setDispatcherId(null);
				return;
				
			}
		}catch(e){
			e;
		}
		var elements=document.getElementsByTagName("*");
		var tabElement=document.getElementById("samplesTab");
		if(tabElement){
			elements=tabElement.tabs[tabElement.shownIndex].getElementsByTagName("*");
		}
		for(var i=0;i<elements.length;i++){
			var element=elements[i];
			if( (element.tagName=="INPUT" && element.type!="hidden") || (element.tagName=="SELECT") || (element.tagName=="TEXTAREA")){
				if(isVisible(element)){
					try{
					element.focus();
					}catch(e){}
					return;
				}
			}
		}
	}
}
function isVisible(element){
	if(element.style.visibility=="hidden" || element.style.display=="none" || element.disabled){
		return false;
	}
	var parent=element.parentNode;
	while(parent.tagName!="BODY"){
		parent=parent.parentNode;
		if(parent.style.visibility=="hidden" || parent.style.display=="none"){
			return false;
		}
	}
	return true;
}
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", function(){setScriptBehaviors()}, false);
}else{
	setScriptBehaviors();
	addListener(window,"unload",function(){unsetScriptBehaviors();});
}


function getElementsByName(name){
	var all=document.getElementsByTagName("*");
	var els=new Array();
	for(var i=0;i<all.length;i++){
		if(all[i].name==name){
			els.push(all[i]);
		}
	}
	return els;
}

function isAppended(element){
	var els=document.getElementsByTagName(element.tagName);
	for(var i=0;i<els.length;i++){
		if(els[i]==element){
			return true;
		}
	}
	return false;
}

function getPxValue(val){
	if(val.indexOf("px")){
		return val.split("px")[0];
	}
	return val;
}

function emulateLoaded(){
	if(!loaded){
		setScriptBehaviors();
	}
}

function fixTextAreas(){
	var areas=document.getElementsByTagName("TEXTAREA");
	var i=0;
	while(areas.length>0){
	//for(i=areas.length-1;i>0;i--){
		var area=areas[0];
		if(area.parentNode.tagName!="BODY" && area.id!="errorText"  && area.id!="txtMap"){
			var id=area.id;
			if(!id || id==""){
				id=area.name;
			}
			var name=area.name;
			var width=area.offsetWidth;
			var height=area.offsetHeight;
			var disabled=area.disabled;
			var readOnly=area.readOnly;
			var value=area.innerText;
			var maxLength=(area.getAttribute("p_maxlength")!=null);
			var numeric=(area.getAttribute("p_numeric")!=null);			
			var required=(area.getAttribute("p_required")!=null);
			var display=area.style.display;
			var visiblility=area.style.visiblility;
			if(!visiblility){
				visiblility="visible";
			}
			area.style.display="none";
			//var onchange=area.onchange;
			if(width==0){
				width=area.cols*3;
			}
			if(height==0){
				height=area.rows*20;
			}
			var html="<IFRAME id='area_"+id+"' width='"+width+"' height='"+height+"' name='area_"+i+"' style='display:"+display+";'></IFRAME><INPUT type='hidden' id='"+id+"' "+(required?"p_required='true' ":"")+(numeric?"p_numeric='true' ":"")+(maxLength?"p_maxlength='"+maxLength+"' maxlength='"+area.getAttribute("maxlength")+"' ":"")+"name='"+name+"' ie6TextArea='true' value='"+value+"'></INPUT>";
			var parent=area.parentNode;
			parent.innerHTML=html;
			try{
				parent.firstChild.style.visibility=visiblility;
			}catch(e){}
			try {
				if (parent.style.visibility == "hidden") parent.style.display = "none";
			}catch(e){}
			if(!disabled && !readOnly){
				window.frames["area_"+i].document.designMode="on";
			}else if(disabled){
				parent.getElementsByTagName("INPUT")[0].disabled=true;
			}else if(readOnly){
				parent.getElementsByTagName("INPUT")[0].readOnly=true;
			}

			var frame=window.frames["area_"+i];
			//window.frames["area_"+i].document.open();
			frame.document.open();
			var value2="";
			for(var i=0;i<value.length;i++){
				if(value.charAt(i)=="\n"){
					value2+="<P>&nbsp;</P>";
				}else{
					value2+=value.charAt(i);
				}
			}
			var body="<body frameId='"+id+"' areaId='area_"+i+"'></body>";
			var areaText='<head>'+
						'<style type="text/css">body{ font-family:arial; font-size:13px;margin:0px;padding:0px;'+
						((readOnly||disabled)?"color:#999999":"" )+
						' } p{margin:1px;}</style> </head>'+
						body;
			frame.document.write(areaText);
			frame.document.body.innerHTML=value2;
			
			setKeyUpEvent(frame);
			
			frame.document.onmousedown=function(){
				//document.getElementById(this.areaId).focus();
			}
			frame.document.close();
			if(readOnly){
				setIE6AreaRO(document.getElementById(id));
			}
		}else{
			var value=area.innerText;
			var input=document.createElement("INPUT");
			input.id=area.id;
			input.name=area.name;
			input.value=value;
			input.type="hidden";
			area.parentNode.appendChild(input);
			area.parentNode.removeChild(area);
		}
		i++;
	}
}

function setIE6AreaRO(area){
	var frame=area.parentNode.getElementsByTagName("IFRAME")[0];
	var frameWin=window.frames[frame.name];
	var value=frameWin.document.body.innerHTML;
	frameWin.readOnly="true";
	frameWin.document.designMode="off";
	frameWin.document.open();
	var body="<body></body>";
	var areaText='<head>'+
				'<style type="text/css">body{ font-family:arial; font-size:13px;margin:0px;padding:0px;'+
				"color:#999999;BACKGROUND-COLOR: #DCDCDC"+
				' } p{margin:1px;}</style> </head>'+
				body;
	frameWin.document.write(areaText);
	frameWin.document.body.innerHTML=value;
	frameWin.document.close();
}

function unsetIE6AreaRO(area){
	var frame=area.parentNode.getElementsByTagName("IFRAME")[0];
	var frameWin=window.frames[frame.name];
	var value=frameWin.document.body.innerHTML;
	frameWin.readOnly="false";
	frameWin.document.designMode="on";
	frameWin.document.open();
	var body="<body frameId='"+area.id+"' areaId='"+frame.id+"'></body>";
	var areaText='<head>'+
				'<style type="text/css">body{ font-family:arial; font-size:13px;margin:0px;padding:0px;'+
				"color:#000000"+
				' } p{margin:1px;}</style> </head>'+
				body;
	frameWin.document.write(areaText);
	frameWin.document.body.innerHTML=value;
	setKeyUpEvent(frameWin);
	frameWin.document.close();
}

function setKeyUpEvent(frame){
	frame.document.onkeyup=function(){
		var frameId=this.body.frameId;
		var txt=this.body.innerText;
		txt=(txt=="<P>&nbsp;</P>")?"":txt;
		if(txt.indexOf("&nbsp;")>0){
			txt.split("&nbsp;").join(" ");
		}
		var paragraphs=(this.body.innerHTML+"").split("<P>&nbsp;</P>");
		for(var i=0;i<(paragraphs.length-1);i++){
			txt+="\n";
		}
		var input=document.getElementById(frameId);
		input.value=txt;
		if(input.getAttribute("p_numeric")!=null){
			//input.validate();
			var num=validateNumber(input);
		}
		if(input.getAttribute("p_maxlength")!=null){
			var max=input.getAttribute("maxlength");
			if(input.value.length>max){
				var val=input.value.substring(0,max);
				input.value=val;
			}
		}
	}
}
