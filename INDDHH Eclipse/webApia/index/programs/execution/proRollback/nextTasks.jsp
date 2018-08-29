<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.ProRollbackBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><%if (dBean.TYPE_ADHOC.equals(dBean.getRollbackType())) {%><TD><%=LabelManager.getName(labelSet,"titAdhoc")%></TD><%} else {%><TD><%=LabelManager.getName(labelSet,"titProRol")%></TD><%}%><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%if (dBean.TYPE_ADHOC.equals(dBean.getRollbackType())) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRollAdTskFrm")%></DIV><%} else {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRollTskFrm")%></DIV><%}%><div type="grid" multiSelect="false" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;">&nbsp;</th><th min_width="100px" style="min-width:100px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblMonTskNom")%>"><%=LabelManager.getName(labelSet,"lblMonTskNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstSta")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstSta")%></th><th min_width="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"lblMonPoolNom")%>"><%=LabelManager.getName(labelSet,"lblMonPoolNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonUsrLog")%>"><%=LabelManager.getName(labelSet,"lblMonUsrLog")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatRea")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatRea")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatEnd")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatEnd")%></th></tr></thead><%MonitorTaskVo mPITVo = dBean.getTaskFrom();%><tbody><tr><td style="width:0px;display:none"><input type=hidden></td><td style="min-width:120px" <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getTskName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
								ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaWai"):
								ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
								ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaAcq"):
								ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCom"):
								ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):
								ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSki"):""%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getPoolName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getUsrLogin())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateReady())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateEnd())%></td></tr></tbody></table></div><%  if (dBean.getRollbackType().equals(com.dogma.bean.execution.ProRollbackBean.TYPE_ROLLBACK)) { 
					Collection col = dBean.getEndPoints(request);
			%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRollTskTo")%></DIV><div type="grid" id="gridList" multiSelect="false" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;">&nbsp;</th><th min_width="100px" style="min-width:100px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblMonTskNom")%>"><%=LabelManager.getName(labelSet,"lblMonTskNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstSta")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstSta")%></th><th min_width="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"lblMonPoolNom")%>"><%=LabelManager.getName(labelSet,"lblMonPoolNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonUsrLog")%>"><%=LabelManager.getName(labelSet,"lblMonUsrLog")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatRea")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatRea")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatEnd")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatEnd")%></th></tr></thead><tbody><%	
						if (col != null) {
							Iterator it = col.iterator();
							int i = 0;
							Integer oldProEleInstId = null;
							while (it.hasNext()) {
								mPITVo = (MonitorTaskVo) it.next(); 
								if (mPITVo.isAlive()) {
								%><tr><td style="width:0px;display:none"><input type=hidden></td><td style="min-width:120px" <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getTskName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
									ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaWai"):
									ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
									ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaAcq"):
									ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCom"):
									ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):
									ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSki"):""%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getPoolName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getUsrLogin())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateReady())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateEnd())%></td></tr><%
								i++;
								}
							}
						}%></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="btnBackTask_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonBack")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonBack")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonBack")%></button><button id=btnConf onclick="btnConfRol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><% } else { %><%Collection col = dBean.getTasksForAdhoc(request);%><input type="hidden" name="gridRowCant" value="<%=col.size()%>" /><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRollAdTskTo")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE-130%>px" <%=dBean.getRollbackType().equals(dBean.TYPE_LOOPBACK)?"multiSelect=false":""%>><table width="900px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;">&nsbp;</th><th min_width="100px" style="min-width:100px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblMonTskNom")%>"><%=LabelManager.getName(labelSet,"lblMonTskNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstSta")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstSta")%></th><th min_width="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"lblMonPoolNom")%>"><%=LabelManager.getName(labelSet,"lblMonPoolNom")%></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblMonUsrLog")%>"><%=LabelManager.getName(labelSet,"lblMonUsrLog")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatRea")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatRea")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProEleInstDatEnd")%>"><%=LabelManager.getName(labelSet,"lblMonProEleInstDatEnd")%></th></tr></thead><tbody><%	
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								Integer oldProEleInstId = null;
								while (it.hasNext()) {
									mPITVo = (MonitorTaskVo) it.next(); 
									if (! mPITVo.isAlive() || dBean.getRollbackType().equals(com.dogma.bean.execution.ProRollbackBean.TYPE_ROLLBACK)) {
									%><tr><td style="display:none;width:0px;"><input type="hidden"  name=chkSel<%=i%>><input name=chkSelValue<%=i%> value="<%=mPITVo.getProInstEleIdFather() == null?  dBean.fmtInt(mPITVo.getProEleInstId()):dBean.fmtInt(mPITVo.getProInstEleIdFather())%>"></td><td style="min-width:120px" <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getTskName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=
											ProEleInstanceVo.ELE_STATUS_WAITING.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaWai"):
											ProEleInstanceVo.ELE_STATUS_READY.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaRea"):
											ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaAcq"):
											ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCom"):
											ProEleInstanceVo.ELE_STATUS_CANCELLED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaCan"):
											ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(mPITVo.getProEleInstStatus())?LabelManager.getName(labelSet,"lblMonProEleInstStaSki"):""%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getPoolName())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTML(mPITVo.getUsrLogin())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateReady())%></td><td <%=mPITVo.isLate()?"class=\"tdProLat\"":mPITVo.isInAlert()?"class=\"tdProInAle\"":""%>><%=dBean.fmtHTMLAMPM(mPITVo.getProEleInstDateEnd())%></td></tr><%
									i++;
									}
								}
							}%></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRollAdHocTyp")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td align=left><input type=radio name="radType" value="<%=dBean.ADHOC_SEQ%>" checked><%=LabelManager.getName(labelSet,"sbtRollAdHocSeq")%></td><td><input type=radio name="radType" value="<%=dBean.ADHOC_PAR%>"><%=LabelManager.getName(labelSet,"sbtRollAdHocPar")%></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="btnBackTask_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonBack")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonBack")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonBack")%></button><button id=btnConf onclick="btnConfAd_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><%}%></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var msgProRoll = "<%=dBean.getRollbackType().equals(dBean.TYPE_ADHOC)?LabelManager.getName(labelSet,"msgProAdHoc"):LabelManager.getName(labelSet,"msgProRol")%>";
</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/execution/proRollback/rollback.js'></script>