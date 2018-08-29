<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><%@page import="com.dogma.vo.WidgetVo"%><%@include file="../../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%
Integer dshId = null;
Date nowDate = new Date();
HashMap widProperties = null;
if (request.getParameter("dshId")!=null){ //Si es un dashboard y no una ventana de visualizacion de hijos
	dshId = new Integer(request.getParameter("dshId"));
	widProperties = wBean.getWidProperties(dshId);
}
Integer widId = new Integer(request.getParameter("widId"));
WidgetVo widVo = wBean.getWidgetVo(widId);
Integer cantInformation = wBean.getCantInformation(widId);
Collection widCol = wBean.getWidChilds(widId); //Obtenemos los hijos del widget
boolean viewWidName = false; //<---- Extraer de las propiedades del widget
boolean viewBtnChilds = true; //valor por defecto
boolean viewBtnHistory = true; //valor por defecto
boolean viewBtnRefresh = false; //valor por defecto
boolean viewBtnComments = false; //valor por defecto
boolean viewBtnInfo = false; //valor por defecto
Double widgetWidth = Double.valueOf(350); //ancho del widget
Double widgetHeight = Double.valueOf(300); //largo del widget
Integer refTimeType = widVo.getWidRefType();
int refTime = 10; //por defecto
if (widVo.getWidRefresh().intValue() != 0){
	refTime = widVo.getWidRefresh().intValue();
}
if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_SEC.intValue()){ //segundos
	refTime = refTime;
}else if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_MIN.intValue()){//minutos
	refTime = refTime * 60;		
}else{
	refTime = refTime * 60 * 60;	
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
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)!=null){
		widgetWidth = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)!=null){
		widgetHeight = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)).getPropValue());
	}
}
%><%@page import="java.util.HashMap"%><%@page import="com.dogma.vo.WidPropertiesVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Date"%><html><meta http-equiv="REFRESH" content="<%=refTime%>"><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><%
double nameSize = widVo.getWidName().length();
double titleSize = widVo.getWidTitle().length();
int maxTitleSize = Double.valueOf(widgetWidth / 8.5).intValue();
String widName = widVo.getWidName().length()>maxTitleSize?widVo.getWidName().substring(0,maxTitleSize)+"..":widVo.getWidName();
String widTitle = widVo.getWidTitle().length()>maxTitleSize?widVo.getWidTitle().substring(0,maxTitleSize)+"..":widVo.getWidTitle();
String widDesc = widVo.getWidDesc();
boolean hasDesc = widDesc!=null && !"".equals(widDesc) && !"null".equals(widDesc);

if (widVo.getWidSrcType()!=null && widVo.getWidSrcType().intValue() == WidgetVo.WIDGET_SRC_TYPE_URL_ID.intValue()){%><body style="background:transparent;" onload="document.location.href='<%=widVo.getWidHtmlCod()%>'"><%if (viewWidName){
		if (widTitle!=null && !"".equals(widTitle)){%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidTitle()+"\""%>><%=widTitle%></DIV><%}else{%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidName()+"\""%>><%=widName%></DIV><%}
	}else{%><DIV style="position:relative;height:28px;width:20px;"></DIV><%} %></body><%}else{ %><body style="background:transparent;"><%if (viewWidName){
		if (widTitle!=null && !"".equals(widTitle)){%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidTitle()+"\""%>><%=widTitle%></DIV><%}else{%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidName()+"\""%>><%=widName%></DIV><%}
	}else{%><DIV style="position:relative;height:28px;width:20px;"></DIV><%} %><div id="widContent"><%=widVo.getWidHtmlCod()%></div><DIV style="border-top:1px solid #999999"><input type="hidden" id="txtLastUpdate" value="<%=wBean.fmtHTMLTime(nowDate)%>" /><% if (viewBtnChilds){%><span><img onclick="viewChilds()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblVwWidChilds")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/childs.png"></span><%}
    if (viewBtnComments){%><span><img onclick="viewComments()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidComments")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/comments.png"></span><%}
	if (viewBtnInfo){%><span><img onclick="viewInfo()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidInfo")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/info.png"></span><%}
	if (viewBtnRefresh){%><span><img onclick="refresh()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidRefresh")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/refresh.png"><span><%}%></DIV></body><%} %></html><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script language='javascript'>
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
function viewComments(){
	openModal("/programs/biExecution/dashboards/dshComments.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>",660,400);
}
function viewInfo(){
	<%if (cantInformation>0){%>
		var lastUpdate = document.getElementById("txtLastUpdate").value;
		var width=700;
		var heigth=<%=70 + (40 * cantInformation)%>;
		openModal("/programs/biExecution/dashboards/dshInfo.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>&lastUpdate="+lastUpdate,width,heigth);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoInfo")%>");
	<%}%>
}
</script><script language='javascript' defer='true'>
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
	var dContent = document.getElementById("widContent");
	if (dContent){
		dContent.style.position="relative";
		dContent.style.height=(height-80)+"px";
	}
}


if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", doOnLoad, false);
}else{
	doOnLoad();
}
</script>
