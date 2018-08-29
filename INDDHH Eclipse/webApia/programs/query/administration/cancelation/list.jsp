<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.QueryBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns" %><%@include file="../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QryProCancelBean"></jsp:useBean><%

com.dogma.bean.query.QryProCancelBean dBean = qBean;
boolean blnProcess = false;
boolean blnStatus = false;
boolean blnSpecific = true;

QueryVo queryVo = dBean.getQueryVo();
Iterator columnas = null;
Iterator iteratorFilas = null;

int posBusEntInstId = -1;
int posProAction = -1;
int posProInstId = -1;
int posProTitle = -1;
int posTskTitle = -1;
int posProName = -1;
int posTskName = -1;
int posAttTitle = -1;
int posAttName = -1;
int posBusEntName = -1;
int posBusEntTitle = -1;
int posFrmName = -1;
int posFrmTitle = -1;
int posAttDesc = -1;

int colsToShow = 1;

boolean[] showPosition = null;
boolean[] showTime = null;
boolean[] showHTML = null;

dBean.saveCookieFilters(request,response);
%><%@page import="com.st.util.translator.TranslationManager"%><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body onload="openFilterSection();"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeProCan")%><%if (blnSpecific) {%> : <%=queryVo.getQryTitle()%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME><form id="frmMain" name="frmMain" method="POST"><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
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
						} %></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><td></td><td><button onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV><%}%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div type="grid" id="gridList" height="<%=Parameters.SCREEN_LIST_SIZE%>"><table class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th align="center" style="width:0px;display:none" title="<%=LabelManager.getToolTip(labelSet,"lblEjeSelTod")%>"></th><%
								
								HashSet headers = new HashSet();
								if (queryVo.getShowColumns().size() > 0) {
									Collection cols = queryVo.getAllShowColumns();
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
										QryColumnVo columna = (QryColumnVo) columnas.next(); 
										showTime[count] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
										showHTML[count] = columna.getFlagValue(QryColumnVo.FLAG_IS_HTML);
										if (! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) {
											if(columna.isAtt()){%><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px"><%=dBean.fmtHTML(TranslationManager.getAttTitle(columna.getQryColName(), columna.getQryColHeadName(), uData.getEnvironmentId(), uData.getLangId()))%></th><%
											}else{ %><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px"><%=dBean.fmtHTML(columna.getQryColHeadName())%></th><%
											}

											String colName = columna.getQryColName().toUpperCase();
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
											if (QueryColumns.COLUMN_ATT_NAME.equalsIgnoreCase(colName)) {
												posAttName = count;
											}
											if (QueryColumns.COLUMN_ATT_LABEL.equalsIgnoreCase(colName)) {
												posAttTitle = count;
											}
											if (QueryColumns.COLUMN_ATT_DESC.equalsIgnoreCase(colName)) {
												posAttDesc = count;
											}
											if (QueryColumns.COLUMN_BUS_ENT_TITLE.equalsIgnoreCase(colName)) {
												posBusEntTitle = count;
											}
											if (QueryColumns.COLUMN_BUS_ENT_NAME.equalsIgnoreCase(colName)) {
												posBusEntName = count;
											}
											if (QueryColumns.COLUMN_FRM_TITLE.equalsIgnoreCase(colName)) {
												posFrmTitle = count;
											}
											if (QueryColumns.COLUMN_FRM_NAME.equalsIgnoreCase(colName)) {
												posFrmName = count;
											}
											
											headers.add(columna.getQryColHeadName().toUpperCase());
											showPosition[count] = true;
											colsToShow ++;
										} else {
											String colName = columna.getQryColName().toUpperCase();
											if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
												posBusEntInstId = count;
 											} else if (QueryColumns.COLUMN_PRO_ACTION.equalsIgnoreCase(colName)) {
 												posProAction = count;
 											} else if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
 												posProInstId = count;
	 										}
											headers.add(colName);
	 										showPosition[count] = false;
 										}
 										count ++;
 									} 
 			 					} else {
	 								if (queryVo.getData() != null) {
  				 						iteratorFilas = queryVo.getData().iterator();
 										if (iteratorFilas.hasNext()) {
 			 								QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
 			 								showPosition = new boolean[row.getColumnas().size()];
 			 								showTime = new boolean[row.getColumnas().size()];
 			 								showHTML = new boolean[row.getColumnas().size()];
 											columnas = row.getColumnas().iterator();
 											int count = 0;
 											while (columnas.hasNext()) {
 												String colShow = (String) columnas.next(); 
 												if (colShow != null) {
 													showPosition[count] = true; %><th style="width:150px;"><%=dBean.fmtHTMLObject(colShow)%></th><%
 												}
												if (QueryColumns.COLUMN_PRO_TITLE.equals(colShow)) {
													posProTitle = count;
												}
												if (QueryColumns.COLUMN_TSK_TITLE.equals(colShow)) {
													posTskTitle = count;
												}
												if (QueryColumns.COLUMN_PRO_NAME.equals(colShow)) {
													posProName = count;
												}
												if (QueryColumns.COLUMN_TSK_NAME.equals(colShow)) {
													posTskName = count;
												}
												if (QueryColumns.COLUMN_ATT_NAME.equals(colShow)) {
													posAttName = count;
												}
												if (QueryColumns.COLUMN_ATT_LABEL.equals(colShow)) {
													posAttTitle = count;
												}
												if (QueryColumns.COLUMN_ATT_DESC.equals(colShow)) {
													posAttDesc = count;
												}
												if (QueryColumns.COLUMN_BUS_ENT_TITLE.equals(colShow)) {
													posBusEntTitle = count;
												}
												if (QueryColumns.COLUMN_BUS_ENT_NAME.equals(colShow)) {
													posBusEntName = count;
												}
												if (QueryColumns.COLUMN_FRM_TITLE.equals(colShow)) {
													posFrmTitle = count;
												}
												if (QueryColumns.COLUMN_FRM_NAME.equals(colShow)) {
													posFrmName = count;
												}
												count ++;
												colsToShow ++;
	 										}
	 										columnas = row.getColumnas().iterator();
 											count = 0;
	 										while (columnas.hasNext()) {
	 											String colName = (String)columnas.next();
	 											if (colName != null) {
	 												colName = colName.toUpperCase();
	 											}
 												if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
 													posBusEntInstId = count;
 	 											} else if (QueryColumns.COLUMN_PRO_ACTION.equalsIgnoreCase(colName)) {
 	 												posProAction = count;
 	 											} else if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
 	 												posProInstId = count;
 		 										}
 												count ++;
	 										}
 										}
  									} 
  								} 
  								if (queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES) && (queryVo.getShowColumns().size() > 0)){
									if (queryVo.getData()!=null && ((ArrayList)queryVo.getData()).size() > 0){
										Iterator it = ((QryRowShowVo)((ArrayList)queryVo.getData()).get(0)).getColumnas().iterator();
										int posCol = 0;
										while (it.hasNext()){
											Object value = it.next();
											if ((value != null)&&(!headers.contains(((String)value).toUpperCase()))){ 
												showPosition[posCol] = true; %><th align="center" title="<%= dBean.fmtHTML("") %>" style="width:100px"><%=dBean.fmtHTML(value.toString())%></th><%
											}
											posCol++;
										}
									}
								}%></tr></thead><tbody><%
							if (dBean.queryHasEmptyRequieredFilters()) { %><tr><td colspan="<%= colsToShow %>"><br><br><%=LabelManager.getName(labelSet,"lblQryMustFil")%><br><br><br></td></tr><% 
							} else {
	  							int count = 1;
	  							if (iteratorFilas != null) {
									Integer busEntId = new Integer(queryVo.getQryColumn(QueryColumns.COLUMN_BUS_ENT_ID,QryColumnVo.COLUMN_TYPE_FILTER).getQryColValue());
									int pos = 0;
									Object value = null;
									QryRowShowVo row = null;
									String proName = null;
									String tskName = null;
									String attName = null;
									String busEntName = null;
									String frmName = null;
									int rowCount=0;
									
									int amountOfColumns = showPosition.length;
									
									int amountOfVisibleColumns = 0;
									for (int i = 0; i < showPosition.length; i++) amountOfVisibleColumns += showPosition[i] ? 1 : 0;
									
		 			  				while (iteratorFilas.hasNext()) {
	 		 	  						row = (QryRowShowVo) iteratorFilas.next(); 
	 		 	  						if (row.getColumnas().size() != amountOfColumns) { %><tr><td colspan="<%= amountOfVisibleColumns %>"><%=LabelManager.getName(labelSet,"msgQryErrAm")%></td></tr><% } else { 
	 		 	  							if ((queryVo.getData().size() > 1 && queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) || (!queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES))) {
			 									if (((queryVo.getShowColumns().size() > 0) && (count != 1) && queryVo.getHasIncrement()) || ((queryVo.getShowColumns().size() > 0) && !queryVo.getHasIncrement()) || (queryVo.getShowColumns().size() == 0)) {
			 										%><tr proInstCancelId="<%=((posProInstId>=0)?dBean.fmtInt(row.getValueInt(posProInstId,true)):"")%>" proInstCancelAction="<%=((posProAction>=0)?row.getValueStr(posProAction,true):"") %>"><td align="center" style="width:0px;display:none"><input type="hidden" id="chkSel<%=rowCount%>" name="chkSel<%=rowCount%>" /><input type="hidden" id="txtEntId<%=rowCount%>" name="txtEntId<%=rowCount%>" value="<%= ((posBusEntInstId>=0)?dBean.fmtInt(row.getValueInt(posBusEntInstId,true)):"") %>"><input type="hidden" name="txtBusEntId<%=((posBusEntInstId>=0)?dBean.fmtInt(row.getValueInt(posBusEntInstId,false)):"")%>" value="<%=dBean.fmtInt(busEntId)%>"></td><%
														
														columnas = row.getColumnas().iterator();
				 										pos = 0;
		 										
				 										while (columnas.hasNext()) {
				 											value = columnas.next();
				 											String strValue="";
				 											if (showPosition[pos]) {
				 												if (pos == posProTitle){
						 											if(posProName != -1){
						 												proName = row.getColumnas().get(posProName).toString(); 
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getProcTitle(proName, value.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 											}else{
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 											}
						 									
						 										} else if (pos == posTskTitle){
						 											if(posTskName != -1){
						 												tskName = row.getColumnas().get(posTskName).toString(); 
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getTaskTitle(tskName, value.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 											}else{
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 											}
						 										} else if (pos == posBusEntTitle){
						 											if(posBusEntName != -1){
						 												busEntName = row.getColumnas().get(posBusEntName).toString(); 
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getBusEntTitle(busEntName, value.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 											}else{
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 											}
					
						 										} else if (pos == posFrmTitle){
						 											if(posFrmName != -1){
						 												frmName = row.getColumnas().get(posFrmName).toString(); 
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getFrmTitle(frmName, value.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 											}else{
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 											}
						 											
						 										} else if (pos == posAttTitle){
						 											if(posAttName != -1){
						 												attName = row.getColumnas().get(posAttName).toString(); 
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getAttTitle(attName, value.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 											}else{
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 											}
						 											
						 										} else if (pos == posAttDesc){
						 											if(posAttName != -1){
						 												attName = row.getColumnas().get(posAttName).toString(); 
						 												String originalValue = "";
						 												if(value != null){
						 													originalValue = value.toString();	
						 												}
						 												strValue=(dBean.fmtHTMLObject(TranslationManager.getAttDesc(attName, originalValue, uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",showHTML[pos]));
						 												
						 											} else {
						 												strValue=(dBean.fmtHTMLObject(value,"&nbsp;"));
						 											}
						 										} else {		 											
						 											strValue=((showTime[pos] && value != null && value instanceof Date)?dBean.fmtDateTime((Date) value):dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));
						 										}%><td title="<%=StringUtil.escapeStr(strValue)%>"><%=strValue%></td><%
						 									}
				 											pos++;
					 									}%></tr><%
			 									}
		 									}
		 	  								count++;
		 									rowCount++;
	 		 	  						}
	 	 							} 
	 	 						}
	 	 					} %></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><% if (! queryVo.isFirstTime()) { %><%@include file="../../../includes/navButtonsQuery.jsp" %><% } else { %><td></td><% } %><td><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_CANCEL)) { %><button onclick="btnCancel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCanPro")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCanPro")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCanPro")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %></td></tr></table><input type=hidden name="txtProId" value="<%=dBean.getTxtProId()%>"><input type=hidden name="txtBusEntId" value="<%=dBean.getBusEntId()%>"><input type=hidden name="proInstCancelId" value=""><input type=hidden name="proInstCancelAction" value=""></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script language="javascript" defer>
function openFilterSection() {
	<% if (queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST) && ! qBean.hasQueryHasBeenExecuted()) {%>
	toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
	<% } %>
}
</script><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/cancelation/list.js"></script><%@include file="../../../../components/scripts/server/endInc.jsp" %>
