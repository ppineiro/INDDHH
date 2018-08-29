<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@include file="../../../components/scripts/server/startInc.jsp" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.dogma.UserData"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/grid.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/gridContextMenu.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="<%=Parameters.ROOT_PATH%>../../../scripts/grid/grids.js"></script></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BusinessClassesBean"></jsp:useBean><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titUploadClass")%></TD></TR><TD></TD></TABLE><DIV id="divContent" class="divContent" style="overflow:hidden;"><form id="frmUploadClass" name="frmUploadClass" method="POST" target="ifrUno" enctype="multipart/form-data"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtUploadClass")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblUploadClass")%>"><%=LabelManager.getName(labelSet,"lblUploadClass")%>:</td><td colspan=3><input style="width:340px" type="FILE" accesskey="<%=LabelManager.getToolTip(labelSet,"lblUploadClass")%>" name="fileName" size="35" ></td></tr></table></form><iframe name=ifrUno src="" style="visibility:hidden;height:0px;width:0px;"></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><div id="isOpen" style="display:none" isOpen="true"></div></body></html><%@include file="../../../components/scripts/server/endModalInc.jsp" %><script language="javascript">

function btnExit_click() {
	window.close();
}
</script><SCRIPT>

function btnConf_click() {
	
	
	if (document.getElementById("fileName").value != null && document.getElementById("fileName").value.length > 0) {
		var split = document.getElementById("fileName").value.split('.');
		if(split.length < 2 || split[split.length-1] != "class") {
			alert("<%=LabelManager.getName(labelSet,"msgUploadedFileNotSupported")%>");
			return false;
		}
		document.getElementById("frmUploadClass").action = "administration.BusinessClassesAction.do?action=confirmUpload";
		submitFormModal(document.getElementById("frmUploadClass"));
		showWaitFrame();
		
	} else {
		return false;
	}
}

function btnExit_click() {
	window.close();
}

function submitOK() {
	window.close();
}


</SCRIPT>