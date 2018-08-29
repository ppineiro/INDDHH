<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			String className = dBean.getShowObjectClass();

			// Get the VO name, and use it to get the description
			String voName = className.substring(className.lastIndexOf(".") + 1);
			voName = StringUtil.replace(voName, "Vo", "");
									
			String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));								
			
			Collection classColumns   = dBean.getShowColumns();
			Collection classObjects   = dBean.getShowObjects();
			ArrayList classObjectIds  = (ArrayList)dBean.getShowObjectIds();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titImpObjects")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><!--     Import data information (numbers, entities, conflicts)							         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpUpdatesObjTyp")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblImpUpdatesObjTyp")%>:</td><td colspan="3"><%=description%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblImpUpdatesObjDat")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><%	
								if (classColumns != null && classColumns.size() > 0) {
									String width = "width:100px";
									if (0 < classColumns.size() && classColumns.size() <= 8) {
										width = "width:" + (int)(100 / classColumns.size()) + "%";
									}
									
									Iterator it = classColumns.iterator();
									while (it.hasNext()) {
										String column = (String)it.next(); 
										out.print("<th style='" + width + "'>" + column + ":</th>");
									}
								}
							%></tr></thead><tbody><%	
								if (classObjects != null && classObjects.size() > 0) {
									Iterator it = classObjects.iterator();
									int i = 0;
									while (it.hasNext()) {
										Object[] values = (Object[])it.next(); 
							%><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidClassId<%=i%>" value="<%=dBean.fmtStr(className + "-" + classObjectIds.get(i))%>"></td><%
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
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td>&nbsp;</td><td><button type="button" onclick="btnRemoveObject_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnImpRemoveObjects")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnImpRemoveObjects")%>"><%=LabelManager.getNameWAccess(labelSet,"btnImpRemoveObjects")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnVol_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importUpdateObjects.js'></script>



