<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.busClass.object.Parameter"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupHierarchyBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titExport")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><tr><td><%=LabelManager.getName(labelSet,"lblExpTo")%>:</td><td colspan=2><input type="radio" checked id="format" name="format" value="excel"><%=LabelManager.getName(labelSet,"lblExcel")%></input></td></tr><tr><td></td><td colspan=2><input type="radio" id="format" name="format" value="csv"><%=LabelManager.getName(labelSet,"lblCsv")%></input></td></tr><tr><td></td><td colspan=2><input type="radio" id="format" name="format" value="xml"><%=LabelManager.getName(labelSet,"lblXml")%></input></td></tr><tr><td></td><td></td><td></td><td></td></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">

function btnConf_click() {
	//1. Recuperamos el formato seleccionado
	var result = new Array();
	var formats=new Array();
	for(var i=0;i<document.getElementsByTagName("INPUT").length;i++){
		if(document.getElementsByTagName("INPUT")[i].id=="format"){
			formats.push(document.getElementsByTagName("INPUT")[i]);
		}
	}
	for (i = 0; i < formats.length && result[0] == null; i++) {
		if (formats[i].checked) {
			result[0] = formats[i].value;
		}
	}
		
	window.returnValue = result;
	window.close();
}	

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>
