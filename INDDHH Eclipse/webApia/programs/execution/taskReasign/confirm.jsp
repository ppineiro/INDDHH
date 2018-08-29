<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.TaskReasignBean"></jsp:useBean><% TasksListVo taskVo = dBean.getTaskListVo(); 
   String mode = request.getParameter("mode");
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titReaTar")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatTar")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%if ("pool".equals(mode)){ %><tr><td><%=LabelManager.getName(labelSet,"lblTskTit")%>:</td><td><%=dBean.fmtStr(taskVo.getTaskTitle())%></td><% if (taskVo.getTaskAcquired()!=null){ %><td><%=LabelManager.getName(labelSet,"lblEjeFecAdqTar")%></td><td><%=dBean.fmtDateAMPM(taskVo.getTaskAcquired())%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblActUser")%>:</td><td><%=dBean.fmtStr(taskVo.getUserLogin())%></td><td><%=LabelManager.getName(labelSet,"lblActPool")%>:</td><td><%=dBean.fmtStr(taskVo.getGroupName())%></td></tr><%}else{%></tr><tr><td><%=LabelManager.getName(labelSet,"lblActPool")%>:</td><td><%=dBean.fmtStr(taskVo.getGroupName())%></td><td></td><td></td></tr><%}%><tr><td><%=LabelManager.getName(labelSet,"lblNuePool")%>:</td><td colspan=2><select name="cmbNewPool" p_required="true" onchange="fncPoolChange()"><option value=""></option><%
								Collection colPools = dBean.getPossiblePools();
								if(colPools!=null){
									Iterator it = colPools.iterator();
									while(it.hasNext()){
										PoolVo poolVo = (PoolVo)it.next();
										if (!poolVo.getPoolName().equals(taskVo.getGroupName())){
											out.print("<option value='" + poolVo.getPoolId() + "'>" + dBean.fmtStr(poolVo.getPoolName()) + "</option>");
										}
									}
								}
							%></select></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblNueUsu")%>:</td><td><select name="cmbNewUser"></select></td><td></td><td></td></tr><%}else {%><tr><td><%=LabelManager.getName(labelSet,"lblTskTit")%>:</td><td><%=dBean.fmtStr(taskVo.getTaskTitle())%></td><td><%=LabelManager.getName(labelSet,"lblEjeFecAdqTar")%></td><td><%=dBean.fmtDateAMPM(taskVo.getTaskAcquired())%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblActUser")%>:</td><td><%=dBean.fmtStr(taskVo.getUserLogin())%></td><td></td><td></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblNueUsu")%>:</td><td><select name="cmbNewUser" p_required=true><%
								Collection col = dBean.getPossibleUsers();
								if(col!=null){
									Iterator it = col.iterator();
									while(it.hasNext()){
										com.dogma.vo.custom.CmbDataVo cmbVo = (com.dogma.vo.custom.CmbDataVo)it.next();
										out.print("<option value='" + cmbVo.getValue() + "'>" + dBean.fmtStr(cmbVo.getText()) + "</option>");
									}
								}
							%></select></td><td></td><td></td></tr><%} %></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/execution/taskReasign/confirm.js"></script><%@include file="../../../components/scripts/server/endInc.jsp" %>

