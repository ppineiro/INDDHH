<%@page import="com.dogma.bean.administration.WidgetBean"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.filter.*"%><%@page import="org.jfree.chart.ChartFrame"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.st.util.translator.TranslationManager"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><%
//<jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean">
//</jsp:useBean>

String widIdStr = request.getParameter("widId");
String beanName = "wBean" + widIdStr;
com.dogma.bean.administration.WidgetBean wBean = (com.dogma.bean.administration.WidgetBean)session.getAttribute(beanName);
if(wBean == null){
	wBean = new WidgetBean();
	wBean.initEnv(request);
	session.setAttribute(beanName, wBean);
}

com.dogma.bean.administration.WidgetBean dBean = wBean;
Date nowDate = new Date();
Integer dshId = null;
HashMap widProperties = null;
if (request.getParameter("dshId")!=null){ //Si es un dashboard y no una ventana de visualizacion de hijos o de visualizacion de query
	dshId = new Integer(request.getParameter("dshId"));
	widProperties = wBean.getWidProperties(dshId);
}
Integer widId = new Integer(request.getParameter("widId"));
Integer cantInformation = wBean.getCantInformation(widId);
Collection widCol = wBean.getWidChilds(widId); //Obtenemos los hijos del widget
WidgetVo widVo = wBean.getWidgetVo(widId);
Integer refTimeType = widVo.getWidRefType();
int refTime = 60; //por defecto
if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_SEC.intValue()){ //segundos
	refTime = widVo.getWidRefresh().intValue() * 1000;
}else if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_MIN.intValue()){//minutos
	refTime = widVo.getWidRefresh().intValue() * 60 * 1000;		
}else{
	refTime = widVo.getWidRefresh().intValue() * 60 * 60 * 1000;	
}
Integer qryId = widVo.getWidSrcId();
String filters = wBean.getWidgetFilters(widVo, request);//Obtenemos los filtros para abrir en una ventana aparte la consulta
Collection ret = dBean.executeQuery(widVo,request); //<----- Ejecutamos la query
if (ret!=null && ret.size()>0){
	Iterator itRet = ret.iterator();
	Object obje = itRet.next();
	if (obje==null){
		Integer error = (Integer)itRet.next();
		String errorMsg = (String)itRet.next();
	%><HTML><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><meta http-equiv="REFRESH" content="5"><%//Hacemos que en 5 segundos intente nuevamente %></head><body style="align:center;vertical-align:middle"><table style="width:475px;height:200px"><tr><td valign="middle"><%
						if (error.intValue() == 1){//ERROR EN LA CLASE DE NEGOCIO DEL USUARIO%><%=errorMsg%><%
						}else{ // OTRO ERROR %><%=errorMsg%><%
						}%></td></tr></table></body></html><%}else{
	QueryVo queryVo = dBean.getQueryVo();
	Collection charts = queryVo.getCharts();
	Iterator itAllCharts = charts.iterator();
	
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
	boolean viewGrid = false; //<<--------------------MODIFICAR SI SE QUIERE MOSTRAR LA GRILLA
	boolean viewWidName = false; 
	boolean viewBtnChilds = true; //valor por defecto
	boolean viewBtnHistory = true; //valor por defecto
	boolean viewBtnRefresh = false; //valor por defecto
	boolean viewBtnComments = false; //valor por defecto
	boolean viewBtnInfo = false; //valor por defecto
	Double widgetWidth = Double.valueOf(350); //ancho del widget
	Double widgetHeight = Double.valueOf(300); //largo del widget
	if (widProperties != null){
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_NAME)!=null){
			viewWidName = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_NAME)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_CHILDS)!=null){
			viewBtnChilds = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_CHILDS)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_HISTORY)!=null){
			viewBtnHistory = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_HISTORY)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_REFRESH)!=null){
			viewBtnRefresh = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_REFRESH)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_COMMENTS)!=null){
			viewBtnComments = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_COMMENTS)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_INFO)!=null){
			viewBtnInfo = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_INFO)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)!=null){
			widgetWidth = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)).getPropValue());
		}
		if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)!=null){
			widgetHeight = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)).getPropValue());
		}
	}
	
	Double contWidth = widgetWidth - 90; //Ancho del div que contiene el gráfico
	Double contHeight = widgetHeight - 110; //Largo del div que contiene el gráfico
	Double imgWidth = contWidth - 10;    //Ancho de la imagen
	Double imgHeight = contHeight - 10;  //Largo de la imagen
	%><HTML><head><meta http-equiv="REFRESH" content="<%=refTime%>"><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><input type="hidden" id="txtLastUpdate" value="<%=dBean.fmtHTMLTime(nowDate)%>" /><div id="widContent"><%if (!viewGrid){ %><%
		double nameSize = widVo.getWidName().length();
		double titleSize = widVo.getWidTitle().length();
		int maxTitleSize = Double.valueOf(widgetWidth / 9).intValue();
		String widName = widVo.getWidName().length()>maxTitleSize?widVo.getWidName().substring(0,maxTitleSize)+"..":widVo.getWidName();
		String widTitle = widVo.getWidTitle().length()>maxTitleSize?widVo.getWidTitle().substring(0,maxTitleSize)+"..":widVo.getWidTitle();
		String widDesc = widVo.getWidDesc();
   	 	boolean hasDesc = widDesc!=null && !"".equals(widDesc) && !"null".equals(widDesc);
		if (viewWidName){
			if (widTitle!=null && !"".equals(widTitle)){%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidTitle()+"\""%>><%=widTitle%></DIV><%}else{%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidName()+"\""%>><%=widName%></DIV><%}
		}else{%><DIV style="position:relative;height:28px;width:20px;></DIV><%} %><table class="tblFormLayout"><tr><td><%=LabelManager.getName(labelSet,"tabCharts")%>:</td><td><select name="cmbChartsDef" id="cmbChartsDef" onchange="chtGraphChange()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblType")%>"><% Iterator itChartsDef = queryVo.getCharts().iterator();
	   		    	   while (itChartsDef.hasNext()){
						   	QryChartVo chartVo = (QryChartVo)itChartsDef.next();%><option value="<%=chartVo.getQryChtId()%>"%><%=chartVo.getQryChtTitle()%></option><%}%></select></td><td align="right"><button type="button" onclick="btnZoomAdd()" title="addZoom" id="addZoom">Zoom +</button></td><td align="left"><button type="button" onclick="btnZoomRem()" title="remZoom" id="remZoom">Zoom -</button></td></tr></table><% Iterator itCharts = queryVo.getCharts().iterator();
    		if (itCharts.hasNext()){
				QryChartVo chartVo = (QryChartVo)itCharts.next(); %><div style="width:<%=contWidth%>;height:<%=contHeight%>px;overflow:auto;position:static;"><img id="imgGraph" src="" width="<%=imgWidth%>" height="<%=imgHeight%>" /></div><%}%></div><%}else{ %><div id="widContent"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"><%if (queryVo.getCharts().size() > 0){ %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabCharts")%>" tabText="<%=LabelManager.getName(labelSet,"tabCharts")%>"><DIV class="subTit"></DIV><table class="tblFormLayout"><COL class="col1" /><COL class="col2" /><COL class="col3" /><COL class="col4" /><tr><td><%=LabelManager.getName(labelSet,"tabCharts")%>:</td><td><select name="cmbChartsDef" id="cmbChartsDef" onchange="chtGraphChange()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblType")%>"><% Iterator itChartsDef = queryVo.getCharts().iterator();
	   				    	   while (itChartsDef.hasNext()){
							   	QryChartVo chartVo = (QryChartVo)itChartsDef.next();%><option value="<%=chartVo.getQryChtId()%>"%><%=chartVo.getQryChtTitle()%></option><%}%></select></td><td><button type="button" onclick="btnZoomAdd()" title="addZoom" id="addZoom">Zoom +</button></td><td><button type="button" onclick="btnZoomRem()" title="remZoom" id="remZoom">Zoom -</button></td></tr><tr><% Iterator itCharts = queryVo.getCharts().iterator();
     				if (itCharts.hasNext()){
						QryChartVo chartVo = (QryChartVo)itCharts.next(); %><td colspan="4" align = "center"><div style="width:<%=contWidth%>;height:<%=contHeight%>px;overflow:auto;position:relative"><img id="imgGraph" src="" width="<%=imgWidth%>" height="<%=imgHeight%>" ></div></td><%}%></tr></table></div><%} %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"sbtRes")%>" tabText="<%=LabelManager.getName(labelSet,"sbtRes")%>"><%int countRow=0;
			int rowCount=0;%><% if (dBean.getQueryVo().getData() != null) { %><%
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
					%><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")+": "+countRow+" "%><%=LabelManager.getName(labelSet,"lblResRegEnc")%></DIV><div type="grid" fastGrid="true" style="height:300px" id="queryGrid" multiSelect="false"><table class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><%
								Iterator columnas;
	 	 						Iterator iteratorFilas = dBean.getQueryVo().getPagedData().iterator();
	 	 						boolean[] addHidden = null;
	 	 						boolean[] showTime = null;
	 	 						boolean[] showColumn = null;
	 	 						boolean[] isHTML = null;
	 	 						QryColumnFilterVo[] hasFilterPossibleValues = null;
								int count = 0;
	 	 						
		 						if (queryVo.getShowColumns().size() > 0 && ! queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) {
									columnas = queryVo.getAllShowColumns().iterator();
									addHidden = new boolean[queryVo.getAllShowColumns().size()];
									showTime = new boolean[queryVo.getAllShowColumns().size()];
									showColumn = new boolean[queryVo.getAllShowColumns().size()];
									isHTML = new boolean[queryVo.getAllShowColumns().size()];
									
									hasFilterPossibleValues = new QryColumnFilterVo[queryVo.getAllShowColumns().size()];
									while (columnas.hasNext()) {
										QryColumnVo columna = (QryColumnVo) columnas.next(); 
										String colName = columna.getQryColName().toUpperCase();
										String auxName = null;
										showColumn[count] = ! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN); %><th align="center" title="<%= dBean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px;<% if (! showColumn[count]) {%>display:none<% } %>"><input type="hidden" name="<%= colName %>" id="<%= colName %>" value=""><%
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
				 						QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
										columnas = row.getColumnas().iterator();
										addHidden = new boolean[row.getColumnas().size()];
										showTime = new boolean[row.getColumnas().size()];
										showColumn = new boolean[row.getColumnas().size()];
										isHTML = new boolean[row.getColumnas().size()];
										hasFilterPossibleValues = new QryColumnFilterVo[row.getColumnas().size()];
										while (columnas.hasNext()) { 
											Object obj = columnas.next(); 
											String colName = dBean.fmtHTMLObject(obj).toUpperCase();
											String auxName = null; %><th style="width:150px;"><input type="hidden" name="<%= colName %>" id="<%= colName %>" value=""><%
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
							int maxRows = 10;
							int rows = 0;
			  				while (iteratorFilas.hasNext()) {
		 						count = 0;
		 						rows ++;
		  						QryRowShowVo row = (QryRowShowVo) iteratorFilas.next(); %><tr><%
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
 									} else {
 										strValue=(((showTime[colCount] && obj != null && obj instanceof Date)?dBean.fmtHTMLTime((Date) obj):dBean.fmtHTMLObject(obj,"&nbsp;",setHTML)));
 									}
	 									
									//Si la columna tiene un filtro, se busca en los possiblevalues para ver si hay mapeo
									com.dogma.vo.filter.QryColumnFilterVo vo = (hasFilterPossibleValues!=null)?hasFilterPossibleValues[colCount]:null;
									if(vo!=null){
										strValue=vo.getPossibleValueForId(strValue);
									}
										 
 									%><td title="<%=StringUtil.escapeStr(strValue)%>" <% if (! showColumn[colCount]) {%>style="display:none"<% } %>><%if (addHidden[colCount]) { %><input type="hidden" name="<%= rowCount * count %>" id="<%= rowCount * count %>" value="<%= (obj == null)?"":(obj instanceof Double)?Integer.toString(((Double) obj).intValue()):obj.toString() %>"><%}%><%=strValue%></td><%colCount++;
								} %></tr><%
								rowCount ++;
								if (rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)) {
									break;
								}
							} %></tbody></table><%}%></div><%if (queryVo.getFlagValue(QueryVo.FLAG_PAGED_QUERY)) { %><%@include file="../../../includes/navButtonsQueryOnLine.jsp" %><%} 
					//if ((rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)) && iteratorFilas.hasNext()) { 
					if (rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)){
						if (queryVo.getMoreData() || iteratorFilas.hasNext()){ %><center><br><%=LabelManager.getName("lblMoreData")%></center><%}
					}		
				} else {
					
					if(!queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST)){
						if (!(queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0)) { %></DIV><center><br><%=LabelManager.getName(labelSet,"lblNoData")%></center><%}
					}
				}%><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME><input type="hidden" name="hddSelRowData" id="selRowData" value=""><input type="hidden" name="qryAction" id="qryAction" value=""></div></div></form></div><%} %><DIV style="border-top:1px solid #999999"><% if (viewBtnChilds){%><span><img onclick="viewChilds()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblVwWidChilds")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/childs.png"></span><%}
		if (viewBtnHistory){%><span><img onclick="openQryMode()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblOpeQryMode")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/openSrc.png"></span><%}
		if (viewBtnComments){%><span><img onclick="viewComments()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidComments")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/comments.png"></span><%}
		if (viewBtnInfo){%><span><img onclick="viewInfo()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidInfo")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/info.png"></span><%}
		if (viewBtnRefresh){%><span><img onclick="refresh()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidRefresh")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/refresh.png"></span><%}%></DIV></body></HTML><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/query/filter.js'></script><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/query/administration/query/dataQuery.js'></script><script language='javascript'>
var SIZE_X =<%=imgWidth%>;//403 
var SIZE_Y = <%=imgHeight%>; //288
var BGC;
function initImgStyle(){
	if (document.body.currentStyle){
		var oStyleSheet=document.styleSheets[0];
		var oRule=oStyleSheet.rules[0];
		BGC = oRule.style.backgroundColor;
	}else{
		var BGCAux=window.getComputedStyle(document.body,"").getPropertyValue("background-color");
		BGCAux=BGCAux.split("(")[1];
		BGCAux=BGCAux.split(")")[0];
		BGC="#";
		BGC+=( (parseInt(BGCAux.split(",")[0]).toString(16)) + (parseInt(BGCAux.split(",")[1]).toString(16)) + (parseInt(BGCAux.split(",")[2]).toString(16)) );
	}
	if (document.getElementById("imgGraph") != null){
		//document.getElementById("imgGraph").parentNode.style.width="500px";
		//document.getElementById("imgGraph").parentNode.style.height="410px";
		document.getElementById("imgGraph").style.width=SIZE_X+"px";
		document.getElementById("imgGraph").style.height=SIZE_Y+"px";
//		document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/query/qryChartWidget.jsp?widId="+ <%=widId%> +"&chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&cacheVar="+Math.random();
		setTimeout('document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/query/qryChartWidget.jsp?widId="+ <%=widId%> +"&chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&cacheVar="+Math.random();',900);
	}
}
function chtGraphChange(){
	//Mostramos la grafica seleccionada
	document.getElementById("imgGraph").style.width=SIZE_X+"px";
	document.getElementById("imgGraph").style.height=SIZE_Y+"px";
	document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/query/qryChartWidget.jsp?widId="+ <%=widId%> +"&chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&cacheVar="+Math.random();
}

function btnBack_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "query.QueryAction.do?action=backToQuery&query=<%=queryVo.getQryId()%>";
	submitForm(document.getElementById("frmMain"));
}
function btnZoomAdd(){
	SIZE_X += 20;
	SIZE_Y += 20;
	document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/query/qryChartWidget.jsp?widId="+ <%=widId%> +"&chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&cacheVar="+Math.random();
	document.getElementById("imgGraph").style.width=SIZE_X+"px";
	document.getElementById("imgGraph").style.height=SIZE_Y+"px";
}
function btnZoomRem(){
	if (SIZE_X - 20 <= 0 || SIZE_Y - 20 <= 0){
		SIZE_X = 193; //MINIMO VALOR EN X
		SIZE_Y = 13; //MINIMO VALOR EN Y
	}else{
		SIZE_X -= 20;
		SIZE_Y -= 20;
	}

	document.getElementById("imgGraph").style.width=SIZE_X+"px";
	document.getElementById("imgGraph").style.height=SIZE_Y+"px";
	document.getElementById("imgGraph").src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/query/qryChartWidget.jsp?widId="+ <%=widId%> +"&chtId=" + document.getElementById("cmbChartsDef").value+ "&sizeX="+SIZE_X+"&sizeY="+SIZE_Y+"&bgc="+escape(BGC)+"&cacheVar="+Math.random();
}

function viewChilds(){
	<% if (widVo!=null && widVo.getDshChildId()!=null){%>
		openModal("/programs/biExecution/dashboards/dashboard.jsp?dshId=<%=widVo.getDshChildId().intValue()%>",window.parent.getStageWidth()-50,window.parent.getStageHeight()-50);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoChilds").replace("<TOK1>",widVo.getWidName())%>");
	<%}%>
}
function refresh(){
	if(confirm("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidRefNow").replace("<TOK1>",widVo.getWidName())%>")){
		window.location.reload(true);
	}
}
function openQryMode(){
	openModal("/query.QueryAction.do?action=viewQuery&query="+<%=qryId%>+"&fromWidget=true<%=filters%>",window.parent.parent.getStageWidth()-50,window.parent.parent.getStageHeight()-50);
}
function viewComments(){
	openModal("/programs/biExecution/dashboards/dshComments.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>",660,400);
}
function viewInfo(){
	<%if (cantInformation>0){%>
		var width=700;
		var height=<%=70 + (40 * cantInformation)%>;
		var lastUpdate = document.getElementById("txtLastUpdate").value;
		openModal("/programs/biExecution/dashboards/dshInfo.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>&lastUpdate="+lastUpdate,width,height);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoInfo")%>");
	<%}%>
}
function tabSwitch() {
}

function doOnLoad() {
	var height;
	if(navigator.userAgent.indexOf("MSIE")>0){
		var height=document.body.parentNode.clientHeight;
		if(document.body.parentNode.clientHeight==0){
			height=document.body.clientHeight;
		}
	}else{
		height=window.innerHeight;
	}
	document.getElementById("widContent").style.position="relative";
	document.getElementById("widContent").style.height=(height-50)+"px";

}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", initImgStyle, false);
    document.addEventListener("DOMContentLoaded", doOnLoad, false);
}else{
	initImgStyle();
	doOnLoad();
}
</script><% }
}%>