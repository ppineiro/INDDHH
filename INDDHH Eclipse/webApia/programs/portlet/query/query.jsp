<%@page import="com.dogma.vo.filter.QryColumnFilterVo"%><%@page import="com.dogma.vo.QryColumnVo"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.custom.CmbDataVo"%><%@page import="java.util.Date"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.ParseException"%><%@page import="com.dogma.action.portlet.QueryAction"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.query.QueryBean"%><%@page import="com.dogma.vo.QueryVo"%><%@page import="java.util.Collection"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.business.querys.factory.QueryColumns"%><%@page import="com.dogma.vo.QryRowShowVo"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%!

public String getFilterHTML(QryColumnFilterVo filter, boolean toProcedure, boolean forceHidden, String labelSet, HttpSession session) {
	if (filter.getQryColumnVo().getFlagValue(QryColumnVo.FLAG_IS_COMBO)) {
		return this.getHTMLCombo(filter, false, forceHidden, session);
	
	} else if (filter.getQryColumnVo().getFlagValue(QryColumnVo.FLAG_IS_LISTCOMBO)) {
		return this.getHTMLCombo(filter, true, forceHidden, session);
	
	} else {
		return this.getHTMLInput(toProcedure, filter, forceHidden, labelSet, session);
	}
}

private String getHTMLInput(boolean toProcedure, QryColumnFilterVo filter, boolean forceHidden, String labelSet, HttpSession session) {
	StringBuffer buffer = new StringBuffer("");
	StringBuffer onChangeScript = new StringBuffer();
	
	buffer.append("<input name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "\" ");
	buffer.append("type=\"" + (forceHidden ? "hidden" : "text") + "\" ");
	buffer.append("value=\"" + StringUtil.replace(filter.getValueAsString(0,false), "\"", "&quot;") + "\" ");
	buffer.append("title=\"" + filter.getQryColumnVo().getQryColHeadName() + "\" ");
	
	if (! forceHidden) {
		if (QryColumnVo.COLUMN_DATA_STRING.equals(filter.getQryColumnVo().getQryColDataType()) || QryColumnVo.COLUMN_DATA_NUMBER.equals(filter.getQryColumnVo().getQryColDataType())) {
			if (filter.getQryColumnVo().getAttributeVo() != null) {
				Integer length = filter.getQryColumnVo().getAttributeVo().getAttLength();
				if (length != null && length.intValue() != 0) {
					buffer.append("maxlenght=\"" + length.toString() + "\" ");
				}
			}
		}

		if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType())) {
			buffer.append("size=\"10\" ");
		}
		
		if (QryColumnVo.COLUMN_DATA_NUMBER.equals(filter.getQryColumnVo().getQryColDataType())) onChangeScript.append("if(!validateNumber(this)){return false;}");
		if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType())) onChangeScript.append("valDate = isDate(this,'');	if(valDate[0]==false){ return false; };");
		if (filter.getQryColumnVo().getFlagValue(QryColumnVo.FLAG_EXECUTE_ONCHANGE)) onChangeScript.append("document.getElementById('action" + session.getId() + "').value='event'; document.getElementById('apiaFilterBtn" + session.getId() + "').click();");
		
		if (onChangeScript.length() > 0) {
			buffer.append("onchange=\"" + onChangeScript.toString() + "\" ");
		}
	}
	
	buffer.append(">");
	
	if (!forceHidden) {
		if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType()) || filter.getParameterMask() != null) {
			if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType())) {
				buffer.append(" (nn/nn/nnnn) ");
			} else {
				buffer.append(" (" + filter.getParameterMask() + ") ");
			}
		}
	}
	
	if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType()) && filter.getQryColumnVo().getFlagValue(filter.getQryColumnVo().FLAG_SHOW_TIME)) {
		if (! forceHidden) {
			buffer.append("<input type=\"text\" name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "h\" maxlength=\"5\" size=5 value=\"" + filter.getHourMinute(filter.getValue(0)) + "\" >");
			buffer.append(" (" + StringUtil.replaceAll(DogmaUtil.getHTMLTimeMask(),"'","") + ") ");
		} else {
			buffer.append("<input type=\"hidden\" name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "h\" value=\"" + filter.getHourMinute(filter.getValue(0)) + "\" >");
		}
	}

	if ((!toProcedure) && QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType())) {
		if (! forceHidden) {
			buffer.append(" -  <input name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "i\" type=\"text\" size=\"10\" value=\"" + StringUtil.replace(filter.getValueAsString(1,false), "\"", "&quot;") + "\" ");
			if (onChangeScript.length() > 0) {
				buffer.append("onchange=\"" + onChangeScript.toString() + "\" ");
			}
			buffer.append(">");
			buffer.append(" (nn/nn/nnnn) ");
			if (QryColumnVo.COLUMN_DATA_DATE.equals(filter.getQryColumnVo().getQryColDataType()) && filter.getQryColumnVo().getFlagValue(filter.getQryColumnVo().FLAG_SHOW_TIME)) {
				buffer.append("<input type=\"text\" name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "ih\" maxlength=\"5\" size=5 value=\"" + filter.getHourMinute(filter.getValue(1)) + "\" >");
				buffer.append(" (" + StringUtil.replaceAll(DogmaUtil.getHTMLTimeMask(),"'","") + ")");
			}
		} else {
			buffer.append("<input name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "i\" type=\"hidden\" value=\"" + StringUtil.replace(filter.getValueAsString(1,false), "\"", "&quot;") + "\">");
			buffer.append("<input type=\"hidden\" name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "ih\" value=\"" + filter.getHourMinute(filter.getValue(1)) + "\" >");
		}
	}
	
	return buffer.toString();
}

private String getHTMLCombo(QryColumnFilterVo filter, boolean multiple, boolean forceHidden, HttpSession session) {
	StringBuffer buffer = new StringBuffer();
	Object value = filter.getValue();
	
	if (! forceHidden) {
		buffer.append("<select " + (multiple ? "multiple " : "") + " ");
		buffer.append("name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "\" ");

		if (filter.getQryColumnVo().getFlagValue(QryColumnVo.FLAG_EXECUTE_ONCHANGE)) {
			buffer.append("onchange=\"document.getElementById('action" + session.getId() + "').value='event'; document.getElementById('apiaFilterBtn" + session.getId() + "').click();\" ");
		}
		
		buffer.append(">");
		if (!multiple) buffer.append("<option value=\"\"></option>");
		
		if (filter.getPossibleValues() != null) {
			Iterator iterator = filter.getPossibleValues().iterator();
			CmbDataVo dataVo = null;
			while (iterator.hasNext()) {
				dataVo = (CmbDataVo) iterator.next();
				Object cmbValue = dataVo.getValue();
				if (value instanceof Double) {
					cmbValue = new Double((String) cmbValue);
				}
				if (value instanceof Date) {
					SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
					try {
						cmbValue = sdf.parse(cmbValue.toString());
					} catch (ParseException e) {
					}
					
				}
				buffer.append("<option value=\"" + StringUtil.replace(dataVo.getValue(), "\"", "&quot;") + "\"" + (cmbValue.equals(value)?" selected":"") + ">" + dataVo.getText() + "</option>");
			}
		}
		
		buffer.append("</select>");
	} else {
		if (value == null) value = "";
		buffer.append("<input type=\"hidden\" name=\"" + QueryAction.FIL_PARAM_PREFIX + filter.getFilterId() + "\" value=\"" + StringUtil.replace(value.toString(), "\"", "&quot;") + "\">");
	}
	
	return buffer.toString();
}


%><%
QueryBean bean		= (QueryBean) request.getSession().getAttribute("apiaPortletBean");
QueryVo queryVo		= bean.getQueryVo();
UserData userData	= bean.getUserData(request);
String labelSet		= userData.getStrLabelSetId();
Integer envId		= userData.getEnvironmentId();
%><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,"titQry")%>:</b><%=bean.fmtHTML(TranslationManager.getQueryTitle(queryVo.getQryName(),queryVo.getQryTitle(),userData.getEnvironmentId(), userData.getLangId()))%></div><div class="apiaDesc"><b><%=LabelManager.getName(labelSet,"lblDes")%>:</b><%=bean.fmtHTML(TranslationManager.getQueryDesc(queryVo.getQryName(),queryVo.getQryDesc(),userData.getEnvironmentId(), userData.getLangId()))%></div><% if (queryVo.getWhereUserColumns() != null && queryVo.getWhereUserColumns().size() > 0) { %><hr><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,"sbtFil")%></b></div><div class="apiaContainer"><form action="QueryAction.portlet" method="post"><%
			/*for (String key : params.keySet()) {
				String value = params.get(key);
				if (value == null) value = ""; %><input type="hidden" name="<%= key %>" value="<%= value %>"><%}*/
			
			for (QryColumnFilterVo filter : (Collection<QryColumnFilterVo>) queryVo.getFilters()) {
				if (filter.getQryColumnVo().FUNCTION_NONE == filter.getFunction() && ! filter.isHidden()) { %><div class="apiaFilter"><b title="<%= bean.fmtHTML(filter.getQryColumnVo().getQryColTooltip()) %>"><%= bean.fmtHTML(filter.getQryColumnVo().getQryColHeadName()) %></b>: <%= this.getFilterHTML(filter, queryVo.getFlagValue(QueryVo.FLAG_TO_PROCEDURE),false,labelSet,session) %></div><% }
			} %><input type="hidden" name="action" id="action<%= session.getId() %>" value="filter"><input type="submit" id="apiaFilterBtn<%= session.getId() %>" value="<%=LabelManager.getName(labelSet,"btnBus")%>"></form><%
		%></div><% } 
	int countRow=0;
	int rowCount=0;
	
	countRow = (queryVo.getData() == null) ? 0 : queryVo.getData().size(); //countRow = bean.getQueryVo().getPagedData().size();
	if (queryVo.getHasIncrement()) countRow--;
	
	%><hr><div class="apiaTitle"><b><%=LabelManager.getName(labelSet,"sbtRes") %>: </b><%= countRow  %><%=LabelManager.getName(labelSet,"lblResRegEnc")%></div><% if (countRow > 0) { %><table cellpadding="0" cellspacing="0" class="apiaTitle"><thead><tr><%
					Iterator columnas;
					Iterator iteratorFilas = bean.getQueryVo().getPagedData().iterator();
					boolean[] showTime = null;
					boolean[] showColumn = null;
					boolean[] isHTML = null;
					QryColumnFilterVo[] hasFilterPossibleValues = null;
					
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
					
					int count = 0;
							
						if (queryVo.getShowColumns().size() > 0 && ! queryVo.getFlagValue(QueryVo.FLAG_ALL_ATTRIBUTES)) {
						columnas = queryVo.getAllShowColumns().iterator();
						showTime = new boolean[queryVo.getAllShowColumns().size()];
						showColumn = new boolean[queryVo.getAllShowColumns().size()];
						isHTML = new boolean[queryVo.getAllShowColumns().size()];
						
						hasFilterPossibleValues = new QryColumnFilterVo[queryVo.getAllShowColumns().size()];
						while (columnas.hasNext()) {
							QryColumnVo columna = (QryColumnVo) columnas.next(); 
							String colName = columna.getQryColName().toUpperCase();
							showColumn[count] = ! columna.getFlagValue(QryColumnVo.FLAG_IS_HIDDEN); %><th align="center" title="<%= bean.fmtHTML(columna.getQryColTooltip()) %>" style="width:<%=columna.getQryColWidth()%>px;<% if (! showColumn[count]) {%>display:none<% } %>"><%
								
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
									out.print(bean.fmtHTML(TranslationManager.getAttTitle(columna.getQryColName(), columna.getQryColHeadName(), userData.getEnvironmentId(), userData.getLangId())));
								}else{
									out.print(bean.fmtHTML(columna.getQryColHeadName()));
								}%></th><%
						} 
						} else {
						if (iteratorFilas.hasNext()) {
	 						QryRowShowVo row = (QryRowShowVo) iteratorFilas.next();
							columnas = row.getColumnas().iterator();
							showTime = new boolean[row.getColumnas().size()];
							showColumn = new boolean[row.getColumnas().size()];
							isHTML = new boolean[row.getColumnas().size()];
							hasFilterPossibleValues = new QryColumnFilterVo[row.getColumnas().size()];
							while (columnas.hasNext()) { 
								Object obj = columnas.next(); 
								String colName = bean.fmtHTMLObject(obj).toUpperCase(); %><th style="width:150px;"><%
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
									count ++; %><%=bean.fmtHTMLObject(obj)%></th><%
							} 
						}
					} %></tr></thead><tbody><%
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
											strValue=(bean.fmtHTMLObject(TranslationManager.getProcTitle(proName, obj.toString(), userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}
								
									} else if (colCount == posTskTitle){
										if(posTskName != -1){
											tskName = showColumns.get(posTskName).toString(); 
											strValue=(bean.fmtHTMLObject(TranslationManager.getTaskTitle(tskName, obj.toString(), userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}
									} else if (colCount == posBusEntTitle){
										if(posBusEntName != -1){
											busEntName = showColumns.get(posBusEntName).toString(); 
											strValue=(bean.fmtHTMLObject(TranslationManager.getBusEntTitle(busEntName, obj.toString(), userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}

									} else if (colCount == posFrmTitle){
										if(posFrmName != -1){
											frmName = showColumns.get(posFrmName).toString(); 
											strValue=(bean.fmtHTMLObject(TranslationManager.getFrmTitle(frmName, obj.toString(), userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}
										
									} else if (colCount == posAttTitle){
										if(posAttName != -1){
											attName = showColumns.get(posAttName).toString(); 
											strValue=(bean.fmtHTMLObject(TranslationManager.getAttTitle(attName, obj.toString(), userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}
										
									} else if (colCount == posAttDesc){
										if(posAttName != -1){
											attName = showColumns.get(posAttName).toString(); 
											String originalValue = "";
											if(obj != null){
												originalValue = obj.toString();	
											}
											strValue=(bean.fmtHTMLObject(TranslationManager.getAttDesc(attName, originalValue, userData.getEnvironmentId(),userData.getLangId()),"&nbsp;",setHTML));
											
										}else{
											strValue=(bean.fmtHTMLObject(obj,"&nbsp;",setHTML));
										}
								
								
									} else {
										strValue=(((showTime[colCount] && obj != null && obj instanceof Date)?bean.fmtDateTime((Date) obj):bean.fmtHTMLObject(obj,"&nbsp;",setHTML)));
										
									}
									
									//Si la columna tiene un filtro, se busca en los possiblevalues para ver si hay mapeo
								com.dogma.vo.filter.QryColumnFilterVo vo = (hasFilterPossibleValues!=null)?hasFilterPossibleValues[colCount]:null;
								if(vo!=null){
									strValue=vo.getPossibleValueForId(strValue);
								}

								 
									%><td <% if (! showColumn[colCount]) {%>style="display:none"<% } %>><%=strValue%></td><%colCount++;
						} %></tr><%
					rowCount ++;
					if (rowCount == (Parameters.MAX_RESULT_QUERY.intValue()+1)) {
						break;
					}
				} %></tbody></table><% if (bean.getQueryVo().getFlagValue(QueryVo.FLAG_PAGED_QUERY)) { %><div class="apiaButtons"><form action="QueryAction.portlet" method="post"><input type="hidden" value="page" name="action"><input type="submit" value="&lt;&lt;" onclick="document.getElementById('qryPage<%= session.getId() %>').value = '1';"><input type="submit" value="&lt;"  onclick="document.getElementById('qryPage<%= session.getId() %>').value = '<%= bean.getPageNumber() - 1%>';"><input type="text" value="<%= bean.getPageNumber() %>" name="qryPage" id="qryPage<%= session.getId() %>" size="2"><%=LabelManager.getName(labelSet,"lblNavOf")%><%= bean.getTotalPages() %><input type="submit" value="&gt;" onclick="document.getElementById('qryPage<%= session.getId() %>').value = '<%= bean.getPageNumber() + 1%>';"><input type="submit" value="&gt;&gt;"  onclick="document.getElementById('qryPage<%= session.getId() %>').value = '<%= bean.getTotalPages() %>';"></form></div><%
		}
	} %><script language="javascript" type="text/javascript"><!--
var GNR_JANUARY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JANUARY))%>";
var GNR_FEBRUARY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FEBRUARY))%>";
var GNR_MARCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MARCH))%>";
var GNR_APRIL		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_APRIL))%>";
var GNR_MAY			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MAY))%>";
var GNR_JUNE		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JUNE))%>";
var GNR_JULY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_JULY))%>";
var GNR_AUGUST		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_AUGUST))%>";
var GNR_SEPTEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_SEPTEMBER))%>";
var GNR_OCTOBER		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_OCTOBER))%>";
var GNR_NOVEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NOVEMBER))%>";
var GNR_DECEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_DECEMBER))%>";
var GNR_MONDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblLunes"))%>";
var GNR_TUESDAY  	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMartes"))%>";
var GNR_WEDNESDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblMiercoles"))%>";
var GNR_THURSDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblJueves"))%>";
var GNR_FRIDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblViernes"))%>";
var GNR_SATURDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblSabado"))%>";
var GNR_SUNDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"lblDomingo"))%>";

var GNR_NO_EXI_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_NO_EXI_MES))%>";
var GNR_FOR_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_FOR_FCH))%>";
var GNR_MIN_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_MIN_FCH))%>";
var GNR_EL_MES_DE	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_EL_MES_DE))%>";
var GNR_TIE_28_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_28_DIA))%>";
var GNR_TIE_29_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_29_DIA))%>";
var GNR_TIE_30_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_30_DIA))%>";
var GNR_TIE_31_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_31_DIA))%>";
var GNR_TIE_00_DIA	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_DIA))%>";
var GNR_TIE_00_MES	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_TIE_00_MES))%>";
	
function validateNumber(obj) {
	var isNumber = false; 
	try { 
		isNumber = obj == '' || ! isNaN(parseInt(obj.value,10)); 
	} catch (e) {
	}

	if (! isNumber) { 
		var GNR_NUMERIC = " <%= StringUtil.replaceAll(LabelManager.getName(labelSet,DogmaException.GNR_NUMERIC),"\"","") %>"; 
		var i = GNR_NUMERIC.indexOf('<TOK1>');
		var text = obj.getAttribute("req_desc");
		if (text != null && text.indexOf(":") == (text.length - 1)) text = text.substring(0,text.length - 1); 
		alert(GNR_NUMERIC.substring(0,i) + text + GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length)); 
		obj.value = ''; 
		return false;
	}

	return true;
}

function isDate(obj) {
	var GNR_DATE_SEPARATOR		= "<%=Parameters.DATE_SEPARATOR%>";
	var strDateFormat			= "<%=EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DATE)%>";
	var arrIsDate = new Array;
 
	if(obj.value==""){
		arrIsDate[0] = true;
		return arrIsDate;
	}

	var sFormattedDate = strDateFormat;
	strDateFormat = strDateFormat.replace("/",GNR_DATE_SEPARATOR);
	strDateFormat = strDateFormat.replace("/",GNR_DATE_SEPARATOR);
	var arrPos = strDateFormat.split(GNR_DATE_SEPARATOR);
	
	var d 	= sFormattedDate.replace(/dd/, "##");
	var m 	= d.replace(/MM/, "##");
	var yy 	= m.replace(/yyyy/, "####");
	
	var sFormatMask = yy.replace("/",GNR_DATE_SEPARATOR);				
	sFormatMask = sFormatMask.replace("/",GNR_DATE_SEPARATOR);
	pblnMask = compare(obj.value,sFormatMask);
    
    	if (pblnMask) {
			arrValoresFecha = obj.value.split(GNR_DATE_SEPARATOR);		
			if(arrPos[0] == "dd"){
				pvntDia = arrValoresFecha[0];
			}
			if(arrPos[1] == "dd"){
				pvntDia = arrValoresFecha[1];
			}
			if(arrPos[2] == "dd"){
				pvntDia = arrValoresFecha[2];
			}
			if(arrPos[0] == "MM"){
				pvntMes = arrValoresFecha[0];
			}
			if(arrPos[1] == "MM"){
				pvntMes = arrValoresFecha[1];
			}
			if(arrPos[2] == "MM"){
				pvntMes = arrValoresFecha[2];
			}
			if(arrPos[0] == "yyyy"){
				pvntAnio = arrValoresFecha[0];
			}
			if(arrPos[1] == "yyyy"){
				pvntAnio = arrValoresFecha[1];
			}
			if(arrPos[2] == "yyyy"){
				pvntAnio = arrValoresFecha[2];
			}			

			pblnBisiesto = isBisiesto(pvntAnio);	
			pblnIsDiaMes = isDiaMes(pvntDia,pvntMes,pblnBisiesto);				

			if (pvntDia == 0) {
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_TIE_00_DIA;
			} else if(pvntMes == 0) {
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_TIE_00_MES;
    		} else if(pvntAnio < 1800){
				arrIsDate[0] = false;	
				arrIsDate[1] = GNR_MIN_FCH;
			} else {
				if (pvntMes <= 12) {
					if (pblnIsDiaMes[0]==false){
						arrIsDate[0] = false;	
						arrIsDate[1] = pblnIsDiaMes[1];
					}else{
						arrIsDate[0] = true;
					}
				}else{
					arrIsDate[0] = false;	
					arrIsDate[1] = GNR_NO_EXI_MES;
				}
			}
				
		}else{
		
			arrIsDate[0] = false;
			arrIsDate[1] = GNR_FOR_FCH;
				
		}	 

	if (! arrIsDate[0]) {
		alert(arrIsDate[1]);
		obj.value = "";
	}
    	
	return (arrIsDate);
}

function isDiaMes(pvntDia,pvntMes,pblnBisiesto){

	var arrNombreMes = new Array;
	
	arrNombreMes[0] = GNR_JANUARY; //"enero"
	arrNombreMes[1] = GNR_FEBRUARY; //"febrero"
	arrNombreMes[2] = GNR_MARCH; //"marzo"
	arrNombreMes[3] = GNR_APRIL; //"abril"
	arrNombreMes[4] = GNR_MAY; //"mayo"
	arrNombreMes[5] = GNR_JUNE; //"junio"
	arrNombreMes[6] = GNR_JULY; //"julio"
	arrNombreMes[7] = GNR_AUGUST; //"agosto"
	arrNombreMes[8] = GNR_SEPTEMBER; //"setiembre"
	arrNombreMes[9] = GNR_OCTOBER; //"octubre"
	arrNombreMes[10] = GNR_NOVEMBER; //"noviembre"
	arrNombreMes[11] = GNR_DECEMBER; //"diciembre"
	
	var arrDiaMes = new Array;

	if ((pvntMes == 1) || (pvntMes == 3) ||(pvntMes == 5) || (pvntMes == 7) || (pvntMes == 8) ||(pvntMes == 10) || (pvntMes == 12)) {
		if 	(pvntDia >	31) {
			arrDiaMes[0] = false;				
			// O m?s de tem 
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_31_DIA +  " ";	
		}else{
			arrDiaMes[0] = true;				
		}
	
	} else if ((pvntMes == 4) || (pvntMes == 6) || (pvntMes == 9) || (pvntMes == 11)){
		if 	(pvntDia >	30) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_30_DIA +  " ";	
		} else {
			arrDiaMes[1] = true;				
		}
	
	} else if ((pvntMes == 2) && (pblnBisiesto)){
		if 	(pvntDia >	29) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_29_DIA +  " ";		
		} else {
			arrDiaMes[1] = true;				
		}
	
	} else if ((pvntMes == 2) && (pblnBisiesto==false)){
		if 	(pvntDia >	28) {
			arrDiaMes[0] = false;				
			arrDiaMes[1] = " " + GNR_EL_MES_DE + " " + arrNombreMes[pvntMes-1] + " " + GNR_TIE_28_DIA +  " ";
		} else {
			arrDiaMes[1] = true;				
		}
	}
	return(arrDiaMes);	
}

function isBisiesto(anio){
	if ((anio % 4)== 0){
		if (anio.substring(2,4) == "00"){
			if ((anio % 400)== 0){
				return(true);
			}else{
				return(false);
			}
		}else{
			return(true);
		}
	
	}else{
		return(false);
	}	
}

function compare(theValue, mask) {
	/* hace el matching de value contra la mascara */
			
	var len_value = theValue.length;
	var len_mask = mask.length;
	
	if (len_value != len_mask)
		return(false);
		
	for (i = 0; i <= len_mask  ; i++) {
		car_value = theValue.substring(i,i+1);
		car_mask = mask.substring(i,i+1);

		if ((car_mask != "#") && (car_mask != "$")) {
			if (car_value != car_mask)
				return(false);
		} else {
			if (car_mask == "#") {
				if (isNumericBln(car_value) != true)
					return(false); 
			} else if (car_mask == "$") {
				if (car_value == "")
					return(false);
			}
		}
	}
		
	return(true);
}

function isNumericBln(valor){

	for (z=0; z < valor.length; z++) {
		caracter = valor.substr(z,1);
		if ((caracter != "0") && (caracter != "1") &&
			(caracter != "2") && (caracter != "3") &&
			(caracter != "4") && (caracter != "5") &&
			(caracter != "6") && (caracter != "7") &&
			(caracter != "8") && (caracter != "9")) {
				return(false);
		}
	}
	return(true);
}

function validateRequiredObject(obj) {
	if (obj == null) return true;

	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "text" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "hidden" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "input" && obj.type.toLowerCase() == "password" && obj.value != "") return true;
	if (obj.tagName.toLowerCase() == "select" && obj.selectedIndex != null && obj.selectedIndex != -1 && obj.options.length > obj.selectedIndex && obj.options[obj.selectedIndex].value != "") return true;

	return false;
}

function validateRequired(sessionId) {
	var form = document.getElementById("frmApia" + sessionId);
	for (var i = 0; i < form.elements.length; i++) {
		var element = form.elements[i];
		var attRequired = element.getAttribute("p_required");
		if (attRequired != null && attRequired == "true") {
			if (! validateRequiredObject(element)) {
				var frmName = element.getAttribute("formname");
				if (frmName == null) frmName = "";
				if (frmName != "") frmName += ".";
				
				var attName = element.getAttribute("req_desc");
				if (attName.indexOf(":") == (attName.length - 1)) attName = attName.substring(0,attName.length - 1);
				alert("Required value for: " + frmName + attName);
				return false;
			}
		}
	}
	return true;
}

</script>
