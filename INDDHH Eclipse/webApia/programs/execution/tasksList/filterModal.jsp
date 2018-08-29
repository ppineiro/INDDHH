<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.st.util.translator.TranslationManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><%String WORK_MODE = request.getParameter("workMode");%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeFilLis")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent" ><FORM id="frmMain" name="frmMain" method="POST" target="frmSubmit"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFil")%></DIV><table><tr><td><select id="cmbOperator" name="cmbOperator"><option value=""></option><option value="AND">AND</option><option value="OR">OR</option></select></td><td><select id="cmbColNames" name="cmbColNames" onchange="cmbColNames_OnChange()" style="width:130px"><option value="<%=ListTaskBean.COL_TASK_TITLE%>"><%=LabelManager.getName(labelSet,"lblTskTit")%></option><option value="<%=ListTaskBean.COL_PROC_ID_PRE%>"><%=LabelManager.getName(labelSet,"lblEjeInsProPre")%></option><option value="<%=ListTaskBean.COL_PROC_ID_NUM%>"><%=LabelManager.getName(labelSet,"lblEjeInsProNum")%></option><option value="<%=ListTaskBean.COL_PROC_ID_POS%>"><%=LabelManager.getName(labelSet,"lblEjeInsProPos")%></option><option value="<%=ListTaskBean.COL_TASK_GROUP%>"><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></option><option value="<%=ListTaskBean.COL_PROC_TITLE%>"><%=LabelManager.getName(labelSet,"lblProTit")%></option><option value="<%=ListTaskBean.COL_PROC_TYPE%>"><%=LabelManager.getName(labelSet,"lblEjeTipProTar")%></option><option value="<%=ListTaskBean.COL_TASK_DATE%>"><%=LabelManager.getName(labelSet,"lblEjeFecCreTar")%></option><option value="<%=ListTaskBean.COL_PROC_DATE%>"><%=LabelManager.getName(labelSet,"lblEjeFecCreProTar")%></option><option value="<%=ListTaskBean.COL_ENT_ID_PRE%>"><%=LabelManager.getName(labelSet,"lblEjeInsEntPre")%></option><option value="<%=ListTaskBean.COL_ENT_ID_NUM%>"><%=LabelManager.getName(labelSet,"lblEjeInsEntNum")%></option><option value="<%=ListTaskBean.COL_ENT_ID_POS%>"><%=LabelManager.getName(labelSet,"lblEjeInsEntPos")%></option><option value="<%=ListTaskBean.COL_PROC_USER%>"><%=LabelManager.getName(labelSet,"lblEjeUsuCreProTar")%></option><option value="<%=ListTaskBean.COL_ENT_STATUS%>"><%=LabelManager.getName(labelSet,"lblEjeStaEntTar")%></option><%if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){%><option value="<%=ListTaskBean.COL_USER_LOGIN%>"><%=LabelManager.getName(labelSet,"lblEjeUseAdq")%></option><%}%><option value="<%=ListTaskBean.COL_PRO_INST_ATT_1%>"><%=LabelManager.getName(labelSet,"lblAtt1Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_2%>"><%=LabelManager.getName(labelSet,"lblAtt2Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_3%>"><%=LabelManager.getName(labelSet,"lblAtt3Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_4%>"><%=LabelManager.getName(labelSet,"lblAtt4Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_5%>"><%=LabelManager.getName(labelSet,"lblAtt5Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_1%>"><%=LabelManager.getName(labelSet,"lblAttNum1Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_2%>"><%=LabelManager.getName(labelSet,"lblAttNum2Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_3%>"><%=LabelManager.getName(labelSet,"lblAttNum3Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_1%>"><%=LabelManager.getName(labelSet,"lblAttDte1Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_2%>"><%=LabelManager.getName(labelSet,"lblAttDte2Pro")%></option><option value="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_3%>"><%=LabelManager.getName(labelSet,"lblAttDte3Pro")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_1%>"><%=LabelManager.getName(labelSet,"lblAtt1EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_2%>"><%=LabelManager.getName(labelSet,"lblAtt2EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_3%>"><%=LabelManager.getName(labelSet,"lblAtt3EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_4%>"><%=LabelManager.getName(labelSet,"lblAtt4EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_5%>"><%=LabelManager.getName(labelSet,"lblAtt5EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_6%>"><%=LabelManager.getName(labelSet,"lblAtt6EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_7%>"><%=LabelManager.getName(labelSet,"lblAtt7EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_8%>"><%=LabelManager.getName(labelSet,"lblAtt8EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_9%>"><%=LabelManager.getName(labelSet,"lblAtt9EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_10%>"><%=LabelManager.getName(labelSet,"lblAtt10EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_1%>"><%=LabelManager.getName(labelSet,"lblAttNum1EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_2%>"><%=LabelManager.getName(labelSet,"lblAttNum2EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_3%>"><%=LabelManager.getName(labelSet,"lblAttNum3EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_4%>"><%=LabelManager.getName(labelSet,"lblAttNum4EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_5%>"><%=LabelManager.getName(labelSet,"lblAttNum5EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_6%>"><%=LabelManager.getName(labelSet,"lblAttNum6EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_7%>"><%=LabelManager.getName(labelSet,"lblAttNum7EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_8%>"><%=LabelManager.getName(labelSet,"lblAttNum8EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_1%>"><%=LabelManager.getName(labelSet,"lblAttDte1EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_2%>"><%=LabelManager.getName(labelSet,"lblAttDte2EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_3%>"><%=LabelManager.getName(labelSet,"lblAttDte3EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_4%>"><%=LabelManager.getName(labelSet,"lblAttDte4EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_5%>"><%=LabelManager.getName(labelSet,"lblAttDte5EntNeg")%></option><option value="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_6%>"><%=LabelManager.getName(labelSet,"lblAttDte6EntNeg")%></option></select></td><td><select id="cmbRel"><option value="0">=</option><option value="1">&lt;</option><option value="2">&lt;=</option><option value="3">&gt;</option><option value="4">&gt;=</option><option value="5">&lt;&gt;</option></select></td><td><input type="text" id="txtFilterValue" maxlength="255" style="display:none;width:100px" disabled="disabled"><select id="cmbTaskFilterValue"  style="display:none;width:368px" disabled="disabled"><%Collection tasks = null;
							if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
								tasks = lBeanInproc.getAllTasks(uData.getEnvironmentId());
							}else{
								tasks = lBeanReady.getAllTasks(uData.getEnvironmentId());
							}
							if(tasks != null){
								Iterator iterTask = tasks.iterator();
								TaskVo tVo = null;
								String originalTaskTitle = "";
								while(iterTask.hasNext()){
									tVo = (TaskVo)iterTask.next();
									tVo.setLanguage(uData.getLangId());
									originalTaskTitle = tVo.getTskTitle();
									TranslationManager.setTranslationByNumber(tVo);%><option value="<%=originalTaskTitle%>"><%=tVo.getTskTitle()%></option><%}
							}%></select><select id="cmbProcessFilterValue"  style="display:none;width:368px" disabled="disabled"><%Collection procs = null;
							if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
								procs = lBeanInproc.getAllProcess(uData.getEnvironmentId());
							}else{
								procs = lBeanReady.getAllProcess(uData.getEnvironmentId());
							}
							if(procs != null){
								Iterator iterProc = procs.iterator();
								ProcessVo pVo = null;
								String originalProcTitle = "";
								while(iterProc.hasNext()){
									pVo = (ProcessVo)iterProc.next();
									pVo.setLanguage(uData.getLangId());
									originalProcTitle = pVo.getProTitle();
									TranslationManager.setTranslationByNumber(pVo);%><option value="<%=originalProcTitle%>"><%=pVo.getProTitle()%></option><%}
							}%></select></td><td><button type="button" onclick="btnAdd_onclick()" style="width:20px">+</button></td><td><button type="button" onclick="btnDel_onclick()"  style="width:20px">-</button></td></tr></table><div class="tableContainerNoHScroll" style="height: 268px;" type="grid" id="gridList"><table width="300px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeExpLog")%>"><%=LabelManager.getName(labelSet,"lblEjeExpLog")%></th><th min_width="110px" style="width:110px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeCol")%>"><%=LabelManager.getName(labelSet,"lblEjeCol")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeExpRel")%>"><%=LabelManager.getName(labelSet,"lblEjeExpRel")%></th><th min_width="290px" style="width:290px" title="<%=LabelManager.getToolTip(labelSet,"lblEjeValFil")%>"><%=LabelManager.getName(labelSet,"lblEjeValFil")%></th></tr></thead><tbody class="scrollContent"><%
						TasksListFilterVo filter = null;
						if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
							filter=lBeanInproc.getFilter();
						} else {
							filter=lBeanReady.getFilter();
						}
						int i=0;
						if(filter!=null && filter.getConditions()!=null){
							Collection col = filter.getConditions();
							Iterator it = col.iterator();
							while(it.hasNext()){
								TasksListFilterVo.Filter aux = (TasksListFilterVo.Filter)it.next();
								%><tr><td style="width:0px;display:none;"><input type='hidden' name='chkSel'></td><td style="width:70px"><input type='hidden' name='hidOpLog'   value='<%=aux.getLogicOp()%>'	><%=aux.getLogicOp()%></td><td style="width:110px"><input type='hidden' name='hidColName' value='<%=aux.getColumn()%>'><%
										if(aux.getColumn()==ListTaskBean.COL_TASK_TITLE) {
											out.print(LabelManager.getName(labelSet,"lblTskTit"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_PRE) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsProPre"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_NUM) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsProNum"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_POS) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsProPos"));
										}
										if(aux.getColumn()==ListTaskBean.COL_TASK_GROUP) {
											out.print(LabelManager.getName(labelSet,"lblEjeGruTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_TITLE) {
											out.print(LabelManager.getName(labelSet,"lblProTit"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_TYPE) {
											out.print(LabelManager.getName(labelSet,"lblEjeTipProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_TASK_DATE) {
											out.print(LabelManager.getName(labelSet,"lblEjeFecCreTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_DATE) {
											out.print(LabelManager.getName(labelSet,"lblEjeFecCreProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_PRE) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntPre"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_NUM) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntNum"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_POS) {
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntPos"));
										}

										if(aux.getColumn()==ListTaskBean.COL_PROC_USER) {
											out.print(LabelManager.getName(labelSet,"lblEjeUsuCreProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_STATUS) {
											out.print(LabelManager.getName(labelSet,"lblEjeStaEntTar"));
										}
										
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
											if(aux.getColumn()==ListTaskBean.COL_USER_LOGIN) {
												out.print(LabelManager.getName(labelSet,"lblEjeUseAdq"));
											}
										}
							
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_1) {
											out.print(LabelManager.getName(labelSet,"lblAtt1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_2) {
											out.print(LabelManager.getName(labelSet,"lblAtt2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_3) {
											out.print(LabelManager.getName(labelSet,"lblAtt3Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_4) {
											out.print(LabelManager.getName(labelSet,"lblAtt4Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_5) {
											out.print(LabelManager.getName(labelSet,"lblAtt5Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_1) {
											out.print(LabelManager.getName(labelSet,"lblAttNum1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_2) {
											out.print(LabelManager.getName(labelSet,"lblAttNum2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_3) {
											out.print(LabelManager.getName(labelSet,"lblAttNum3Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_1) {
											out.print(LabelManager.getName(labelSet,"lblAttDte1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_2) {
											out.print(LabelManager.getName(labelSet,"lblAttDte2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_3) {
											out.print(LabelManager.getName(labelSet,"lblAttDte3Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_1) {
											out.print(LabelManager.getName(labelSet,"lblAtt1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_2) {
											out.print(LabelManager.getName(labelSet,"lblAtt2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_3) {
											out.print(LabelManager.getName(labelSet,"lblAtt3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_4) {
											out.print(LabelManager.getName(labelSet,"lblAtt4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_5) {
											out.print(LabelManager.getName(labelSet,"lblAtt5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_6) {
											out.print(LabelManager.getName(labelSet,"lblAtt6EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_7) {
											out.print(LabelManager.getName(labelSet,"lblAtt7EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_8) {
											out.print(LabelManager.getName(labelSet,"lblAtt8EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_9) {
											out.print(LabelManager.getName(labelSet,"lblAtt9EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_10) {
											out.print(LabelManager.getName(labelSet,"lblAtt10EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_1) {
											out.print(LabelManager.getName(labelSet,"lblAttNum1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_2) {
											out.print(LabelManager.getName(labelSet,"lblAttNum2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_3) {
											out.print(LabelManager.getName(labelSet,"lblAttNum3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_4) {
											out.print(LabelManager.getName(labelSet,"lblAttNum4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_5) {
											out.print(LabelManager.getName(labelSet,"lblAttNum5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_6) {
											out.print(LabelManager.getName(labelSet,"lblAttNum6EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_7) {
											out.print(LabelManager.getName(labelSet,"lblAttNum7EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_8) {
											out.print(LabelManager.getName(labelSet,"lblAttNum8EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_1) {
											out.print(LabelManager.getName(labelSet,"lblAttDte1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_2) {
											out.print(LabelManager.getName(labelSet,"lblAttDte2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_3) {
											out.print(LabelManager.getName(labelSet,"lblAttDte3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_4) {
											out.print(LabelManager.getName(labelSet,"lblAttDte4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_5) {
											out.print(LabelManager.getName(labelSet,"lblAttDte5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_6) {
											out.print(LabelManager.getName(labelSet,"lblAttDte6EntNeg"));
										} %></td><td style="width:70px"><input type='hidden' name='hidRel'     value='<%=aux.getRelationOp()%>'	><%=aux.getRelationOp()%></td><td style="width:90px"><input type='hidden' name='hidValue'   value='<%=aux.getValue()%>'		><%if(aux.getColumn()==ListTaskBean.COL_TASK_TITLE) {
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%><input type='hidden' name='hidTaskTransValue'   value='<%=aux.getValue() + "·" + lBeanInproc.getTaskTranslatedTitle(aux.getValue())%>'><%out.print(lBeanInproc.getTaskTranslatedTitle(aux.getValue()));
										}else{%><input type='hidden' name='hidTaskTransValue'   value='<%=aux.getValue() + "·" + lBeanReady.getTaskTranslatedTitle(aux.getValue())%>'><%out.print(lBeanReady.getTaskTranslatedTitle(aux.getValue()));
										}
									}else if(aux.getColumn()==ListTaskBean.COL_PROC_TITLE) {
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%><input type='hidden' name='hidProcTransValue'   value='<%=aux.getValue() + "·" + lBeanInproc.getTaskTranslatedTitle(aux.getValue())%>'><%out.print(lBeanInproc.getProcTranslatedTitle(aux.getValue()));
										}else{%><input type='hidden' name='hidProcTransValue'   value='<%=aux.getValue() + "·" + lBeanReady.getTaskTranslatedTitle(aux.getValue())%>'><%out.print(lBeanReady.getProcTranslatedTitle(aux.getValue()));
										}
									}else{
										out.print(aux.getValue());
									}%></td></tr><%
								i++;
							}
						}
						%></tbody></table></div></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeApl")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeApl")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeApl")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var WORK_MODE 		= "<%=WORK_MODE%>";
var TASK_TITLE      = "<%=ListTaskBean.COL_TASK_TITLE%>";
var PROCESS_TITLE   = "<%=ListTaskBean.COL_PROC_TITLE%>";
var MISSING_VALUE 	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgEjeDebIngVal"))%>";
var MISSING_OP_LOG 	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgEjeDebIngOpLog"))%>";
var CANT_USE_OP_LOG	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgEjeNoPueOpLogPri"))%>";
var NUMBER_EXPECTED = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgEjeNumEsperado"))%>";
var COL_PROC_NUM = "<%=LabelManager.getName(labelSet,"lblEjeInsProNum")%>";
var COL_ENT_NUM = "<%=LabelManager.getName(labelSet,"lblEjeInsEntNum")%>";

window.onload= function(){
	document.getElementById("cmbColNames").onchange();
}
</script><script src="<%=Parameters.ROOT_PATH%>/programs/execution/tasksList/filterModal.js"></script>
