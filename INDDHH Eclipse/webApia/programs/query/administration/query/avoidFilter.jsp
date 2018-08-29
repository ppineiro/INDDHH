<%@page import="com.dogma.vo.custom.QryColFilterMappingVo"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.*" %><%@include file="../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QueryBean"></jsp:useBean><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body onload="checkClose();"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQryAvoidFilter")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><% 
			Integer qryToId = Integer.parseInt(StringUtil.split(request.getParameter("qryToId"),"_")[1]);
			Collection possibleColumns = qBean.getPossibleAvoidColumns(request, qryToId);
			boolean doClose = false;
			if (possibleColumns == null || possibleColumns.size() == 0) { 
				doClose = true; %><%=LabelManager.getName(labelSet,"lblQryNotAutoFilter")%><%=LabelManager.getToolTip(labelSet,"lblQryNotAutoFilter")%><%
			} else { %><div type="grid" id="gridPools" style="height:200px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:30px" title="">&nbsp;</th><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblLab")%>"><%=LabelManager.getName(labelSet,"lblQryFil")%></th></tr></thead><tbody ><%
				   			for (Iterator it = possibleColumns.iterator(); it.hasNext(); ) {
								QryColFilterMappingVo filterMapping = (QryColFilterMappingVo) it.next(); %><tr x_notselectable="true"><td style="width:0px;display:none;"><input type="hidden"><input type="hidden" name="mappgins" value="<%= filterMapping.getQryColName() %>"></td><td><input type="checkbox" name="<%= filterMapping.getQryColName() %>" id="<%= filterMapping.getQryColName() %>" checked></td><td><%= filterMapping.getQryColTitle() %></td><td><%= filterMapping.getQryFilTitle() %></td></tr><%
				   			} %></tbody></table></div><%
			} %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="right""><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function getSelected(){
	var mappings = document.getElementsByName("mappgins");
	if (mappings != null) {
		var result = new Array();
		for (i = 0; i < mappings.length; i++) {
			var mapping = mappings[i];
			var checkbox = document.getElementById(mapping.value);

			arr = new Array();
			arr[0] = mapping.value;
			arr[1] = ! checkbox.checked;
			
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function checkClose() {
	<% if (doClose) { %>
		btnExit_click();
	<% } %>
}
</script>