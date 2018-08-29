<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			String className = dBean.getShowObjectClass();
			Collection classColumns = dBean.getShowColumns();
			Collection classObjects = dBean.getShowObjects();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"lblImpObjects")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpSelectedType")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblImpSelectedType")%>:</td><%
							// Get the VO name, and use it to get the description
							String voName = className.substring(className.lastIndexOf(".") + 1);
							voName = StringUtil.replace(voName, "Vo", "");
											
							String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));		   			
			   			%><td colspan="3"><%=description%></td></tr></table><BR><div class="subTit"><%="Objetos"%></div><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><%	
								if (classColumns != null && classColumns.size() > 0) {
									String width = "width:100px";
									if (0 < classColumns.size() && classColumns.size() <= 8) {
										width = "width:" + (int)(100 / classColumns.size()) + "%";
									}
									
									Iterator it = classColumns.iterator();
									while (it.hasNext()) {
										String column = (String)it.next(); 
										out.println("<th style=\"" + width + "\">" + column + ":</th>");
									}
								}
							%></tr></thead><tbody><%	
								if (classObjects != null && classObjects.size() > 0) {
									Iterator it = classObjects.iterator();
									int i = 0;
									while (it.hasNext()) {
										Object[] values = (Object[])it.next(); 
							%><tr><%
										for (int j = 0; j < values.length; j++) {
											if (values[j] != null) {
 							%><td><%=dBean.fmtHTML(values[j].toString())%></td><%
											} else {
							%><td>&nbsp</td><%
											}
										}
										i++;
							%></tr><%
									}
								}
							%></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><iframe id="iframeKeepActive" style="display:none"></iframe><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importShowObjects.js'></script>

