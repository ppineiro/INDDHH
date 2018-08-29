<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			String className = dBean.getShowObjectClass();
			Collection classColumns   = dBean.getShowColumns();
			Collection classObjects   = dBean.getShowObjects();
			ArrayList classObjectIds  = (ArrayList)dBean.getShowObjectIds();
			
			// Get the VO name, and use it to get the description
			String voName = className.substring(className.lastIndexOf(".") + 1);
			voName = StringUtil.replace(voName, "Vo", "");
											
			String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));			
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"sbtImpConflictsList")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><!--     Import data information (numbers, entities, conflicts)							         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpConflictsObjTyp")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblImpConflictsObjTyp")%>:</td><td colspan="3"><%=description%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpConflictsObjDat")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><%	
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
							%><tr><td style="width:width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidClassId<%=i%>" value="<%=dBean.fmtStr(className + "-" + classObjectIds.get(i))%>"></td><%
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
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td>&nbsp;</td><td><button type="button" onclick="btnMapObject_click()" 
				   				    accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigMap")%>" 
				   				    title="<%=LabelManager.getToolTip(labelSet,"btnMigMap")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigMap")%></button><button type="button" onclick="btnUpdateObject_click()" 
				   			        accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigUpd")%>" 
				   			        title="<%=LabelManager.getToolTip(labelSet,"btnMigUpd")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigUpd")%></button><button type="button" onclick="btnModifyObject_click()" 
				   			        accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigMod")%>" 
				   			        title="<%=LabelManager.getToolTip(labelSet,"btnMigMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigMod")%></button><button type="button" onclick="btnRemoveObject_click()" 
				   			        accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigRem")%>" 
				   			        title="<%=LabelManager.getToolTip(labelSet,"btnMigRem")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigRem")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><iframe id="iframeKeepActive" style="display:none"></iframe><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importConflictObjects.js'></script>



