<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
		String className  = dBean.getShowObjectClass();
		HashMap classData = dBean.getConflictToModifyData();
	%><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"sbtImpConflictsModify")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpConflictsObjTyp")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblImpConflictsObjTyp")%>:</td><td colspan="3"><%=className%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpConflictsObjDat")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
					Iterator itKeys = classData.keySet().iterator();
					while (itKeys.hasNext()) {
						String field = (String)itKeys.next();
						Object[] valdata = (Object[])classData.get(field);
						Object value = valdata[0];
			 			out.print("<tr>");
						if (field.toLowerCase().indexOf("id") == -1) {
   			 			    out.print("<td>" + field + ":</td>");
				   			out.print("<td colspan='3'><input type='text' name='" + field + "' size='50' value='" + value + "'></td>");
				   		}
			 			out.print("</tr>");
					}
				%></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnCon_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importConflictModify.js'></script>

