<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.util.DogmaUtil"%><HTML><head><script language="javascript" src="<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/flash.js"></script><script language="javascript">
	function proTypeChange(){}
</script><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.SimScenarioBean"></jsp:useBean><body><div id="divContent"><form id="frmMain" name="frmMain" method="POST" target="mapsubmit"><!--     - MAPA DEL PROCESSO          --><TABLE WIDTH="100%" HEIGHT="100%" BORDER=0 cellspacing=0><TR><TD VALIGN="middle" ALIGN="center"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  id="Designer" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0" WIDTH="98%" HEIGHT="500px" style="/*border:1px solid blue*/" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="allways" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/BPMN/Simulator.swf" /><param name="FlashVars" value="elementAtts=<%=Parameters.ROOT_PATH%>/flash/BPMN/simulatorElementAttributes.jsp&urlBase=<%=Parameters.ROOT_PATH%>/flash/BPMN/"/><param name="quality" value="high" /><param name="menu" value="false"><param name="bgcolor" value="#EFEFEF" /><param name="WMODE" value="transparent" /><embed wmode="transparent" id="Designer" name="Designer" menu="false" allowScriptAccess="allways" src="<%=Parameters.ROOT_PATH%>/flash/BPMN/Simulator.swf" flashVars="elementAtts=<%=Parameters.ROOT_PATH%>/flash/BPMN/simulatorElementAttributes.jsp&urlBase=<%=Parameters.ROOT_PATH%>/flash/BPMN/" quality="high" bgcolor="#efefef" width="98%" height="450" swLiveConnect="true"   align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object></TD></TR></TABLE><table width=100% style="display:none"><tr><td align=right vAlign="middle"><%=LabelManager.getName(labelSet,"tabProMap")%>:</td><td vAlign="middle"><TEXTAREA p_required="true" name="txtMap" cols="100" rows="30"><%=StringUtil.replace(dBean.getProcessXml(), "&", "&amp;")%></TEXTAREA><TEXTAREA p_required="true" name="txtSimulation" id="txtSimulation" cols="100" rows="30"><%=StringUtil.replace(dBean.getSimulatorXml(), "&", "&amp;")%></TEXTAREA><input type=hidden name="txtProId" value="<%=dBean.getActualProId()%>"></td></tr></table></FORM><iframe id="mapsubmit" name="mapsubmit" style="width:0px;height:0px;top:-10px;position:absolute" border="no"></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	getFlashMovie("Designer").getSimulation();
}
function btnExit_click() {
	window.returnValue=null;
	window.close();
}
function getSelected(){
	return null;
}

function saveSimulation(xml){
	document.getElementById("txtSimulation").value=xml;
	document.getElementById("frmMain").action="administration.SimScenarioAction.do?action=verifieXML" + windowId;
	submitForm(document.getElementById("frmMain"));
}

function setSimulation(){
	var xml=document.getElementById("txtSimulation").value;
	getFlashMovie("Designer").setSimulation(xml);
}

function validScenario(){
	window.returnValue=document.getElementById("txtSimulation").value;
	window.close();
}

function invalidScenario(errornum){
	alert(errornum);
}

</script>
