function setPropertyChanged(obj){
	var funcAux="";
	if(obj.onchange){
		var funcAux=obj.onchange+"";
	}
	if(obj.onclick){
		funcAux+=obj.onclick;
		obj.onclick=null;
	}
	if(funcAux.indexOf("this.parentNode.focus();")>=0){
		funcAux=( funcAux.split("this.parentNode.focus();")[1] ).split("}")[0];
	}
	if(funcAux.indexOf("function")>=0){
		funcAux=funcAux.substring((funcAux.indexOf("{")+1),funcAux.lastIndexOf("}"));
	}
	//var func=function(){setTimeout(funcAux,0);}
	if(obj.getAttribute("onpropertychange")){
		funcAux+=" var evt=getEventObject(event);"+obj.getAttribute("onpropertychange").split("this").join("getEventSource(evt)");
	}
	var func=new Function("event",funcAux);
	obj.addEventListener("change",func,true);
	obj.onchange=function(event){
		event.target.parentNode.getElementsByTagName("INPUT")[1].value=event.target.checked+"";
	}
	obj.setAttribute("onpropertychange","")
}

function unsetPropertyChanged(obj){
	delete(obj.onchange)
}

function setPropertiesChanged(){
	if(!MSIE){
		var inputs=document.getElementsByTagName("INPUT");
		for(var i=0;i<inputs.length;i++){
			if(inputs[i].getAttribute("onpropertychange")!=null){
				setPropertyChanged(inputs[i]);
			}
		}
	}
}
//mozilla defer
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setPropertiesChanged, false);
}