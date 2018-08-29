<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.Configuration"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.scheduler.SchedulerBean"></jsp:useBean><%
SchBusClaActivityVo schVo = dBean.getSchedulerVo();
BusClassVo bcVo = dBean.getBusClass();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSch")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabSchData")%>" tabText="<%=LabelManager.getName(labelSet,"tabSchData")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatSch")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><%if (schVo.getSchBusClaId() != null) {%><td class=readOnly><input type=hidden name="txtSchName" value="<%=dBean.fmtHTML(schVo.getSchName())%>"><%=dBean.fmtHTML(schVo.getSchName())%><%} else { %><td><input p_required=true type=text accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" name="txtSchName" value="<%=dBean.fmtHTML(schVo.getSchName())%>"><%} %></td><td title="<%=LabelManager.getToolTip(labelSet,"lblPeri")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPeri")%>:</td><td><select p_required=true name="cmbPeri" id="cmbPeri" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPeri")%>" onChange="checkPeriodicity();" ><option></option><%
									Collection cPer = SchedulerBean.getPeriodicity(request,labelSet);
									if(cPer!=null){
										Iterator itPer = cPer.iterator();
										while(itPer.hasNext()){
											CmbDataVo cmb = (CmbDataVo)itPer.next();
											%><option value="<%=dBean.fmtHTML(cmb.getValue())%>" <%if(schVo!=null && schVo.getPeriodicity()!=null && schVo.getPeriodicity().equals(cmb.getValue())){out.print(" selected ");}%> ><%=dBean.fmtHTML(cmb.getText())%></option><%
										}
									}
									%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCla")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCla")%>:</td><%if (schVo.getSchBusClaId() != null) {%><td class=readOnly colspan="1"><input type=hidden name="cmbClass" value="<%=dBean.fmtInt(schVo.getBusClaId())%>"><%=dBean.fmtHTML(bcVo.getBusClaName())%><%} else {%><td colspan="1"><select p_required=true name="cmbClass" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblCla")%>" onchange="reloadPage()"><option></option><%
										//Collection cBus = dBean.getClasses(request);
										Collection cBus = dBean.getClassesScheduler(request);
										if(cBus!=null){
											Iterator itBus = cBus.iterator();
											while(itBus.hasNext()){
												BusClassVo cmb = (BusClassVo)itBus.next();
												%><option value="<%=dBean.fmtHTML(cmb.getBusClaId())%>" <%if(schVo!=null && schVo.getBusClaId()!=null && schVo.getBusClaId().equals(cmb.getBusClaId())){out.print(" selected ");}%> ><%=dBean.fmtHTML(cmb.getBusClaName())%></option><%
											}
										}
										%></select><%}%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblSchAfterSchSel")%>"><%=LabelManager.getNameWAccess(labelSet,"lblSchAfterSchSel")%>:</td><td><select <% if (schVo != null && SchBusClaActivityVo.PERIODICITY_AFTER_SCHEDULER.equals(schVo.getPeriodicity())) { %> p_required=true <% } else { %> disabled <% } %> name="cmbSchAfterSchId" id="cmbSchAfterSchId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSchAfterSchSel")%>"><option></option><% 
				   					Collection schs = dBean.getSchedulers(request); 
				   					if (schs != null) {
				   						for (Iterator it = schs.iterator(); it.hasNext(); ) {
				   							SchBusClaActivityVo aSch = (SchBusClaActivityVo) it.next();
				   							%><option value="<%=dBean.fmtHTML(aSch.getSchBusClaId())%>" <%if(schVo!=null && schVo.getSchAfterSchId()!=null && schVo.getSchAfterSchId().equals(aSch.getSchBusClaId())){out.print(" selected ");}%> ><%=dBean.fmtHTML(aSch.getSchName())%></option><%
				   						}
				   					} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFchIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFchIni")%>:</td><td><input type=text name="txtFchIni" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_required="true" size="10" maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFchIni")%>" <%if(schVo!=null){%>value="<%=dBean.fmtHTML(schVo.getFirstExecution())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblHorIni")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHorIni")%>:</td><td><input type=text name="txtHorIni" maxlength=5 size=5 p_mask="<%=DogmaUtil.getHTMLTimeMask()%>" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblHorIni")%>"  <%if(schVo!=null && schVo.getFirstExecution()!=null){%>value="<%=schVo.getHourMinute(schVo.getFirstExecution())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFchFin")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFchFin")%>:</td><td><input type=text name="txtFchFin" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" size="10" maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFchFin")%>" <%if(schVo!=null){%>value="<%=dBean.fmtHTML(schVo.getEndExecution())%>"<%}%>></td><td title="<%=LabelManager.getToolTip(labelSet,"lblHorFin")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHorFin")%>:</td><td><input type=text name="txtHorFin" maxlength=5 size=5 p_mask="<%=DogmaUtil.getHTMLTimeMask()%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblHorEnd")%>"  <%if(schVo!=null && schVo.getEndExecution()!=null){%>value="<%=schVo.getHourMinute(schVo.getEndExecution())%>"<%}%>></td></tr><%
				   			int radSel=1;
				   			if (!Parameters.SCHED_DISTRIBUTED || schVo.getNodeName() == null || "".equals(schVo.getNodeName())) {
				   				radSel=1;
				   			}else {
				   				radSel=2;
				   			}
				   		%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblUltEje")%>"><%=LabelManager.getName(labelSet,"lblUltEje")%>:</td><td><input type=text name="txtUltEje" readonly size="10" maxlength="10" class="txtReadOnly" <%if(schVo!=null){%>value="<%=dBean.fmtHTML(schVo.getLastExecution())%>"<%}%>><input type=text name="txtUltEjeHor" readonly maxlength=5 size=5 class="txtReadOnly" <%if(schVo!=null && schVo.getLastExecution()!=null){%>value="<%=schVo.getHourMinute(schVo.getLastExecution())%>"<%}%>></td><td align=right><%=LabelManager.getName(labelSet,"lblExeNode")%>:</td><td><input type="radio" name="radExeNode" onclick="showOtherNode(1,false);" value="1" <%if(radSel==1) {out.print(" checked ");}%><%= (!Parameters.SCHED_DISTRIBUTED)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblAllNodes")%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSta")%>"><%=LabelManager.getName(labelSet,"lblSta")%>:</td><td><% if (schVo.getSchActStatus() != null) {
									switch (schVo.getSchActStatus().intValue()) {
										case SchBusClaActivityVo.STATUS_NONE:
											out.write(LabelManager.getName(labelSet,"lblSchStaNoRun"));
											break;
										case SchBusClaActivityVo.STATUS_IN_EXECUTION:
											out.write(LabelManager.getName(labelSet,"lblSchStaRun"));
											break;
										case SchBusClaActivityVo.STATUS_FOR_EXECUTION:
											out.write(LabelManager.getName(labelSet,"lblSchStaForRun"));
											break;
										case SchBusClaActivityVo.STATUS_CANCEL:
											out.write(LabelManager.getName(labelSet,"lblSchStaCancel"));
											break;
										case SchBusClaActivityVo.STATUS_FINISH_OK:
											out.write(LabelManager.getName(labelSet,"lblSchStaOk"));
											break;
										case SchBusClaActivityVo.STATUS_FINISH_ERROR:
											out.write(LabelManager.getName(labelSet,"lblSchStaError"));
											break;
									}
								} %></td><td><input type=hidden name="radSelected" value="<%=radSel%>"></td><td><input type="radio" name="radExeNode" onclick="showOtherNode(2,true);" value="2" <%if (radSel==2) {out.print(" checked ");}%><%= (!Parameters.SCHED_DISTRIBUTED)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblSpecNode")%>:
								<input <%= (!Parameters.SCHED_DISTRIBUTED || schVo.getNodeName() == null || "".equals(schVo.getNodeName()))?"disabled":"" %> p_required="<%=(Parameters.SCHED_DISTRIBUTED)?"true":"false" %> type="text" name="txtExeNode" id="txtExeNode" value="<%=(Parameters.SCHED_DISTRIBUTED && schVo.getNodeName() != null)?dBean.fmtHTML(schVo.getNodeName()):""%>"></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtParSch")%></DIV><div type="grid" id="gridParams" style="height:200px" cellpadding="0" cellspacing="0"><table id="tblParams" class="tblDataGrid"><thead><tr><th min_width="28px" style="width:28px" title="<%=LabelManager.getToolTip(labelSet,"lblNumPar")%>"><%=LabelManager.getName(labelSet,"lblNumPar")%></th><th min_width="120px" style="min-width:120px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="120px" style="min-width:120px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblVal")%>"><%=LabelManager.getName(labelSet,"lblVal")%></th></tr></thead><tbody id="tblParamsBody"><%
						if (schVo != null && schVo.getSchBusClaId() != null && schVo.getParams() != null && schVo.getParams().size()>0) {
							if (schVo.getParams() != null && schVo.getParams().size()>0) {
								Iterator it = schVo.getParams().iterator();
		 						BusClaParBindingVo bbVo = null;
		 						int i=1;
		 						while (it.hasNext()) {
		   							bbVo = (BusClaParBindingVo)it.next(); %><tr onclick="selectRow()"><td align="center"><%=i%></td><td style="min-width:120px"><input type=hidden name="txtParId" value="<%=dBean.fmtInt(bbVo.getBusClaParId())%>"><input type=hidden name="txtParTyp" value="<%=dBean.fmtStr(bbVo.getBusClaParType())%>"><%=dBean.fmtStr(bbVo.getBusClaParName())%></td><% if (AttributeVo.TYPE_STRING.equals(bbVo.getBusClaParType())) {%><td style="min-width:120px"><input type="text" name="txtParVal" value="<%if (bbVo != null) out.print(dBean.fmtStr(bbVo.getValueAsString()));%>" size=30 maxlength="255"></td><% } else if (AttributeVo.TYPE_NUMERIC.equals(bbVo.getBusClaParType())) {%><td style="min-width:120px"><input type="text" name="txtParVal" value="<%if (bbVo != null) out.print(dBean.fmtStr(bbVo.getValueAsString()));%>" p_numeric="true" size="10" maxlength="10"></td><% } else {%><td style="min-width:120px"><input type="text" name="txtParVal" value="<%if (bbVo != null) out.print(dBean.fmtStr(bbVo.getValueAsString()));%>" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" size="10" maxlength="10"></td><% }%></tr><%i++;
		   						}
		 					}
		 				} else {
							if (bcVo != null && bcVo.getBusClaParams() != null && bcVo.getBusClaParams().size()>0) {
								Iterator it = bcVo.getBusClaParams().iterator();
		 						BusClaParameterVo bbVo = null;
		 						int i=1;
		 						while (it.hasNext()) {
		   							bbVo = (BusClaParameterVo)it.next(); %><tr onclick="selectRow()"><td align="center"><%=i%></td><td><input type=hidden name="txtParId" value="<%=dBean.fmtInt(bbVo.getBusClaParId())%>"><input type=hidden name="txtParTyp" value="<%=dBean.fmtStr(bbVo.getBusClaParType())%>"><%=dBean.fmtStr(bbVo.getBusClaParName())%></td><% if (AttributeVo.TYPE_STRING.equals(bbVo.getBusClaParType())) {%><td><input type="text" name="txtParVal" value="" size=30 maxlength=255></td><% } else if (AttributeVo.TYPE_NUMERIC.equals(bbVo.getBusClaParType())) {%><td><input type="text" name="txtParVal" value="" p_numeric="true" size="10" maxlength="10"></td><% } else {%><td><input type="text" name="txtParVal" value="" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" size="10" maxlength="10"></td><% }%></tr><%i++;
		   						}
		 					}
		 				}%></tbody></table></div></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabSchOnError")%>" tabText="<%=LabelManager.getName(labelSet,"tabSchOnError")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatSch")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSchOnErrorDis")%>"><%=LabelManager.getName(labelSet,"lblSchOnErrorDis")%>:</td><td><input type="checkbox" value="true" name="chkOnErrorDis" <%= schVo.getFlag(SchBusClaActivityVo.FLAG_ON_ERROR_DISABLED) ? "checked":"" %>></td></tr></table><!-- Notificación por email a grupos --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSchNotEmail")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSchSendNotEmail")%>"><%=LabelManager.getName(labelSet,"lblSchSendNotEmail")%>:</td><td><input type="checkbox" value="true" name="chkOnErrorEmail" <%= schVo.getFlag(SchBusClaActivityVo.FLAG_ON_ERROR_SEND_EMAIL) ? "checked":"" %>></td></tr></table><div type="grid" id="gridEmail" style="height:200px"><table id="tblPools" width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="100px" style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="100px" style="min-width:100px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th></tr></thead><tbody id="tblPoolBody"><%Collection pools = schVo.getNotificationsFor(SchErrNotificationVo.NOTIFICATION_EMAIL);
						for (Iterator it = pools.iterator(); it.hasNext(); ) {
 							PoolVo poolVo = ((SchErrNotificationVo) it.next()).getPoolVo(); %><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="chkPool" value="<%=dBean.fmtInt(poolVo.getPoolId())%>"><input type=hidden name="poolName" value="<%=dBean.fmtHTML(poolVo.getPoolName())%>"><input type=hidden name="poolDesc" value="<%=dBean.fmtHTML(poolVo.getPoolDesc())%>"><input type=hidden name="poolNotType" value="<%=SchErrNotificationVo.NOTIFICATION_EMAIL%>"></td><td><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(poolVo.getPoolName())%><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("</B>");}%></td><td style="min-width:100px"><%=dBean.fmtHTML(poolVo.getPoolDesc())%></td></tr><%
	 					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddPool_click('gridEmail','<%=SchErrNotificationVo.NOTIFICATION_EMAIL%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelPool_click('gridEmail')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><!-- Notificación por mensaje a grupos --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSchNotMsg")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSchSendNotMsg")%>"><%=LabelManager.getName(labelSet,"lblSchSendNotMsg")%>:</td><td><input type="checkbox" value="true" name="chkOnErrorMsg" <%= schVo.getFlag(SchBusClaActivityVo.FLAG_ON_ERROR_CREATE_MSG) ? "checked":"" %>></td></tr></table><div type="grid" id="gridMsg" style="height:200px"><table id="tblPools" width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="100px" style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="100px" style="min-width:100px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th></tr></thead><tbody id="tblPoolBody"><%pools = schVo.getNotificationsFor(SchErrNotificationVo.NOTIFICATION_MESSAGE);
						for (Iterator it = pools.iterator(); it.hasNext(); ) {
 							PoolVo poolVo = ((SchErrNotificationVo) it.next()).getPoolVo(); %><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="chkPool" value="<%=dBean.fmtInt(poolVo.getPoolId())%>"><input type=hidden name="poolName" value="<%=dBean.fmtHTML(poolVo.getPoolName())%>"><input type=hidden name="poolDesc" value="<%=dBean.fmtHTML(poolVo.getPoolDesc())%>"><input type=hidden name="poolNotType" value="<%=SchErrNotificationVo.NOTIFICATION_MESSAGE%>"></td><td><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(poolVo.getPoolName())%><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("</B>");}%></td><td style="min-width:100px"><%=dBean.fmtHTML(poolVo.getPoolDesc())%></td></tr><%
	 					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddPool_click('gridMsg','<%= SchErrNotificationVo.NOTIFICATION_MESSAGE %>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelPool_click('gridMsg')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
var DISTRIBUTED_SCHEDULER = "<%=Parameters.SCHED_DISTRIBUTED%>";
var MSG_INVALID_ACTUAL_NODE_NAME = "<%=LabelManager.getName(labelSet,"msgInvalidActualNodeName") %>";
var MSG_INVALID_NODE_NAME = "<%=LabelManager.getName(labelSet,"msgInvalidNodeName") %>";
</SCRIPT><script language=javascript>
	var envId = <%=dBean.getEnvId(request)%>;
	var perAfterSch = "<%= SchBusClaActivityVo.PERIODICITY_AFTER_SCHEDULER %>";

	function checkHour(obj){
		var regExp = /^([0-1][0-9]|[2][0-3])<%=Parameters.TIME_SEPARATOR%>[0-5][0-9]$/
		return regExp.test(obj.value);
	}
	function showOtherNode(val, show){
		document.getElementById("radSelected").value = val;
		if (!show){
			document.getElementById("txtExeNode").value = "";
			document.getElementById("txtExeNode").disabled = true;
		}else{
			document.getElementById("txtExeNode").disabled = false;
		}
	}
</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/scheduler/admin/update.js'></script>