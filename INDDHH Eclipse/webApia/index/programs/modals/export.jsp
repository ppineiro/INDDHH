<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.busClass.object.Parameter"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titExport")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><% if (request.getParameter("hiddeHtml") == null) {%><input type="radio" checked id="format" name="format" value="html"><%=LabelManager.getName(labelSet,"lblHtml")%><br><% } %><% if (request.getParameter("hiddePdf") == null) {%><input type="radio" checked id="format" name="format" value="pdf"><%=LabelManager.getName(labelSet,"lblPdf")%><br><% } %><% if (request.getParameter("hiddeExcel") == null) {%><input type="radio" checked id="format" name="format" value="excel"><%=LabelManager.getName(labelSet,"lblExcel")%><br><% } %><% if (request.getParameter("hiddeCSV") == null) {%><input type="radio" checked id="format" name="format" value="csv"><%=LabelManager.getName(labelSet,"lblCsv")%><br><% } %><% if (request.getParameter("hiddeXPDL") == null) {%><input type="radio" checked id="format" name="format" value="xpdl"><%=LabelManager.getName("lblXpdl")%><br><% } %><% if (request.getParameter("showXML") != null && request.getParameter("showXML").equals("true")) { %><input type="radio"   checked id="format" name="format" value="xml"><%=LabelManager.getName(labelSet,"lblXml")%><br><% } %><% if (request.getParameter("hiddeTXT") == null) { %><input type="radio"   checked id="format" name="format" value="txt"><%=LabelManager.getName(labelSet,"lblTxt")%><br><% } %><% if (request.getParameter("hiddeCount") == null) { %><%if ("true".equals(request.getParameter("isQuery"))){ %><br><input type="radio" id="count" name="count" value="all"><%=LabelManager.getName(labelSet,"lblExpAll").concat(" ("+ LabelManager.getName(labelSet,"flaMax") + " " + Parameters.MAX_EXPORT_QUERY.toString() + ")")%><br><input type="radio" id="count" name="count" value="actual" checked><%=LabelManager.getName(labelSet,"lblExpAct").concat(" (" + LabelManager.getName(labelSet,"flaMax") + " " + Parameters.MAX_RESULT_QUERY.toString() + ")")%><%}else{ %><br><input type="radio" id="count" name="count" value="all"><%=LabelManager.getName(labelSet,"lblExpAll")%><br><input type="radio" id="count" name="count" value="actual" checked><%=LabelManager.getName(labelSet,"lblExpAct")%><%} %><% }%></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">

function btnConf_click() {
	var value;
	value = new Array();
	value[0] = null;
	value[1] = null;
	var formats=new Array();
	for(var i=0;i<document.getElementsByTagName("INPUT").length;i++){
		if(document.getElementsByTagName("INPUT")[i].id=="format"){
			formats.push(document.getElementsByTagName("INPUT")[i]);
		}
	}
	for (i = 0; i < formats.length && value[0] == null; i++) {
		if (formats[i].checked) {
			value[0] = formats[i].value;
		}
	}
	<% if (request.getParameter("hiddeCount") == null) { %>
		var counts=new Array();
		for(var i=0;i<document.getElementsByTagName("INPUT").length;i++){
			if(document.getElementsByTagName("INPUT")[i].id=="count"){
				counts.push(document.getElementsByTagName("INPUT")[i]);
			}
		}
		for (i = 0; i < counts.length && value[1] == null; i++) {
			if (counts[i].checked) {
				value[1] = counts[i].value;
			}
		}
	<% } %>
	window.returnValue = value;
	window.close();
}	

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>
