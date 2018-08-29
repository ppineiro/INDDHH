<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.QueryBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns" %><%@include file="../../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.ProcessMonitorBean"></jsp:useBean><%
try {
com.dogma.bean.query.ProcessMonitorBean dBean = qBean;
boolean blnProcess = false;
boolean blnStatus = false;
boolean blnSpecific = true;

QueryVo queryVo = dBean.getQueryVo();
Iterator columnas = null;
Iterator iteratorFilas = null;

int posEnvId = -1;
int posProInstId = -1;
int posProId = -1;
int posProVerId = -1;
int posBusEntId = -1;
int posBusEntInstId = -1;
int posProMaxDur = -1;
int posProAlertDur = -1;
int posProInstCreateDate = -1;
int posProInstEndDate = -1;

int colsToShow = 1;

boolean[] showPosition = null;
boolean[] showTime = null;
boolean[] isHTML = null;

dBean.saveCookieFilters(request,response);
%><HTML><head><%@include file="../../../../../components/scripts/server/headInclude.jsp" %><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script></head><body onload="checkFilter()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMon")%><%if (blnSpecific) {%> : <%=queryVo.getQryTitle()%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea"  style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
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
						} %></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><td></td><td><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV><%}%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:20px;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeStaPro")%>"></th><%
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
									isHTML = new boolean[size];
									columnas = cols.iterator();
									int count = 0;
									if (queryVo.getData() != null) {
  				 						iteratorFilas = queryVo.getData().iterator();
  				 					}
									while (columnas.hasNext()) {
										columna = (QryColumnVo) columnas.next(); 
										showTime[count] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
										isHTML[count] = columna.getFlagValue(QryColumnVo.FLAG_IS_HTML);
										if (! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) {
											boolean canOrder = (columna.getAttId() == null) && ! columna.getQryColName().equals(dBean.getOrderColumn());  %><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>"  style="width:<%=columna.getQryColWidth()%>px<% if (canOrder) {%>;cursor:hand" onclick="orderBy('<%=columna.getQryColName()%>')<%}%>"><%=canOrder?"<u>":""%><%=dBean.fmtHTML(columna.getQryColHeadName())%><%=canOrder?"</u>":""%></th><%
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
											}
												
											showPosition[count] = false;
 										}
										
										if (QueryColumns.COLUMN_PRO_MAX_DUR.equalsIgnoreCase(colName)) {
											posProMaxDur = count;
										} else if (QueryColumns.COLUMN_PRO_INST_CREATE_DATE.equalsIgnoreCase(colName)) {
											posProInstCreateDate = count;
										} else if (QueryColumns.COLUMN_PRO_INST_END_DATE.equalsIgnoreCase(colName)) {
											posProInstEndDate = count;
										} else if (QueryColumns.COLUMN_PRO_ALERT_DUR.equalsIgnoreCase(colName)) {
											posProAlertDur = count;
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
 			 								isHTML = new boolean[row.getColumnas().size()];
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
 												} else {
 													if (colShow != null) {
 														boolean canOrder = ! colShow.equals(dBean.getOrderColumn());
	 													showPosition[count] = true; %><th style="width:150px;<% if (canOrder) {%>;cursor:hand" onclick="orderBy('<%=colShow%>')<%}%>""><%=canOrder?"<u>":""%><%=dBean.fmtHTMLObject(colShow)%><%=canOrder?"</u>":""%></th><%
 													}
													colsToShow ++;
 												}
 												
 												if (QueryColumns.COLUMN_PRO_MAX_DUR.equalsIgnoreCase(colShow)) {
 													posProMaxDur = count;
 												} else if (QueryColumns.COLUMN_PRO_INST_CREATE_DATE.equalsIgnoreCase(colShow)) {
 													posProInstCreateDate = count;
 												} else if (QueryColumns.COLUMN_PRO_INST_END_DATE.equalsIgnoreCase(colShow)) {
 													posProInstEndDate = count;
 												} else if (QueryColumns.COLUMN_PRO_ALERT_DUR.equalsIgnoreCase(colShow)) {
 													posProAlertDur = count;
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
	 		 	  						rowString = row.getProcessMonitorQueryString(posEnvId,posProInstId,posProId,posProVerId,posBusEntId,posBusEntInstId,posProMaxDur); 
	 		 	  						isLate = row.isProLate(posProInstCreateDate,posProInstEndDate,posProMaxDur);
	 		 	  						isInAlert = row.isProInAlert(posProInstCreateDate,posProInstEndDate,posProAlertDur); 
	 		 	  						odd = (count % 2 == 0); %><tr row_id="<%=rowString%>" <%=isLate?"class=\"tdProLat\"":isInAlert?"class=\"tdProInAle\"":odd?"class=\"trOdd\"":""%> id=LIST><td align="center" <%=isLate?"class=\"tdProLat\"":isInAlert?"class=\"tdProInAle\"":odd?"class=\"trOdd\"":""%>><button type="button" style="filter:none;BACKGROUND-COLOR:transparent;BORDER:0px;MARGIN-LEFT:0px;MARGIN-RIGHT:0px;PADDING-LEFT:0px;PADDING-RIGHT:0px;PADDING-TOP:0px;PADDING-BOTTOM:0px;"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/proStatus<%= isLate?"2":isInAlert?"1":"0" %>.gif"></button></td><%
		 									columnas = row.getColumnas().iterator();
	 										pos = 0;
	 										while (columnas.hasNext()) { 
	 											value = columnas.next();
	 											if (showPosition[pos]) { 
	 												String strValue=((showTime[pos] && value != null && value instanceof Date)?dBean.fmtDateTime((Date) value):dBean.fmtHTMLObject(value,"&nbsp;",isHTML[pos]));%><td title="<%=StringUtil.escapeStr(strValue)%>"><%=strValue%></td><%
			 									}
	 											pos ++;
		 									} %></tr><%
	 	  								count ++;
	 	 							} 
	 	 						}
	 	 					} %></tbody></table><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><% if (! queryVo.isFirstTime()) { %><%@include file="../../../../includes/navButtonsQuery.jsp" %><% } else { %><td></td><% } %><td><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button type="button" onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_DETAILS)) { %><button type="button" onclick="btnDet_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonDet")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonDet")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonDet")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_TASK)) { %><button type="button" onclick="btnTsk_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonTsk")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonTsk")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonTsk")%></button><% } %></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/monitor/process/list.js"></script><script language="javascript">
function checkFilter(){
	<%if((queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST) && ! qBean.hasQueryHasBeenExecuted()) || "true".equals(request.getParameter("fromOnChange"))){%>
		toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
	<%} else if (qBean.queryHasEmptyRequieredFilters()) { %>
		fireEvent(document.getElementById('toggleFilter'),'click');
	<% } %>
}
</script><%@include file="../../../../../components/scripts/server/endInc.jsp" %><% } catch (Exception e) {
e.printStackTrace(); } %>