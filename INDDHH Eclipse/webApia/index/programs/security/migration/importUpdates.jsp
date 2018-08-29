<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			Map updateMap = dBean.getUpdateObjects();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMigEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><!--     Import data information (numbers, entities, conflicts)							         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpUpdatesObjTyp")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:80%" title="<%=LabelManager.getName(labelSet,"lblImpUpdatesObjTyp")%>"><%=LabelManager.getName(labelSet,"lblImpUpdatesObjTyp")%>:
								</th><th style="width:10%" title="<%=LabelManager.getName(labelSet,"lblImpUpdatesObjCnt")%>"><%=LabelManager.getName(labelSet,"lblImpUpdatesObjCnt")%>:
								</th></tr></thead><tbody><%	
								if (updateMap != null && updateMap.size() > 0) {
									Iterator itkeys = updateMap.keySet().iterator();
									int i = 0;
									while (itkeys.hasNext()) {
										String className = (String)itkeys.next(); 
										
										// Get the VO name, and use it to get the description
										String voName = className.substring(className.lastIndexOf(".") + 1);
										voName = StringUtil.replace(voName, "Vo", "");
											
										String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));
										
										HashMap objMap = (HashMap)updateMap.get(className);
										if (objMap != null && objMap.size() > 0) {
											String classCount = String.valueOf(objMap.size());
							%><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidClassId<%=i%>" value="<%=dBean.fmtStr(className)%>"></td><td><%=dBean.fmtHTML(description)%></td><td><%=dBean.fmtHTML(classCount)%></td></tr><%
											i++;
										}
									}
								}
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnShowObjects_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnShowObjects")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnShowObjects")%>"><%=LabelManager.getNameWAccess(labelSet,"btnShowObjects")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnVol_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importUpdates.js'></script>

