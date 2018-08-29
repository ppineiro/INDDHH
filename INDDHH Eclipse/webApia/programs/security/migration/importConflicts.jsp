<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			Map confMap = dBean.getImportConflicts();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"sbtImpConflicts")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpConflictObjTypes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getName(labelSet,"lblImpConflictsObjTyp")%>"><%=LabelManager.getName(labelSet,"lblImpConflictsObjTyp")%>:
								</th><th style="width:190px" title="<%=LabelManager.getName(labelSet,"lblImpConflictsObjCnt")%>"><%=LabelManager.getName(labelSet,"lblImpConflictsObjCnt")%>:
								</th></tr></thead><tbody><%	
								if (confMap != null && confMap.size() > 0) {
									Iterator itkeys = confMap.keySet().iterator();
									int i = 0;
									while (itkeys.hasNext()) {
										String className = (String)itkeys.next(); 
										
										// Get the VO name, and use it to get the description
										String voName = className.substring(className.lastIndexOf(".") + 1);
										voName = StringUtil.replace(voName, "Vo", "");
											
										String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));										
										
										HashMap objMap = (HashMap)confMap.get(className);
										if (objMap != null && objMap.size() > 0) {
											String classCount = String.valueOf(objMap.size());
							%><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidClassId<%=i%>" value="<%=dBean.fmtStr(className)%>"></td><td><%=dBean.fmtHTML(description)%></td><td><%=dBean.fmtHTML(classCount)%></td></tr><%
											i++;
										}
									}
								}
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td>&nbsp;</td><td><button type="button" onclick="btnMapObjects_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigMap")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMigMap")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigMap")%></button><button type="button" onclick="btnUpdateObjects_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigUpd")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMigUpd")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigUpd")%></button><button type="button" onclick="btnRemoveObjects_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigRem")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMigRem")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigRem")%></button><button type="button" onclick="btnShowObjects_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMigShowAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMigShowAll")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMigShowAll")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><iframe id="iframeKeepActive" style="display:none"></iframe><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importConflicts.js'></script>

