<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.query.QueryBean"%><%@page import="com.dogma.business.querys.factory.QueryColumns" %><%@include file="../../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.EntInstanceBean"></jsp:useBean><%
com.dogma.bean.query.EntInstanceBean dBean = qBean;
boolean blnProcess = false;
boolean blnStatus = false;
boolean blnSpecific = true;

QueryVo queryVo = dBean.getQueryVo();
Iterator columnas = null;
Iterator iteratorFilas = null;

int posBusEntInstId = -1;
int posEnvId = -1;
int posNotShow = -1;
int posBusEntAdminType = -1;
int colsToShow = 1;

boolean[] showPosition = null;
boolean[] showTime = null;
boolean[] showHTML = null;

dBean.saveCookieFilters(request,response);
%><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeEnt")%><%if (blnSpecific) {%> : <%=queryVo.getQryTitle()%><%}%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME><form id="frmMain" name="frmMain" method="POST"><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
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
						} %></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><td></td><td><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></table></DIV><%}%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th align="center" style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblEjeSelTod")%>"></th><%

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
										showHTML[count] = columna.getFlagValue(QryColumnVo.FLAG_SHOW_TIME);
										if (! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN)) { %><th align="center" title="<%=dBean.fmtHTML(columna.getQryColTooltip())%>" style="width:<%=columna.getQryColWidth()%>px;"><%=dBean.fmtHTML(columna.getQryColHeadName())%></th><%
												headers.add(columna.getQryColHeadName().toUpperCase());
												showPosition[count] = true;
												colsToShow ++;
										} else {
											String colName = columna.getQryColName().toUpperCase();
											if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
												posBusEntInstId = count;
 											} else if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colName)) {
 												posEnvId = count;
 											} else if (QueryColumns.COLUMN_BUS_ENT_ADMIN_TYPE.equalsIgnoreCase(colName)) {
 												posBusEntAdminType = count;
 											} else if ("_NOT_SHOW".equalsIgnoreCase(colName)) {
 												posNotShow = count;
	 										}
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
 												showPosition[count] = true; %><th style="width:150px;"><%=dBean.fmtHTMLObject(colShow)%></th><%
												count ++;
												colsToShow ++;
	 										} 
	 										columnas = row.getColumnas().iterator();
 											count = 0;
	 										while (columnas.hasNext()) {
 												String colName = ((String) columnas.next()).toUpperCase();
	 											if (QueryColumns.COLUMN_BUS_ENT_INST_ID.equalsIgnoreCase(colName)) {
 													posBusEntInstId = count;
 												} else if (QueryColumns.COLUMN_ENV_ID.equalsIgnoreCase(colName)) {
 													posEnvId = count;
 												} else if (QueryColumns.COLUMN_BUS_ENT_ADMIN_TYPE.equalsIgnoreCase(colName)) {
	 												posBusEntAdminType = count;
 												} else if ("_NOT_SHOW".equalsIgnoreCase(colName)) {
	 												posNotShow = count;
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
							if (qBean.queryHasEmptyRequieredFilters()) { %><tr><td colspan="<%= colsToShow %>"><br><br><%=LabelManager.getName(labelSet,"lblQryMustFil")%><br><br><br></td></tr><% 
							} else {
	  							int count = 1;
	  							if (iteratorFilas != null) {
									Integer busEntId = new Integer(queryVo.getQryColumn(QueryColumns.COLUMN_BUS_ENT_ID,QryColumnVo.COLUMN_TYPE_FILTER).getQryColValue());
									int pos = 0;
									Object value = null;
									QryRowShowVo row = null;
									int i = 0;
									
		 			  				while (iteratorFilas.hasNext()) {
	 		 	  						row = (QryRowShowVo) iteratorFilas.next(); %><tr><td align="center" style="width:0px;display:none;"><input type="hidden" name="chkSel<%=i%>" value="off"><input type="hidden" name="txtEntId<%=i%>" value="<%= dBean.fmtInt(row.getValueInt(posBusEntInstId,true)) %>" id="idSel"><input type="hidden" name="txtBusEntId<%=i%>" value="<%=dBean.fmtInt(busEntId)%>"><input type="hidden" name="txtBusEntAdm<%=i%>" value="<%=dBean.fmtStr(row.getValueStr(posBusEntAdminType,false))%>"></td><%
		 									columnas = row.getColumnas().iterator();
	 										pos = 0;

	 										if ((queryVo.getData().size() > 1 && queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) || (!queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES))){
		 										if (((queryVo.getShowColumns().size() > 0) && (count != 1) && queryVo.getHasIncrement()) || ((queryVo.getShowColumns().size() > 0) && !queryVo.getHasIncrement()) || (queryVo.getShowColumns().size() == 0)) {
		 											while (columnas.hasNext()) { 
			 											value = columnas.next();
			 											if (pos < showPosition.length) {
			 												if (showPosition[pos]) {
			 													String strValue=((showTime[pos] && value != null && value instanceof Date)?dBean.fmtDateTime((Date) value):dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));%><td title="<%=strValue%>"><%=strValue%></td><%
					 										}
			 											} else {
			 												String strValue=(( value != null && value instanceof Date)?dBean.fmtDateTime((Date) value):dBean.fmtHTMLObject(value,"&nbsp;",showHTML[pos]));%><td title="<%=strValue%>"><%=strValue%></td><%
			 											}
			 											pos ++;
				 									}
		 										}
			 								}%></tr><%
	 	  								count ++;
	 									i++;
	 	 							}
	 	 						}
	 	 					} %></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><% if (! queryVo.isFirstTime()) { %><%@include file="../../../includes/navButtonsQuery.jsp" %><% } else { %><td></td><% } %><td><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_CLONE)) { %><button type="button" onclick="btnClo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnClo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnClo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnClo")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_NEW)) { %><button type="button" onclick="btnNew_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_ALTER)) { %><button type="button" onclick="btnMod_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_DELETE)) { %><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_DEP)) { %><button type="button" onclick="btnDep_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDep")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDep")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDep")%></button><% } %><% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/entity/list.js"></script><script>
	var internalDivType = "<%=com.dogma.DogmaConstants.SESSION_CMP_HEIGHT%>";
	var userConfirm = "<%=dBean.userConfirm%>";
	var msgUsrConfDel = '<%=LabelManager.getName(labelSet,DogmaException.EXE_BUS_ENT_INST_CANT_DELETE_REL_ASK)%>';
	window.document.onreadystatechange=function(){
		if(document.readyState=='complete'){
			if(userConfirm == "true"){
				var ret = confirm(msgUsrConfDel);
				if(ret==true){
					document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=remove&overrideRelations=true";
					submitForm(document.getElementById("frmMain"));
				}
			}
		}
	}
</script><script language="javascript" defer><% if (queryVo.getFlagValue(QueryVo.FLAG_DONT_EXECUTE_FIRST) && ! qBean.hasQueryHasBeenExecuted()) {%>
toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
<% } %></script><%@include file="../../../../components/scripts/server/endInc.jsp" %>
