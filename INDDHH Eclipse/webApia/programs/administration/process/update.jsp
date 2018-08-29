<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.bi.BIEngine"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.bean.ExternalGenerator" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="fnOnLoad()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"></jsp:useBean><%
ProDefinitionVo proVo = dBean.getProcessVo();
boolean locked = (proVo.getProLockUser()!=null && !"".equals(proVo.getProLockUser())); //Si no es null y no es "" --> esta bloqueado
boolean lockedByMe = (locked && proVo.getProLockUser().equals(dBean.getActualUser(request)));//false
boolean onCreate = (proVo==null || proVo.getProId()==null);
boolean saveChangesBlock = ((onCreate || lockedByMe) && (proVo.getIsBpmn() == null || (proVo.getIsBpmn() != null && proVo.getIsBpmn() != 1))); //si se esta creando o esta bloqueado por mi podemos guardar
boolean saveChangesRW = (proVo.getProId()==null)?true:dBean.hasWritePermission(request, proVo.getProId(), proVo.getPrjId(), dBean.getActualUser(request));
boolean showExitAlert = (onCreate || lockedByMe);
String attIdsStr = dBean.getSelDimAttIds(); //Devuelve string de attId's seleccionados como dimension (pertenecientes a datos del proc, ent o atts redundantes). Utilizado para las consultas analiticas
String attEntIdsStr = dBean.getSelDimEntAttIds(); //Devuelve string de attId's (pertenecientes a formularios de entidad) seleccionados como dimension. Utilizado para las consultas analiticas
String attProIdsStr = dBean.getSelDimProAttIds(); //Devuelve string de attId's (pertenecientes a formularios de proceso) seleccionados como dimension. Utilizado para las consultas analiticas
String attMsrIdsStr = dBean.getSelMsrAttIds(); //Devuelve string de attId's seleccionados como medidas(pertenecientes a datos del proc, ent o atts redundantes). Utilizado para las consultas analiticas
String attEntMsrIds = dBean.getSelEntMsrAttIds(); //Devuelve string de attId's (pertenecientes a formularios de entidad) seleccionados como medidas. Utilizado para las consultas analiticas
String attProMsrIds = dBean.getSelProMsrAttIds(); //Devuelve string de attId's (pertenecientes a formularios de proceso) seleccionados como medidas. Utilizado para las consultas analiticas
boolean mustRebuild = dBean.isCubeInconsistency(request); //Indica si el cubo contiene una inconsistencia y debe ser eliminado y vuelto a crear

boolean saveChanges = false;
if (saveChangesRW){
	saveChanges = saveChangesBlock;
}

HashMap attributes = new HashMap();
if (proVo.getProAttributes() != null) {
	Iterator iterator = proVo.getProAttributes().iterator();
	while (iterator.hasNext()) {
		AttributeVo attribute = (AttributeVo) iterator.next();
		if (attribute != null) {
			attributes.put(attribute.getAttId(),attribute);
		}
	}
}
AttributeVo attribute = null;
boolean envUsesHierarchy = "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request), EnvParameters.ENV_USES_HIERARCHY));
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPro")%><%if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VIEW_PRO) { %>
				(View Process)
			<%} else if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VERSION) { %>
				(View Version)
			<%}%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmDownload" name="frmDownload" method="POST"></form><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPro")%></DIV><table class="tblFormLayout"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   					boolean hasProject = (proVo.getPrjId() != null && proVo.getPrjId().intValue() != 0);%><td style="width:20%;" title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" maxwidth="150" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
		   					Iterator itPrj = colProj.iterator();
		   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
	   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
	   							<%if (hasProject) {
									if (prjVo.getPrjId().equals(proVo.getPrjId())) {
										out.print ("selected");
									}
								}%>
								><%=prjVo.getPrjName()%></option><%}
	   					}%></select></td><td style="width:20%;" title="<%=LabelManager.getToolTip(labelSet,"lblCat")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCat")%>:</td><td rowspan=5 valign=top align=left><div id="tblProfileTree" style="BORDER-LEFT:1px solid #777777;BORDER-RIGHT:1px solid #777777;BORDER-TOP:1px solid gray;BORDER-BOTTOM:1px solid #777777;BACKGROUND-COLOR:#DFDFDF;SCROLLBAR-FACE-COLOR: #DFDFDF;SCROLLBAR-HIGHLIGHT-COLOR: #FFFFFF;SCROLLBAR-SHADOW-COLOR: #C0C0C0;SCROLLBAR-ARROW-COLOR: #808080;SCROLLBAR-DARKSHADOW-COLOR: #808080;SCROLLBAR-BASE-COLOR: #808080;scrollbar-3d-light-color: #808080;OVERFLOW:AUTO;WIDTH:100%;HEIGHT:133px"><%
						  request.setAttribute("envId", dBean.getEnvId(request));
						  request.setAttribute("selCat", proVo.getClaTreId());
						  %><jsp:include page="../clasifications/getClasificationTreeXML.jsp"/></div></td></tr><tr><%if (proVo.hasEverBeenInstanced()) {%><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td class="readOnly" ><input type="hidden" name="txtName" value="<%=dBean.fmtStr(proVo.getProName())%>"><%=dBean.fmtHTML(proVo.getProName())%></td><%} else {%><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" value="<%=dBean.fmtStr(proVo.getProName())%>"></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input name="txtTitle" p_required="true" onChange="document.getElementById('docTit').value=this.value"  maxlength="250" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" value="<%=dBean.fmtStr(proVo.getProTitle())%>" size=30></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td><TEXTAREA p_maxlength="true" maxlength="255" name="txtDesc" cols=30 rows=4 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>"><%=dBean.fmtHTML(proVo.getProDesc())%></TEXTAREA></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"><input type="hidden" name="actualUser" value="<%=dBean.getActualUser(request)%>"></tr><!--     - INDICADOR DE ACCIÓN          --><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAccPro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAccPro")%>:</td><%if (proVo.hasEverBeenInstanced()) {%><td class="readOnly"><input type="hidden" name="txtProAction"  onChange="loadQuerys()" value="<%= proVo.getProAction() %>"><%	if (ProcessVo.PROCESS_ACTION_CREATION.equals(proVo.getProAction())) {
									out.print(LabelManager.getName(labelSet,"lblAccProCre"));
								} else if (ProcessVo.PROCESS_ACTION_ALTERATION.equals(proVo.getProAction())) {
									out.print(LabelManager.getName(labelSet,"lblAccProAlt"));
								} else if (ProcessVo.PROCESS_ACTION_CANCEL.equals(proVo.getProAction())) {
									out.print(LabelManager.getName(labelSet,"lblAccProCan"));
								}%><% } else { %><td><select name="txtProAction" p_required="true"  onChange="loadQuerys()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAccPro")%>"><option value=""></option><option value="<%=ProcessVo.PROCESS_ACTION_CREATION%>"  <%=ProcessVo.PROCESS_ACTION_CREATION.equals(proVo.getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblAccProCre")%></option><%if (envUsesEntities) {%><option value="<%=ProcessVo.PROCESS_ACTION_ALTERATION%>" <%=ProcessVo.PROCESS_ACTION_ALTERATION.equals(proVo.getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblAccProAlt")%></option><%}%><option value="<%=ProcessVo.PROCESS_ACTION_CANCEL%>" <%=ProcessVo.PROCESS_ACTION_CANCEL.equals(proVo.getProAction())?"selected":""%>><%=LabelManager.getName(labelSet,"lblAccProCan")%></option></select><% } %></td></tr><!--     - TIPO DE PROCESO          --><tr style="display:none"><td title="<%=LabelManager.getToolTip(labelSet,"lblTipPro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipPro")%>:</td><td><% if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_INSERT) {%><select name="txtProType" onChange="proTypeChange()" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipPro")%>"><option value="<%=ProcessVo.PROCESS_TYPE_AUTO%>" <%=ProcessVo.PROCESS_TYPE_AUTO.equals(proVo.getProType())?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipProAut")%></option><option value="<%=ProcessVo.PROCESS_TYPE_MANUAL%>" <%=ProcessVo.PROCESS_TYPE_MANUAL.equals(proVo.getProType())?"selected":""%>><%=LabelManager.getName(labelSet,"lblTipProMan")%></option></select><% } else {%><input type=hidden name="txtProType" value="<%=dBean.fmtStr(proVo.getProType())%>"><input disabled=true class="txtReadONly" value="<%
		   					if (proVo.getProType().equals(ProcessVo.PROCESS_TYPE_AUTO)) {
		   					%><%=LabelManager.getName(labelSet,"lblTipProAut")%><%
		   					} else {
		   					%><%=LabelManager.getName(labelSet,"lblTipProMan")%><%		   					
		   					}
		   					out.print("\">");
		   				 }
		   				 %></td></tr><!--     - ENTIDAD ASOCIADA          --><%	Collection col = dBean.getBusEntities(request);
   					boolean hasEntity = proVo.getEntityProcessVo() != null;
   					if (col != null && col.size()>0) {%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEntAso")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEntAso")%>:</td><%if (hasEntity) {%><td colspan=2 class="readOnly"><input type=hidden name="txtBusEnt" value="<%=proVo.getEntityProcessVo().getBusEntId()%>"><%} else {%><td colspan=2><input type=hidden name="txtBusEnt" value=""><select  onChange="loadQuerys()" name="selBusEnt" onBlur="entBlur()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEntAso")%>"><option><%}%><%	Iterator it = col.iterator();
							BusEntityVo entVo = null;
		   					while (it.hasNext()) {
		   						entVo = (BusEntityVo) it.next();
								if (!hasEntity) {%><option value="<%=entVo.getBusEntId()%>" <%
									if (proVo.getEntityProcessVo() != null && entVo.getBusEntId().equals(proVo.getEntityProcessVo().getBusEntId())) {
										out.print ("selected");
									}%>><%=entVo.getBusEntName()%><%} else if (proVo.getEntityProcessVo() != null && entVo.getBusEntId().equals(proVo.getEntityProcessVo().getBusEntId())) {
									out.print(entVo.getBusEntName());
								}
		   					}%></select></td></tr><%} else {%><input type=hidden name="txtBusEnt" value=""><input type=hidden name="selBusEnt" value=""><%}%><!--     - TEMPLATES          --><!-- CONSULTA ASOCIADA --><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryAso")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryAso")%>:</td></td><td><select name="qryId" id="qryId"><option value=""></option><% 
							col = dBean.getQuerys(request);
							if (col != null && col.size() > 0) {
								for (Iterator it = col.iterator(); it.hasNext(); ) {
									QueryVo qryVo = (QueryVo) it.next(); %><option value="<%= qryVo.getQryId() %>" <%= (qryVo.getQryId().equals(proVo.getQryId()))?"selected":"" %>><%= qryVo.getQryName() %></option><% 
								}
							} %></select></td><td title="<%=LabelManager.getToolTip(labelSet,"lblImage")%>"><%=LabelManager.getNameWAccess(labelSet,"lblImage")%>:</td><%String img=( "".equals(proVo.getImgPath()) || proVo.getImgPath()==null  )?"":proVo.getImgPath();%><td><div onClick="openImagePicker(this)" style="cursor:pointer;cursor:hand;position:relative;width:50px;height:50px;background-image:url(<%=Parameters.ROOT_PATH+"/images/"%><%=img==""?"uploaded/procicon.png":"uploaded/"+img%>)"><input type="hidden" name="txtProjImg" id="txtProjImg" value="<%=img%>" /></div></td></tr><!-- TEMPLATES --><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTem")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTem")%>:</td><td colspan=3 nowrap><select name="txtTemplate" onChange="changeTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTem")%>"><%	String[][] templates = com.dogma.DogmaConstants.PRO_TEMPLATES;
							boolean isCustomTemplate = true;
							for (int i=0;i< templates.length;i++) {
								out.print("<option value=\"" + dBean.fmtStr(templates[i][1]) + "\"" );
								if ((proVo.getProExeTemplate() != null && 
									proVo.getProExeTemplate().equals(templates[i][1])) ||
									proVo.getProExeTemplate() == templates[i][1]) {
									out.print(" selected ");
									isCustomTemplate = false;
								}
								out.print(">");
								out.print(LabelManager.getName(labelSet,templates[i][0]));
								out.print("\n");
							}
							%><option value="<CUSTOM>" <%=isCustomTemplate?"selected":""%>><%=LabelManager.getName(labelSet,"lblTemCustom")%></select>
		   				&nbsp;
						<button type="button" id="btnVerOne" <%if (isCustomTemplate) {%>style="display:none"<%}%> onClick="btnViewTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button><input id=customTemplate onKeyUp="customKeyPress()" type="text" name="txtCusTemplate" size="40" <%if (!isCustomTemplate) {%>disabled="true" style="display:none"<%} else {%> value="<%=dBean.fmtStr(proVo.getProExeTemplate())%>" <%}%>>
		   				&nbsp;
						<button type="button" id="btnVerTwo" <%if (!isCustomTemplate) {%>style="display:none"<%}%> onClick="btnViewTemplate()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button></td></tr><!-- CALENDARIOS --><%	Collection colCal = dBean.getCalendars();
   					boolean hasCalendar = (proVo.getCalendarId() != null && proVo.getCalendarId().intValue() != 0);
   
   					if (colCal != null && colCal.size()>0) { %><tr><td title="<%=LabelManager.getToolTip(labelSet,"titCal")%>"><%=LabelManager.getNameWAccess(labelSet,"titCal")%>:</td><td colspan=2><input type=hidden name="txtCal" value=""><select name="selCal" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEntAso")%>"><%Iterator itCal = colCal.iterator();
		   					CalendarVo calVo = null;%><option value="0"></option><%
		   					while (itCal.hasNext()) {
		   						calVo = (CalendarVo) itCal.next();%><option value="<%=calVo.getCalendarId()%>" 
		   						<%if (hasCalendar) {
									if (calVo.getCalendarId().equals(proVo.getCalendarId())) {
										out.print ("selected");
									}%>
									><%=calVo.getCalendarName()%></option><%} else {%>
									><%=calVo.getCalendarName()%></option><%}%><%}%></select>
		   				&nbsp;
		   				<button type="button" id="btnVerCal" onClick="btnViewCalendar()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNotCalChange")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNotCalChange")%>:</td><td><input type="checkbox" name="chkDontAllowCalChange" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAllowCalChange")%>" <%if(proVo.getFlagValue(ProcessVo.FLAG_DONT_ALLOW_CALENDAR_CHANGE)) {%>checked<%}%>></td></tr><%} else { %><input type=hidden name="txtCal" value=""><%}%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblProHidFun")%>"><%=LabelManager.getNameWAccess(labelSet,"lblProHidFun")%>:</td><td><input type="checkbox" name="chkHidFun" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblProHidFun")%>" <%= proVo.getFlagValue(ProcessVo.FLAG_HIDDE_FUNCTIONALITY)?"checked":""%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblPerDel")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPerDel")%>:</td><td><input type="checkbox" name="txtPerDel" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPerDel")%>" <%if(proVo.getFlagValue(ProcessVo.FLAG_DELEGATE)) {%>checked<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblProCreateFun")%>"><%=LabelManager.getNameWAccess(labelSet,"lblProCreateFun")%>:</td><% if (proVo.isFncInProfile()) { %><td><input type="checkbox" name="chkCreateFunX" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblProCreateFun")%>" disabled checked><input type="hidden" name="chkCreateFun" checked value="true"></td><% } else { %><td><input type="checkbox" name="chkCreateFun" value="true" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblProCreateFun")%>" <%= (proVo.getFncId() != null)?"checked":""%>></td><% } %></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMsgProcCreated")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMsgProcCreated")%>:</td><td><input type="checkbox" name="chkMsgProc" accessKey="<%=LabelManager.getAccessKey(labelSet,"lblMsgProcCreated")%>" <%if(proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_PROCESS_CREATED) || (!proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_PROCESS_CREATED) && proVo.getFlagValue(ProcessVo.FLAG_MSG_PROCESS_CREATED))) {%>checked<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblMsgEntCreated")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMsgEntCreated")%>:</td><%if (proVo.getEntityProcessVo() == null){ %><td><input disabled=true type="checkbox" name="chkMsgEnt" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMsgEntCreated")%>" <%if(proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED) || (!proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED) && proVo.getFlagValue(ProcessVo.FLAG_MSG_ENTITY_CREATED))) {%>checked<%}%>></td><%} else { %><td><input type="checkbox" name="chkMsgEnt" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMsgEntCreated")%>" <%if(proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED) || (!proVo.isFlagNull(proVo.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED) && proVo.getFlagValue(ProcessVo.FLAG_MSG_ENTITY_CREATED))) {%>checked<%}%>></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMsgCustomCreated")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMsgCustomCreated")%>:</td><td><input type="checkbox" name="chkMsgCustom" onClick="changeCustomMsg()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMsgCustomCreated")%>" <%if(proVo.getFlagValue(ProcessVo.FLAG_MSG_CUSTOM_CREATED)) {%>checked<%}%>></td><%if(proVo.getFlagValue(ProcessVo.FLAG_MSG_CUSTOM_CREATED)) {%><td><input name="txtCustomMsg" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMsgCustomCreated")%>" type="text" value="<%=dBean.fmtStr(proVo.getCustomMsg())%>" size=50></td><%} else {%><td><input name="txtCustomMsg" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMsgCustomCreated")%>" type="text" value="<%=dBean.fmtStr(proVo.getCustomMsg())%>" style="visibility:hidden" size=50></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblExternalUrlAccess")%>"><%=LabelManager.getNameWAccess(labelSet,"lblExternalUrlAccess")%>:</td><td colspan="3"><%= ExternalGenerator.generateProcessUrl(request, proVo.getProId(), (proVo.getEntityProcessVo() != null) ? proVo.getEntityProcessVo().getBusEntId() : null)%></td></tr></table><BR><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDefIde")%></DIV><table class="tblFormLayout"><tr><td colspan=4><table width=100%><tr><%if (proVo.hasEverBeenInstanced()) {%><input type="hidden" name="radIdePre" value="<%=proVo.getProIdePre()%>"><input type="hidden" name="radIdeNum" value="<%=proVo.getProIdeNum()%>"><input type="hidden" name="radIdePos" value="<%=proVo.getProIdePos()%>"><input type="hidden" name="txtIdePre" value="<%=proVo.getProIdePreFix()%>"><input type="hidden" name="txtIdePos" value="<%=proVo.getProIdePosFix()%>"><%}%><td align=right vAlign="middle"><%=LabelManager.getName(labelSet,"lblPre")%>:</td><td vAlign="middle"><input type="radio" name="radIdePre" onClick="changeIdePre(true);" value="<%=ProcessVo.IDENTIFIER_TXT_NOT_USE%>" <%if (proVo.getProIdePre() == null || ProcessVo.IDENTIFIER_TXT_NOT_USE.equals(proVo.getProIdePre())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblNoUsa")%></td><td align=right vAlign="middle"><%=LabelManager.getName(labelSet,"lblNumero")%>:</td><td vAlign="middle"><input type="radio" name="radIdeNum" value="<%=ProcessVo.IDENTIFIER_NUM_AUTO%>" <%if (proVo.getProIdeNum() == null || ProcessVo.IDENTIFIER_NUM_AUTO.equals(proVo.getProIdeNum())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblAutNum")%></td><td align=right vAlign="middle"><%=LabelManager.getName(labelSet,"lblSuf")%>:</td><td vAlign="middle"><input type="radio" name="radIdePos" onClick="changeIdePos(true);" value="<%=ProcessVo.IDENTIFIER_TXT_NOT_USE%>" <%if (proVo.getProIdePos() == null || ProcessVo.IDENTIFIER_TXT_NOT_USE.equals(proVo.getProIdePos())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblNoUsa")%></td></tr><tr><td align=right vAlign="middle"></td><td vAlign="middle"><input type="radio" name="radIdePre" onClick="changeIdePre(true);" value="<%=ProcessVo.IDENTIFIER_TXT_WRITE%>" <%if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePre())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblPerIng")%></td><td align=right vAlign="middle"></td><td vAlign="middle"><input type="radio" name="radIdeNum" value="<%=ProcessVo.IDENTIFIER_NUM_WRITE%>" <%if (ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblExiIng")%></td><td align=right vAlign="middle"></td><td vAlign="middle"><input type="radio" name="radIdePos" onClick="changeIdePos(true);" value="<%=ProcessVo.IDENTIFIER_TXT_WRITE%>" <%if (ProcessVo.IDENTIFIER_TXT_WRITE.equals(proVo.getProIdePos())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblPerIng")%></td></tr><tr><td align=right vAlign="middle"></td><td vAlign="middle"><table cellspacing="0" cellpadding="0"><tr><td><input type="radio" name="radIdePre" onClick="changeIdePre(false);" value="<%=ProcessVo.IDENTIFIER_TXT_FIXED%>" <%if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePre())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblFij")%></td><td><input type=text size=6 maxlength=50 name="txtIdePre" value="<%=dBean.fmtStr(proVo.getProIdePreFix())%>" <%if (!ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePre())) {out.print(" disabled ");} else {out.print(" p_required=true"); if(proVo.hasEverBeenInstanced()){out.print(" disabled");}}%>></td></tr></table></td><td align=right vAlign="middle"></td><td vAlign="middle"><input type="radio" name="radIdeNum" value="<%=ProcessVo.IDENTIFIER_NUM_BOTH%>" <%if (ProcessVo.IDENTIFIER_NUM_BOTH.equals(proVo.getProIdeNum())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblAmbos")%></td><td align=right vAlign="middle"></td><td vAlign="middle"><table cellspacing="0" cellpadding="0"><tr><td><input type="radio" name="radIdePos" onClick="changeIdePos(false);" value="<%=ProcessVo.IDENTIFIER_TXT_FIXED%>" <%if (ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePos())) {out.print(" checked ");}%><%= proVo.hasEverBeenInstanced()?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblFij")%></td><td><input type=text size=6 maxlength=50 name="txtIdePos" value="<%=dBean.fmtStr(proVo.getProIdePosFix())%>" <%if (!ProcessVo.IDENTIFIER_TXT_FIXED.equals(proVo.getProIdePos())) {out.print(" disabled ");} else {out.print(" p_required=true"); if(proVo.hasEverBeenInstanced()){out.print(" disabled");}}%>></td></tr></table></td></tr></table></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabAttPro")%>" tabText="<%=LabelManager.getName(labelSet,"tabAttPro")%>"><!--     - Sección de atributos específicos          --><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAtt1Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAtt1Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttId1()); %><input type="hidden" name="hidAttId1" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttName1" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(1,'<%= AttributeVo.TYPE_STRING %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAtt1Pro")%>"><button type="button" onClick="btnRemAtt_click(1,'<%= AttributeVo.TYPE_STRING %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttNum1Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdNum1()); %><input type="hidden" name="hidAttIdNum1" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameNum1" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(1,'<%= AttributeVo.TYPE_NUMERIC %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttNum1Pro")%>"><button type="button" onClick="btnRemAtt_click(1,'<%= AttributeVo.TYPE_NUMERIC %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAtt2Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAtt2Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttId2()); %><input type="hidden" name="hidAttId2" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttName2" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(2,'<%= AttributeVo.TYPE_STRING %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAtt2Pro")%>"><button type="button" onClick="btnRemAtt_click(2,'<%= AttributeVo.TYPE_STRING %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttNum2Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttNum2Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdNum2()); %><input type="hidden" name="hidAttIdNum2" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameNum2" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(2,'<%= AttributeVo.TYPE_NUMERIC %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttNum2Pro")%>"><button type="button" onClick="btnRemAtt_click(2,'<%= AttributeVo.TYPE_NUMERIC %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAtt3Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAtt3Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttId3()); %><input type="hidden" name="hidAttId3" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttName3" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(3,'<%= AttributeVo.TYPE_STRING %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAtt3Pro")%>"><button type="button" onClick="btnRemAtt_click(3,'<%= AttributeVo.TYPE_STRING %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttNum3Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttNum3Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdNum3()); %><input type="hidden" name="hidAttIdNum3" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameNum3" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(3,'<%= AttributeVo.TYPE_NUMERIC %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttNum3Pro")%>"><button type="button" onClick="btnRemAtt_click(3,'<%= AttributeVo.TYPE_NUMERIC %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAtt4Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAtt4Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttId4()); %><input type="hidden" name="hidAttId4" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttName4" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(4,'<%= AttributeVo.TYPE_STRING %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAtt4Pro")%>"><button type="button" onClick="btnRemAtt_click(4,'<%= AttributeVo.TYPE_STRING %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttDte1Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttDte1Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdDte1()); %><input type="hidden" name="hidAttIdDte1" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameDte1" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(1,'<%= AttributeVo.TYPE_DATE %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttDte1Pro")%>"><button type="button" onClick="btnRemAtt_click(1,'<%= AttributeVo.TYPE_DATE%>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAtt5Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAtt5Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttId5()); %><input type="hidden" name="hidAttId5" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttName5" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(5,'<%= AttributeVo.TYPE_STRING %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAtt5Pro")%>"><button type="button" onClick="btnRemAtt_click(5,'<%= AttributeVo.TYPE_STRING %>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttDte2Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttDte2Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdDte2()); %><input type="hidden" name="hidAttIdDte2" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameDte2" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(2,'<%= AttributeVo.TYPE_DATE %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttDte2Pro")%>"><button type="button" onClick="btnRemAtt_click(2,'<%= AttributeVo.TYPE_DATE%>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr><tr><td></td><td></td><td title="<%=LabelManager.getToolTip(labelSet,"lblAttDte3Pro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAttDte3Pro")%>:</td><td><%
								attribute = (AttributeVo) attributes.get(proVo.getAttIdDte3()); %><input type="hidden" name="hidAttIdDte3" value="<%= (attribute != null)?attribute.getAttId().toString():"" %>"><input type="text" name="txtAttNameDte3" readonly class='txtReadOnly' value="<%= (attribute != null)?attribute.getAttName():"" %>"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btnQuery.gif" onClick="btnLoadAtt_click(3,'<%= AttributeVo.TYPE_DATE %>')" style="cursor:hand;position:static;" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblAttDte3Pro")%>"><button type="button" onClick="btnRemAtt_click(3,'<%= AttributeVo.TYPE_DATE%>')" title="<%=LabelManager.getToolTip(labelSet,"btnRemAtt")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemAtt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemAtt")%></button></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabProMap")%>" tabText="<%=LabelManager.getName(labelSet,"tabProMap")%>" style="display:none;"><!--     - MAPA DEL PROCESSO          --><TABLE WIDTH="100%" HEIGHT="100%" BORDER=0 cellspacing=0><TR><TD VALIGN="middle" ALIGN="center"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
				 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" 
					WIDTH="100%" 
					HEIGHT="500px" 
					style="/*border:1px solid blue*/"
					id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" /><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/<%=windowId%>"/><param name="quality" value="high" /><param name="menu" value="false"><param name="bgcolor" value="#EFEFEF" /><param name="WMODE" value="transparent" /><embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/<%=windowId%>" /></object></TD></TR></TABLE><table width=100% style="display:none"><tr><td align=right vAlign="middle"><%=LabelManager.getName(labelSet,"tabProMap")%>:</td><td vAlign="middle"><TEXTAREA p_required="true"  id="txtMap"  name="txtMap" cols="100" rows="30"><%=StringUtil.replace(proVo.getProDefinitionXml(), "&", "&amp;")%></TEXTAREA></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabAct")%>" tabText="<%=LabelManager.getName(labelSet,"tabAct")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDurAct")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblIniProAtr")%>"><%=LabelManager.getNameWAccess(labelSet,"lblIniProAtr")%>:</td><td><input type=text maxlength=3 size=4 name="txtProDurMaxD" p_numeric="true" value="<%=dBean.fmtInt(proVo.getProMaxDurationDay())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProDurMaxD")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDay")%><input type=text maxlength=3 size=4 name="txtProDurMaxH" p_numeric="true" value="<%=dBean.fmtInt(proVo.getProMaxDurationHour())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProDurMaxH")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHour")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipNot")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipNot")%>:</td><td><input type=checkbox name="chkNotEma" <%
		   				if (proVo.isNotEmail()) {
		   					out.print("checked");
						}%> value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotMail")%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblIniProAle")%>"><%=LabelManager.getNameWAccess(labelSet,"lblIniProAle")%>:</td><td><input type=text maxlength=3 size=4 name="txtProDurAleD" p_numeric="true" value="<%=dBean.fmtInt(proVo.getProAlertDurationDay())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProDurMaxD")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDay")%><input type=text maxlength=3 size=4 name="txtProDurAleH" p_numeric="true" value="<%=dBean.fmtInt(proVo.getProAlertDurationHour())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblProDurMaxH")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHour")%></td><td><font style="visibility:hidden"><%=LabelManager.getName(labelSet,"lblTipNot")%>:</font></td><td><input type=checkbox name="chkNotMes" <%
		   				if (proVo.isNotMessage()) {
		   					out.print("checked");
						}%>  value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotMes")%></td></tr><tr><td></td><td></td><td><font style="visibility:hidden"><%=LabelManager.getName(labelSet,"lblTipNot")%>:</font></td><td><input type=checkbox name="chkNotChat" <%
		   				if (proVo.isNotChat()) {
		   					out.print("checked");
						}%>  value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipNot")%>"><%=LabelManager.getName(labelSet,"lblProNotChat")%></td><td></td><td></td></tr><tr><td></td><td></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTskInAtr")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTskInAtr")%>:</td><td><input type=checkbox name="chkLibTas" <%if(proVo.getFlagValue(ProcessVo.FLAG_LIB_TASKS)) {%>checked<%}%> value="1" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLibTsks")%>"><%=LabelManager.getName(labelSet,"lblLibTsks")%></td><td></td><td></td></tr><tr><td></td><td></td><td></td><td><%Collection colPools = dBean.getEnvPools(request);
   						   boolean hasPool = (proVo.getProGruReasign() != null && proVo.getProGruReasign().intValue() != 0);%><input type=checkbox name="chkReaGru" value="1" <%if (hasPool==true){%>checked <%}%>onclick="chkReaGruFun()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblReaProGru")%>"><%=LabelManager.getName(labelSet,"lblReaProGru")%>:			   
				   		<select name="reaGroups" id="reaGroups" <%if (hasPool==false){%>disabled = "true" <%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colPools != null && colPools.size()>0) {
			   				Iterator itPool = colPools.iterator();
			   				PoolVo poolVo = null;%><option value="0"></option><%while (itPool.hasNext()) {
		   						poolVo = (PoolVo) itPool.next();%><option value="<%=poolVo.getPoolId()%>"
		   						<%if (hasPool) {
									if (poolVo.getPoolId().equals(proVo.getProGruReasign())) {
										out.print ("selected");
									}
								}%>
								><%=poolVo.getPoolName()%></option><%}
						 }%></select></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtNot")%></DIV><!--     - NOTIFICACIONES          --><div style="height: 200px;" type="grid" id="gridList" docBean=""><table width="500px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th min_width="200px" title="" style="width:200px">&nbsp;</th><th min_width="122px" style="min-width:122px;width:25%" title="<%=LabelManager.getToolTip(labelSet,"lblProCre")%>"><%=LabelManager.getName(labelSet,"lblProCre")%></th><th min_width="122px" style="min-width:122px;width:25%" title="<%=LabelManager.getToolTip(labelSet,"lblProEnd")%>"><%=LabelManager.getName(labelSet,"lblProEnd")%></th><th min_width="122px" style="min-width:122px;width:25%" title="<%=LabelManager.getToolTip(labelSet,"lblProAla")%>"><%=LabelManager.getName(labelSet,"lblProAla")%></th><th min_width="122px" style="min-width:122px;width:25%" title="<%=LabelManager.getToolTip(labelSet,"lblProOve")%>"><%=LabelManager.getName(labelSet,"lblProOve")%></th></tr></thead><tbody class="scrollContent" id="tblUsrBody"><%
					if (proVo.getProNotGeneric() != null) {
						Iterator iterator = proVo.getProNotGeneric().values().iterator();
						ProNotificationVo notVo = null;
						while (iterator.hasNext()) {
							notVo = (ProNotificationVo) iterator.next(); %><tr><td><%if(!"".equals(LabelManager.getName(labelSet,"lblProNot" + notVo.getProNotTo()))){%><%=LabelManager.getName(labelSet,"lblProNot" + notVo.getProNotTo())%><%}else{%><%="&nbsp;"%><%}%></td><% if (ProNotificationVo.NOTIFY_CREATE_USER.equals(notVo.getProNotTo())) { %><td align="center"></td><td align="center"><input type="checkbox" name="proEnd<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnEnd() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proAle<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnAlert() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proOve<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnOverdue() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><% } else if (ProNotificationVo.NOTIFY_ENTITY_CREATE_USER.equals(notVo.getProNotTo())) { %><td align="center"><input type="checkbox" name="proCre<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnCreate() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proEnd<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnEnd() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proAle<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnAlert() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proOve<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnOverdue() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><% } else if (ProNotificationVo.NOTIFY_USER_ACQ_TASK.equals(notVo.getProNotTo())) { %><td align="center"></td><td align="center"></td><td align="center"><input type="checkbox" name="proAle<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnAlert() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><td align="center"><input type="checkbox" name="proOve<%=notVo.getProNotTo()%>" <%=(notVo.getProNotOnOverdue() != null)?"checked":""%> value="<%=ProNotificationVo.NOTIFY_POOL_YES%>"></td><% } else { %><td align="center"><select style="display:none" name="proCre<%=notVo.getProNotTo()%>" onChange="cmbAlert_change('proCre<%=notVo.getProNotTo()%>')"><option value="<%=ProNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getProNotOnCreate() == null || notVo.getProNotOnCreate().intValue() == ProNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=ProNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getProNotOnCreate() != null && notVo.getProNotOnCreate().intValue() == ProNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=ProNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getProNotOnCreate() != null && notVo.getProNotOnCreate().intValue() == ProNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getProNotOnCreate() != null && notVo.getProNotOnCreate().intValue() == ProNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getProNotOnCreate() != null && notVo.getProNotOnCreate().intValue() >= ProNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input  style="display:none" <%if (notVo.getProNotOnCreate() == null || notVo.getProNotOnCreate().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="proCre<%=notVo.getProNotTo()%>L" size="3" value="<%=(notVo.getProNotOnCreate() != null)?notVo.getProNotOnCreate().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><% 
										if (! (ProNotificationVo.NOTIFY_POOL_ASIG_TASK.equals(notVo.getProNotTo()))) { %><select name="proEnd<%=notVo.getProNotTo()%>" onChange="cmbAlert_change('proEnd<%=notVo.getProNotTo()%>')"><option value="<%=ProNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getProNotOnEnd() == null || notVo.getProNotOnEnd().intValue() == ProNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=ProNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getProNotOnEnd() != null && notVo.getProNotOnEnd().intValue() == ProNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=ProNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getProNotOnEnd() != null && notVo.getProNotOnEnd().intValue() == ProNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getProNotOnEnd() != null && notVo.getProNotOnEnd().intValue() == ProNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getProNotOnEnd() != null && notVo.getProNotOnEnd().intValue() >= ProNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getProNotOnEnd() == null || notVo.getProNotOnEnd().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="proEnd<%=notVo.getProNotTo()%>L" size="3" value="<%=(notVo.getProNotOnEnd() != null)?notVo.getProNotOnEnd().intValue():0%>" maxlength="3" p_numeric=true><%
										} %></td><td align="center"><select name="proAle<%=notVo.getProNotTo()%>" onChange="cmbAlert_change('proAle<%=notVo.getProNotTo()%>')"><option value="<%=ProNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getProNotOnAlert() == null || notVo.getProNotOnAlert().intValue() == ProNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=ProNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getProNotOnAlert() != null && notVo.getProNotOnAlert().intValue() == ProNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=ProNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getProNotOnAlert() != null && notVo.getProNotOnAlert().intValue() == ProNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getProNotOnAlert() != null && notVo.getProNotOnAlert().intValue() == ProNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getProNotOnAlert() != null && notVo.getProNotOnAlert().intValue() >= ProNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><% } %></select><input <%if (notVo.getProNotOnAlert() == null || notVo.getProNotOnAlert().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="proAle<%=notVo.getProNotTo()%>L" size="3" value="<%=(notVo.getProNotOnAlert() != null)?notVo.getProNotOnAlert().intValue():0%>" maxlength="3" p_numeric=true></td><td align="center"><select name="proOve<%=notVo.getProNotTo()%>" onChange="cmbAlert_change('proOve<%=notVo.getProNotTo()%>')"><option value="<%=ProNotificationVo.NOTIFY_POOL_NO%>" <%=(notVo.getProNotOnOverdue() == null || notVo.getProNotOnOverdue().intValue() == ProNotificationVo.NOTIFY_POOL_NO)?"selected":""%>></option><option value="<%=ProNotificationVo.NOTIFY_POOL_YES%>" <%=(notVo.getProNotOnOverdue() != null && notVo.getProNotOnOverdue().intValue() == ProNotificationVo.NOTIFY_POOL_YES)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolYes")%></option><% if (envUsesHierarchy) { %><option value="<%=ProNotificationVo.NOTIFY_POOL_FATHER%>" <%=(notVo.getProNotOnOverdue() != null && notVo.getProNotOnOverdue().intValue() == ProNotificationVo.NOTIFY_POOL_FATHER)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolFat")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_ANCESTOR%>" <%=(notVo.getProNotOnOverdue() != null && notVo.getProNotOnOverdue().intValue() == ProNotificationVo.NOTIFY_POOL_ANCESTOR)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolAnc")%></option><option value="<%=ProNotificationVo.NOTIFY_POOL_X_LEVELS%>" <%=(notVo.getProNotOnOverdue() != null && notVo.getProNotOnOverdue().intValue() >= ProNotificationVo.NOTIFY_POOL_X_LEVELS)?"selected":""%>><%=LabelManager.getName(labelSet,"lblNotPoolLevel")%></option><
											<% } %></select><input <%if (notVo.getProNotOnOverdue() == null || notVo.getProNotOnOverdue().intValue() < 0) {%>style="visibility:hidden"<%}%> type="text" name="proOve<%=notVo.getProNotTo()%>L" size="3" value="<%=(notVo.getProNotOnOverdue() != null)?notVo.getProNotOnOverdue().intValue():0%>" maxlength="3" p_numeric=true></td><% } %></tr><%
						}
					} %><tr><td><%=LabelManager.getName(labelSet,"lblPool")%></td><td align="center" valign=top><img style='cursor:hand;position:static;' border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterPools('<%=ProNotPoolVo.NOTIFICATION_EVENT_CREATE%>')"></td><td align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterPools('<%=ProNotPoolVo.NOTIFICATION_EVENT_END%>')"></td><td align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterPools('<%=ProNotPoolVo.NOTIFICATION_EVENT_ALERT%>')"></td><td align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterPools('<%=ProNotPoolVo.NOTIFICATION_EVENT_OVERDUE%>')"></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblMen")%></td><td style="min-width:122px" align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterMessage('<%=ProNotPoolVo.NOTIFICATION_EVENT_CREATE%>')"></td><td style="min-width:122px" align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterMessage('<%=ProNotPoolVo.NOTIFICATION_EVENT_END%>')"></td><td style="min-width:122px" align="center"><img style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterMessage('<%=ProNotPoolVo.NOTIFICATION_EVENT_ALERT%>')"></td><td style="min-width:122px" align="center"><img border=0 style='cursor:hand;position:static;' src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onClick="alterMessage('<%=ProNotPoolVo.NOTIFICATION_EVENT_OVERDUE%>')"></td></tr></tbody></table></div></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabDoc")%>"><!--     - DOCUMENTOS          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDoc")%></DIV><jsp:include page="../../documents/documents.jsp" flush="true"><jsp:param name="docBean" value="process"/></jsp:include><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMon")%>" tabText="<%=LabelManager.getName(labelSet,"tabMon")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMonForEnt")%></DIV><div type="grid" id="gridMonForms" height="100"><table id="tblMonForms" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="200px" style="min-width:200px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblFor")%>"><%=LabelManager.getName(labelSet,"lblFor")%></th></tr></thead><tbody id="tblMonFormBody"><%
						if (proVo.getMonProForms() != null){
						Iterator it = proVo.getMonProForms().iterator();
 						while (it.hasNext()) {
   							MonProFormVo monFrm = (MonProFormVo)it.next(); %><tr><td style="width:0px;display:none;"><input type="hidden" name="chkMonFormSel"><input type=hidden name="chkMonForm" value="<%=dBean.fmtInt(monFrm.getFrmId())%>"></td><td style="min-width:200px"><%=dBean.fmtStr(monFrm.getFrmName())%></td></tr><%
   						}
 					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD><button type="button" onClick="upMon_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUp")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUp")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUp")%></button><button type="button" onClick="downMon_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDown")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDown")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDown")%></button></TD><td><button type="button" onClick="btnAddMonForm_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onClick="btnDelMonForm_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabProDoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabProDoc")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocPro")%></DIV><table class="tblFormLayout" cellpadding="0" cellspacing="0"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocId")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocId")%>:</td><td><input name="txtDocID" maxlength="50" size=50 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDocId")%>" type="text" <%if(proVo!=null) {%>value="<%=dBean.fmtStr(proVo.getProUniqueId())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocTit")%>:</td><td><input id="docTit" readonly size=50 class="txtReadOnly" p_readonly="true" <%if(proVo!=null) {%>value="<%=dBean.fmtStr(proVo.getProTitle())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocIncFront")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocIncFront")%>:</td><td><input id="chkHeadImage" type="checkbox" onclick="if(this.checked){document.getElementById('divFrontImage').style.display='block';}else{{document.getElementById('divFrontImage').style.display='none';}}" id="txtDocIncFront" name="txtDocIncFront" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDocIncFront")%>" <%if(proVo.getFlagValue(ProcessVo.FLAG_DOC_INCLUDE_FRONT_IMG)) {%>checked<%}%>></td><%String img2=( "".equals(proVo.getProFrontImage()) || proVo.getProFrontImage()==null  )?"":proVo.getProFrontImage();%><td colspan="2"><div id="divFrontImage" onClick="openImagePicker(this)" style="cursor:pointer;cursor:hand;position:relative;width:50px;height:50px;background-image:url(<%=Parameters.ROOT_PATH+"/images/"%><%=img2==""?"procicon.png":"uploaded/"+img2%>)<%if(!proVo.getFlagValue(ProcessVo.FLAG_DOC_INCLUDE_FRONT_IMG)) {%>;display:none<%}%>"><input type="hidden"  name="txtProjFrontImg" id="txtProjFrontImg" value="<%=img2%>" /></div></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDocIncHead")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocIncHead")%>:</td><td><input id="chkFronImage" type="checkbox" onclick="if(this.checked){document.getElementById('divHeadImage').style.display='block';}else{{document.getElementById('divHeadImage').style.display='none';}}" id="txtDocIncHead" name="txtDocIncHead" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDocIncHead")%>" <%if(proVo.getFlagValue(ProcessVo.FLAG_DOC_INCLUDE_HEADER_IMG)) {%>checked<%}%>></td><%String img3=( "".equals(proVo.getProHeaderImage()) || proVo.getProHeaderImage()==null  )?"":proVo.getProHeaderImage();%><td colspan="2"><div id="divHeadImage" onClick="openImagePicker(this)" style="cursor:pointer;cursor:hand;position:relative;width:50px;height:50px;background-image:url(<%=Parameters.ROOT_PATH+"/images/"%><%=img3==""?"procicon.png":"uploaded/"+img3%>)<%if(!proVo.getFlagValue(ProcessVo.FLAG_DOC_INCLUDE_HEADER_IMG)) {%>;display:none<%}%>"><input type="hidden"  name="txtProjHeadImg" id="txtProjHeadImg" value="<%=img3%>" /></div></td></tr></table><br><br><table cellpadding="0" cellspacing="0"><tr><td style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblDocProObj")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDocProObj")%>:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaObj" id="areaObj"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocObj()));}%></TEXTAREA></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocDatPro")%></DIV><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc1" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField1Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc1" id="areaDoc1"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField1()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc2" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField2Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc2" id="areaDoc2"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField2()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc3" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField3Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc3" id="areaDoc3"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField3()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc4" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField4Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc4" id="areaDoc4"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField4()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc5" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField5Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc5" id="areaDoc5"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField5()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc6" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField6Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc6" id="areaDoc6"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField6()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc7" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField7Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc7" id="areaDoc7"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField7()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc8" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField8Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc8" id="areaDoc8"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField8()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc9" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField9Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc9" id="areaDoc9"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField9()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc10" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField10Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc10" id="areaDoc10"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField10()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc11" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField11Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc11" id="areaDoc11"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField11()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc12" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField12Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc12" id="areaDoc12"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField12()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc13" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField13Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc13" id="areaDoc13"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField13()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc14" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField14Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc14" id="areaDoc14"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField14()));}%></TEXTAREA></td></tr></table><table cellpadding="0" cellspacing="0"><tr><td style="width:20%"><input type="text" name="txtDoc15" value="<%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField15Desc()));}%>">:</td><td style="width:80%"><TEXTAREA  p_maxlength="true" maxlength="3000" name="areaDoc15" id="areaDoc15"><%if(proVo!=null && proVo.getProDocFields()!=null) { out.print(dBean.fmtStr(proVo.getProDocFields().getProDocField15()));}%></TEXTAREA></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtProEvt")%></DIV><div type="grid" id="gridProEvt" height="100"><table id="tblProEvt" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblProEvt")%>"><%=LabelManager.getName(labelSet,"lblTarEvt")%></th><th min_width="300px" style="width:300px" title="<%=LabelManager.getToolTip(labelSet,"lblProAct")%>"><%=LabelManager.getName(labelSet,"lblTarAct")%></th></tr></thead><tbody id="tblProEvtBody"><% 
						if(proVo!=null && proVo.getProDocEvents()!=null && proVo.getProDocEvents().size() > 0) {
							Iterator itE = proVo.getProDocEvents().iterator();
							while(itE.hasNext()){
								ProDocEventsVo vo = (ProDocEventsVo)itE.next();
								if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_CREATE){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtCre")%></td><td><input type="text" name="txtEvtCre" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_COMPLETE){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtFin")%></td><td><input type="text" name="txtEvtFin" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_CANCEL){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtCan")%></td><td><input type="text" name="txtEvtCan" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_SUSPEND){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtSus")%></td><td><input type="text" name="txtEvtSus" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_RESUME){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtRea")%></td><td><input type="text" name="txtEvtRea" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%									
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_ONWARNING){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtAtr")%></td><td><input type="text" name="txtEvtAtr" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_PRO_ONOVERDUE){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtAtr")%></td><td><input type="text" name="txtEvtAtr" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if (vo.getEvtId().intValue() == EventVo.EVENT_PRO_ROLLBACK){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtRol")%></td><td><input type="text" name="txtEvtRol" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								} else if(vo.getEvtId().intValue() == EventVo.EVENT_MONITOR_PROCESS_VIEW_DETAILS){
									%><tr><td><%=LabelManager.getName(labelSet,"lblProEvtDet")%></td><td><input type="text" name="txtEvtDet" size=70 value="<%=dBean.fmtStr(vo.getEvtDoc())%>"></td></tr><%
								}
									
							} 
						 }else{ %><tr><td><%=LabelManager.getName(labelSet,"lblProEvtCre")%></td><td><input type="text" name="txtEvtCre" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtFin")%></td><td><input type="text" name="txtEvtFin" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtCan")%></td><td><input type="text" name="txtEvtCan" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtSus")%></td><td><input type="text" name="txtEvtSus" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtRea")%></td><td><input type="text" name="txtEvtRea" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtAtr")%></td><td><input type="text" name="txtEvtAtr" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtVen")%></td><td><input type="text" name="txtEvtVen" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtRol")%></td><td><input type="text" name="txtEvtRol" size=70 value=" "></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblProEvtDet")%></td><td><input type="text" name="txtEvtDet" size=70 value=" "></td></tr><% } %></tbody></table></div></div><br/><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabPer")%>"><%@ include file="permissions.jsp" %></div><!-- *****COMIENZA GRID PARA CONSULTAS ANALITICAS ******* --><!-- Se habilita solo si esta configurado correctamente el config.properties --><% 
		Integer proId = null;
		Integer busEntId = null;
		if (proVo!= null && proVo.getProId()!= null){
			proId = proVo.getProId();
		}
		if (proVo!= null && proVo.getEntityProcessVo()!= null){
			busEntId = proVo.getEntityProcessVo().getBusEntId();
		}
		
		if (Parameters.BI_INSTALLED && dBean.getProcessVo().getProId()==null) {// SE DEBE CONFIRMAR EL PRoceso ANTES DE GENERAR EL CUBO%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><table class="tblFormLayout"><tr><td><%=LabelManager.getName(labelSet,"msgMustConfProBefGenCube")%></td></tr></table></div><%}else if (!Parameters.BI_INSTALLED && proVo.getCubeId()!= null){
		 	//Si el bi no esta instalado pero ya se definió un cubo (seria casi imposible)
		 	saveChanges=false;%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><table class="tblFormLayout"><tr><td><%=LabelManager.getName(labelSet,"msgBINotInstalled")%></td></tr></table></div><%}else if (Parameters.BI_INSTALLED && !BIEngine.biCorrectlyInstalled() && proVo.getCubeId()!= null){
		 	//Si la configuracion del bi esta mal pero ya se definió un cubo
		 	saveChanges=false;%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><table class="tblFormLayout"><tr><td><%=BIEngine.getBIConfErrorMsg(labelSet)%></td></tr></table></div><%}else if (Parameters.BI_INSTALLED && BIEngine.biCorrectlyInstalled() && dBean.getProcessVo().getCubeId()!=null && dBean.getCubeVo()== null) {// VERIFICAMOS QUE EL CUBO EXISTA EN LA BASE DEL BI%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><table class="tblFormLayout"><tr><td><%=LabelManager.getName(labelSet,"msgProCbeNotFound")%></td></tr></table></div><%}else if (Parameters.BI_INSTALLED && BIEngine.biCorrectlyInstalled()) {
			//Si la configuracion del bi esta bien mostramos la solapa de consultas analiticas%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDwQry")%>" tabText="<%=LabelManager.getName(labelSet,"tabDwQry")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"txtAnaGenData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
					String cubeName = "";
					String cubeTitle = "";
					String cubeDesc = "";
					boolean hasCube = false;
					Integer cubeId = proVo.getCubeId();
					Collection colAtts = new ArrayList();
					if (proVo.getProId()!=null && cubeId!=null){
						hasCube = true;
						cubeName = dBean.getCubeVo().getCubeName();
						cubeTitle = dBean.getCubeVo().getCubeTitle();
						if (dBean.getCubeVo().getCubeDesc()!=null){
							cubeDesc = dBean.getCubeVo().getCubeDesc();
						}
					}
					
					if (mustRebuild){
						hasCube=false;
						cubeName="";
						cubeDesc="";
					}
					
					%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDwCreCube")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDwCreCube")%>:</td><td><input type="checkbox" name="chkCreateCbe" <%=(hasCube)?"checked":""%> onClick="enableDisable()"></td><input type="hidden" name="hidCbeChanged" value="false"></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input type="text" maxlength="32" name="txtCbeName" id="txtCbeName" p_required="<%=(hasCube)?"true":"false"%>" value="<%=cubeName%>" <%=hasCube?"":"disabled"%>><%=(hasCube)?"":"*"%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input type="text" maxlength="32" name="txtCbeTitle" id="txtCbeTitle" p_required="<%=(hasCube)?"true":"false"%>" value="<%=cubeTitle%>" <%=hasCube?"":"disabled"%>><%=(hasCube)?"":"*"%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDesc")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDesc")%>:</td><td><input type="text" maxlength="255" name="txtCbeDesc" id="txtCbeDesc" name="<%=cubeDesc%>" value="<%=cubeDesc%>" <%=hasCube?"":"disabled"%>></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblDwDimensions")%></DIV><div type="grid" id="gridDims" style="height:100px"><table id="tblDims" class="tblDimGrid"  cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_wdith="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")+"/"+LabelManager.getName(labelSet,"lblProperty")%>"><%=LabelManager.getName(labelSet,"lblAtt") + "/" + LabelManager.getName(labelSet,"lblProperty")%></th><th min_width="35px" style="width:35px" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th><th min_width="25px" style="width:25px" title="<%=LabelManager.getToolTip(labelSet,"lblProps")%>"><%=LabelManager.getName(labelSet,"lblProps")%></th><th min_width="150px" style="min-width:150px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody><% 
						if (hasCube && dBean.getDwCols()!=null && dBean.getDwCols().size()>0){
							Iterator itDwCols = dBean.getDwCols().iterator();
							int row = 0;
							while (itDwCols.hasNext()){
								ProcessDwColumnVo proDwColVo = (ProcessDwColumnVo) itDwCols.next();
								String attName="";
								if (proDwColVo.getDwType().intValue() == ProcessDwColumnVo.DW_TYPE_DIMENSION){%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkSel" value=""></td><td align="center"><%
											AttributeVo attVo = null;
											if (proDwColVo != null && proDwColVo.getAttId()!= null){
												attVo = dBean.getCubeAttribute(proDwColVo.getAttId());
											}
											if (attVo != null){%><input name="attName" id="attName" style="width:90px;" disabled value="<%=attVo.getAttName()%>" title="<%=attVo.getAttName()%>"><input type="hidden" name="hidAttId" value="<%=attVo.getAttId()%>"><input type='hidden' name='hidAttName' value="<%=attVo.getAttName()%>"><%}else{%><input name="attName" id="attName" style="width:90px;" disabled value=""><input type="hidden" name="hidAttId" value=""><input type='hidden' name='hidAttName' value=""><%}
											if (proDwColVo!=null){ %><input type="hidden" name="hidAttType" value="<%=proDwColVo.getAttType()%>"><%}else{ %><input type="hidden" name="hidAttType" value=""><%}
											if (proDwColVo!=null && proDwColVo.getAttFrom()!=null){ %><input type="hidden" name="hidAttFrom" value="<%=proDwColVo.getAttFrom()%>"><%}else{ %><input type="hidden" name="hidAttFrom" value=""><%}
											if (proDwColVo != null && proDwColVo.getProcessDwColumnId() != null){%><input type="hidden" name="hidDimEntDwColId" value="<%=proDwColVo.getProcessDwColumnId().intValue()%>"><%}else{%><input type="hidden" name="hidDimEntDwColId" value="0"><%}%></td><%
											if ("S".equals(proDwColVo.getAttType())){ //Es string %><td>STRING</td><%
											}else if ("D".equals(proDwColVo.getAttType())){ //Es date %><td>DATE</td><%
											}else{ //Es numeric %><td>NUMERIC</td><%
											}%><td><span style="vertical-align:bottom;"><img title="<%=LabelManager.getName(labelSet,"lblCliToProps")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="17" height="16" onclick="openPropModal(this)" style="cursor:pointer;cursor:hand"></span><input type="hidden" name="hidDimProp" value="<%=proDwColVo.getAllMemberName()%>"></td><td style="min-width:150px" align="center"><input type="text" name="txtDimName" maxlength="50" onChange="chkDimName(this)" value="<%=proDwColVo.getDwName()%>"><% if ("D".equals(proDwColVo.getAttType())){%><span> | </span><span><%=LabelManager.getName(labelSet,"lblYear")%>:</span><span><input type="checkbox" name="chkYear" <%=proDwColVo.getFlagValue(0)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblSem")%>:</span><span><input type="checkbox" name="chkSem" <%=proDwColVo.getFlagValue(1)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblTrim")%>:</span><span><input type="checkbox" name="chkTrim" <%=proDwColVo.getFlagValue(2)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblMonth")%>:</span><span><input type="checkbox" name="chkMonth" <%=proDwColVo.getFlagValue(3)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblWeeDay")%>:</span><span><input type="checkbox" name="chkWeekDay" <%=proDwColVo.getFlagValue(4)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblBIDay")%>:</span><span><input type="checkbox" name="chkDay" <%=proDwColVo.getFlagValue(5)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblBIHour")%>:</span><span><input type="checkbox" name="chkHour" <%=proDwColVo.getFlagValue(6)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblMinute")%>:</span><span><input type="checkbox" name="chkMin" <%=proDwColVo.getFlagValue(7)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><span> | </span><span><%=LabelManager.getName(labelSet,"lblSecond")%>:</span><span><input type="checkbox" name="chkSec" <%=proDwColVo.getFlagValue(8)?"checked":""%> onClick="cubeChanged()" value="<%=row%>"></span><input type="hidden" id="txtMapEntityId" name="txtMapEntityId" value=""><%}else{%><input type="hidden" id="txtMapEntityId" name="txtMapEntityId" value="<%=(proDwColVo.getEntMapId()!=null)?proDwColVo.getEntMapId().toString():""%>"><%if (proDwColVo.getAttId().intValue() >1000){ %><input type="text" id="txtMapEntityName" name="txtMapEntityName" title="<%=LabelManager.getName(labelSet,"lblMapEntity")%>" disabled value="<%=(proDwColVo.getEntMapId()!=null && dBean.getMapEntity(proDwColVo.getEntMapId()) != null)?dBean.getMapEntity(proDwColVo.getEntMapId()).getBusEntName():""%>"><span style="vertical-align:bottom;"><img title="<%=LabelManager.getName(labelSet,"lblCliSelMapEntity")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="17" height="16" onclick="openEntModal(this)" style="cursor:pointer;cursor:hand"><img title="<%=LabelManager.getToolTip(labelSet,"lblDelMapEntity")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/eraser.gif" width="17" height="16" onclick="btnRemMapEnt_click(this)" style="cursor:pointer;cursor:hand"></span><%} %><%}%></td></tr><%
								row++;
							  }		
						 }
					   }%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><input type="hidden" id="txtHidAttIds" name="txtHidAttIds" value="<%=attIdsStr%>"><input type="hidden" id="txtHidEntAttIds" name="txtHidEntAttIds" value="<%=attEntIdsStr%>"><input type="hidden" id="txtHidProAttIds" name="txtHidProAttIds" value="<%=attProIdsStr%>"><button type="button" id="btnAddDim" <%=hasCube?"":"disabled"%> onclick="btnAddDimension_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelDim" <%=hasCube?"":"disabled"%> onclick="btnDelDimension_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblMeasures")%></DIV><div type="grid" id="gridMeasures" style="height:100px"><table id="tblMeas" class="tblMeasGrid"  cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;"	title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="150px" style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")+"/"+LabelManager.getName(labelSet,"lblProperty")%>"><%=LabelManager.getName(labelSet,"lblAtt")+"/"+LabelManager.getName(labelSet,"lblProperty")%></th><th min_width="120px" style="width:120px"	title="<%=LabelManager.getToolTip(labelSet,"lblDispName")%>"><%=LabelManager.getName(labelSet, "lblDispName")%></th><th min_width="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"titMeasType")%>"><%=LabelManager.getName(labelSet,"titMeasType")%></th><th min_width="60px" style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblAggregator")%>"><%=LabelManager.getName(labelSet, "lblAggregator")%></th><th min_width="60px" style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblFormat")%>"><%=LabelManager.getName(labelSet, "lblFormat")%></th><th min_width="190px" style="width:190px" title="<%=LabelManager.getToolTip(labelSet,"titFormula")%>"><%=LabelManager.getName(labelSet,"titFormula")%></th><th min_width="150px" style="min-width:150px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"titVisible")%>"><%=LabelManager.getName(labelSet,"titVisible")%></th></tr></thead><tbody><% 
						if (hasCube && dBean.getDwCols()!=null && dBean.getDwCols().size()>0){
							Iterator itDwCols = dBean.getDwCols().iterator();
							int rowIndx = 0;
							while (itDwCols.hasNext()){
								Iterator itAtts   = colAtts.iterator();
								ProcessDwColumnVo proDwColVo = (ProcessDwColumnVo) itDwCols.next();
								String attName="";
								if (proDwColVo.getDwType().intValue() == ProcessDwColumnVo.DW_TYPE_MEASURE){
									if (proDwColVo.getAttId() != null){ //Es de tipo Measure%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkSel" value=""></td><td align="center"><%
												AttributeVo attVo = null;
												if (proDwColVo != null && proDwColVo.getAttId()!= null){
													attVo = dBean.getCubeAttribute(proDwColVo.getAttId());
												}
												if (attVo != null){%><input name="attMeaName" id="attMeaName" style="width:150px;" disabled value="<%=attVo.getAttName()%>" title="<%=attVo.getAttName()%>"><input type="hidden" name="hidAttMeasId" value="<%=attVo.getAttId()%>"><input type='hidden' name='hidAttMeasName' value="<%=attVo.getAttName()%>"><%
													if (proDwColVo!=null && proDwColVo.getAttFrom()!=null){ %><input type="hidden" name="hidAttMeasFrom" value="<%=proDwColVo.getAttFrom()%>"><%}else{ %><input type="hidden" name="hidAttMeasFrom" value=""><%}
												}else{%><input name="attMeaName" id="attMeaName" style="width:150px;" disabled value=""><input type="hidden" name="hidAttMeasId" value=""><input type='hidden' name='hidAttMeasName' value=""><%
													if (proDwColVo!=null && proDwColVo.getAttFrom()!=null){ %><input type="hidden" name="hidAttMeasFrom" value="<%=proDwColVo.getAttFrom()%>"><%}else{ %><input type="hidden" name="hidAttMeasFrom" value=""><%}
												}%><input type="hidden" name="hidAttMeasType" value="<%=proDwColVo.getAttType()%>"><input type="hidden" name="hidMeasEntDwColId" value="<%=proDwColVo.getProcessDwColumnId().intValue()%>"></td><td align="center"><input type="text" name="dispName" maxlength="50" onChange="chkMeasName(this)" value="<%=proDwColVo.getDwName()%>"></td><td><select name="selTypeMeasure" onChange="changeMeasureType(this)"><option value="0" selected><%=LabelManager.getName(labelSet,"lblMeasStandard")%></option><option value="1"><%=LabelManager.getName(labelSet,"lblMeasCalculated")%></option></select></td><td><select name="selAgregator" id="selAgregator" style="display:block"><option value="0" <%=("SUM".equals(proDwColVo.getAgregator()))?"selected":""%>>SUM</option><option value="1" <%=("AVG".equals(proDwColVo.getAgregator()))?"selected":""%>>AVG</option><option value="2" <%=("COUNT".equals(proDwColVo.getAgregator()))?"selected":""%>>COUNT</option><option value="3" <%=("MIN".equals(proDwColVo.getAgregator()))?"selected":""%>>MIN</option><option value="4" <%=("MAX".equals(proDwColVo.getAgregator()))?"selected":""%>>MAX</option><option value="5" <%=("DISTINCT COUNT".equals(proDwColVo.getAgregator()))?"selected":""%>>DIST. COUNT</option></select></td><td><input type="text" name="format" value="<%=proDwColVo.getFormat()%>"></td><td><input type="text" name="formula" value="" size=40 style="display:none"></td><td style="min-width:150px"><input type="checkbox" name="visible" value="<%=rowIndx%>" <%=(proDwColVo.getVisibility().intValue()==1)?"checked":""%>><%rowIndx++;%></td></tr><%
									}else{ //Es de tipo Calculated Member %><tr><td style="width:0px;display:none;"><input type="hidden" name="chkSel" value=""></td><td><input name="attMeaName" id="attMeaName" style="display:none;width:110px;" disabled value=""><input type="hidden" name="hidAttMeasId" value=""><input type='hidden' name='hidAttMeasName' value=""><input type="hidden" name="hidAttMeasFrom" value=""><input type="hidden" name="hidAttMeasType" value=""><input type="hidden" name="hidMeasEntDwColId" value="<%=proDwColVo.getProcessDwColumnId().intValue()%>"></td><td align="center"><input type="text" name="dispName" maxlength="50" onChange="chkMeasName(this)" value="<%=proDwColVo.getDwName()%>"></td><td><select name="selTypeMeasure" onChange="changeMeasureType(this)"><option value="0"><%=LabelManager.getName(labelSet,"lblMeasStandard")%></option><option value="1" selected><%=LabelManager.getName(labelSet,"lblMeasCalculated")%></option></select></td><td><select name="selAgregator" id="selAgregator" style="display:none"><option value="-1" selected></option><option value="0">SUM</option><option value="1">AVG</option><option value="2">COUNT</option><option value="3">MIN</option><option value="4">MAX</option><option value="5">DIST. COUNT</option></select></td><td><input type="text" name="format" value="" style="display:none"></td><td><input type="text" name="formula" onChange="chkFormula(this,null)" value="<%=proDwColVo.getFormula()%>" size=40 style="display:block" title="[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos"></td><td style="min-width:150px"><input type="checkbox" name="visible" value="<%=rowIndx%>" <%=(proDwColVo.getVisibility().intValue()==1)?"checked":""%>><%rowIndx++;%></td></tr><%
									}
								}											
						 }
					   }%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><input type="hidden" id="txtHidAttMsrIds" name="txtHidAttMsrIds" value="<%=attMsrIdsStr%>"><input type="hidden" id="txtHidAttEntMsrIds" name="txtHidAttEntMsrIds" value="<%=attEntMsrIds%>"><input type="hidden" id="txtHidAttProMsrIds" name="txtHidAttProMsrIds" value="<%=attProMsrIds%>"><button type="button" id="btnDupMeas" <%=hasCube?"":"disabled"%> onclick="btnDupMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDup")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDup")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDup")%></button><button type="button" id="btnAddMeas" <%=hasCube?"":"disabled"%> onclick="btnAddMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelMeas" <%=hasCube?"":"disabled"%> onclick="btnDelMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br><!--     - Perfiles con acceso al cubo en modo navegador --><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblPrfAccCube")%></DIV><div type="grid" id="gridProfiles" style="height:100px"><table id="tblProfiles" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="200px" style="min-width:200px;width:90%"  title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody id="tblPerBody"><%  Collection cubeProfs = dBean.getCubeProfiles();
						if (hasCube && cubeProfs != null && cubeProfs.size()>0){
						Iterator itProfiles = cubeProfs.iterator();
						while (itProfiles.hasNext()) {
							ProfileVo profileVo = (ProfileVo) itProfiles.next();
							%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPrfSel"><input type=hidden name="chkPrf" value="<%=dBean.fmtInt(profileVo.getPrfId())%>"></td><td style="min-width:200px"><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(profileVo.getPrfName())%></td><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("</B>");}%></tr><%
						} 
					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" id="btnAddCbePrf" onClick="btnAddProfile_click()" <%=hasCube?"":"disabled"%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelCbePrf" onClick="btnDelProfile_click()" <%=hasCube?"":"disabled"%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br><!--  Perfiles con acceso restringido en modo visualizador --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtPerNoAcc")%></DIV><div type="grid" id="gridNoAccProfiles" style="height:100px"><table id="tblProfiles"  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="400px" style="width:400px" title="<%=LabelManager.getToolTip(labelSet,"lblProfile")%>"><%=LabelManager.getName(labelSet,"lblProfile")%></th><th min_width="200px" style="min-width:200px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblResDimensions")%>"><%=LabelManager.getName(labelSet,"lblResDimensions")%></th></tr></thead><tbody id="tblPerBody"><%  Collection cubePrfRes = dBean.getCubePrfRestricted();
							if (cubePrfRes != null && cubePrfRes.size()>0){
								Iterator itPrfRes = cubePrfRes.iterator();
								while (itPrfRes.hasNext()) {
									String prfName = (String) itPrfRes.next();
									%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPrfRestSel"><input type=hidden name="chkPrfRest" value=""></td><td value="<%=prfName%>" flagNew="false"><%=prfName%></td><td style="min-width:200px"><span style="vertical-align:bottom;"><img title="<%=LabelManager.getName(labelSet,"lblCliSelDimension")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="17" height="16" onclick="openNoAccDims(this)" style="cursor:pointer;cursor:hand"></span></td></tr><%
								} 
							}%></tbody></table><iframe name="gridCbePrfNoAcc" id="gridCbePrfNoAcc" style="display:none"></iframe></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" id="btnAddNoAccPrf" onclick="btnAddNoAccProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelNoAccPrf" onclick="btnDelNoAccProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br><!--   Carga de datos   --><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblDataLoad")%></DIV><table class="tblFormLayout"><tr><td><input <%=(!hasCube)?"disabled":""%> type="radio" name="dataLoad" id="dataLoad1" onClick="changeRadFact(1);" value="" checked><%=LabelManager.getName(labelSet,"lblLoadOnConfirm")%></td><td><button <%=(!hasCube)?"disabled":""%> type="button" id="btnEstTime" onClick="btnEstTime_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEstTime")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEstTime")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEstTime")%></button></td><td></td><td></td></tr><tr><td><input <%=(!hasCube)?"disabled":""%> type="radio" name="dataLoad" id="dataLoad2" onClick="changeRadFact(2);" value="" ><%=LabelManager.getName(labelSet,"lblSchedLoad")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblFchIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFchIni")%>:</td><td><input disabled type=text name="txtFchIni" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" size="10" maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFchIni")%>" value=""></td><td></td></tr><tr><td></td><td title="<%=LabelManager.getToolTip(labelSet,"lblHorIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHorIni")%>:</td><td><input disabled type=text name="txtHorIni" maxlength=5 size=5 p_mask="<%=DogmaUtil.getHTMLTimeMask()%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblHorIni")%>" value=""></td><td></td></tr><tr><td><input name="radSelected" id="radSelected" type="hidden" value="1"></td><td></td><td></td><td></td></tr></table><br><!--   Ejecucion del cubo  
				<DIV class="subTit"><%=LabelManager.getName(labelSet,"lblExecution")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getName(labelSet,"lblLoadInMemAtStart")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLoadInMemAtStart")%>:</td><td><input type="checkbox" name="chkLodInMemAtStart" title="<%=LabelManager.getToolTip(labelSet,"lblLoadInMemAtStart")%>" <%=hasCube?"":"disabled"%><%=(dBean.getSchedVo()==null || SchBusClaActivityVo.STATUS_DISABLED==dBean.getSchedVo().getSchActStatus().intValue())?"":"checked"%> title="<%=LabelManager.getToolTip(labelSet,"lblLoadInMemAtStart")%>"></td></tr></table>
			 --></div><%
		   }%></div></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><%if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VERSION) { %><TD align="left"><button type="button" onClick="showFlashInput()">XML Input</button></TD><TD align="right"><button type="button" id="btnBack" onClick="btnBackVer_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%} else if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VIEW_PRO) {%><TD align="left"><button type="button" onClick="showFlashInput()">XML Input</button></TD><TD align="right"><button type="button" id="btnBack" onClick="btnBackPro_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%} else {%><TD align="left"><% /*
					<button type="button" onClick="showFlashInput()">XML Input</button><button type="button" onClick="showFlashOutput()">XML Output</button> */ %><button type="button" onClick="actionAfterFlash='validar';getFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVal")%></button></TD><TD align="right"><button type="button" id="btnGenDoc" disabled onClick="btnDoc()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGenProDoc")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGenProDoc")%>"><%=LabelManager.getNameWAccess(labelSet,"btnGenProDoc")%></button><button type="button" <%=(!saveChanges)?"disabled":"" %> onClick="actionAfterFlash='guardar';getFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGua")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGua")%>"><%=LabelManager.getNameWAccess(labelSet,"btnGua")%></button><button type="button" <%=(!saveChanges)?"disabled":"" %> onClick="actionAfterFlash='confirmar';getFlashOutput()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onClick="btnBack_click('<%=showExitAlert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%}%><button type="button" id="btnSalir" onClick="btnExit_click('<%=showExitAlert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><!-- FLASH PARA IMPRESION --><div id="imageGenerator" style="position:absolute;top=1;left=0;width:1px;height:1px;overflow:hidden;display:none;"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
				 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
					WIDTH="100%" 
					HEIGHT="500px" 
					style="/*border:1px solid blue*/"
					id="shellPrint" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" /><param name="FlashVars" value="toPrint=true&utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/<%=windowId%>"/><param name="quality" value="high" /><param name="menu" value="false"><param name="bgcolor" value="#EFEFEF" /><param name="WMODE" value="transparent" /><embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shellPrint" name="shellPrint" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="toPrint=true&utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/<%=windowId%>" /></object></div></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><%
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
str.append("init_instance_callback:\"sizeMe\",");
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
%></script><iframe id="ifrmDow" name="ifrmDow" style="position:absolute;WIDTH:0px;HEIGHT:0px;top:0px;left:0px" src=""></iframe><script language="javascript" type="text/javascript">

	function loadEditors(){
		if (document.addEventListener) {
			//document.addEventListener("DOMContentLoaded", function(){
			tinyMCE.execCommand('mceAddControl', false, "areaObj");
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaObj");
		}
		
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc1"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc1");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc2"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc2");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc3");
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc3");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc4"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc4");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc5"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc5");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc6"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc6");
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc7"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc7");	
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc8"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc8");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc9"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc9");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc10"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc10");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc11"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc11");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc12"); 
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc12");	 
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc13");
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc13");
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc14");
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc14");
		}
		if (document.addEventListener) {
			tinyMCE.execCommand('mceAddControl', false, "areaDoc15");
		}else{
			tinyMCE.execCommand("mceAddControl", false, "areaDoc15");	
		}
	}
</script><SCRIPT>
var WARN_USER_NOT_IN_POOLS = "<%=LabelManager.getName(labelSet,"msgWarnUserNotInPools")%>";
var TYPE_NUMERIC = "<%= AttributeVo.TYPE_NUMERIC %>";
var TYPE_DATE = "<%= AttributeVo.TYPE_DATE %>";
var TYPE_STRING = "<%= AttributeVo.TYPE_STRING %>";
var USRCREATION_FORM_ID = "<%= FormVo.USRCREATION_FORM_ID %>";
var VERSION_ON_SAVE = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgProSavVersion"))%>";
var CONFIRM_PRINT = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgProConfPrint"))%>";
var MSG_ALR_EXI_MEAS = "<%=LabelManager.getName(labelSet,"msgAlrExiMeas") %>";
var MSG_ALR_EXI_DIM = "<%=LabelManager.getName(labelSet,"msgAlrExiDim") %>";
var LBL_SEL_ATTRIBUTE = "<%=LabelManager.getName(labelSet,"lblSelAttribute")%>";
var LBL_SEL_PRO_PROPERTY = "<%=LabelManager.getName(labelSet,"lblSelProProperty")%>";
var MSG_MUST_ASOC_ATT_FIRST = "<%=LabelManager.getName(labelSet,"msgProcMustAsocAttFirst") %>";
var envId = "<%=dBean.getEnvId(request)%>";
var LBL_SEL_MAP_ENTITY = "<%=LabelManager.getName(labelSet,"lblCliSelMapEntity")%>";
var MAP_ENTITY = "<%=LabelManager.getName(labelSet,"lblMapEntity")%>";
var MSG_MUST_SEL_MEAS_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelMeasFirst") %>";
var LBL_DEL_MAP_ENTITY = "<%=LabelManager.getName(labelSet, "lblDelMapEntity")%>";
var LBL_YEAR = "<%=LabelManager.getName(labelSet,"lblYear") %>";
var LBL_SEMESTER = "<%=LabelManager.getName(labelSet,"lblSem") %>";
var LBL_TRIMESTER = "<%=LabelManager.getName(labelSet,"lblTrim") %>";
var LBL_MONTH = "<%=LabelManager.getName(labelSet,"lblMonth") %>";
var MSG_MUST_SEL_DIM_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelDimFirst") %>";
var LBL_WEEKDAY = "<%=LabelManager.getName(labelSet,"lblWeeDay") %>";
var LBL_DAY = "<%=LabelManager.getName(labelSet,"lblBIDay") %>";
var LBL_HOUR = "<%=LabelManager.getName(labelSet,"lblBIHour") %>";
var LBL_MINUTE = "<%=LabelManager.getName(labelSet,"lblMinute") %>";
var MSG_VWS_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgViewsWillBeLost") %>";
var LBL_SECOND = "<%=LabelManager.getName(labelSet,"lblSecond") %>";
var LBL_MEAS_STANDARD = "<%=LabelManager.getName(labelSet,"lblMeasStandard")%>";
var LBL_MEAS_CALCULATED = "<%=LabelManager.getName(labelSet,"lblMeasCalculated")%>";
var MSG_DELETE_CUBE_CONFIRM = "<%=LabelManager.getName(labelSet,"msgDelCbeConfirm") %>";
var MSG_ATT_IN_USE = "<%=LabelManager.getName(labelSet,"msgAttInUse")%>";
var MSG_CBE_IN_USE_BY_WIDGET = "<%=LabelManager.getName(labelSet,"msgCbeInUseByWidget")%>";
var MSG_CBE_IN_USE_BY_CUBE = "<%=LabelManager.getName(labelSet,"msgCbeInUseByCube")%>";
var PRO_CREATE_DATE = "101";
var PRO_CONSEC_DAYS = "102";
var PRO_END_REMAIN = "103";
var PRO_EST_ALARM_REMAIN = "104";
var PRO_CREATE_GROUP = "105";
var PRO_CREATE_USER = "106";
var PRO_DELAY_STATUS = "107";
var PRO_PRIORITY = "108";
var PRO_STATUS = "109";
var DW_ATT_FROM_ENTITY_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_BASIC_DATA%>";
var DW_ATT_FROM_PROCESS_BASIC_DATA = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_BASIC_DATA%>";
var DW_ATT_FROM_ENTITY_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_ENTITY_FORM%>";
var DW_ATT_FROM_PROCESS_FORM = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS_FORM%>";
var DW_ATT_FROM_PROCESS = "<%=ProcessDwColumnVo.DW_ATT_FROM_PROCESS%>";
var MSG_MUST_ENT_CBE_NAME = "<%=LabelManager.getName(labelSet,"msgMustEntCbeName")%>";
var MSG_MUST_ENT_ONE_DIM = "<%=LabelManager.getName(labelSet,"msgMustEntOneDimension")%>";
var MSG_MUST_ENTER_FORMULA = "<%=LabelManager.getName(labelSet,"msgMustEntFormula")%>";
var MSG_MIS_DIM_ATT = "<%=LabelManager.getName(labelSet,"msgMisDimAttribute")%>";
var MSG_WRG_DIM_NAME = "<%=LabelManager.getName(labelSet,"msgWrgDimName")%>";
var MSG_AT_LEAST_ONE_DIM_MUST_USE_ATT = "<%=LabelManager.getName(labelSet,"msgAtLeastOneDimMusUseAtt")%>";
var MSG_MUST_ENT_ONE_MEAS = "<%=LabelManager.getName(labelSet,"msgMustEntOneMeasure")%>";
var MSG_WRG_MEA_NAME = "<%=LabelManager.getName(labelSet,"msgWrgMeaName")%>";
var MSG_MIS_MEA_ATT = "<%=LabelManager.getName(labelSet,"msgMisMeaAttribute")%>";
var MSG_ATLEAST_ONE_MEAS_VISIBLE = "<%=LabelManager.getName(labelSet,"msgAtLeastOneMeasVisible")%>";
var MSG_MUST_ENT_ONE_PRF = "<%=LabelManager.getName(labelSet,"msgMustEntOneProfile")%>";
var MSG_DUE_TO_BI_UPD_CBE_MUST_BE_REGEN = "<%=LabelManager.getName(labelSet,"msgDueToBiUpdProCbeMstBeRegen")%>";
var MSG_PRO_LCK_BY_OTH_USER = "<%=LabelManager.getName(labelSet,"msgProLockedByOthUser")%>";
var MSG_PRO_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgProcPermError")%>";
var MSG_DIM_NAME_UNIQUE = "<%=LabelManager.getName(labelSet,"msgDimNameUnique")%>";
var MSG_MEASURE_NAME_UNIQUE = "<%=LabelManager.getName(labelSet,"msgMeasureNameUnique")%>";
var MSG_MEAS_OP1_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp1NameInvalid")%>";
var MSG_MEAS_OP2_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp2NameInvalid")%>";
var MSG_MEAS_NAME_LOOP_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasNameLoopInvalid")%>";
var MSG_CUBE_NAME_ALREADY_EXIST = "<%=LabelManager.getName(labelSet,"msgCubExi")%>";
var MSG_CUBE_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgCbeNamInv")%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";
var LBL_SEL_DIM_TO_DENIE_ACCESS = "<%=LabelManager.getName(labelSet, "lblCliSelDimension")%>";
var MSG_PRF_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfNoAccDeleted")%>";
var MSG_PRFS_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfsNoAccDeleted")%>";
var MSG_CBE_NAME_MISS = "<%=LabelManager.getName(labelSet,"msgCbeNameMiss")%>";
var LBL_CLI_TO_PROPS = "<%=LabelManager.getName(labelSet,"lblCliToProps")%>";
var LBL_TOD = "<%=LabelManager.getName(labelSet,"lblTod")%>";
var DO_ACTION_CONFIRM = "<%=dBean.DO_ACTION_CONFIRM%>";
var DO_ACTION_SAVE = "<%=dBean.DO_ACTION_SAVE%>";

<%if (proVo != null && proVo.getCubeId()!=null){%>
CANT_VIEWS = "<%=dBean.getCubeViewsList(proVo.getCubeId()).size()%>";
<%}else{%>
CANT_VIEWS = 0;
<%}%>

var viewsWithError = <%=dBean.isViewsWithErrors()%>;
var errorViews = "<%=dBean.getErrorViews()%>";
var msgVwWithError = "<%=LabelManager.getName(labelSet,"msgVwWillBeDeleted")%>";

</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/process/process.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/process/flash.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/process/cubes.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/ajax.js"></script><script language="javascript">

function fnOnLoad(){
	var mustRebuild = "<%=mustRebuild%>"; //Indicates if the cube must be rebuild
	if ("true" == mustRebuild){
		alert(MSG_DUE_TO_BI_UPD_CBE_MUST_BE_REGEN);
	}
	document.getElementById("imageGenerator").style.display="block";
}

function showContent(contentNumber){
	if(document.getElementById("content"+contentNumber).style.display!="block"){
		if(navigator.userAgent.indexOf("MSIE")<0){
			if(contentNumber!=1 && flashLoaded && document.getElementById("content1").style.display=="block"){
				listener.contentNumber=contentNumber;
				hideFlash();
			}else{
				hideAllContents();
				document.getElementById("tab"+contentNumber).parentNode.className="here";
				document.getElementById("content"+contentNumber).style.display="block";
				var container=window.parent.document.getElementById(window.name);
				if(container){
					container.style.display="none";
					container.style.display="block";
				}
			}
		}else{
			hideAllContents();
			document.getElementById("tab"+contentNumber).parentNode.className="here";
			document.getElementById("content"+contentNumber).style.display="block";
		}
	}
}
function hideAllContents(){
	for(var i=0;i<5;i++){
		document.getElementById("tab"+i).parentNode.className="";
		document.getElementById("content"+i).style.display="none";
	}
}
</script><SCRIPT LANGUAGE="VBScript">
Sub shell_FSCommand(ByVal command, ByVal args)
    call shell_DoFSCommand(command, args)
end sub

Sub shellPrint_FSCommand(ByVal command, ByVal args)
    call shellPrint_DoFSCommand(command, args)
end sub
</SCRIPT><SCRIPT defer="true">

function changeIdePos(val) {
	document.getElementById("txtIdePos").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'false';
	} else {
		setRequiredField(document.getElementById("txtIdePos"));
		//document.getElementById("txtIdePos").p_required = 'true';
	}
}

function changeIdePre(val) {
	document.getElementById("txtIdePre").disabled = val; 
	if (val) {
		unsetRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").p_required = 'false';
	} else {
		setRequiredField(document.getElementById("txtIdePre"));
		//document.getElementById("txtIdePre").p_required = 'true';
	}
}

<%if (dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VERSION ||
	  dBean.getOperationType() == com.dogma.bean.administration.ProcessBean.OP_TYPE_VIEW_PRO) { %>
	function disableAll(){
		var ele;
		for (i=0;i<document.getElementsByTagName("*").length;i++) {
			ele = document.getElementsByTagName("*")[i];
			if (ele.tagName == "INPUT" || ele.tagName == "SELECT" || ele.tagName == "TEXTAREA" || ele.tagName == "BUTTON") {
				if (ele.tagName == "TEXTAREA" || ele.tagName == "SELECT" || (ele.tagName == "INPUT" && ele.type=="text")) {
					ele.style.backgroundColor="gainsboro";
				}
				if (ele.id != "btnBack" && ele.id != "btnSalir") {
					ele.disabled="true";	
				}
			}
		}
	}
	if (document.addEventListener) {
  	  document.addEventListener("DOMContentLoaded", disableAll, false);
	}else{
		disableAll();
	}
<%}%></SCRIPT><script language="javascript">
function getFlashObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
		return document.getElementById(movieName);
	}
}
function chkReaGruFun(){
	if (document.getElementById("reaGroups").disabled){
		document.getElementById("reaGroups").disabled = false;
	}else{
		document.getElementById("reaGroups").disabled = true;
	}
}
var dependencies=false; //usado para que al presionar volver o salir pregunte si desea perder los datos ingresados (si no estamos en dependencies debe preguntar)
var newProcess = <%=proVo.getProId()==null%>;
var loadedEditors = false;
function tabSwitch(){
	var index=document.getElementById("samplesTab").getSelectedTabIndex();
	if(index==6 && !loadedEditors){
		loadedEditors = true;
		loadEditors();
		sizeMe();
	}
}
</script>

		