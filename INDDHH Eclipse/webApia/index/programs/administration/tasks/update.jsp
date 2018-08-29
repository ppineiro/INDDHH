<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskBean"></jsp:useBean><%
TskDefinitionVo taskVo = dBean.getTskDefinitionVo();
boolean envUsesHierarchy = "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request), EnvParameters.ENV_USES_HIERARCHY));
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (taskVo.getTskId()==null)?true:dBean.hasWritePermission(request, taskVo.getTskId(), taskVo.getPrjId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titTar")%></TD><TD></TD></TR></TABLE><div id="divContent" style="height:200px"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatTar")%></DIV><table class="tblFormLayout" cellpadding="0" cellspacing="0"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   							boolean hasProject = (taskVo.getPrjId() != null && taskVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   						Iterator itPrj = colProj.iterator();
			   						ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   								prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   								<%if (hasProject) {
											if (prjVo.getPrjId().equals(taskVo.getPrjId())) {
												out.print ("selected");
											}%>
											><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input p_required=true name="txtName" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(taskVo!=null) {%>value="<%=dBean.fmtStr(taskVo.getTskName())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input p_required=true name="txtTitle" maxlength="255" onchange="document.getElementById('docTit').value=this.value" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" <%if(taskVo!=null) {%>value="<%=dBean.fmtStr(taskVo.getTskTitle())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan="3"><input name="txtDesc" size="80" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(taskVo!=null) {%>value="<%=dBean.fmtStr(taskVo.getTskDesc())%>"<%}%>></td></tr><!--     - TEMPLATES          --><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTem")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTem")%>:</td><td colspan=4><select name="txtTemplate" onchange="changeTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTem")%>"><%	String[][] templates = com.dogma.DogmaConstants.TSK_TEMPLATES;
							boolean isCustomTemplate = taskVo.getTskExeTemplate() != null;
							boolean canView = false;
							for (int i=0;i< templates.length;i++) {
								out.print("<option value=\"" + dBean.fmtStr(templates[i][1]) + "\"" );
								if ((	(taskVo.getTskExeTemplate() != null && 
									 	taskVo.getTskExeTemplate().equals(templates[i][1]))) || 
									 	(taskVo.getTskExeTemplate() == null && templates[i][1] == null)) {
									out.print(" selected ");
									isCustomTemplate = false;
									canView = true;
								}
								out.print(">");
								out.print(LabelManager.getName(labelSet,templates[i][0]));
								out.print("\n");
							}
							%><option value="<CUSTOM>" <%=isCustomTemplate?"selected":""%>><%=LabelManager.getName(labelSet,"lblTemCustom")%></select>
		   				&nbsp;
						<button type="button" id="btnVerOne" <%if (isCustomTemplate) {%>style="display:none"<%}%><% if (! canView) {%>disabled<% } %> onclick="btnViewTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button><input id=customTemplate onkeyup="customKeyPress()" type="text" name="txtCusTemplate" size="40" <%if (!isCustomTemplate) {%>disabled="true" style="visibility:hidden"<%} else {%> value="<%=dBean.fmtStr(taskVo.getTskExeTemplate())%>" <%}%>>
		   				&nbsp;
						<button type="button" id="btnVerTwo" <%if (!isCustomTemplate) {%>style="visibility:hidden"<%}%> onclick="btnViewTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblPerDel")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPerDel")%>:</td><td><input type="checkbox" name="txtPerDel" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPerDel")%>" <%if(taskVo.getFlagValue(TaskVo.POS_FLAG_DELEGATE)) {%>checked<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblImage")%>"><%=LabelManager.getNameWAccess(labelSet,"lblImage")%>:</td><%String img=( "".equals(taskVo.getImgPath()) || taskVo.getImgPath()==null  )?"":taskVo.getImgPath();%><td><div onclick="openImagePicker(this)" style="cursor:pointer;cursor:hand;position:relative;width:50px;height:50px;background-image:url(<%=Parameters.ROOT_PATH+"/images/"%><%=img==""?"uploaded/taskicon.png":"uploaded/"+img%>)"><input type="hidden" name="txtTaskImg" id="txtTaskImg" value="<%=img%>" /></div></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabAct")%>" tabText="<%=LabelManager.getName(labelSet,"tabAct")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDurAct")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblIniTskAtr")%>"><%=LabelManager.getNameWAccess(labelSet,"lblIniTskAtr")%>:</td><td><input type=text maxlength=3 size=4 name="txtTskDurMaxD" p_numeric="true" integer=true value="<%=dBean.fmtInt(taskVo.getTskMaxDurationDay())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDurMax")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDay")%><input type=text maxlength=3 size=4 name="txtTskDurMaxH" p_numeric="true" integer=true value="<%=dBean.fmtInt(taskVo.getTskMaxDurationHour())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDurMax")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHour")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipNot")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipNot")%>:</td><td><input type=checkbox name="chkNotEma" <%
		   				if (taskVo.isNotEmail()) {
		   					out.print("checked");
						}%> value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotMail")%></td></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblIniTskAle")%>"><%=LabelManager.getNameWAccess(labelSet,"lblIniTskAle")%>:</td><td><input type=text maxlength=3 size=4 name="txtTskDurAleD" p_numeric="true" integer=true value="<%=dBean.fmtInt(taskVo.getTskAlertDurationDay())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDurAle")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDay")%><input type=text maxlength=3 size=4 name="txtTskDurAleH" p_numeric="true" integer=true value="<%=dBean.fmtInt(taskVo.getTskAlertDurationHour())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDurAle")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHour")%></td><td><font style="visibility:hidden"><%=LabelManager.getName(labelSet,"lblTipNot")%>:</font></td><td><input type=checkbox name="chkNotMes" <%
		   				if (taskVo.isNotMessage()) {
		   					out.print("checked");
						}%>  value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotMes")%></td><td></td><td></td></tr><tr><td></td><td></td><td><font style="visibility:hidden"><%=LabelManager.getName(labelSet,"lblTipNot")%>:</font></td><td><input type=checkbox name="chkNotChat" <%
		   				if (taskVo.isNotChat()) {
		   					out.print("checked");
						}%>  value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotChat")%></td><td></td><td></td></tr><tr><td></td><td></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTskInAtr")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTskInAtr")%>:</td><td><input type=checkbox name="chkLibTas" <%if(taskVo.getFlagValue(TaskVo.POS_FLAG_LIB_TSK)) {%>checked<%}%> value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLibTsk")%>"><%=LabelManager.getName(labelSet,"lblLibTsk")%></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td><%Collection colPools = dBean.getEnvPools(request);
   						   boolean hasPool = (taskVo.getTskGruReasign() != null && taskVo.getTskGruReasign().intValue() != 0);%><input type=checkbox name="chkReaGru" value="1" <%if (hasPool==true){%>checked <%}%>onclick="chkReaGruFun()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblReaTskGru")%>"><%=LabelManager.getName(labelSet,"lblReaTskGru")%>:			   
				   		<select name="reaGroups" id="reaGroups" <%if (hasPool==false){%>disabled = "true" <%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colPools != null && colPools.size()>0) {
			   				Iterator itPool = colPools.iterator();
			   				PoolVo poolVo = null;%><option value="0"></option><%while (itPool.hasNext()) {
		   						poolVo = (PoolVo) itPool.next();%><option value="<%=poolVo.getPoolId()%>"
		   						<%if (hasPool) {
									if (poolVo.getPoolId().equals(taskVo.getTskGruReasign())) {
										out.print ("selected");
											}%>
											><%=poolVo.getPoolName()%></option><%} else {%>
											><%=poolVo.getPoolName()%></option><%}
			   						}%></select><%}%></select></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtNot")%></DIV><!--     - NOTIFICACIONES          --><div type="grid" id="gridUsers" style="height:220px"><table id="tblUsers" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="200px" style="width:200px" title=""></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskAsi")%>"><%=LabelManager.getName(labelSet,"lblTskAsi")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskCom")%>"><%=LabelManager.getName(labelSet,"lblTskCom")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskAcq")%>"><%=LabelManager.getName(labelSet,"lblTskAcq")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskRel")%>"><%=LabelManager.getName(labelSet,"lblTskRel")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskAle")%>"><%=LabelManager.getName(labelSet,"lblTskAle")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskOver")%>"><%=LabelManager.getName(labelSet,"lblTskOver")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskRea")%>"><%=LabelManager.getName(labelSet,"lblTskRea")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskEle")%>"><%=LabelManager.getName(labelSet,"lblTskEle")%></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTskDele")%>"><%=LabelManager.getName(labelSet,"lblTskDele")%></th></tr></thead><tbody id="tblUsrBody"><%
					Collection notifications = taskVo.getTskNotGenericCol();
					if (notifications != null) {
						Iterator iterator = notifications.iterator();
						TskNotificationVo notVo = null;
						while (iterator.hasNext()) {
							notVo = (TskNotificationVo) iterator.next(); %><tr><td><%=LabelManager.getName(labelSet,"lblTskNot" + notVo.getTskNotTo())%></td><% if (TskNotificationVo.NOTIFY_CREATE_USER.equals(notVo.getTskNotTo()) || TskNotificationVo.NOTIFY_ENTITY_CREATE_USER.equals(notVo.getTskNotTo())) { %><td align="center"><input type="checkbox" name="tskAsi<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnAsigned() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskCom<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnComplete() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskAcq<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnAcquired() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskRel<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnRelease() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskAla<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnAlarm() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskOver<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnOverdue() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskRea<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnReasign() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskEle<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnElevate() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="tskDele<%=notVo.getTskNotTo()%>" <%=(notVo.getTskNotOnDelegate() != null)?"checked":""%> value="<%=TskNotificationVo.NOTIFY_POOL_YES%>"></td><% } else { %><td align="center"><select name="tskAsi<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskAsi<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnAsigned() == null || notVo.getTskNotOnAsigned().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnAsigned() != null && notVo.getTskNotOnAsigned().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnAsigned() != null && notVo.getTskNotOnAsigned().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnAsigned() != null && notVo.getTskNotOnAsigned().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnAsigned() != null && notVo.getTskNotOnAsigned().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnAsigned() == null || notVo.getTskNotOnAsigned().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskAsi<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnAsigned() != null)?notVo.getTskNotOnAsigned().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskCom<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskCom<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnComplete() == null || notVo.getTskNotOnComplete().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnComplete() != null && notVo.getTskNotOnComplete().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnComplete() != null && notVo.getTskNotOnComplete().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnComplete() != null && notVo.getTskNotOnComplete().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnComplete() != null && notVo.getTskNotOnComplete().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnComplete() == null || notVo.getTskNotOnComplete().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskCom<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnComplete() != null)?notVo.getTskNotOnComplete().intValue():0%>" maxlength="3" p_numeric=true></td align="center"><td align="center"><select name="tskAcq<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskAcq<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnAcquired() == null || notVo.getTskNotOnAcquired().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnAcquired() != null && notVo.getTskNotOnAcquired().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnAcquired() != null && notVo.getTskNotOnAcquired().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnAcquired() != null && notVo.getTskNotOnAcquired().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnAcquired() != null && notVo.getTskNotOnAcquired().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnAcquired() == null || notVo.getTskNotOnAcquired().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskAcq<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnAcquired() != null)?notVo.getTskNotOnAcquired().intValue():0%>" maxlength="3" p_numeric=true></td align="center"><td align="center"><select name="tskRel<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskRea<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnRelease() == null || notVo.getTskNotOnRelease().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnRelease() != null && notVo.getTskNotOnRelease().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnRelease() != null && notVo.getTskNotOnRelease().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnRelease() != null && notVo.getTskNotOnRelease().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnRelease() != null && notVo.getTskNotOnRelease().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnRelease() == null || notVo.getTskNotOnRelease().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskRel<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnRelease() != null)?notVo.getTskNotOnRelease().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskAla<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskAla<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnAlarm() == null || notVo.getTskNotOnAlarm().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnAlarm() != null && notVo.getTskNotOnAlarm().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnAlarm() != null && notVo.getTskNotOnAlarm().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnAlarm() != null && notVo.getTskNotOnAlarm().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnAlarm() != null && notVo.getTskNotOnAlarm().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnAlarm() == null || notVo.getTskNotOnAlarm().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskAla<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnAlarm() != null)?notVo.getTskNotOnAlarm().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskOver<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskOver<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnOverdue() == null || notVo.getTskNotOnOverdue().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnOverdue() != null && notVo.getTskNotOnOverdue().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnOverdue() != null && notVo.getTskNotOnOverdue().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnOverdue() != null && notVo.getTskNotOnOverdue().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnOverdue() != null && notVo.getTskNotOnOverdue().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnOverdue() == null || notVo.getTskNotOnOverdue().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskOver<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnOverdue() != null)?notVo.getTskNotOnOverdue().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskRea<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskRea<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnReasign() == null || notVo.getTskNotOnReasign().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnReasign() != null && notVo.getTskNotOnReasign().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnReasign() != null && notVo.getTskNotOnReasign().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnReasign() != null && notVo.getTskNotOnReasign().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnReasign() != null && notVo.getTskNotOnReasign().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnReasign() == null || notVo.getTskNotOnReasign().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskRea<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnReasign() != null)?notVo.getTskNotOnReasign().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskEle<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskEle<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnElevate() == null || notVo.getTskNotOnElevate().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnElevate() != null && notVo.getTskNotOnElevate().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnElevate() != null && notVo.getTskNotOnElevate().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnElevate() != null && notVo.getTskNotOnElevate().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnElevate() != null && notVo.getTskNotOnElevate().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnElevate() == null || notVo.getTskNotOnElevate().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskEle<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnElevate() != null)?notVo.getTskNotOnElevate().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="tskDele<%=notVo.getTskNotTo()%>" onChange="cmbAlert_change('tskDele<%=notVo.getTskNotTo()%>')"><option value="<%=TskNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getTskNotOnDelegate() == null || notVo.getTskNotOnDelegate().intValue() == TskNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=TskNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getTskNotOnDelegate() != null && notVo.getTskNotOnDelegate().intValue() == TskNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=TskNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getTskNotOnDelegate() != null && notVo.getTskNotOnDelegate().intValue() == TskNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getTskNotOnDelegate() != null && notVo.getTskNotOnDelegate().intValue() == TskNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=TskNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getTskNotOnDelegate() != null && notVo.getTskNotOnDelegate().intValue() >= TskNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getTskNotOnDelegate() == null || notVo.getTskNotOnDelegate().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="tskDele<%=notVo.getTskNotTo()%>L" size="3" value="<%=(notVo.getTskNotOnDelegate() != null)?notVo.getTskNotOnDelegate().intValue():0%>" maxlength="3" p_numeric=true></td><% } %></tr><%
						}
					} %><tr><td><%=LabelManager.getName(labelSet,"lblPool")%></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_ASIGN%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_COMPLEAT%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_ACQUIRED%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_RELEASE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_ALERT%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_OVERDUE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_REASIGN%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_ELEVATE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterPools('<%=TskNotPoolVo.NOTIFICATION_EVENT_DELEGATE%>')"></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblMen")%></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_ASIGN%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_COMPLEAT%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_ACQUIRED%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_RELEASE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_ALERT%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_OVERDUE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_REASIGN%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_ELEVATE%>')"></td><td align="center"><img style='position:static;cursor:hand' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick="alterMessage('<%=TskNotPoolVo.NOTIFICATION_EVENT_DELEGATE%>')"></td></tr></tbody></table></div></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDocTar")%>" tabText="<%=LabelManager.getName(labelSet,"tabDocTar")%>"><!--     - DOCUMENTS          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDoc")%></DIV><jsp:include page="../../documents/documents.jsp" flush="true"><jsp:param name="docBean" value="form"/></jsp:include><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabTskDoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabTskDoc")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocTar")%></DIV><table class="tblFormLayout" cellpadding="0" cellspacing="0"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocId")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocId")%>:</td><td><input name="txtDocID" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDocId")%>" type="text" <%if(taskVo!=null) {%>value="<%=dBean.fmtStr(taskVo.getTskUniqueId())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocTit")%>:</td><td><input id="docTit" readonly class="txtReadOnly" p_readonly="true" <%if(taskVo!=null) {%>value="<%=dBean.fmtStr(taskVo.getTskTitle())%>"<%}%>></td><td></td><td></td></tr></table><br><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocDescGen")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocDescGen")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDescGen" id="areaDescGen"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocDesc()));}%></TEXTAREA></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblDocTskCurBas")%></DIV><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocActMan")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActMan")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActMan" id="areaActMan"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActMan()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"  title="<%=LabelManager.getToolTip(labelSet,"lblDocActTar")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActTar")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActTar" id="areaActTar"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActTar()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocActManPos")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActManPos")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActManPos" id="areaActManPos"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActManPos()));}%></TEXTAREA></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblDocTskCurAlt")%></DIV><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocActManAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActManAnt")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActManAnt" id="areaActManAnt"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActManAnt()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocActTarAlt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActTarAlt")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActTarAlt" id="areaActTarAlt"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActTarAlt()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocActManPosAlt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocActManPosAlt")%>:</td><td style="width:80%" ><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaActManPosAlt" id="areaActManPosAlt"><%if(taskVo!=null && taskVo.getTskDocFields()!=null) { out.print(dBean.fmtStr(taskVo.getTskDocFields().getTskDocActManPosAlt()));}%></TEXTAREA></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtTarEvt")%></DIV><div type="grid" id="gridTarEvt" height="100"><table id="tblTarEvt" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblTarEvt")%>"><%=LabelManager.getName(labelSet,"lblTarEvt")%></th><th min_width="300px" style="width:300px" title="<%=LabelManager.getToolTip(labelSet,"lblTarAct")%>"><%=LabelManager.getName(labelSet,"lblTarAct")%></th></tr></thead><tbody id="tblTarEvtBody"><% 
						if(taskVo!=null && taskVo.getTskDocEvents()!=null && taskVo.getTskDocEvents().size() > 0) {
							Iterator itE = taskVo.getTskDocEvents().iterator();
							while(itE.hasNext()){
								TskDocEventsVo vo = (TskDocEventsVo)itE.next();
								if(vo.getEvtId().intValue() == EventVo.EVENT_TSK_COMPLETE){
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtCom")%></td><td><input type="text" name="txtEvtCom" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><% 
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_REASIGN) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAsi")%></td><td><input type="text" name="txtEvtAsi" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>" ></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_WORK) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtTra")%></td><td><input type="text" name="txtEvtTra" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_ACQUIRE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAdq")%></td><td><input type="text" name="txtEvtAdq" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_RELEASE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtLib")%></td><td><input type="text" name="txtEvtLib" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_ONWARNING) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAtr")%></td><td><input type="text" name="txtEvtAtr" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_ONOVERDUE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtVen")%></td><td><input type="text" name="txtEvtVen" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%					
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_SAVE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtSav")%></td><td><input type="text" name="txtEvtSav" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%	
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_STEPCHG) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtStep")%></td><td><input type="text" name="txtEvtStep" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%	
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_ELEVATE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtEle")%></td><td><input type="text" name="txtEvtEle" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%	
								}else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_DELEGATE) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtDel")%></td><td><input type="text" name="txtEvtDel" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%	
								}else if (vo.getEvtId().intValue() == EventVo.EVENT_TSK_ROLLBACK ) {
									%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtRol")%></td><td><input type="text" name="txtEvtRol" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%	
								} 
								    
								  
							}
						} else {%><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtCom")%></td><td><input type="text" name="txtEvtCom" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAsi")%></td><td><input type="text" name="txtEvtAsi" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtTra")%></td><td><input type="text" name="txtEvtTra" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAdq")%></td><td><input type="text" name="txtEvtAdq" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtLib")%></td><td><input type="text" name="txtEvtLib" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtAtr")%></td><td><input type="text" name="txtEvtAtr" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtVen")%></td><td><input type="text" name="txtEvtVen" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtSav")%></td><td><input type="text" name="txtEvtSav" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtStep")%></td><td><input type="text" name="txtEvtStep" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtEle")%></td><td><input type="text" name="txtEvtEle" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtDel")%></td><td><input type="text" name="txtEvtDel" size=70  value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblTarEvtRol")%></td><td><input type="text" name="txtEvtRol" size=70  value=" "></td></tr><% } %></tbody></table></div></div><br/><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabTskPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabTskPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/administration/tasks/update.js'></script><%
StringBuffer str = new StringBuffer();
str.append("<script language=\"javascript\" type=\"text/javascript\" src=\"" + Parameters.ROOT_PATH + "/scripts/tinymce/jscripts/tiny_mce/tiny_mce.js\"></script>");
str.append("<script language=\"javascript\" type=\"text/javascript\">");
str.append("tinyMCE.init({");
str.append("mode : \"exact\",");
str.append("height : \"350\",");
str.append("width : \"600\",");
str.append("theme : \"advanced\",");
if(LanguageVo.LANG_EN==uData.getLangId().intValue()){
	str.append("language : \"en\",");
} else if(LanguageVo.LANG_SP==uData.getLangId().intValue()){
	str.append("language : \"es\",");
} else if(LanguageVo.LANG_PT==uData.getLangId().intValue()){
	str.append("language : \"pt\",");
}

str.append("plugins : \"safari,spellchecker,pagebreak,style,table,save,advhr,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,advlist\",");
str.append("theme_advanced_toolbar_location : \"top\",");
str.append("theme_advanced_buttons1 : \"bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,styleselect,formatselect,fontselect,fontsizeselect\",");
str.append("theme_advanced_buttons2 : \"cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,|,undo,redo,|,cleanup,code,|,insertdate,inserttime,preview,|,forecolor,backcolor\",");
str.append("theme_advanced_buttons3 : \"tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,|,spellchecker\",");
str.append("theme_advanced_toolbar_align : \"left\",");
str.append("theme_advanced_statusbar_location : \"bottom\",");
//str.append("content_css : \"css/example.css\",");
str.append("template_external_list_url : \"js/template_list.js\",");
//str.append("external_link_list_url : \"js/link_list.js\",");
//str.append("external_image_list_url : \"js/image_list.js\",");
//str.append("media_external_list_url : \"js/media_list.js\",");
str.append("theme_advanced_resizing : true,");

str.append("spellchecker_languages : \"" +
		((LanguageVo.LANG_SP == uData.getLangId().intValue()) ? "+" : "") +
		LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiEsp") + "=es_UY," +
		((LanguageVo.LANG_EN == uData.getLangId().intValue()) ? "+" : "") +
		LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiIng") + "=en_US," +
		((LanguageVo.LANG_PT == uData.getLangId().intValue()) ? "+" : "") +
		LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lblIdiPor") + "=pt_PT" + 
		"\",");
str.append("spellchecker_rpc_url    : \"" + Parameters.ROOT_PATH  + "/spellchecker/jmyspell-spellchecker\",");

//Style formats
str.append("style_formats : [" +
	"{title : '" + LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lbltmceStyRedText") + "', inline : 'span', styles : {color : '#ff0000'}}," +
	"{title : '" + LabelManager.getName(uData.getLabelSetId(), uData.getLangId(), "lbltmceStyRedHead") + "', block : 'h1', styles : {color : '#ff0000'}}" +
    /*
	"{title : 'Bold text', inline : 'b'}," +
	"{title : 'Red text', inline : 'span', styles : {color : '#ff0000'}}," +
	"{title : 'Red header', block : 'h1', styles : {color : '#ff0000'}}," +
	"{title : 'Example 1', inline : 'span', classes : 'example1'}," +
	"{title : 'Table styles'}," +
	"{title : 'Table row 1', selector : 'tr', classes : 'tablerow1'}" +
	*/
"]");

str.append("});");
str.append("</script>");
out.print(str.toString());
%><script language="javascript" type="text/javascript">

		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaDescGen");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaDescGen");	sizeMe();}	});
		}
		
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActMan");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActMan");	sizeMe();}	});
		}
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActTar");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActTar");	sizeMe();}	});
		}
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActManPos");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActManPos");	sizeMe();}	});
		}		
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActManAnt");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActManAnt");	sizeMe();}	});
		}	
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActTarAlt");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActTarAlt");	sizeMe();}	});
		}
		if (document.addEventListener) {
			document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaActManPosAlt");sizeMe();},false);
		}else{
			document.attachEvent("onreadystatechange", function(){if(document.readyState=="complete"){tinyMCE.execCommand("mceAddControl", false, "areaActManPosAlt");	sizeMe();}	});
		}			
</script><SCRIPT>
function btnAddUsr_click() {

	var rets = openModal("/programs/modals/users.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridUsers").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD");
					
					oTd0.innerHTML = "<input type='checkbox' name='chkUsrSel'><input type='hidden' name='chkUsr'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[0];
					oTd2.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridUsers").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

function btnDelUsr_click() {
	document.getElementById("gridUsers").removeSelected();
}
</SCRIPT><SCRIPT>
function tabSwitch(){
}
function chkReaGruFun(){
	if (document.getElementById("reaGroups").disabled){
		document.getElementById("reaGroups").disabled = false;
	}else{
		document.getElementById("reaGroups").disabled = true;
	}
}
</SCRIPT>