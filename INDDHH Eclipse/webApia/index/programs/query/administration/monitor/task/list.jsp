<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.QueryBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns" %><%@include file="../../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.TaskMonitorBean"></jsp:useBean><%

com.dogma.bean.query.TaskMonitorBean dBean = qBean;
boolean blnProcess = false;
boolean blnStatus = false;
boolean blnSpecific = true;

QueryVo queryVo = dBean.getQueryVo();
Iterator columnas = null;
Iterator iteratorFilas = null;

int posEnvId = -1;
int posProInstId = -1;
int posProEleInstId = -1;
int posProId = -1;
int posProVerId = -1;
int posBusEntId = -1;
int posBusEntInstId = -1;
int posProMaxDur = -1;
int posTskMaxDur = -1;
int posTskAlertDur = -1;
int posProEleInstDateReady = -1;
int posProEleInstDateEnd = -1;

int colsToShow = 1;

boolean[] showPosition = null;
boolean[] showTime = null;
boolean[] showHTML = null;

dBean.saveCookieFilters(request,response);
%><HTML><head><%@include file="../../../../../components/scripts/server/headInclude.jsp" %><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script></head><body onload="checkFilter()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMonTsk")%><%if (blnSpecific) {%> : <%=queryVo.getQryTitle()%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
						boolean addedNewLine = false;
						boolean addedEndLine = true;
						for (java.util.Iterator iterator =  queryVo.getFilters().iterator(); iterator.hasNext(); ) {
							com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo) iterator.next();
							if (com.dogma.vo.QryColumnVo.FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) {
								if (addedEndLine || filter.is2Column()) {
									if (filter.is2Column() && ! addedEndLine) {
										out.print("</tr>");
										addedEndLine = true;
									}
									out.print("<tr>");
									addedNewLine = true; 
								} else {
									addedNewLine = false; 
								} 
								out.print("<td title=\"");
								out.print(dBean.fmtHTML(filter.getQryColumnVo().getQryColTooltip()));
								out.print("\">");
								out.print(dBean.fmtHTML(filter.getQryColumnVo().getQryColHeadName()));
								out.print(":</td>");
								out.print("<td ");
								out.print((filter.is2Column())?"colspan='3'":"");
								out.print(">");
								out.print(filter.getHTML(styleDirectory,queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE)));
								out.print("</td>");
								if (filter.is2Column()) {
									out.print("</tr>");
									addedEndLine = true;
									addedNewLine = false;
								} else if (! addedNewLine) {
									out.print("</tr>");
									addedEndLine = true;
								} else {
									addedEndLine = false;
								}
							}
						}
						if (! addedEndLine) {
							out.print("</tr>");
						} %></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><td></td><td><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV><%}%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table class="tblDataGrid"><thead><tr><th style="width:20px;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaTsk")%>"></th><%
 								if (queryVo.getShowColumns().size() > 0 && ! queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) {
									Collection cols = queryVo.getAllShowColumns();
									QryColumnVo columna = null;
									String colName = null;
									
									int size = 0;
									if (queryVo.getHasIncrement() && (queryVo.getData() != null)) {
										size = ((QryRowShowVo)((ArrayList)queryVo.getData()).get(0)).getColumnas().size();
									} else {
										size = cols.size();
									}
									
									showPosition = new boolean[size];
									showTime = new boolean[size];
									showHTML = new boolean[size];
									columnas = cols.iterator();
									int count = 0;
									if (queryVo.getData() != null) {
  				 						iteratorFilas = queryVo.getData().iterator();
  				 					}
									while (columnas.hasNext()) {
										columna = (QryColumnVo) columnas.next(); 
										showTime[count] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
										showHTML[count] = columna.getFlagValue(QryColumnVo.FLAG_IS_HTML);
										if (! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) {%><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px"><%=dBean.fmtHTML(columna.getQryColHeadName())%></th><%
											showPosition[count] = true;
											colsToShow ++;
										} else {
											colName = columna.getQryColName().toUpperCase();

											if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colName)) {
												posEnvId = count;
											} else if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
												posProInstId = count;
											} else if (QueryColumns.COLUMN_PRO_ID.equalsIgnoreCase(colName)) {
												posProId = count;
											} else if (QueryColumns.COLUMN_PRO_VER_ID.equalsIgnoreCase(colName)) {
												posProVerId = count;
											} else if (QueryColumns.COLUMN_BUS_ENT_ID.equalsIgnoreCase(colName)) {
												posBusEntId = count;
											} else if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
												posBusEntInstId = count;
											} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colName)) {
												posProEleInstId = count;
											}
												
											showPosition[count] = false;
 										}
										
										if (QueryColumns.COLUMN_PRO_MAX_DUR.equalsIgnoreCase(colName)) {
											posProMaxDur = count;
										} else if (QueryColumns.COLUMN_TSK_MAX_DUR.equalsIgnoreCase(colName)) {
											posTskMaxDur = count;
										} else if (QueryColumns.COLUMN_TSK_ALERT_DUR.equalsIgnoreCase(colName)) {
											posTskAlertDur = count;
										} else if (QueryColumns.COLUMN_PRO_ELE_INST_DATE_READY.equalsIgnoreCase(colName)) {
											posProEleInstDateReady = count;
										} else if (QueryColumns.COLUMN_PRO_ELE_INST_DATE_END.equalsIgnoreCase(colName)) {
											posProEleInstDateEnd = count;
										}
										
 										count ++;
 									} 
 			 					} else {
	 								if (queryVo.getData() != null) {
  				 						iteratorFilas = queryVo.getData().iterator();
 										if (iteratorFilas.hasNext()) {
 											int count = 0;
 											String colShow = null;
 			 								QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
 			 								showPosition = new boolean[row.getColumnas().size()];
 			 								showTime = new boolean[row.getColumnas().size()];
 			 								showHTML = new boolean[row.getColumnas().size()];
 											columnas = row.getColumnas().iterator();
 											while (columnas.hasNext()) {
 												colShow = (String) columnas.next(); 
 												showPosition[count] = false;
 												if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colShow)) {
 													posEnvId = count;
 												} else if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colShow)) {
 													posProInstId = count;
 												} else if (QueryColumns.COLUMN_PRO_ID.equalsIgnoreCase(colShow)) {
 													posProId = count;
 												} else if (QueryColumns.COLUMN_PRO_VER_ID.equalsIgnoreCase(colShow)) {
 													posProVerId = count;
 												} else if (QueryColumns.COLUMN_BUS_ENT_ID.equalsIgnoreCase(colShow)) {
 													posBusEntId = count;
 												} else if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colShow)) {
 													posBusEntInstId = count;
 												} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colShow)) {
 													posProEleInstId = count;
 												} else {
 													if (colShow != null) {
	 													showPosition[count] = true; %><th style="width:150px;"><%=dBean.fmtHTMLObject(colShow)%></th><%
 													}
													colsToShow ++;
 												}

 												if (QueryColumns.COLUMN_PRO_MAX_DUR.equalsIgnoreCase(colShow)) {
 													posProMaxDur = count;
 												} else if (QueryColumns.COLUMN_TSK_MAX_DUR.equalsIgnoreCase(colShow)) {
 													posTskMaxDur = count;
 												} else if (QueryColumns.COLUMN_TSK_ALERT_DUR.equalsIgnoreCase(colShow)) {
 													posTskAlertDur = count;
 												} else if (QueryColumns.COLUMN_PRO_ELE_INST_DATE_READY.equalsIgnoreCase(colShow)) {
 													posProEleInstDateReady = count;
 												} else if (QueryColumns.COLUMN_PRO_ELE_INST_DATE_END.equalsIgnoreCase(colShow)) {
 													posProEleInstDateEnd = count;
 												}
												
 												count ++;
	 										} 
 										}
  									} 
  								} %></tr></thead><tbody><%
							if (qBean.queryHasEmptyRequieredFilters()) { %><tr><td colspan="<%= colsToShow %>"><br><br><%=LabelManager.getName(labelSet,"lblQryMustFil")%><br><br><br></td></tr><% 
							} else {
	  							int count = 1;
	  							if (iteratorFilas != null) {
									int pos = 0;
									Object value = null;
									QryRowShowVo row = null;
									String rowString = null;
									boolean isLate = false;
									boolean isInAlert = false;
									boolean odd = false;
									
		 			  				while (iteratorFilas.hasNext()) {
	 		 	  						row = (QryRowShowVo) iteratorFilas.next(); 
	 		 	  						rowString = row.getTaskMonitorQueryString(posEnvId,posProInstId,posProEleInstId,posProId,posProVerId,posBusEntId,posBusEntInstId,posProMaxDur,posTskMaxDur);
	 		 	  						isLate = row.isTskLate(posProEleInstDateReady,posProEleInstDateEnd,posTskMaxDur);
	 		 	  						isInAlert = row.isTskInAlert(posProEleInstDateReady,posProEleInstDateEnd,posTskAlertDur);
	 		 	  						odd = (count % 2 == 0); %><tr row_id="<%=rowString%>" <%=isLate?"class=\"tdProLat\"":isInAlert?"class=\"tdProInAle\"":odd?"class=\"trOdd\"":""%> onclick="selectProcess(this)" id=LIST><td align="center" <%=isLate?"class=\"tdProLat\"":isInAlert?"class=\"tdProInAle\"":odd?"class=\"trOdd\"":""%>><button type="button" style="filter:none;BACKGROUND-COLOR:transparent;BORDER:0px;MARGIN-LEFT:0px;MARGIN-RIGHT:0px;PADDING-LEFT:0px;PADDING-RIGHT:0px;PADDING-TOP:0px;PADDING-BOTTOM:0px;"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/tskStatus<%=isLate?"2":isInAlert?"1":"0"%>.gif"></button></td><%
		 									columnas = row.getColumnas().iterator();
	 										pos = 0;
	 										while (columnas.hasNext()) { 
	 											value = columnas.next();
	 											if (showPosition[pos]) { 
	 												String strValue=((showTime[pos] && value != null && value instanceof Date)?dBean.fmtDateTime((Date) value):dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
	 												%><td title="<%=strValue%>"><%=strValue%></td><%
			 									}
	 											pos ++;
		 									} %></tr><%
	 	  								count ++;
	 	 							} 
	 	 						}
	 	 					} %></tbody></table><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><% if (! queryVo.isFirstTime()) { %><%@include file="../../../../includes/navButtonsQuery.jsp" %><% } else { %><td></td><% } %><td><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button type="button" onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_DETAILS)) { %><button type="button" onclick="btnDet_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonDet")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonDet")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonDet")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_HISTORY)) { %><button type="button" onclick="btnHis_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonHis")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonHis")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonHis")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_TASK)) { %><button type="button" onclick="btnTsk_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonTsk")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonTsk")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonTsk")%></button><% } %></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/monitor/task/list.js"></script><%@include file="../../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function checkFilter(){
	<%if ((queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST) && ! qBean.hasQueryHasBeenExecuted()) || qBean.queryHasEmptyRequieredFilters()) { %>
		fireEvent(document.getElementById('toggleFilter'),'click');
	<% } %>
}
</script>
