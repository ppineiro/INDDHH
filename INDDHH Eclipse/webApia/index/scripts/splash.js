//window.document.onreadystatechange=fnStartDocInit;

function fnStartDocInit(){
	//if (document.readyState=='complete' || (window.navigator.appVersion.indexOf('MSIE')<0) ){
		try {
			var win=window;
			while(!win.document.getElementById("iframeMessages") ){
			win=win.parent;
			}
			win.document.getElementById("iframeMessages").onclose=function(){
				if(window.parent.name.indexOf("modal")>=0 ){window.parent.close();}
				if(window.name.indexOf("modal")>=0 ){window.close();}
				if(windowId){
					try{window.closeThisWindow()}catch(e){}
				}
			}						 
			setTimeout(function(){win.document.getElementById("iframeMessages").showMessage(document.getElementById("errorText").value, document.body);},200);
		} catch (e) {
			str = document.getElementById("errorText").value;
			if (str.indexOf("</PRE>") != null) {
			str = str.substring(5,str.indexOf("</PRE>"));
			}
			alert(str);
		}
	//}
}

if (document.addEventListener) {
	document.addEventListener('DOMContentLoaded', fnStartDocInit, false);
}else{
	fnStartDocInit();
}