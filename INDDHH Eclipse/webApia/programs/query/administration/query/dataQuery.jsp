<%@page import="com.dogma.vo.*"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.filter.*"%><%@page import="org.jfree.chart.ChartFrame"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="java.lang.*"%><%@page import="com.dogma.business.querys.factory.*" %><%@include file="../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QueryBean"></jsp:useBean><%
com.dogma.bean.query.QueryBean dBean = qBean;

QueryVo queryVo = dBean.getQueryVo();
Collection charts = queryVo.getCharts();
Iterator itAllCharts = charts.iterator();
Collection filterColumns = dBean.getQueryFilter(); 

dBean.saveCookieFilters(request,response);
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
Collection filterColNames = new ArrayList();
Collection filterColVos = new ArrayList();
boolean onlyGrid = "true".equals(request.getParameter("onlyGrid"));
boolean onlyChart = "true".equals(request.getParameter("onlyChart"));
boolean fromQryUrl = "true".equals(request.getParameter("fromQryUrl"));
Integer onFinish = new Integer(1);
if (request.getParameter("onFinish")!=null){
	onFinish = new Integer(request.getParameter("onFinish"));
}
int amountOfActions = 0;
%><%@page import="com.st.util.translator.TranslationManager"%><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><script language="javascript">
var menuActions=new Array();
<% if (queryVo.getAction(QueryVo.ACTION_VIEW_QUERY)) {
	Collection col = queryVo.getActionsTo();
	if (col != null && col.size() > 0) {
		for (Iterator it = col.iterator(); it.hasNext(); ) {
			QryNavigationVo navVo = (QryNavigationVo) it.next(); 
			amountOfActions ++;%>
			menuActions.push({value:"<%= QueryVo.ACTION_VIEW_QUERY %>_<%= navVo.getQryToId() %>",text:"<%=LabelManager.getName(labelSet,"lblQryActVieQry")%>: <%= navVo.getQryToTitle() %>"});
			<%
		} 
	} 
} %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_FORM)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_VIEW_FORM %>", text:"<%=LabelManager.getName(labelSet,"lblQryActVieFor")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_ENTITY)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_VIEW_ENTITY %>", text:"<%=LabelManager.getName(labelSet,"lblQryActVieEnt")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_PROCESS)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_VIEW_PROCESS %>", text:"<%=LabelManager.getName(labelSet,"lblQryActViePro")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_TASK)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_VIEW_TASK %>", text:"<%=LabelManager.getName(labelSet,"lblQryActVieTas")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_WORK_ENTITY)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_WORK_ENTITY %>", text:"<%=LabelManager.getName(labelSet,"lblQryActWorEnt")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_WORK_TASK)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_WORK_TASK %>", text:"<%=LabelManager.getName(labelSet,"lblQryActWorTas")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_ACQUIRE_TASK)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_ACQUIRE_TASK %>", text:"<%=LabelManager.getName(labelSet,"lblQryActAcqTas")%>"});<% } %><% if (queryVo.getAction(QueryVo.ACTION_COMPLETE_TASK)) { amountOfActions ++;%>menuActions.push({value:"<%= QueryVo.ACTION_COMPLETE_TASK %>", text:"<%=LabelManager.getName(labelSet,"lblQryActComTas")%>"});<% } %><%

boolean hasOneAction = amountOfActions == 1;
%></script></head><body onLoad="doOnLoad();"><%if (onlyChart){ %><table class="tblFormLayout"><tr><td></td><td><select name="cmbChartsDef" id="cmbChartsDef" style="display:none"><% Iterator itChartsDef = queryVo.getCharts().iterator();
		    	   while (itChartsDef.hasNext()){
					   	QryChartVo chartVo = (QryChartVo)itChartsDef.next();%><option value="<%=chartVo.getQryChtId()%>"%><%=chartVo.getQryChtTitle()%></option><%}%></select></td><td align="right"><button type="button" onclick="btnZoomAdd()" title="addZoom" id="addZoom">Zoom +</button></td><td align="left"><button type="button" onclick="btnZoomRem()" title="remZoom" id="remZoom">Zoom -</button></td></tr><tr><td colspan="4" align = "center"><div style="width:90%;height:600px;overflow:auto;position:relative"><img height=600 width=1000 align = "center" id="imgGraph" src=""></div></td></tr></table><%}else{ %><TABLE class="pageTop"><COL class="col1" /><COL class="col2" /><TR><TD><%=LabelManager.getName(labelSet,"titQry")%></TD><TD></TD></TR></TABLE><div id="divContent"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryInfo")%></DIV><table class="tblFormLayout"><COL class="col1" /><COL class="col2" /><COL class="col3" /><COL class="col4" /><tr><td><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td colspan="3"><%=dBean.fmtHTML(TranslationManager.getQueryTitle(queryVo.getQryName(),queryVo.getQryTitle(),uData.getEnvironmentId(), uData.getLangId()))%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblDes")%>:</td><td colspan="3"><%=dBean.fmtHTML(TranslationManager.getQueryDesc(queryVo.getQryName(),queryVo.getQryDesc(),uData.getEnvironmentId(), uData.getLangId()))%></td></tr></table><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"sbtRes")%>" tabText="<%=LabelManager.getName(labelSet,"sbtRes")%>"><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><%
					boolean addedNewLine = false;
					boolean addedEndLine = true;
					
					StringBuffer buff=new StringBuffer();  
					int rows=0;
					for (java.util.Iterator iterator =  queryVo.getFilters().iterator(); iterator.hasNext(); ) {
						com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo) iterator.next();
						if (com.dogma.vo.QryColumnVo.FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) {
							if (addedEndLine || filter.is2Column()) {
								if (filter.is2Column() && ! addedEndLine) {
									buff.append("</tr>");
									addedEndLine = true;
								}
								buff.append("<tr>");
								rows++;
								addedNewLine = true; 
							} else {
								addedNewLine = false; 
							} 
							filterColNames.add(filter.getFilterColumnName().toUpperCase());
							filterColVos.add(filter);
							buff.append("<td title=\"");
							buff.append(dBean.fmtHTML(filter.getQryColumnVo().getQryColTooltip()));
							buff.append("\">");
							buff.append(dBean.fmtHTML(filter.getQryColumnVo().getQryColHeadName()));
							buff.append(":</td>");
							buff.append("<td ");
							buff.append((filter.is2Column())?"colspan='3'":"");
							buff.append(">");
							buff.append(filter.getHTML(styleDirectory,queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE)));
							buff.append("</td>");
							if (filter.is2Column()) {
								buff.append("</tr>");
								addedEndLine = true;
								addedNewLine = false;
							} else if (! addedNewLine) {
								buff.append("</tr>");
								addedEndLine = true;
							} else {
								addedEndLine = false;
							}
						}
					}
					if (! addedEndLine) {
						buff.append("</tr>");
					} %><DIV class="subTit"><table width="99%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><%if(request.getAttribute("onlyFilter")==null){%><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection()"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button><%}%></td></tr></table></DIV><%if(request.getAttribute("onlyFilter")==null){%><DIV id="listFilterArea" isQuery="true" style="display:none"  topSize="30px"><%}%><form id="frmFilter" name="frmFilter" method="POST"><DIV <%if(request.getAttribute("onlyFilter")==null){%>style="OVERFLOW:AUTO;HEIGHT:<%= (rows*30)+20 %>px;"<%}%>><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%=buff.toString() %><tr><td></td><td></td><td></td><td></td></tr></table></div><table class="tblFormLayout"><tr style="width=100%"><td></td><td align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button><button type="button" onclick="btnReset_click()" title="<%=LabelManager.getToolTip(labelSet,"btnRes")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRes")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRes")%></button></td></tr></table></form><%if(request.getAttribute("onlyFilter")==null){%></DIV><%}
			}%><%int countRow=0;
			int rowCount=0;%><% if (dBean.getQueryVo().getData() != null /*&& dBean.getQueryVo().getData().size()>0*/) { %><%
						//countRow = dBean.getQueryVo().getPagedData().size();
					 	countRow = dBean.getQueryVo().getData().size();
						if (!(queryVo.getShowColumns().size() > 0 && ! queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES))) {
							//countRow --;
						}
						if (countRow > Parameters.MAX_RESULT_QUERY.intValue()) {
							//countRow --;
						}
						//out.println(countRow);
						if (queryVo.getHasIncrement()){
							countRow--;
						}
					%><%if(request.getAttribute("onlyFilter")==null){%><form id="frmMain" name="frmMain" method="POST"><% if (!dBean.getQueryVo().getFlagValue(QueryVo.FLAG_SHOW_QUANT_RESULT)){%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")+": "+countRow+" "%><%=LabelManager.getName(labelSet,"lblResRegEnc")%></DIV><%}%><div type="grid" fastGrid="true" style="height:300px" id="queryGrid" multiSelect="false"><table class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr id="resultHeader"><%
								Iterator columnas;
	 	 						Iterator iteratorFilas = dBean.getQueryVo().getPagedData().iterator();
	 	 						boolean[] addHidden = null;
	 	 						boolean[] showTime = null;
	 	 						boolean[] showColumn = null;
	 	 						boolean[] avoidFilter = null;
	 	 						boolean[] isHTML = null;
	 	 						QryColumnFilterVo[] hasFilterPossibleValues = null;
								int count = 0;
	 	 						
		 						if (queryVo.getShowColumns().size() > 0 && ! queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) {
									columnas	= queryVo.getAllShowColumns().iterator();
									addHidden	= new boolean[queryVo.getAllShowColumns().size()];
									showTime	= new boolean[queryVo.getAllShowColumns().size()];
									showColumn	= new boolean[queryVo.getAllShowColumns().size()];
									avoidFilter	= new boolean[queryVo.getAllShowColumns().size()];
									isHTML		= new boolean[queryVo.getAllShowColumns().size()];
									
									hasFilterPossibleValues = new QryColumnFilterVo[queryVo.getAllShowColumns().size()];
									while (columnas.hasNext()) {
										QryColumnVo columna = (QryColumnVo) columnas.next(); 
										String colName = columna.getQryColName().toUpperCase();
										String auxName = null;
										showColumn[count] = ! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN); 
										avoidFilter[count] = columna.getFlagValue(QryColumnVo.FLAG_DONT_USE_AS_AUTOFILTER); %><th align="center" id="header<%= columna.getQryColName() %>" avoidFilter="<%= avoidFilter[count] %>" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px;<% if (! showColumn[count]) {%>display:none<% } %>"><input type="hidden" name="<%= colName %>" id="<%= colName %>" value=""><%
											if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
												auxName = "proInstId";
											} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colName)) {
												auxName = "proEleInstId";
											} else if (QueryColumns.COLUMN_BUS_ENT_ID.equalsIgnoreCase(colName)) {
												auxName = "busEntId";
											} else if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
												auxName = "busEntInstId";
											} else if (QueryColumns.COLUMN_BUS_ENT_ADMIN_TYPE.equalsIgnoreCase(colName)) {
												auxName = "busEntAdminType";
											} else if (QueryColumns.COLUMN_PRO_ID.equalsIgnoreCase(colName)) {
												auxName = "txtProId";
											}
											if (auxName != null) { %><input type="hidden" name="<%= auxName %>" id="<%= auxName %>" value=""><%
												addHidden[count] = true;
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
											
											if(columna.getBusEntId() == null && ((ArrayList)filterColNames).indexOf(colName) > -1) {
												com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo)((ArrayList)filterColVos).get(((ArrayList)filterColNames).indexOf(colName));
												hasFilterPossibleValues[count]=filter;
											}
											
											
											showTime[count] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
											isHTML[count] = columna.getFlagValue(QryColumnVo.FLAG_IS_HTML);
											count ++; 
											if(columna.isAtt()){
												out.print(dBean.fmtHTML(TranslationManager.getAttTitle(columna.getQryColName(), columna.getQryColHeadName(), uData.getEnvironmentId(), uData.getLangId())));
											}else{
												out.print(dBean.fmtHTML(columna.getQryColHeadName()));
											}%></th><%
									} 
			 					} else {
									if (iteratorFilas.hasNext()) {
										Iterator<QryColumnVo> iteratorShowColumns = queryVo.getAllShowColumns().iterator();
				 						QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
										columnas = row.getColumnas().iterator();
										addHidden = new boolean[row.getColumnas().size()];
										showTime = new boolean[row.getColumnas().size()];
										showColumn = new boolean[row.getColumnas().size()];
										isHTML = new boolean[row.getColumnas().size()];
										avoidFilter = new boolean[row.getColumnas().size()];
										hasFilterPossibleValues = new QryColumnFilterVo[row.getColumnas().size()];
										while (columnas.hasNext()) { 
											Object obj = columnas.next(); 
											String colName = dBean.fmtHTMLObject(obj).toUpperCase();
											String auxName = null;
											
											if (iteratorShowColumns != null && iteratorShowColumns.hasNext()) {
												QryColumnVo aColVo = iteratorShowColumns.next();
												showColumn[count] = ! aColVo.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN);
											} else {
												showColumn[count] = true;
											} %><th style="width:150px;" id="header<%= colName %>" avoidFilter="<%= avoidFilter[count] %>" style="<% if (! showColumn[count]) {%>display:none<% } %>"><input type="hidden" name="<%= colName %>" id="<%= colName %>" value=""><%
												if (QueryColumns.COLUMN_PRO_INST_ID.equalsIgnoreCase(colName)) {
													auxName = "proInstId";
												} else if (QueryColumns.COLUMN_PRO_ELE_INST_ID.equalsIgnoreCase(colName)) {
													auxName = "proEleInstId";
												} else if (QueryColumns.COLUMN_BUS_ENT_ID.equalsIgnoreCase(colName)) {
													auxName = "busEntId";
												} else if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
													auxName = "busEntInstId";
												} else if (QueryColumns.COLUMN_BUS_ENT_ADMIN_TYPE.equalsIgnoreCase(colName)) {
													auxName = "busEntAdminType";
												} else if (QueryColumns.COLUMN_PRO_ID.equalsIgnoreCase(colName)) {
													auxName = "txtProId";
												}
											    
												if (auxName != null) { %><input type="hidden" name="<%= auxName %>" id="<%= auxName %>" value=""><%
													addHidden[count] = true;
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
 
												if(((ArrayList)filterColNames).indexOf(colName) > -1) {
													com.dogma.vo.filter.QryColumnFilterVo filter = (com.dogma.vo.filter.QryColumnFilterVo)((ArrayList)filterColVos).get(((ArrayList)filterColNames).indexOf(colName));
													hasFilterPossibleValues[count]=filter;
												}
												
												showColumn[count] = true;
												count ++; %><%=dBean.fmtHTMLObject(obj)%></th><%
										} 
									}
	 							} %></tr></thead><%if(request.getAttribute("onlyFilter")==null){%><tbody><% 
							rowCount = 1;
							int colCount = 0;
							String proName = null;
							String tskName = null;
							String attName = null;
							String busEntName = null;
							String frmName = null;
							ArrayList showColumns = null;
			  				while (iteratorFilas.hasNext()) {
		 						count = 0;
		  						QryRowShowVo row = (QryRowShowVo) iteratorFilas.next(); %><tr <%if (Parameters.DBLCLICK_TASK_LISTS && hasOneAction) {%> ondblclick="btnAction_click()()" <%} %>><%
									columnas = row.getColumnas().iterator();
	 								showColumns = row.getColumnas();
		 							colCount = 0;
		 							boolean setHTML = false;
									while (columnas.hasNext()) { 
										Object obj = columnas.next();
										setHTML = isHTML[colCount];
										String strValue="";
											count ++; 
											if (colCount == posProTitle){
	 											if(posProName != -1){
	 												proName = showColumns.get(posProName).toString(); 
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getProcTitle(proName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}
	 									
	 										} else if (colCount == posTskTitle){
	 											if(posTskName != -1){
	 												tskName = showColumns.get(posTskName).toString(); 
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getTaskTitle(tskName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}
	 										} else if (colCount == posBusEntTitle){
	 											if(posBusEntName != -1){
	 												busEntName = showColumns.get(posBusEntName).toString(); 
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getBusEntTitle(busEntName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}

	 										} else if (colCount == posFrmTitle){
	 											if(posFrmName != -1){
	 												frmName = showColumns.get(posFrmName).toString(); 
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getFrmTitle(frmName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}
	 											
	 										} else if (colCount == posAttTitle){
	 											if(posAttName != -1){
	 												attName = showColumns.get(posAttName).toString(); 
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getAttTitle(attName, obj.toString(), uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}
	 											
	 										} else if (colCount == posAttDesc){
	 											if(posAttName != -1){
	 												attName = showColumns.get(posAttName).toString(); 
	 												String originalValue = "";
	 												if(obj != null){
	 													originalValue = obj.toString();	
	 												}
	 												strValue=(dBean.fmtHTMLObject(TranslationManager.getAttDesc(attName, originalValue, uData.getEnvironmentId(),uData.getLangId()),"&nbsp;",setHTML));
	 												
	 											}else{
	 												strValue=(dBean.fmtHTMLObject(obj,"&nbsp;",setHTML));
	 											}
	 									
	 										} else if (obj instanceof DocumentVo) {
	 											DocumentVo docVo = (DocumentVo) obj;
	 											docVo.setEnvId(uData.getEnvironmentId());
	 											docVo = dBean.getDocumentForDownload(request,docVo);
	 											
	 											if (docVo == null) {
	 												strValue = "Can't find document for download.";
	 											} else {
	 												strValue = "<a href='#' onclick='downloadDocument(" + docVo.getDocId() + ");' >" + docVo.getDocName() + "</a>";
	 											}
	 											
	 										} else {
	 											strValue=(((showTime[colCount] && obj != null && obj instanceof Date)?dBean.fmtDateTime((Date) obj):dBean.fmtHTMLObject(obj,"&nbsp;",setHTML)));
	 											
	 										}
	 										
 											//Si la columna tiene un filtro, se busca en los possiblevalues para ver si hay mapeo
											com.dogma.vo.filter.QryColumnFilterVo vo = (hasFilterPossibleValues!=null)?hasFilterPossibleValues[colCount]:null;
											if(vo!=null){
												strValue=vo.getPossibleValueForId(strValue);
											}

											 
	 										%><td title="<%=StringUtil.escapeStr(strValue)%>" <% if (! showColumn[colCount]) {%>style="display:none"<% } %>><%if (addHidden[colCount]) { %><%//se agrega un input dummy para que cuando martin selecciona un renglon, no se pierda el valor del otro input %><input type="hidden" name="dummy" id="dummy" value=""><input type="hidden" name="<%= rowCount * count %>" id="<%= rowCount * count %>" value="<%= (obj == null)?"":(obj instanceof Double)?Integer.toString(((Double) obj).intValue()):obj.toString() %>"><%}%><%=strValue%></td><%colCount++;
									} %></tr><%
								rowCount ++;
								if (rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)) {
									break;
								}
							} %></tbody><%}%></table></div><%if (queryVo.getFlagValue(QueryVo.FLAG_PAGED_QUERY)) { %><%@include file="../../../includes/navButtonsQueryOnLine.jsp" %><%} 
					//if ((rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)) && iteratorFilas.hasNext()) { 
					if (rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)){
						if (queryVo.getMoreData() || iteratorFilas.hasNext()){ %><center><br><%=LabelManager.getName("lblMoreData")%></center><%}
					}		
				} else {
					%><form id="frmMain" name="frmMain" method="POST"></form><% 
					if(!queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST)){
						if (!(queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0)) { %></DIV><center><br><%=LabelManager.getName(labelSet,"lblNoData")%></center><%}
					}
				}%><input type="hidden" name="hddSelRowData" id="selRowData" value=""><input type="hidden" name="qryAction" id="qryAction" value=""></form><%}%><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></div><%if ((queryVo.getCharts().size() > 0) && !onlyGrid){ %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabCharts")%>" tabText="<%=LabelManager.getName(labelSet,"tabCharts")%>"><DIV class="subTit"></DIV><table class="tblFormLayout"><COL class="col1" /><COL class="col2" /><COL class="col3" /><COL class="col4" /><tr><td><%=LabelManager.getName(labelSet,"tabCharts")%>:</td><td><select name="cmbChartsDef" id="cmbChartsDef" onchange="chtGraphChange()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblType")%>"><% Iterator itChartsDef = queryVo.getCharts().iterator();
	   				    	   while (itChartsDef.hasNext()){
							   	QryChartVo chartVo = (QryChartVo)itChartsDef.next();%><option value="<%=chartVo.getQryChtId()%>"%><%=chartVo.getQryChtTitle()%></option><%}%></select></td><td align="right"><button type="button" onclick="btnZoomAdd()" title="addZoom" id="addZoom">Zoom +</button></td><td align="left"><button type="button" onclick="btnZoomRem()" title="remZoom" id="remZoom">Zoom -</button></td></tr><tr><td colspan="4" align = "center"><% Iterator itCharts = queryVo.getCharts().iterator();
     				if (itCharts.hasNext()){
						QryChartVo chartVo = (QryChartVo)itCharts.next(); %><div style="width:90%;height:600px;overflow:auto;position:relative"><img height=600 width=1000 align = "center" id="imgGraph" src=""></div><%}%></td></tr></table></div><%} %></div></div><TABLE class="pageBottom"><COL class="col1" /><COL class="col2" /><TR><TD><% if (dBean.getQueryVo().getData() != null) { 
					if (queryVo.hasActions()&& queryVo.getDbConId() != null && queryVo.getDbConId().equals(new Integer(-1))) { %><%=LabelManager.getName(labelSet,"lblQryActions")%>: <select name="selQryAction" id="selQryAction"><% if (queryVo.getAction(QueryVo.ACTION_VIEW_QUERY)) {
								Collection col = queryVo.getActionsTo();
								if (col != null && col.size() > 0) {
									for (Iterator it = col.iterator(); it.hasNext(); ) {
										QryNavigationVo navVo = (QryNavigationVo) it.next(); %><option allowAutoFilterSelect="<%= navVo.getFlagValue(QryNavigationVo.FLAG_ALLOW_USER_SELECT_AUTO_FILTER) %>" value="<%= QueryVo.ACTION_VIEW_QUERY %>_<%= navVo.getQryToId() %>"><%=LabelManager.getName(labelSet,"lblQryActVieQry")%>: <%= navVo.getQryToTitle() %></option><%
									} 
								} 
							} %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_FORM)) { %><option value="<%= QueryVo.ACTION_VIEW_FORM %>"><%=LabelManager.getName(labelSet,"lblQryActVieFor")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_ENTITY)) { %><option value="<%= QueryVo.ACTION_VIEW_ENTITY %>"><%=LabelManager.getName(labelSet,"lblQryActVieEnt")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_PROCESS)) { %><option value="<%= QueryVo.ACTION_VIEW_PROCESS %>"><%=LabelManager.getName(labelSet,"lblQryActViePro")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_VIEW_TASK)) { %><option value="<%= QueryVo.ACTION_VIEW_TASK %>"><%=LabelManager.getName(labelSet,"lblQryActVieTas")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_WORK_ENTITY)) { %><option value="<%= QueryVo.ACTION_WORK_ENTITY %>"><%=LabelManager.getName(labelSet,"lblQryActWorEnt")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_WORK_TASK)) { %><option value="<%= QueryVo.ACTION_WORK_TASK %>"><%=LabelManager.getName(labelSet,"lblQryActWorTas")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_ACQUIRE_TASK)) { %><option value="<%= QueryVo.ACTION_ACQUIRE_TASK %>"><%=LabelManager.getName(labelSet,"lblQryActAcqTas")%></option><% } %><% if (queryVo.getAction(QueryVo.ACTION_COMPLETE_TASK)) { %><option value="<%= QueryVo.ACTION_COMPLETE_TASK %>"><%=LabelManager.getName(labelSet,"lblQryActComTas")%></option><% } %></select><button type="button" onclick="btnAction_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAction")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAction")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAction")%></button><% 
					}
					
					if (queryVo.hasActions()&& !new Integer(-1).equals(queryVo.getDbConId()) && queryVo.getAction(QueryVo.ACTION_VIEW_QUERY)) { %><%=LabelManager.getName(labelSet,"lblQryActions")%>: <select name="selQryAction" id="selQryAction"><% if (queryVo.getAction(QueryVo.ACTION_VIEW_QUERY)) {
								Collection col = queryVo.getActionsTo();
								if (col != null && col.size() > 0) {
									for (Iterator it = col.iterator(); it.hasNext(); ) {
										QryNavigationVo navVo = (QryNavigationVo) it.next(); %><option value="<%= QueryVo.ACTION_VIEW_QUERY %>_<%= navVo.getQryToId() %>"><%=LabelManager.getName(labelSet,"lblQryActVieQry")%>: <%= navVo.getQryToTitle() %></option><%
									} 
								} 
							} %></select><button type="button" onclick="btnAction_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAction")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAction")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAction")%></button><%}
				}%></TD><TD><%if (!fromQryUrl){ %><%if(request.getAttribute("onlyFilter")==null){%><button onclick="btnRefresh_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAct")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAct")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAct")%></button><% } %><% if (!queryVo.getFlagValue(QueryVo.FLAG_PAGED_QUERY)) { %><% if (request.getAttribute("onlyFilter")==null && queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button type="button" onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %><% if (request.getAttribute("onlyFilter")==null && queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_PRINT)) { %><button type="button" onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><% } %><% }%><% if (dBean.getActionsCall() != null && dBean.getActionsCall().size() > 0) { %><button type="button" onclick="btnAnt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><% }%><%}%><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><%} %><form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form></body></HTML><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/query/filter.js'></script><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/query/dataQuery.js'></script><script language='javascript' defer="defer" defer>
var FROM_URL = <%=fromQryUrl%>;
var ON_FINISH = <%=onFinish.toString()%>;
var OPEN_FILTER = <%= qBean.isOpenFilter() %>;
var SIZE_X = 700;
var SIZE_Y = 300;
var BGC;

function initImgStyle(){
	BGC = null;
	if (document.body.currentStyle){
		var oStyleSheet=document.styleSheets[0];
		var oRule=oStyleSheet.rules[0];
		BGC = oRule.style.backgroundColor;
	}
	if (BGC == null || BGC == "") {
		var BGCAux = "(255,255,255)"
		try { BGCAux=window.getComputedStyle(document.body,"").getPropertyValue("background-color"); } catch(e) {}
		BGCAux=BGCAux.split("(")[1];
		BGCAux=BGCAux.split(")")[0];
		BGC="#";
		BGC+=( (parseInt(BGCAux.split(",")[0]).toString(16)) + (parseInt(BGCAux.split(",")[1]).toString(16)) + (parseInt(BGCAux.split(",")[2]).toString(16)) );
	}
	if (document.getElementById("imgGraph") != null){
		document.getElementById("imgGraph").style.width=SIZE_X+"px";
		document.getElementById("imgGraph").style.height=SIZE_Y+"px";
		if(document.getElementById("cmbChartsDef")){
			document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/query/administration/query/chart.jsp?chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&UID="+Math.random();
		}
	}
}
function chtGraphChange(){
	//Mostramos la grafica seleccionada
	if(document.getElementById("imgGraph")){
		document.getElementById("imgGraph").style.width=SIZE_X+"px";
		document.getElementById("imgGraph").style.height=SIZE_Y+"px";
		if(document.getElementById("cmbChartsDef")){
			document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/query/administration/query/chart.jsp?chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&UID="+Math.random();
		}
	}
}

function btnBack_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=backToQuery&query=<%=queryVo.getQryId()%>";
	submitForm(document.getElementById("frmMain"));
}
function btnZoomAdd(){
	SIZE_X += 100;
	SIZE_Y += 100;
	if(document.getElementById("imgGraph")){
		if(document.getElementById("cmbChartsDef")){
			document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/query/administration/query/chart.jsp?chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&UID="+Math.random();
		}		
		document.getElementById("imgGraph").style.width=SIZE_X+"px";
		document.getElementById("imgGraph").style.height=SIZE_Y+"px";
	}
}
function btnZoomRem(){
	if (SIZE_X > 100 && SIZE_Y > 100){
		SIZE_X -= 100;	
		SIZE_Y -= 100;
		if(document.getElementById("imgGraph")){
			document.getElementById("imgGraph").style.width=SIZE_X+"px";
			document.getElementById("imgGraph").style.height=SIZE_Y+"px";
			if(document.getElementById("cmbChartsDef")){			
				document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/query/administration/query/chart.jsp?chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&UID="+Math.random();
			}
		}
	}
}

function tabSwitch() {
}

function doOnLoad() {
	
	SIZE_X = getStageWidth() - 200;
	SIZE_Y = getStageHeight() - 250;

	if(document.getElementById("cmbChartsDef")){	
		document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/query/administration/query/chart.jsp?chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&UID="+Math.random();
		document.getElementById("imgGraph").style.width=SIZE_X+"px";
		document.getElementById("imgGraph").style.height=SIZE_Y+"px";
	}
	
	if (OPEN_FILTER) toggleFilterSection();
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", initImgStyle, false);
}else{
	initImgStyle();
}

function stringType(field) {
	var rets = openModal("/programs/query/administration/filter/string.jsp?type=" + document.getElementById(field).value,500,200);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function numberType(field) {
	var rets = openModal("/programs/query/administration/filter/number.jsp?type=" + document.getElementById(field).value,500,220);
	var doAfter=function(rets){
		if (rets != null) {
			document.getElementById(field).value = rets;
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


</script>
