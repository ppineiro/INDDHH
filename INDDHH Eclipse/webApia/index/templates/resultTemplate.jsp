<%@taglib uri='regions' prefix='region'%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.StringUtil"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/frmTargetStart.jsp" %><script language="javascript">
	var autoClose =   "<region:render section='closeAutomatically'/>";
	var closeWindow = "<region:render section='navigate'/>";
	var nextUrl		= "<region:render section='nextUrl'/>";
	var btnSalir	= "<region:render section='btnSalir'/>";
	
	if (nextUrl == "") {
		nextUrl = "/FramesAction.do?action=splash";
	}

	function btnConf_click(){
		window.parent.document.getElementById("iframeResult").hideResultFrame();
		if (closeWindow == "true") {
			window.parent.document.getElementById("iframeResult").getBody().document.location.href="<%=Parameters.ROOT_PATH%>" + nextUrl;
		}
	}
</script><div id="divMsg" style="height:195px;overflow:hidden;"><table class="tblTitulo"><tr><td><region:render section='title'/></td></tr></table><!-----------------------------START CONTENT----------------><div class="divContent" id="divContent" style="width:340px; height:147px;overflow:auto;display:block;"><form id="frmMain" name="frmMain" method="POST"><table><tr><td id="preMsg"><region:render section='message'/></td></tr></table></form></div><!--------START BUTTONBAR-------------------------><table id="btnsBar" class="btnsBar" style="display:block;"><tr><td align="right" width=100% nowrap><button onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCon")%></button> &nbsp; 
				<button id="btnSalir" style="visibility:hidden" onclick="window.parent.document.getElementById('iframeResult').hideResultFrame()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnSal")%></button></td></tr></table></div><!--------END BUTTONBAR-------------------------></body></html><script language="javascript" defer="true">
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setBtnSalir, false);
}else{
	setBtnSalir();
}
function setBtnSalir(){
	if (btnSalir == "true") {
		document.getElementById("btnSalir").style.visibility = "visible";
	} else {
		document.getElementById("btnSalir").style.display = "none";	
	}
}
</script><%@include file="../components/scripts/server/frmTargetEnd.jsp" %>