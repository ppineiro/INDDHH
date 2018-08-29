<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><%@page import="com.dogma.vo.WidgetVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager"%><%@include file="../../../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%
Integer dshId = null;
HashMap widProperties = null;
if (request.getParameter("dshId")!=null){ //Si es un dashboard y no una ventana de visualizacion de hijos
	dshId = new Integer(request.getParameter("dshId"));
	widProperties = wBean.getWidProperties(dshId);
}
Integer widId = new Integer(request.getParameter("widId"));
Integer cantInformation = wBean.getCantInformation(widId);
WidgetVo widVo = wBean.getWidgetVo(widId);
widVo.setActualUser(uData.getUserId());
boolean viewWidName = false; //<---- Extraer de las propiedades del widget
boolean viewBtnChilds = true; //valor por defecto
boolean viewBtnHistory = true; //valor por defecto
boolean viewBtnRefresh = false; //valor por defecto
boolean viewBtnComments = false; //valor por defecto
boolean viewBtnInfo = false; //valor por defecto
boolean viewTimer = false; //valor por defecto
Double widgetWidth = Double.valueOf(350); //ancho del widget
Double widgetHeight = Double.valueOf(300); //largo del widget
Integer widRefresh = widVo.getWidRefresh();
Integer widRefType = widVo.getWidRefType();
String flashName = "meter"; //por defecto
if (widVo.getWidKpiStyle().intValue() > 3){
	flashName = "gauges";
}
//Seteamos los valores de las propiedades del widget
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
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_TIMER)!=null){
		viewTimer = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_TIMER)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)!=null){
		widgetWidth = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)!=null){
		widgetHeight = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)).getPropValue());
	}
}
String defaultColor = "0xD8D8D8";
Object value = null;
Collection errorCol = wBean.verifiyKPIBusClasses(widVo);
if (errorCol!=null && errorCol.size()>0){ //Si alguna de las clases de negocio utilizadas por el widget no existe
	Iterator itNextVal = errorCol.iterator();
	value = (Object) itNextVal.next();
	if (value == null){
		Integer error = (Integer)itNextVal.next();
		String errorMsg = (String)itNextVal.next();
		%><HTML><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><meta http-equiv="REFRESH" content="<%=widRefresh.intValue()%>"></head><body style="align:center;vertical-align:middle"><table style="width:100%;height:100%" valign="middle" style="border:1px solid red"><tr><td align="center"><b><%=widVo.getWidName()%></b></td></tr><tr><td align="center"><%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblErrLoadWid")%></td></tr><tr><td align="center" style="color:#FF0000;text-decoration: underline;" title="<%=errorMsg%>"><%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblSeeError")%></td></tr></table></body></html><%}
}
if (errorCol == null || value != null){%><%@page import="com.dogma.vo.WidPropertiesVo"%><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es"><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><title><%=flashName%></title><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><%@include file="../../../../../components/scripts/server/headInclude.jsp" %></head><body style="background:transparent;"><div><%  
				double nameSize = widVo.getWidName().length();
				double titleSize = widVo.getWidTitle().length();
				int maxTitleSize = Double.valueOf(widgetWidth / 8.5).intValue();
				String widName = widVo.getWidName().length()>maxTitleSize?widVo.getWidName().substring(0,maxTitleSize)+"..":widVo.getWidName();
				String widTitle = widVo.getWidTitle().length()>maxTitleSize?widVo.getWidTitle().substring(0,maxTitleSize)+"..":widVo.getWidTitle();
				String widDesc = widVo.getWidDesc();
			    boolean hasDesc = widDesc!=null && !"".equals(widDesc) && !"null".equals(widDesc);
				if (viewWidName){
					if (widTitle!=null && !"".equals(widTitle)){%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidTitle()+"\""%>><%=widTitle%></DIV><%}else{%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidName()+"\""%>><%=widName%></DIV><%}
				}else{%><DIV class="subTit" style="visibility:hidden"></DIV><%} %><!--URL utilizadas en la película--><!--Texto utilizado en la película--><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="100%" height="200px" id="<%=flashName%>" align="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/kpi/gauge/<%=flashName%>.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="transparent" /><param name="flashVars" value='noBtns=true&errorMsg=<%=LabelManager.getName(labelSet,"msgErrGetWidValue").replace("<TOK1>",request.getParameter("widName"))%>&xmlUrl=<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/kpi/gauge/gauge.jsp?widId=<%=widId.intValue()%>%26viewTimer=<%=viewTimer%>' /><embed src="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/kpi/gauge/<%=flashName%>.swf" wmode="transparent" quality="high" bgcolor="#ffffff" flashvars="noBtns=true&errorMsg=<%=LabelManager.getName(labelSet,"msgErrGetWidValue").replace("<TOK1>",request.getParameter("widName"))%>&xmlUrl=<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/kpi/gauge/gauge.jsp?widId=<%=widId.intValue()%>%26viewTimer=<%=viewTimer%>" width="100%" height="200" name="<%=flashName%>" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object></div><DIV style="border-top:1px solid #999999"><% if (viewBtnChilds){%><span><img onclick="viewChilds()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblVwWidChilds")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/childs.png"></span><%}
				if (viewBtnHistory){%><span><img onclick="viewHistory()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblVwWidHistory")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/history.png"></span><%}
				if (viewBtnComments){%><span><img onclick="viewComments()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidComments")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/comments.png"></span><%}
				if (viewBtnInfo){%><span><img onclick="viewInfo()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidInfo")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/info.png"></span><%}
				if (viewBtnRefresh){%><span><img onclick="refresh()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidRefresh")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/refresh.png"></span><%}%></DIV></body></html><%@include file="../../../../../components/scripts/server/endInc.jsp" %><%}%><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script language='javascript'>
function viewChilds(){
	<% if (widVo!=null && widVo.getDshChildId()!=null){%>
		openModal("/programs/biExecution/dashboards/dashboard.jsp?dshId=<%=widVo.getDshChildId().intValue()%>",window.parent.getStageWidth()-50,window.parent.getStageHeight()-50);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoChilds").replace("<TOK1>",widVo.getWidName())%>");
	<%}%>
}
function viewHistory(){
	var width = window.parent.parent.getStageWidth()*.8;
	var height = window.parent.parent.getStageHeight()*.8;
	openModal("/programs/biExecution/dashboards/dshHistoryChart.jsp?widId=<%=widId.intValue()%>&widRefresh=<%=widRefresh.intValue()%>&widRefType=<%=widRefType.intValue()%>&widName=<%=widVo.getWidName()%>&width="+width+ "&height=" + height, width,height);
}
function refresh(){
	if(confirm("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidRefNow").replace("<TOK1>",widVo.getWidName())%>")){
		window.location.reload(true);
	}
}
function viewComments(){
	openModal("/programs/biExecution/dashboards/dshComments.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>",660,400);
}
function viewInfo(){
	<%if (cantInformation>0){%>
		var width=700;
		var height=<%=70 + (40 * cantInformation)%>;
		openModal("/programs/biExecution/dashboards/dshInfo.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>",width,height);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoInfo")%>");
	<%}%>
}
</script>
