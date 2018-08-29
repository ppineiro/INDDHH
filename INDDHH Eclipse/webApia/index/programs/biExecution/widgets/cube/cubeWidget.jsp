<%@page import="java.util.Date"%><%@page import="com.dogma.bean.administration.WidgetBean"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.WidgetVo"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><%
//<jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean">
//</jsp:useBean>

Integer widId = new Integer(request.getParameter("widId"));
Integer dshId = null;

String beanName = "wBean" + widId.toString();
com.dogma.bean.administration.WidgetBean wBean = (com.dogma.bean.administration.WidgetBean)session.getAttribute(beanName);
if(wBean == null){
	wBean = new WidgetBean();
	wBean.initEnv(request);
	session.setAttribute(beanName, wBean);
}

com.dogma.bean.administration.WidgetBean dBean = wBean;
HashMap widProperties = null;
if (request.getParameter("dshId")!=null){ //Si es un dashboard y no una ventana de visualizacion de hijos
	dshId = Integer.valueOf(request.getParameter("dshId"));
	widProperties = wBean.getWidProperties(dshId);
}

Integer cantInformation = wBean.getCantInformation(widId);
WidgetVo widVo = wBean.getWidgetVo(widId);
Integer dshChildId = widVo.getDshChildId();
Collection widCol = wBean.getWidChilds(widId); //Obtenemos los hijos del widget
boolean busy=((Boolean)(  (request.getSession().getAttribute("busy")!=null?request.getSession().getAttribute("busy"):new Boolean(false))    )    ).booleanValue();
boolean viewWidName = false;
boolean viewBtnRefresh = false; //valor por defecto
String viewMode = "chart"; //por defecto se muestra la gráfica
boolean viewBtnComments = false; //valor por defecto
boolean viewBtnInfo = false; //valor por defecto
Double widgetWidth = Double.valueOf(350); //ancho del widget
Double widgetHeight = Double.valueOf(300); //largo del widget
Date nowDate = new Date();
Integer refTimeType = widVo.getWidRefType();
int refTime = 60; //por defecto
if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_SEC.intValue()){ //segundos
	refTime = widVo.getWidRefresh().intValue() * 1000;
}else if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_MIN.intValue()){//minutos
	refTime = widVo.getWidRefresh().intValue() * 60 * 1000;		
}else{
	refTime = widVo.getWidRefresh().intValue() * 60 * 60 * 1000;	
}

//Seteamos los valores de las propiedades del widget
if (widProperties != null){
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_NAME)!=null){
		viewWidName = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_NAME)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_CUBE_VIEW_MODE)!=null){
		viewMode = ((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_CUBE_VIEW_MODE)).getPropValue();
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_COMMENTS)!=null){
		viewBtnComments = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_COMMENTS)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_INFO)!=null){
		viewBtnInfo = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_INFO)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_REFRESH)!=null){
		viewBtnRefresh = "true".equals(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BTN_REFRESH)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)!=null){
		widgetWidth = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)).getPropValue());
	}
	if (widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)!=null){
		widgetHeight = Double.valueOf(((WidPropertiesVo)widProperties.get(widId.intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)).getPropValue());
	}
}

%><%@page import="java.util.HashMap"%><%@page import="com.dogma.vo.WidPropertiesVo"%><%@page import="java.util.Collection"%><html><head><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script><script language="javascript">
//navigator.language="en-en";
<%if(request.getParameter("windowId")!=null){ %>
var windowId        = "&windowId=<%=request.getParameter("windowId")%>&tokenId=<%=uData.getTokenId()%>";
<%}else{%>
var windowId        = "&tokenId=<%=uData.getTokenId()%>";
<%}%>
var URL_ROOT_PATH		 	="<%=Parameters.ROOT_PATH%>";
function init(){
	document.getElementById('jPivotForm').submit();
}
</script><%
if (busy){%><meta http-equiv="REFRESH" content="5"><%//Hacemos que en 5 segundos intente nuevamente %></head><body style="align:center;vertical-align:middle;background:transparent;"><img src="<%=Parameters.ROOT_PATH%>/jpivot/toolbar/wait.gif" style="display: block;height: 60px;margin-left: auto;margin-right: auto;margin-top: 20%;"/></body><%}else{
request.getSession().setAttribute("busy",new Boolean(true));
request.getSession().setAttribute("widgetBusy",new Boolean(true));
%><meta http-equiv="REFRESH" content="<%=refTime%>"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><%@include file="../../../../../components/scripts/server/headInclude.jsp" %></head><body onload="init()" style="padding:0px;margin:0px;background:transparent;"><input type="hidden" id="txtLastUpdate" value="<%=dBean.fmtHTMLTime(nowDate)%>" /><%  
	double nameSize = widVo.getWidName().length();
	double titleSize = widVo.getWidTitle().length();
	int maxTitleSize = Double.valueOf(widgetWidth / 8.5).intValue();
	String widName = widVo.getWidName().length()>maxTitleSize?widVo.getWidName().substring(0,maxTitleSize)+"..":widVo.getWidName();
	String widTitle = widVo.getWidTitle().length()>maxTitleSize?widVo.getWidTitle().substring(0,maxTitleSize)+"..":widVo.getWidTitle();
	String widDesc = widVo.getWidDesc();
	   boolean hasDesc = widDesc!=null && !"".equals(widDesc) && !"null".equals(widDesc);
	if (viewWidName){
		if (widTitle!=null && !"".equals(widTitle)){%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidTitle()+"\""%>><%=widTitle%></DIV><%}else{%><DIV class="subTit" <%=hasDesc?"title=\""+widVo.getWidDesc()+"\"":"title=\""+widVo.getWidName()+"\""%>><%=widName%></DIV><%}
	}else{%><DIV class="subTit" style="visibility:hidden"></DIV><%} %><div id="blocker_<%=widId%>" style="height: 100%;position: absolute;width: 100%;text-align: center;"><img src="<%=Parameters.ROOT_PATH%>/jpivot/toolbar/wait.gif" style="display: block;height: 60px;margin-left: auto;margin-right: auto;margin-top: 20%;"/></div><iframe name="jpivot" frameborder="no" style="height:<%=widgetHeight - 60%>px;width:100%;"></iframe><form accept-language="en-us" id="jPivotForm" action="<%=Parameters.ROOT_PATH%>/jpivot/widgetSchemaLoader.jsp?schemaId=<%=request.getParameter("schemaId")%>&dshId=<%=dshId%>&widId=<%=widId%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>&cantInformation=<%=cantInformation%>&entityCube=<%=request.getParameter("entityCube")%>&viewWidName=<%=viewWidName%>&viewBtnComments=<%=viewBtnComments%>&viewBtnInfo=<%=viewBtnInfo%>&viewBtnRefresh=<%=viewBtnRefresh%>&widName=<%=widVo.getWidName()%>&widTitle=<%=widVo.getWidTitle()%>&widDesc=<%=widVo.getWidDesc()%>&dshChildId=<%=dshChildId%>&viewMode=<%=viewMode%>&widWidth=<%=widgetWidth%>&widHeight=<%=widgetHeight%>" method="POST" target="jpivot"></form><DIV style="border-top:1px solid #999999"><span style="margin:2px"><img onclick="viewChilds()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblVwWidChilds")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/childs.png"></span><span style="margin:2px"><img onclick="openVwMode()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblOpeVisMode")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/openSrc.png"></span><%if (viewBtnComments){%><span><img onclick="viewComments()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidComments")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/comments.png"></span><%}
	if (viewBtnInfo){%><span><img onclick="viewInfo()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidInfo")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/info.png"></span><%}
	if (viewBtnRefresh){%><span><img onclick="refresh()" style="cursor:pointer;cursor:hand;" width="25" height="25" title="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblWidRefresh")%>" border="0" src="<%=Parameters.ROOT_PATH%>/images/dashboard/refresh.png"></span><%}%></DIV></body><%}%></html><script language="javascript">
function viewChilds(){
	<% if (dshChildId!=null){%>
		openModal("/programs/biExecution/dashboards/dashboard.jsp?dshId=<%=dshChildId.intValue()%>",window.parent.parent.getStageWidth()-50,window.parent.parent.getStageHeight()-50);
	<%}else{%>
		alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoChilds").replace("<TOK1>",widVo.getWidName())%>");
	<%}%>
}

function openVwMode(){
	openModal("/jpivot/widgetVwSchemaLoader.jsp?mode=viewer&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>",window.parent.parent.getStageWidth()-50,window.parent.parent.getStageHeight()-50);
}
function viewComments(){
	<%if(dshId!=null && widId!=null){%>
		openModal("/programs/biExecution/dashboards/dshComments.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>",660,400);
	<%}%>
}
function viewInfo(){
	<%if(dshId!=null && widId!=null){
		if (cantInformation>0){%>
			var width=700;
			var height=<%=70 + (40 * cantInformation)%>;
			var lastUpdate = document.getElementById("txtLastUpdate").value;
			openModal("/programs/biExecution/dashboards/dshInfo.jsp?dshId=<%=dshId.intValue()%>&widId=<%=widId.intValue()%>&lastUpdate="+lastUpdate,width,height);
		<%}else{%>
			alert("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidNoInfo")%>");
		<%}
	}%>
}
function refresh(){
	if(confirm("<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWidRefNow").replace("<TOK1>",widVo.getWidName())%>")){
		var wid_id = <%=widId%>;
		window.location.reload(true);
	}
}
</script>