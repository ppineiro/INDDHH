<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><jsp:useBean id="lBeanReady" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><jsp:useBean id="lBeanInproc" scope="session" class="com.dogma.bean.execution.ListTaskBean"></jsp:useBean><%

String WORK_MODE = request.getParameter("listType");

	if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
		lBeanInproc.setCookieColumn(response,request);
		lBeanInproc.setCookieFilter(response,request);
	} else {
		lBeanReady.setCookieColumn(response,request);
		lBeanReady.setCookieFilter(response,request);
	} 
%><%!	public String getValue(String value){
		if(value.equals("")){
			return (String)("<p></p>");
		}
		return value;
	}
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><HTML><head><%@include file="../../../components/scripts/server/startInc.jsp" %><%@include file="../../../components/scripts/server/headInclude.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/execution/tasksList/clientList.js" defer="true"></script></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%><%=LabelManager.getName(labelSet,"titEjeMisTar")%><%}else{%><%=LabelManager.getName(labelSet,"titEjeTarLib")%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" name="divContent" <%=tl_div_height%> class="divContent" style="overflow:hidden;"><FORM id="frmMain" name="frmMain" method="POST"><table class="tblFilter"><tr><td vAlign="top"><%=LabelManager.getName(labelSet,"lblEjeFilApl")%>:
						
						<%
						TasksListFilterVo filter = null;
						if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
							filter = lBeanInproc.getFilter();
						}else{	
							filter = lBeanReady.getFilter();
						}
						if (filter==null || filter.getConditions()==null || filter.getConditions().size()==0){
							out.print(LabelManager.getName(labelSet,"lblEjeNin"));
						} else {
							Collection colFilter = filter.getConditions();
							if (colFilter!=null) {
								Iterator itFilt = colFilter.iterator();
								int j = 0;
								while(itFilt.hasNext()){
									TasksListFilterVo.Filter aux = (TasksListFilterVo.Filter)itFilt.next();
									out.print(aux.getLogicOp() + " ");
										if(aux.getColumn()==ListTaskBean.COL_PRIORIDAD ){
											out.print(LabelManager.getName(labelSet,"lblEjePriPro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_TASK_TITLE ){
											out.print(LabelManager.getName(labelSet,"lblTskTit"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_PRE){
											out.print(LabelManager.getName(labelSet,"lblEjeInsProPre"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_NUM){
											out.print(LabelManager.getName(labelSet,"lblEjeInsProNum"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_ID_POS){
											out.print(LabelManager.getName(labelSet,"lblEjeInsProPos"));
										}
										if(aux.getColumn()==ListTaskBean.COL_TASK_GROUP){
											out.print(LabelManager.getName(labelSet,"lblEjeGruTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_TITLE){
											out.print(LabelManager.getName(labelSet,"lblProTit"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_TYPE){
											out.print(LabelManager.getName(labelSet,"lblEjeTipProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_TASK_DATE){
											out.print(LabelManager.getName(labelSet,"lblEjeFecCreTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_DATE){
											out.print(LabelManager.getName(labelSet,"lblEjeFecCreProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_PRE){
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntPre"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_NUM){
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntNum"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_ID_POS){
											out.print(LabelManager.getName(labelSet,"lblEjeInsEntPos"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PROC_USER){
											out.print(LabelManager.getName(labelSet,"lblEjeUsuCreProTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_STATUS){
											out.print(LabelManager.getName(labelSet,"lblEjeStaEntTar"));
										}
										if(aux.getColumn()==ListTaskBean.COL_USER_LOGIN){
											out.print(LabelManager.getName(labelSet,"lblEjeUseAdq"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_1){
											out.print(LabelManager.getName(labelSet,"lblAtt1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_2){
											out.print(LabelManager.getName(labelSet,"lblAtt2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_3){
											out.print(LabelManager.getName(labelSet,"lblAtt3Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_4){
											out.print(LabelManager.getName(labelSet,"lblAtt4Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_5){
											out.print(LabelManager.getName(labelSet,"lblAtt5Pro"));
										}
	
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_1){
											out.print(LabelManager.getName(labelSet,"lblAttNum1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_2){
											out.print(LabelManager.getName(labelSet,"lblAttNum2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_NUM_3){
											out.print(LabelManager.getName(labelSet,"lblAttNum3Pro"));
										}
	
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_1){
											out.print(LabelManager.getName(labelSet,"lblAttDte1Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_2){
											out.print(LabelManager.getName(labelSet,"lblAttDte2Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_PRO_INST_ATT_DTE_3){
											out.print(LabelManager.getName(labelSet,"lblAttDte3Pro"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_1){
											out.print(LabelManager.getName(labelSet,"lblAtt1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_2){
											out.print(LabelManager.getName(labelSet,"lblAtt2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_3){
											out.print(LabelManager.getName(labelSet,"lblAtt3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_4){
											out.print(LabelManager.getName(labelSet,"lblAtt4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_5){
											out.print(LabelManager.getName(labelSet,"lblAtt5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_6){
											out.print(LabelManager.getName(labelSet,"lblAtt6EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_7){
											out.print(LabelManager.getName(labelSet,"lblAtt7EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_8){
											out.print(LabelManager.getName(labelSet,"lblAtt8EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_9){
											out.print(LabelManager.getName(labelSet,"lblAtt9EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_10){
											out.print(LabelManager.getName(labelSet,"lblAtt10EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_1){
											out.print(LabelManager.getName(labelSet,"lblAttNum1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_2){
											out.print(LabelManager.getName(labelSet,"lblAttNum2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_3){
											out.print(LabelManager.getName(labelSet,"lblAttNum3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_4){
											out.print(LabelManager.getName(labelSet,"lblAttNum4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_5){
											out.print(LabelManager.getName(labelSet,"lblAttNum5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_6){
											out.print(LabelManager.getName(labelSet,"lblAttNum6EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_7){
											out.print(LabelManager.getName(labelSet,"lblAttNum7EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_NUM_8){
											out.print(LabelManager.getName(labelSet,"lblAttNum8EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_1){
											out.print(LabelManager.getName(labelSet,"lblAttNum1EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_2){
											out.print(LabelManager.getName(labelSet,"lblAttNum2EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_3){
											out.print(LabelManager.getName(labelSet,"lblAttNum3EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_4){
											out.print(LabelManager.getName(labelSet,"lblAttNum4EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_5){
											out.print(LabelManager.getName(labelSet,"lblAttNum5EntNeg"));
										}
										if(aux.getColumn()==ListTaskBean.COL_ENT_INST_ATT_DTE_6){
											out.print(LabelManager.getName(labelSet,"lblAttNum6EntNeg"));
										}
									out.print(" " + aux.getRelationOp() + " ");
									if(aux.getColumn()==ListTaskBean.COL_TASK_TITLE ){
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
											out.print(lBeanInproc.getTaskTranslatedTitle(aux.getValue()) + " ");
										}else{	
											out.print(lBeanReady.getTaskTranslatedTitle(aux.getValue()) + " ");
										}										
									}else if(aux.getColumn()==ListTaskBean.COL_PROC_TITLE){
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
											out.print(lBeanInproc.getProcTranslatedTitle(aux.getValue()) + " ");
										}else{	
											out.print(lBeanReady.getProcTranslatedTitle(aux.getValue()) + " ");
										}	
										
									}else{
										out.print(aux.getValue() + " ");
									}
									out.print("  <A href='#nowhere' onclick='removeFilter(" + j + ")'>(x)</A> ");
									j++;
								}
							}
							
							if (filter!=null && filter.getConditions()!=null && filter.getConditions().size()>0){
								out.print(" &nbsp; <A href='#nowhere' onclick='removeAllFilters()'>"+LabelManager.getName(labelSet,"btnDeleteAll")+"</A>");
							}
						}
						
						
						
						%></td></tr></table><br><div class="tableContainerNoHScroll" style="height: <%=Parameters.SCREEN_LIST_SIZE%>px;" type="grid" fastGrid="true" id="gridList" height="290"><table id="tblHead" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="display:none;width:0px"></th><%
											TaskListColumnsVo columns = null;
											if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)) {
												columns = lBeanInproc.getColumns();
											} else {
												columns = lBeanReady.getColumns();
											}
											
											Iterator iterator = columns.iterator();
											while (iterator.hasNext()) {
												ColumnVo columna = (ColumnVo) iterator.next(); 
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow()) {%><th min_width="30px" class="sortable" colId="<%=ListTaskBean.COL_PRIORIDAD%>" style="width:30px;cursor:pointer;cursor:hand;"  title="<%=LabelManager.getToolTip(labelSet,"lblEjePriPro")%>" onclick="orderBy('<%=ListTaskBean.ORDER_PRIORIDAD%>')">&nbsp;</th><%}
												
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow()) {%><th min_width="30px" class="sortable" style="width:30px;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaPro")%>">&nbsp;</th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow()) {%><th min_width="30px" class="sortable" style="width:30px;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaTsk")%>">&nbsp;</th><%}
												
												if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow()) {%><th min_width="250px" class="sortable" colId="<%=ListTaskBean.COL_TASK_TITLE%>" style="cursor:pointer;cursor:hand;width:250px;"  title="<%=LabelManager.getToolTip(labelSet,"lblEjeNomTar")%>" onclick="orderBy('<%=ListTaskBean.ORDER_TASK_TITLE%>')"><u><%=LabelManager.getName(labelSet,"lblTskTit")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) {%><th min_width="150px" class="sortable" colId="<%=ListTaskBean.COL_ENT_ID_NUM%>" style="cursor:pointer;cursor:hand;width:150px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_ID_NUM%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeInsEntNum")%>"><u><%=LabelManager.getName(labelSet,"lblEjeInsEntNum")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) {%><th min_width="150px" class="sortable" colId="<%=ListTaskBean.COL_PROC_ID_NUM%>" style="cursor:pointer;cursor:hand;width:150px;" onclick="orderBy('<%=ListTaskBean.ORDER_PROC_ID_NUM%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeInsProNum")%>"><u><%=LabelManager.getName(labelSet,"lblEjeInsProNum")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) {%><th min_width="150px" class="sortable" colId="<%=ListTaskBean.COL_TASK_GROUP%>" style="cursor:pointer;cursor:hand;width:150px;" onclick="orderBy('<%=ListTaskBean.ORDER_TASK_GROUP%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeGruTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeGruTar")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) {%><th min_width="250px" class="sortable" colId="<%=ListTaskBean.COL_PROC_TITLE%>" style="cursor:pointer;cursor:hand;width:250px;" onclick="orderBy('<%=ListTaskBean.ORDER_PROC_TITLE%>')" title="<%=LabelManager.getToolTip(labelSet,"lblProTit")%>"><u><%=LabelManager.getName(labelSet,"lblProTit")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) {%><th min_width="110px" class="sortable" colId="<%=ListTaskBean.COL_PROC_TYPE%>" style="cursor:pointer;cursor:hand;width:110px;" onclick="orderBy('<%=ListTaskBean.ORDER_PROC_TYPE%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeTipProTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeTipProTar")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_TASK_DATE%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_TASK_DATE%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeFecCreTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeFecCreTar")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PROC_DATE%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PROC_DATE%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeFecCreProTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeFecCreProTar")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PROC_USER%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PROC_USER%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeUsuCreProTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeUsuCreProTar")%></u><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_STATUS%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_STATUS%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaEntTar")%>"><u><%=LabelManager.getName(labelSet,"lblEjeStaEntTar")%></u><span></span></th><%}
												if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
													if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow()) { %><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_USER_LOGIN%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_USER_LOGIN%>')" title="<%=LabelManager.getToolTip(labelSet,"lblEjeUseAdq")%>"><u><%=LabelManager.getName(labelSet,"lblEjeUseAdq")%></u><span></span></th><%}
												}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt1Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt1Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt2Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt2Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt3Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt3Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_4%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_4%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt4Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt4Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_5%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_5%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt5Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt5Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_NUM_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum1Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum1Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_NUM_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum2Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum2Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_NUM_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_NUM_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum3Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum3Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_DTE_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte1Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte1Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_DTE_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte2Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte2Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_PRO_INST_ATT_DTE_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_PRO_INST_ATT_DTE_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte3Pro")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte3Pro")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt1EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt1EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt2EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt2EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt3EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt3EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_4%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_4%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt4EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt4EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_5%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_5%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt5EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt5EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_6%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_6%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt6EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt6EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_7%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_7%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt7EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt7EntNeg")%></a><span></span></th><%}																								
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_8%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_8%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt8EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt8EntNeg")%></a><span></span></th><%}																								
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_9%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_9%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt9EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt9EntNeg")%></a><span></span></th><%}																								
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_10%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_10%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAtt10EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAtt10EntNeg")%></a><span></span></th><%}																								
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum1EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum1EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum2EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum2EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum3EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum3EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_4%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_4%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum4EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum4EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_5%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_5%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum5EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum5EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_6%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_6%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum6EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum6EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_7%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_7%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum7EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum7EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_NUM_8%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_NUM_8%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttNum8EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttNum8EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_1%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_1%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte1EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte1EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_2%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_2%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte2EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte2EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_3%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_3%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte3EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte3EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_4%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_4%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte4EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte4EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_5%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_5%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte5EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte5EntNeg")%></a><span></span></th><%}
												if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {%><th min_width="130px" class="sortable" colId="<%=ListTaskBean.COL_ENT_INST_ATT_DTE_6%>" style="cursor:pointer;cursor:hand;width:130px;" onclick="orderBy('<%=ListTaskBean.ORDER_ENT_INST_ATT_DTE_6%>')" title="<%=LabelManager.getToolTip(labelSet,"lblAttDte6EntNeg")%>"><a href="#"><%=LabelManager.getName(labelSet,"lblAttDte6EntNeg")%></a><span></span></th><%}
												
											}%></tr></thead><tbody><%Collection col = null;
										if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
											col = lBeanInproc.getList();
										} else {
											col = lBeanReady.getList();
										}
										if (col != null) {
											Iterator it = col.iterator();
											int i = 0;
											TasksListVo aVO = null;
											while (it.hasNext()) {
												aVO = (TasksListVo) it.next();
												TranslationManager.setTaskListsVoTranslation(aVO, uData.getEnvironmentId(), uData.getLangId());
												iterator = columns.iterator(); %><tr <%if(Parameters.DBLCLICK_TASK_LISTS){%> ondblclick="btnTra_click()" <%} %>  task_id="<%=lBeanReady.fmtStr(aVO.getQueryString())%>" id=LIST <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"x_disabled=\"true\"":""%>><td style="display:none;width:0px"><input type="hidden"></td><%
													while (iterator.hasNext()) {
														ColumnVo columna = (ColumnVo) iterator.next();
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRIORIDAD ) && columna.isShow()) {%><td filter='false' style="width:30px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><img style="position:static;" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/priority<%= aVO.getPriority().intValue() %>.gif"></td><%
														}
			
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_STATUS ) && columna.isShow()) {%><td filter='false' style="width:30px;" align="center" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%String image=( (aVO.getProImage()==null  )?"procicon.png":aVO.getProImage()  );%><img style="width:20px;height:20px;position:static;" src="administration.ImagesAction.do?action=addFooter&image=<%=image%>&footer=proStatus<%= aVO.getProStatus() %>.gif"></td><%
														}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_STATUS ) && columna.isShow()) {%><td  filter='false' style="width:30px;" align="center" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%String image=( (aVO.getTskImage()==null  )?"taskicon.png":aVO.getTskImage()  );%><img style="width:20px;height:20px;position:static;" src="administration.ImagesAction.do?action=addFooter&image=<%=image%>&footer=tskStatus<%= aVO.getTskStatus() %>.gif"></td><%
														}
														
														if(columna.getNombre().equals(TaskListColumnsVo.COL_TSK_TITLE ) && columna.isShow()) {%><td style=";width:250px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(aVO.getTaskTitle()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_ENTIDAD) && columna.isShow()) {%><td style=";width:150px;"  <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(BusEntInstanceVo.getEntityIdentification(aVO.getEntInstIdPre(),aVO.getEntInstIdNum(),aVO.getEntInstIdPos())))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_NUMERO_PROCESO) && columna.isShow()) {%><td style=";width:150px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(ProInstanceVo.getEntityIdentification(aVO.getProcInstIdPre(),aVO.getProcInstIdNum(),aVO.getProcInstIdPos())))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_GRUPO) && columna.isShow()) {%><td style=";width:150px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(aVO.getGroupName()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_TITLE) && columna.isShow()) {%><td style=";width:250px;"  <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(aVO.getProcessTitle()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_TIPO_PROCESO) && columna.isShow()) {%><td style=";width:110px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%if(ProcessVo.PROCESS_ACTION_CREATION.equals(aVO.getProcessType())){%><%=getValue(LabelManager.getName(labelSet,"lblEjeActCre"))%><%}%><%if(ProcessVo.PROCESS_ACTION_ALTERATION.equals(aVO.getProcessType())){%><%=getValue(LabelManager.getName(labelSet,"lblEjeActAlt"))%><%}%><%if(ProcessVo.PROCESS_ACTION_CANCEL.equals(aVO.getProcessType())){%><%=getValue(LabelManager.getName(labelSet,"lblEjeActCan"))%><%}%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_TAREA) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtDateAMPM(aVO.getTaskCreationDate()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_CREACION_PROCESO) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtDateAMPM(aVO.getProcCreationDate()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_CREADOR_PROCESO) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(aVO.getProcCreateUser()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_STATUS) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(TranslationManager.getStatusTitle(aVO.getEntStatus(),uData.getEnvironmentId(), uData.getLangId())))%></td><%}
														if (WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !Parameters.SHOW_MY_TASKS){
															if(columna.getNombre().equals(TaskListColumnsVo.COL_USER_LOGIN) && columna.isShow()) {%><td style=";width:130px;" colId="<%=Parameters.SHOW_MY_TASKS%>" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%>><%=getValue(lBeanReady.fmtStr(aVO.getUserLogin()))%></td><%}
														}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabel1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabel1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_2) && columna.isShow()) {%><td style=";width:130px;"  <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabel2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabel2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabel3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabel3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_4) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabel4() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabel4())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt4Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_5) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabel5() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabel5())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt5Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelNum1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelNum1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_2) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelNum2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelNum2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_NUM_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelNum3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelNum3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelDte1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelDte1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt1ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_2) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelDte2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelDte2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt2ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_PRO_INST_ATT_DTE_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getProAttLabelDte3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getProAttLabelDte3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getProInstAtt3ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_2) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_4) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel4() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel4())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_5) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel5() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel5())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_6) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel6() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel6())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_7) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel7() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel7())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_8) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel8() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel8())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_9) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel9() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel9())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt9Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_10) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabel10() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabel10())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt10Value()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_2) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_4) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum4() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum4())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_5) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum5() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum5())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_6) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum6() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum6())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_7) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum7() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum7())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt7ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_NUM_8) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelNum8() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelNum8())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt8ValueNum()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_1) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte1() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte1())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt1ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_2) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte2() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte2())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt2ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_3) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte3() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte3())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt3ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_4) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte4() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte4())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt4ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_5) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte5() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte5())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt5ValueDte()))%></td><%}
														if(columna.getNombre().equals(TaskListColumnsVo.COL_ENT_INST_ATT_DTE_6) && columna.isShow()) {%><td style=";width:130px;" <%=(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS) && !aVO.getUserLogin().equals(aVO.getUsersPool()))?"class=\"tdDisable\"":""%><%=(aVO.getEntAttLabelDte6() != null)?("title=\""+lBeanReady.fmtHTMLObject(aVO.getEntAttLabelDte6())+"\""):""%>><%=getValue(lBeanReady.fmtHTMLObject(aVO.getEntInstAtt6ValueDte()))%></td><%}
													}%></tr><%
												i++;
											}
										}
										%></tbody></table></div><table class="navBar"><COL><COL class="colM"><COL><tr><td align=left><button type="button" type="button" onclick="btnExp_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><button type="button" type="button" onclick="btnFil_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeFil")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeFil")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeFil")%></button><button type="button" type="button" onclick="btnCol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeCol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeCol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeCol")%></button><button type="button" type="button" onclick="refresh()" id="btnRefresh" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRef")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRef")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRef")%></button></td><%@include file="../../includes/navButtonsTaskList.jsp" %><td align=right><%if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%><button type="button" type="button" onclick="btnLib_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeLib")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeLib")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeLib")%></button><%} else {%><button type="button" type="button" onclick="btnCap_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeCap")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeCap")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeCap")%></button><%}%><button type="button" type="button" onclick="btnTra_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeTra")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeTra")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeTra")%></button></td></tr></table><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" type="button" type="button" onclick="splash_iframe()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><div id=contextMenu onclick="clickMenu()"  onmouseover="switchMenu()"  onmouseout="switchMenu()"  style="position:absolute;  display:none; width:80;  background-Color:menu;  border: 2px outset; "><div class="menuItem" id=mnuFiltrar>Filtrar</div><hr><div class="menuItem" id=mnuColBestFit>Col Best Fit</div><div class="menuItem" id=mnuTblBestFit>Tbl Best Fit</div></div></body></html><script><%if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%>
	var WORK_MODE = "<%=ListTaskBean.WORKING_MODE_INPROCESS%>";
<%} else {%>
	var WORK_MODE = "<%=ListTaskBean.WORKING_MODE_READY%>";
<%}%>	
	var DIRTY_FLAG_MY = window.parent.document.getElementById("dirtyMyTasks");
	var DIRTY_FLAG_FREE = window.parent.document.getElementById("dirtyFreeTasks");

function setDirtyMode() {
	<%if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){%>
		DIRTY_FLAG_FREE.value = "true";
	<%} else {%>
		DIRTY_FLAG_MY.value = "true";
	<%}%>
}

function setDirtyBoth() {
	DIRTY_FLAG_MY.value = "true";
	DIRTY_FLAG_FREE.value = "true";
}

var ONLY_ONE_SELECTED = "<%=LabelManager.getName(labelSet,"msgSolUnaSel")%>";
</script><%@include file="../../../components/scripts/server/endIncTasksList.jsp" %><script>

	function removeFilter(index) {
		document.getElementById("frmMain").action = "execution.TasksListAction.do?action=removeFilter&workMode=" + WORK_MODE + "&filterId=" + index;
		submitForm(document.getElementById("frmMain"));
	}
	
	function removeAllFilters(){
		document.getElementById("frmMain").action = "execution.TasksListAction.do?action=removeAllFilters&workMode=" + WORK_MODE;
		submitForm(document.getElementById("frmMain"));
	}
	
	var theDif=55;

	function filter(row) {
		if(row.tagName=="SPAN"){
			row=row.parentNode;
		}
		
		var colId=0;
		
		var tr=row.parentNode;
		
		for(var i=0;i<tr.getElementsByTagName("td").length;i++){
			if(tr.getElementsByTagName("td")[i]==row){
				colId=row.parentNode.parentNode.parentNode.rows[0].getElementsByTagName("th")[i].getAttribute("colId")
			}
		}
		
		var filterValue= row.getElementsByTagName("SPAN")[0]?row.getElementsByTagName("SPAN")[0].innerHTML:row.innerHTML;
		if(filterValue.charAt[0]==" "){filterValue=filterValue.substring(1);}
		if(filterValue.charAt[filterValue.length-1]==" "){filterValue=filterValue.substring(filterValue.length);}
		
		
		
		document.getElementById("frmMain").action = "execution.TasksListAction.do?action=filterAuto&workMode=" + WORK_MODE + "&filterId=" + colId +"&filterValue="+filterValue;
		submitForm(document.getElementById("frmMain"));
	}

	/*function mnuOrdenar() {
		orderBy(contextMenuSrcElement.parentNode.parentNode.parentNode.children(0).rows(0).cells(contextMenuSrcElement.cellIndex).colId);
	}

	function mnuColBestFit() {
		row = contextMenuSrcElement.parentNode.parentNode.parentNode.parentNode.previousSibling.children(0).children(0).children(0);
		row.cells(contextMenuSrcElement.cellIndex).bestFit();
	}

	function mnuTblBestFit() {
		grid = contextMenuSrcElement.parentNode.parentNode.parentNode.parentNode;
		grid.bestFit();
	}
	
	function switchMenu() {     
		el=event.srcElement;  
		if (el.className=="menuItem") {    
			el.className="highlightItem";  
		} else if (el.className=="highlightItem") {    
			el.className="menuItem";  
		}
	}
	
	function closeMenu() {
		contextMenu.releaseCapture();  
		contextMenu.style.display="none";  
	}	
	
	function sizeContainerIFrame(){
		window.parent.sizeIFrames();
	}
	document.attachEvent("oncontextmenu", closeMenu);*/
	/*
	function init(){
		sizeMe();
		var tmp=this;
		window.onresize=function(e){
			if(navigator.userAgent.indexOf("MSIE")>0){
				e=window.event;
			}
			e.cancelBubble=true;
			tmp.sizeMe();
		}
	}
	function sizeMe(){
		var width=(document.body.offsetWidth-10);
		var dif=55;
		if(navigator.userAgent.indexOf("MSIE")>0){
			width=(document.body.offsetWidth)-15;
		}
///		document.getElementById("taskGrid").style.width=width+"px";
		var divs=document.getElementById("taskGrid").getElementsByTagName("div");
		for(var i=0;i<divs.length;i++){
			if(width>0){
				divs[i].style.width=width+"px";
			}
		}
		var height=window.innerHeight;
		if(navigator.userAgent.indexOf("MSIE")>0){
			window.event.cancelBubble = true;
			height=document.body.parentNode.clientHeight;
		}
		
		if(height>0){
			document.getElementById("taskGrid").parentNode.parentNode.parentNode.parentNode.style.height=(height)+"px";
			document.getElementById("divContent").style.height=(height-dif)+"px";
		}
		document.getElementById("taskGrid").style.display="none";
		document.getElementById("taskGrid").style.display="block";
		/*var tables=document.getElementsByTagName("TABLE");
		for(var i=0;i<tables.length;i++){
			if(tables[i].className=="navBar"){
				tables[i].style.width=(width-10)+"px";
			}
		}*/
//	}

var lblEjeFilter = "<%=LabelManager.getName(labelSet,"lblEjeFilter")%>";

document.getElementById("gridList").gridMenu=function(callerGrid,doc,tempX,tempY,aEvent){
	var div=document.createElement("div");
	div.id="contextMenuContainer";
	div.innerHTML='<table id="contextMenu" width="115" border="0px" cellpadding="0"><tr><td width="100" style="padding-left:20px;">'+lblEjeFilter+'</td></tr><tr><td style="padding-left:20px;">'+GRID_SELECTALL+'</td></tr><tr><td style="padding-left:20px;">'+GRID_SELECTNONE+'</td></tr></table>';
	div.style.position="absolute";
	div.style.width="115px";
	div.style.zIndex="9999999";
	//setOuterBlurEmulation(document);
	document.onmousedown=function(e){
		if(navigator.userAgent.indexOf("MSIE")>0){
			e=window.event;
		}
		//unSetOuterBlurEmulation();
		setTimeout(hideMenu,200);
		e.cancelBubble = true;
		document.oncontextmenu=[];
	}
	//div.style.height="300px";
	div.style.border="1px solid black";
	div.style.left=tempX+"px";
	div.style.top=tempY+"px";
	document.body.appendChild(div);
	var tds=div.getElementsByTagName("TD");
	var table=doc;
	if(table.tagName=="DIV"){
		table=doc.getElementsByTagName("TABLE");
		table=table[0];
	}else{
		while(table.tagName!="TABLE"){
			table=table.parentNode;
		}
	}
	if(doc.tagName=="TD" || doc.parentNode.tagName=="TD" || doc.parentNode.tagName=="SPAN"){
		var myTD = null;
		if(doc.tagName=="TD"){
			myTD = doc; 
		} else if (doc.parentNode.tagName=="TD") {
			myTD = doc.parentNode;
		} else {
			myTD = doc.parentNode.parentNode;
		}
		if(myTD.getAttribute("filter")!=null){
			tds[0].style.color="#BEBEBE";	
		} else {
			tds[0].onclick=function(){
				filter(doc);
				//alert(doc);
			}
		}	
	}else{
		tds[0].style.color="#BEBEBE";
	}
	tds[1].onclick=function(){
		//select All
		callerGrid.selectAll();
	}
	tds[2].onclick=function(){
		//unselect All
		callerGrid.unselectAll();
	}
	/*tds[3].onclick=function(){
		sizeCols();
		//alert(doc);
	}*/
	if(window.navigator.appVersion.indexOf("MSIE")>=0){
		for(var i=0;i<tds.length;i++){
			element=aEvent.srcElement;
			tds[i].onmouseover=function(){
				element=window.event.srcElement;
				element.parentNode.className="hoverEmulate";
			}
			tds[i].onmouseout=function(){
				element=window.event.srcElement;
				element.parentNode.className="";
			}
		}
	}
}



</script>
