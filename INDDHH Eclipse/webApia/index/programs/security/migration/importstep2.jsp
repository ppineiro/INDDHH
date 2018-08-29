<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@page import="com.dogma.migration.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			EnvironmentVo envVo = dBean.getEnvVo();
			HashMap objMap = dBean.getImportObjects();
			HashMap jsMap  = dBean.getJavascriptMap();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMigEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigImpData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getName(labelSet,"lblMigImpFile")%>"><%=LabelManager.getName(labelSet,"lblMigImpFile")%>:
						</td><td colspan="3"><%=dBean.getImportZipFile().substring(dBean.getImportZipFile().lastIndexOf("\\") + 1)%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigImpEnvData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td></td><td></td><td></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblMigEnvName")%>:</td><td colspan="3"><%=envVo.getEnvName()%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblMigEnvDescription")%>:</td><td colspan="3"><%=envVo.getEnvDesc()%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpObjTypes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%="Seleccion de fila"%>"></th><th style="width:100%" title="<%=LabelManager.getName(labelSet,"lblImpObjTyp")%>"><%=LabelManager.getName(labelSet,"lblImpObjTyp")%>:
								</th><th style="width:150px" title="<%=LabelManager.getName(labelSet,"lblImpObjCnt")%>"><%=LabelManager.getName(labelSet,"lblImpObjCnt")%>:
								</th></tr></thead><tbody><%	
								if (objMap != null && objMap.size() > 0) {
									Iterator itkeys = objMap.keySet().iterator();
									int i = 0;
									while (itkeys.hasNext()) {
										String objKey = (String)itkeys.next(); 
										HashMap classMap = (HashMap)objMap.get(objKey);
										if (classMap != null && classMap.size() > 0) {
											ArrayList objects = new ArrayList(classMap.values());
											Object fstObj = objects.get(0);
											String className = fstObj.getClass().getName();
											
											// Get the VO name, and use it to get the description
											String voName = className.substring(className.lastIndexOf(".") + 1);
											voName = StringUtil.replace(voName, "Vo", "");
											
											String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(voName));
											
											String classCount = String.valueOf(objects.size()); %><tr><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidClassId<%=i%>" value="<%=dBean.fmtStr(className)%>"></td><td><%=dBean.fmtHTML(description)%></td><td><%=dBean.fmtHTML(classCount)%></td></tr><%
											i++;
										}
									}
								}
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"lblShowDetailMessage")%></td><td><button type="button" onclick="btnConflicts_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnConflicts")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnConflicts")%>"><%=LabelManager.getNameWAccess(labelSet,"btnConflicts")%></button><button type="button" onclick="btnShowObjects_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDetails")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnDetails")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDetails")%></button><%
								HashMap updateMap = dBean.getUpdateObjects();
								if (updateMap != null && updateMap.size() > 0) {
							%><button type="button" onclick="btnShowUpdates_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUpdates")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnUpdates")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUpdates")%></button><%
								}
							%></td></tr></table><% if (false /*jsMap != null && jsMap.size() > 0*/) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImpJSBC")%></DIV><div type="grid" id="jsGridList" style="height:<%=Parameters.SCREEN_LIST_SIZE / 2%>px"><table  width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%="Seleccion de fila"%>"></th><th style="width:90%" title="<%=LabelManager.getName(labelSet,"lblJSBCName")%>"><%=LabelManager.getName(labelSet,"lblJSBCName")%>:
								</th></tr></thead><tbody><%	
								Iterator itkeys = jsMap.keySet().iterator();
								int i = 0;
								while (itkeys.hasNext()) {
									String file = (String)itkeys.next(); 
									String[] data = (String[])jsMap.get(file);
									if (data != null && data.length == 2) {
							%><tr><td style="width:0px;display:none;"><input type="hidden" id="jsIdSel" name="jsChkSel<%=i%>"><input type="hidden" name="hidJSId<%=i%>" value="<%=dBean.fmtStr(file)%>"></td><td><%=dBean.fmtHTML(file)%></td></tr><%
									}
									i++;
								}
							%></tbody></table></div><table class="navBar"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"lblShowDetailMessage")%></td><td><button type="button" onclick="btnShowJS_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnShowJS")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnShowJS")%>"><%=LabelManager.getNameWAccess(labelSet,"btnShowJS")%></button><button type="button" onclick="btnRemoveJS_click()" 
				   					accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemoveJS")%>" 
				   					title="<%=LabelManager.getToolTip(labelSet,"btnRemoveJS")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemoveJS")%></button></td></tr></table><% } %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><iframe id="iframeKeepActive" style="display:none"></iframe><button type="button" onclick="btnAnt_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><button type="button" onclick="btnCon_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnVol_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnSal_click()" 
							accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" 
							title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/importstep2.js'></script>

