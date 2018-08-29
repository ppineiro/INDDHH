function sizeMe(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		var height=window.parent.document.getElementById(window.name).offsetHeight-30;
		if (document.getElementById("divContent")){
			document.getElementById("divContent").style.height=height+"px";
		}
	}else{
		var height=window.innerHeight;
		if(document.getElementById("divContent")){
			document.getElementById("divContent").style.height=(height-30)+"px";
		}
	}
}

function init(){
	window.onresize=function(evt){
		if(window.event){
			evt=window.event;
		}
		evt.cancelBubble=true;
		sizeMe();
	}
	try{sizeMe();}catch(e){};
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}else{
	init();
}
