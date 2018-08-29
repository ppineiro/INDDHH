<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="viewFilterLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet, "titVwFilter")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><tr><td  style="text-align: right;" title="<%=LabelManager.getToolTip(labelSet,"lblCla")%>"><%=LabelManager.getName(labelSet,"lblCla")%>:</td><td><input style="width: 100%" name="inpCla" id="inpCla" type="text"></td><td><button style="margin-left: 7px" type="button" id="btnTest" onclick="btnTest_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTest")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTest")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTest")%></button></td></tr><tr><td  style="text-align: right;" title="<%=LabelManager.getToolTip(labelSet,"lblPar1")%>"><%=LabelManager.getName(labelSet,"lblPar1")%>:</td><td><input name="inpPar1" id="inpPar1" type="text"></td></tr><tr><td  style="text-align: right;" title="<%=LabelManager.getToolTip(labelSet,"lblPar2")%>"><%=LabelManager.getName(labelSet,"lblPar2")%>:</td><td><input name="inpPar1" id="inpPar2" type="text"></td></tr></table><iframe name="toolbarSubmit" style="height:1px;width:1px;visibility:hidden;"></iframe></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></td><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
var viewId = <%=request.getParameter("viewId")%>;
var userId = "<%=request.getParameter("userId")%>";

function viewFilterLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/viewFilterXML.jsp?vwId=" + viewId;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readVwFilterXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

/*
 * 
 <ROW><VW_FILTER_CLASS>lallala</VW_FILTER_CLASS><VW_FILTER_PAR1>lala</VW_FILTER_PAR1><VW_FILTER_PAR2>lal2</VW_FILTER_PAR2></ROW>
 */
function readVwFilterXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
		var currentNode = xmlRoot.childNodes[0];
		var tagName = currentNode.nodeName;
		var tagValue = currentNode.firstChild.nodeValue;
		if (tagName == "VW_FILTER_CLASS"){
			if (tagValue==null || tagValue=="null") tagValue = "";
			document.getElementById("inpCla").value = tagValue;
		}
		
		currentNode = xmlRoot.childNodes[1];
		tagName = currentNode.nodeName;
		tagValue = currentNode.firstChild.nodeValue;
		
		if (tagName == "VW_FILTER_PAR1"){
			if (tagValue==null || tagValue=="null") tagValue = "";
			document.getElementById("inpPar1").value = tagValue;
		}
		
		currentNode = xmlRoot.childNodes[2];
		tagName = currentNode.nodeName;
		tagValue = currentNode.firstChild.nodeValue;
		
		if (tagName == "VW_FILTER_PAR2"){
			if (tagValue==null || tagValue=="null") tagValue = "";
			document.getElementById("inpPar2").value = tagValue;
		}
		
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}	

function btnTest_click() {
	var vars = "&after=afterTest&className=" + document.getElementById('inpCla').value;
	var frm = document.getElementById("frmMain");
	var action = frm.action;
	var target = frm.target;
	
	frm.action = URL_ROOT_PATH + "/Views?action=testViewFilterClass" + vars;
	frm.target = "toolbarSubmit";
	submitForm(frm);
	
	frm.action=action;
	frm.target=target;
}

function btnConf_click() {
	var claName = encodeURIComponent(document.getElementById("inpCla").value);
	var inpPar1 = encodeURIComponent(document.getElementById("inpPar1").value);
	var inpPar2 = encodeURIComponent(document.getElementById("inpPar2").value);
	var vars="&after=afterConfirm&className=" + claName + "&inpPar1=" + inpPar1 + "&inpPar2=" + inpPar2 + "&viewId="+viewId + "&userId=" + userId;
	
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action=URL_ROOT_PATH+"/Views?action=confirmViewFilterClass"+vars;
	frm.target="toolbarSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}	

function afterTest(result) {
	alert(result);
}

function afterConfirm(result) {
	window.returnValue=result;
	window.close();
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>