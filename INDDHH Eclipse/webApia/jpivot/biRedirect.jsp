<%@page import="com.dogma.*"%><html><head><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script language="javascript">

function init(){
	var biFrame=document.getElementById("biFrame");
	
	if (!MSIE){
		biFrame.addEventListener('load', function(){
			hideWaitAMoment();
		}
		, false);
	}else{
		var func=function(){
			hideWaitAMoment();
		}
		biFrame.attachEvent("onreadystatechange", func);
	}
	biFrame.src="<%=request.getAttribute("biUrl")%>";
}

function hideWaitAMoment(){
	var win=window;
	while((!win.document.getElementById("iframeMessages") || !win.document.getElementById("workArea") || !win.document.getElementById("iframeResult")) && (win!=win.parent) ){
		win=win.parent;
	}
	if(win.document.getElementById("iframeMessages") && win.document.getElementById("iframeResult")){
		win.document.getElementById("iframeMessages").hideResultFrame();
		win.document.getElementById("iframeResult").hideResultFrame();
	}

}
</script></head><body onload="init();" padding="0" style="margin:0px"><iframe id="biFrame" height="100%" width="100%" frameBorder="0" src="" scrolling="NO"></iframe></body></html>