<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.bean.query.TaskListBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><%@page import="com.st.util.translator.TranslationManager"%><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body onload="doLoad();"><jsp:useBean id="qBeanReady" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><jsp:useBean id="qBeanInproc" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><%
String WORK_MODE = request.getParameter("listType");
com.dogma.bean.query.TaskListBean dBean = null;
boolean inProcessMode = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS);

if (inProcessMode) {
	dBean = qBeanInproc;
} else {
	dBean = qBeanReady;
}

dBean.setCookieFilter(response,request);
	
QueryVo queryVo = dBean.getQueryVo();
dBean.setCookieColumns(response);

int posProInstId = -1;
int posProEleInstId = -1;
int posWorkMode = -1;
int posUsrLogin = -1;
int posUsersPool = -1;
int posProAction = -1;
int posProTitle = -1;
int posTskTitle = -1;
int posProName = -1;
int posTskName = -1;
int posEnvId = -1;
int posNotShow = -1;
int posPriority = -1;
int posProInstWarnDate = -1;
int posProInstOverDate = -1;
int posProEleInstWarnDate = -1;
int posProEleInstOverDate = -1;
boolean[] showTime = null;
boolean[] showPosition = null;
boolean[] isHTML = null;
int[] mustShowColumns = null;
boolean showColumnsButton = false;
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%if(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)){%><%=dBean.getQueryVo().getQryTitle() + " : " + LabelManager.getName(labelSet,"titEjeMisTar")%><%}else{%><%=dBean.getQueryVo().getQryTitle() + " : " + LabelManager.getName(labelSet,"titEjeTarLib")%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" name="divContent" <%=tl_div_height%> class="divContent"><FORM id="frmMain" name="frmMain" method="POST"><table class="tblFilter"><tr><td vAlign="top"><%=LabelManager.getName(labelSet,"lblEjeFilApl")%>:<%
						Collection filterColumns = queryVo.getFilters();
						Iterator iterator = filterColumns.iterator();
						boolean addAnd = false;
						int j = 0;
 						while (iterator.hasNext()) {
 							QryColumnFilterVo filter = (QryColumnFilterVo) iterator.next();
 							if ( QryColumnVo.FUNCTION_NONE == filter.getFunction() && (! filter.isHidden()) && filter.getValue() != null && ! filter.getValue().equals("")) { 
 								if (addAnd) {
 									out.print(" AND ");
	 							} %><%=dBean.fmtHTML(filter.getQryColumnVo().getQryColHeadName()) %>: 
 								<%=dBean.fmtStr(filter.getText(labelSet))%><%out.print("<A href='#nowhere' onclick='removeFilter(\"" + filter.getFilterId() + "\")'>(x)</A>");
 								j++;
								addAnd = true;
 							}
 							
	 					} 
 						if (! addAnd) { %><%=LabelManager.getName(labelSet,"lblEjeNin")%><%
	 					} else {
	 						out.print(" &nbsp; <A href='#nowhere' onclick='removeAllFilters()'>"+LabelManager.getName(labelSet,"btnDeleteAll")+"</A>");
	 					}
	 						%></td></tr></table><br><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px" ><table class="tblDataGrid" cellspacing="0" cellpadding="0"><thead><tr><%
								Iterator columnas;
 		 						Iterator iteratorFilas = null;
 		 						HashSet headers = new HashSet();
 		 						
 		 						if (queryVo.getData() != null) {
 		 							iteratorFilas = queryVo.getData().iterator();
 		 						}
 		 						
 								ArrayList showColumns = queryVo.getAllShowColumns();
 								if (queryVo.getShowColumns().size() > 0) {
									int size = 0;
									if (queryVo.getHasIncrement() && (queryVo.getData() != null)) {
										size = ((QryRowShowVo)((ArrayList)queryVo.getData()).get(0)).getColumnas().size();
									} else {
										size = showColumns.size();
									}
									showPosition = new boolean[size];
									showTime = new boolean[size];
									isHTML = new boolean[size];
									showColumnsButton = true;
									mustShowColumns = dBean.getMustShowColumns(size);
									QryColumnVo columna = null;
									String colName = null;
									boolean canOrder = false;
									boolean colProStatus;
									boolean colTskStatus;
									boolean isSetPriority = false;
									boolean isSetProStatus = false;
									boolean isSetProStatusOver = false;
									boolean isSetProStatusWarn = false;
									boolean isSetTskStatus = false;
									boolean isSetTskStatusOver = false;
									boolean isSetTskStatusWarn = false;
									int count = 0;
									for (int i = 0; i < mustShowColumns.length; i++) {
										count = i;
										int thePosition = Math.abs(mustShowColumns[i]) - 1;
										
										if (showColumns.size() <= thePosition) {
											count++;
											continue;
										}
										
										QryColumnVo col = (QryColumnVo) showColumns.get(thePosition);
										if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_PRIORITY)) {
											isSetPriority = true;
											if (mustShowColumns[count] >= 0) {
												mustShowColumns[count] *= -1;
											}
										} else if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_INST_WARN_DATE) || col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_INST_OVER_DATE)) {
											isSetProStatus = true;
											if (mustShowColumns[count] >= 0) {
												mustShowColumns[count] *= -1;
											}
											if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_INST_WARN_DATE)) {
												isSetProStatusWarn = true;
											} else if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_INST_OVER_DATE)) {
												isSetProStatusOver = true;
											}
										} else if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_ELE_INST_WARN_DATE) || col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_ELE_INST_OVER_DATE)) {
											isSetTskStatus = true;
											if (mustShowColumns[count] >= 0) {
												mustShowColumns[count] *= -1;
											}
											if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_ELE_INST_WARN_DATE)) {
												isSetTskStatusWarn = true;
											} else if (col.getQryColName().equalsIgnoreCase(QueryColumns.COLUMN_PRO_ELE_INST_OVER_DATE)) {
												isSetTskStatusOver = true;
											}
										}
										count++;
									}
									if (isSetPriority) {%><th class="sortable" align="center" style="width:30px;cursor:pointer;cursor:hand;" title="<%=LabelManager.getToolTip(labelSet,"lblEjePriPro")%>" onclick="orderBy('<%=QueryColumns.COLUMN_PRO_PRIORITY%>')">&nbsp;</th><%
									}
									if (isSetProStatus) {
										if (isSetProStatusOver) { %><th class="sortable" align="center" style="width:30px;cursor:pointer;cursor:hand;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaPro")%>" onclick="orderBy('<%=QueryColumns.COLUMN_PRO_INST_OVER_DATE%>')">&nbsp;</th><%
										} else { %><th class="sortable" align="center" style="width:30px;cursor:pointer;cursor:hand;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaPro")%>" onclick="orderBy('<%=QueryColumns.COLUMN_PRO_INST_WARN_DATE%>')">&nbsp;</th><%
										}
									}
									if (isSetTskStatus) {
										if (isSetTskStatusOver) { %><th class="sortable" align="center" style="width:30px;cursor:pointer;cursor:hand;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaTsk")%>" onclick="orderBy('<%=QueryColumns.COLUMN_PRO_ELE_INST_OVER_DATE%>')">&nbsp;</th><%
										} else { %><th class="sortable" align="center" style="width:30px;cursor:pointer;cursor:hand;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaTsk")%>" onclick="orderBy('<%=QueryColumns.COLUMN_PRO_ELE_INST_WARN_DATE%>')">&nbsp;</th><%
										}
									}
									
									for (int i = 0; i < mustShowColumns.length; i++) {
										int columnPos = Math.abs(mustShowColumns[i]) - 1;
										if (showColumns.size() <= columnPos) {
											continue;
										}
										columna = (QryColumnVo) showColumns.get(columnPos);
										colName = columna.getQryColName().toUpperCase();

										if (columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN) && mustShowColumns[i] >= 0) {
											mustShowColumns[i] *= -1;
										}
										
										if (mustShowColumns[i] >= 0 && !columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) {
											canOrder = (columna.getAttId() == null) && ! columna.getQryColName().equals(dBean.getOrderColumn());  

											if(!columna.isAtt()){%><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px<% if (canOrder) {%>;cursor:hand" onclick="orderBy('<%=columna.getQryColName()%>')<%}%>"><%=canOrder?"<u>":""%><%=dBean.fmtHTML(columna.getQryColHeadName())%><%=canOrder?"<u>":""%></th><%
											}else{%><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px<% if (canOrder) {%>;cursor:hand" onclick="orderBy('<%=columna.getQryColName()%>')<%}%>"><%=canOrder?"<u>":""%><%=dBean.fmtHTML(TranslationManager.getAttTitle(columna.getQryColName(), columna.getQryColHeadName(),uData.getEnvironmentId(), uData.getLangId()))%><%=canOrder?"<u>":""%></th><%
											}

											showPosition[columnPos] = true;
											headers.add(columna.getQryColHeadName().toUpperCase());
										}
										
										if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
											posProInstId = columnPos; 
										} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colName)) {
											posProEleInstId = columnPos;
										} else if (QueryColumns.COLUMN_WORK_MODE.equalsIgnoreCase(colName)) {
											posWorkMode = columnPos;
										} else if (QueryColumns.COLUMN_USERS_POOL.equalsIgnoreCase(colName)) {
											posUsersPool = columnPos;
										} else if (QueryColumns.COLUMN_USR_LOGIN.equalsIgnoreCase(colName)) {
											posUsrLogin = columnPos;
										} else if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colName)) {
											posEnvId = columnPos;
										} else if ("_NOT_SHOW".equalsIgnoreCase(colName)) {
											posNotShow = columnPos;
										}

										if (QueryColumns.COLUMN_PRO_ACTION.equalsIgnoreCase(colName)) {
											posProAction = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_TITLE.equalsIgnoreCase(colName)) {
											posProTitle = columnPos;
										}
										if (QueryColumns.COLUMN_TSK_TITLE.equalsIgnoreCase(colName)) {
											posTskTitle = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_NAME.equalsIgnoreCase(colName)) {
											posProName = columnPos;
										}
										if (QueryColumns.COLUMN_TSK_NAME.equalsIgnoreCase(colName)) {
											posTskName = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_PRIORITY.equalsIgnoreCase(colName)) {
											posPriority = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_INST_WARN_DATE.equalsIgnoreCase(colName)) {
											posProInstWarnDate = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_INST_OVER_DATE.equalsIgnoreCase(colName)) {
											posProInstOverDate = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_ELE_INST_WARN_DATE.equalsIgnoreCase(colName)) {
											posProEleInstWarnDate = columnPos;
										}
										if (QueryColumns.COLUMN_PRO_ELE_INST_OVER_DATE.equalsIgnoreCase(colName)) {
											posProEleInstOverDate = columnPos;
										}

										showTime[columnPos] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
										
										isHTML[columnPos] = columna.getFlagValue(QryColumnVo.FLAG_IS_HTML);
									} 
		 						} else {
									if (iteratorFilas != null && iteratorFilas.hasNext()) {
			 							QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
			 							mustShowColumns = new int[row.getColumnas().size()];
										showTime = new boolean[row.getColumnas().size()];
										isHTML = new boolean[row.getColumnas().size()];
										showPosition = new boolean[row.getColumnas().size()];

										int count = 0;
										columnas = row.getColumnas().iterator();
										
	 									showColumns = row.getColumnas();
										
										while (columnas.hasNext()) {
											mustShowColumns[count] = count + 1;
											String colShow = (String) columnas.next();
											String colName = (colShow!=null)?colShow.toUpperCase():null;
											if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
												posProInstId = count; 
											} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colName)) {
												posProEleInstId = count;
											} else if (QueryColumns.COLUMN_WORK_MODE.equalsIgnoreCase(colName)) {
												posWorkMode = count;
											} else if (QueryColumns.COLUMN_USERS_POOL.equalsIgnoreCase(colName)) {
												posUsersPool = count;
											} else if (QueryColumns.COLUMN_USR_LOGIN.equalsIgnoreCase(colName)) {
												posUsrLogin = count;
											} else if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colName)) {
												posEnvId = count;
											} else if ("_NOT_SHOW".equalsIgnoreCase(colName)) {
												posNotShow = count;
											} else { 
												if (colName != null) { 
													showPosition[count] = true; %><th style="width:150px;"><%=dBean.fmtHTMLObject(colShow)%></th><%
												}
											}
											if (QueryColumns.COLUMN_PRO_ACTION.equalsIgnoreCase(colName)) {
												posProAction = count;
											}
											if (QueryColumns.COLUMN_PRO_TITLE.equalsIgnoreCase(colName)) {
												posProTitle = count;
											}
											if (QueryColumns.COLUMN_TSK_TITLE.equalsIgnoreCase(colName)) {
												posTskTitle = count;
											}
											if (QueryColumns.COLUMN_PRO_NAME.equalsIgnoreCase(colName)) {
												posProName = count;
											}
											if (QueryColumns.COLUMN_TSK_NAME.equalsIgnoreCase(colName)) {
												posTskName = count;
											}
											count ++;
										} 
									}
 								}
 								if (queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES) && (queryVo.getShowColumns().size() > 0)){
									if (queryVo.getData()!=null && ((ArrayList)queryVo.getData()).size() > 0){
										Iterator it = ((QryRowShowVo)((ArrayList)queryVo.getData()).get(0)).getColumnas().iterator();
										int posCol = 0;
										boolean addValue;
										while (it.hasNext()){
											addValue = true;
											Object value = it.next();
											if ((value != null)&&(!headers.contains(((String)value).toUpperCase()))){
												if (posCol < mustShowColumns.length) {
													if (mustShowColumns[posCol] < 0) {
														addValue = false;
													}
												}
												if (addValue) {
													showPosition[posCol] = true; %><th align="center" title="<%= dBean.fmtHTML("") %>" style="width:100px"><%=dBean.fmtHTML(value.toString())%></th><%
													QryColumnVo colValue = new QryColumnVo();
													colValue.setEnvId(queryVo.getEnvId());
													colValue.setQryId(queryVo.getQryId());
													colValue.setQryColName(value.toString().toUpperCase());
													showColumns.add(colValue);
												}
											}
											posCol++;
										}
									}
								}
 								%></tr></thead><tbody id="taskList" ><%
 						if (
 								posProInstId == -1 || 
 								posProEleInstId == -1 || 
 								posWorkMode == -1 || 
 								posUsrLogin == -1 || 
 								posUsersPool == -1 || 
 								posEnvId == -1) { %><tr><td colspan="<%= (mustShowColumns == null) ? 1 : mustShowColumns.length %>"><%= LabelManager.getName(labelSet,"msgQryTskListNorAllCol") %></td></tr><% } else {
								int count = 1;
								String processType = null;
								QryRowShowVo row = null;
								Object obj = null;
								String proName = null;
								String tskName = null;
								boolean setColProStatus = false;
								boolean setColTskStatus = false;
								boolean setColPriority = false;
								if (posPriority != -1) {
									setColPriority = true;
								}
								if (posProInstWarnDate != -1 || posProInstOverDate != -1) {
									setColProStatus = true;
								}
								if (posProEleInstWarnDate != -1 || posProEleInstOverDate != -1) {
									setColTskStatus = true;
								}
				  				while (iteratorFilas != null && iteratorFilas.hasNext()) {
		 	  						row = (QryRowShowVo) iteratorFilas.next();
		 	  						if ((queryVo.getData().size() > 1 && queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) || (!queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES))){
		 	  							if (((queryVo.getShowColumns().size() > 0) && (count != 1) && queryVo.getHasIncrement()) || ((queryVo.getShowColumns().size() > 0) && !queryVo.getHasIncrement()) || (queryVo.getShowColumns().size() == 0)) {
		 	  								boolean sameUser = (posUsrLogin>=0)?row.equalsCols(dBean.getUserId(request),posUsrLogin):false; %><tr <%if(Parameters.DBLCLICK_TASK_LISTS){%> ondblclick="btnTra_click()" <%} %>  task_id="<%= row.getTaskListQueryString(posProInstId, posProEleInstId) %>"  id=LIST><%
			 								columnas = row.getColumnas().iterator();
	
		 									int pos = 0;
	
		 									boolean setHTML = false;
		 									int numPriority = -1;
		 									if (setColPriority) {
		 										Double priority = (Double)row.getColumnas().get(posPriority);
		 										if (priority != null) {
		 											numPriority = priority.intValue();
		 										}
		 									}
		 									int numProStatus = 0;
		 									if (setColProStatus) {
		 										Date proInstOverDate = null;
		 										Date proInstWarnDate = null;
		 										if (posProInstOverDate != -1) {
		 											proInstOverDate = (Date)row.getColumnas().get(posProInstOverDate);
	 											}
	 											if (posProInstWarnDate != -1) {
	 												proInstWarnDate = (Date)row.getColumnas().get(posProInstWarnDate);
	 											}
	 											if (proInstOverDate != null && (new Date().after(proInstOverDate))) {
	 												numProStatus = 2;
	 											} else if (proInstWarnDate != null && (new Date().after(proInstWarnDate))) {
	 												numProStatus = 1;
	 											}
	 										}
		 									int numTskStatus = 0;
		 									if (setColTskStatus) {
		 										Date proEleInstOverDate = null;
		 										Date proEleInstWarnDate = null;
		 										if (posProEleInstOverDate != -1) {
		 											proEleInstOverDate = (Date)row.getColumnas().get(posProEleInstOverDate);
		 										}
	 											if (posProEleInstWarnDate != -1) {
	 												proEleInstWarnDate = (Date)row.getColumnas().get(posProEleInstWarnDate);
	 											}
		 										if (proEleInstOverDate != null && (new Date().after(proEleInstOverDate))) {
	 												numTskStatus = 2;
	 											} else if (proEleInstWarnDate != null && (new Date().after(proEleInstWarnDate))) {
	 												numTskStatus = 1;
	 											}
	 										}
		 									
		 									if (setColPriority) {%><td style="width:30px;" <%=(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS) && !sameUser)?"class=\"tdDisable\"":""%>><% 
												if (numPriority != -1){%><img style="position:static;" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/priority<%=numPriority%>.gif"><%
												} else {%>
													&nbsp; <%
												}%></td><%
		 									}
	 										if (setColProStatus) { %><td style="width:30px;" align="center" <%=(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS) && !sameUser)?"class=\"tdDisable\"":""%>><img style="width:20px;height:20px;position:static;" src="administration.ImagesAction.do?action=addFooter&image=procicon.png&footer=proStatus<%=numProStatus%>.gif"></td><%
	 										}
	 										if (setColTskStatus) { %><td style="width:30px;" align="center" <%=(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS) && !sameUser)?"class=\"tdDisable\"":""%>><img style="width:20px;height:20px;position:static;" src="administration.ImagesAction.do?action=addFooter&image=taskicon.png&footer=tskStatus<%=numTskStatus%>.gif"></td><%
	 										}
	 										
	 										for (int i = 0; i < mustShowColumns.length; i++) {
	 											pos = Math.abs(mustShowColumns[i]) - 1;
		 										obj = row.getColumnas().get(Math.abs(mustShowColumns[i]) - 1);
		 										String strValue="";
		 										if (showPosition[pos] && mustShowColumns[i] > 0) {
			 										setHTML = isHTML[pos];
			 										if (posProInstId != pos && posProEleInstId != pos && posWorkMode != pos && posUsrLogin != pos && posUsersPool != pos && posEnvId != pos && posNotShow != pos) {%><% if (pos == posProAction) {
															processType = (String) obj;
															if (ProcessVo.PROCESS_ACTION_CREATION.equals(processType)) {
																strValue=(LabelManager.getName(labelSet,"lblEjeActCre"));
															} else if (ProcessVo.PROCESS_ACTION_ALTERATION.equals(processType)) {
																strValue=(LabelManager.getName(labelSet,"lblEjeActAlt"));
															} else if (ProcessVo.PROCESS_ACTION_CANCEL.equals(processType)) { 
																strValue=(LabelManager.getName(labelSet,"lblEjeActCan"));
															}
				 										}else if (pos == posProTitle){
				 											if(posProName != -1){
				 												proName = showColumns.get(posProName).toString(); 
				 												strValue=(dBean.fmtHTMLObject(TranslationManager.getProcTitle(proName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
				 											}else{
				 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
				 											}
				 									
				 										} else if (pos == posTskTitle){
				 											if(posTskName != -1){
				 												tskName = showColumns.get(posTskName).toString(); 
				 												strValue=(dBean.fmtHTMLObject(TranslationManager.getTaskTitle(tskName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
				 											}else{
				 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
				 											}
				 										} else {
				 											strValue=((showTime[pos] && obj != null && (obj instanceof Date || obj instanceof java.sql.Timestamp))?dBean.fmtDateTime((Date) obj):dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
				 										} %><td title="<%=StringUtil.escapeStr(strValue)%>" <%=(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS) && !sameUser)?"class=\"tdDisable\"":""%>><%=strValue%></td><%
				 									}
		 										}
			 								} %></tr><%
		 								}
			 						}
		 	  						count ++;
	 							} 
	 						} %></tbody></table></div><table class="navBar"><COL><COL class="colM"><COL><tr><%
int butFilter = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)?QueryVo.FLAG_SHOW_BUTTON_FILTER:QueryVo.FLAG_SHOW_BUTTON_FILTER_2;
int butColumns = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)?QueryVo.FLAG_SHOW_BUTTON_COLUMNS:QueryVo.FLAG_SHOW_BUTTON_COLUMNS_2;
int butRefresh = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)?QueryVo.FLAG_SHOW_BUTTON_REFRESH:QueryVo.FLAG_SHOW_BUTTON_REFRESH_2;
int butWork = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)?QueryVo.FLAG_SHOW_BUTTON_WORK:QueryVo.FLAG_SHOW_BUTTON_WORK_2;
int butExport = WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)?QueryVo.FLAG_SHOW_BUTTON_EXPORT:QueryVo.FLAG_SHOW_BUTTON_EXPORT_2;
int butOnlyMyTasks = QueryVo.FLAG_SHOW_BUTTON_ONLY_MY_TASKS;
%><td align=left><% if (queryVo.getButtonValue(butExport)) { %><button type="button" onclick="btnExp_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %><% if (queryVo.getButtonValue(butFilter)) { %><button type="button" onclick="btnFil_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeFil")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeFil")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeFil")%></button><% } %><% if (showColumnsButton && queryVo.getButtonValue(butColumns)) { %><button type="button" onclick="btnCol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeCol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeCol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeCol")%></button><% } %><% if (queryVo.getButtonValue(butRefresh)) { %><button type="button" onclick="refresh()" id="btnRefresh" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRef")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRef")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRef")%></button><% } %></td><%@include file="../../../includes/navButtonsQuery.jsp" %><td align=right><%if(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)){%><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_RELEASE)) { %><button type="button" onclick="btnLib_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeLib")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeLib")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeLib")%></button><% } %><%} else {%><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_ACQUIRED)) { %><button type="button" onclick="btnCap_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeCap")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeCap")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeCap")%></button><% } %><%}%><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_WORK)) { %><button type="button" onclick="btnTra_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeTra")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeTra")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeTra")%></button><% } %><% if (inProcessMode && queryVo.getButtonValue(butOnlyMyTasks)) {%><span><input type="checkbox" name="onlyMyTasks" value="true" onclick="changeOnlyMyTaskValue()" <%= dBean.isShowOnlyMyTask() ? "checked" : "" %>><%=LabelManager.getNameWAccess(labelSet,"btnOnlyMyTasks")%></span><% } %></td></tr></table><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash_iframe()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script><%if(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)){%>
	var WORK_MODE = "<%=TaskListBean.WORKING_MODE_INPROCESS%>";
<%} else {%>
	var WORK_MODE = "<%=TaskListBean.WORKING_MODE_READY%>";
<%}%>	
	var DIRTY_FLAG_MY = window.parent.document.getElementById("dirtyMyTasks");
	var DIRTY_FLAG_FREE = window.parent.document.getElementById("dirtyFreeTasks");

function setDirtyMode() {
	<%if(WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)){%>
		DIRTY_FLAG_FREE.value = "true";
	<%} else {%>
		DIRTY_FLAG_MY.value = "true";
	<%}%>
}

function setDirtyBoth() {
	DIRTY_FLAG_MY.value = "true";
	DIRTY_FLAG_FREE.value = "true";
}

function removeFilter(index) {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=removeFilter&workMode=" + WORK_MODE + "&filterId=" + index;
	submitForm(document.getElementById("frmMain"));
}

function removeAllFilters() {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=removeAllFilters&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function goToPage(){
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=page&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function doLoad() {
	<% if (queryVo.getButtonValue(butFilter) && dBean.isShowFilterModal()) { %>
		btnFil_click();<% 
		dBean.setShowFilterModal(false);
	} %>
}

</script><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/list/client.js"></script><%@include file="../../../../components/scripts/server/endIncTasksList.jsp" %>
