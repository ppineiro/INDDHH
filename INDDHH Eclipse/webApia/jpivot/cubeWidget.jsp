<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="java.util.Date"%><%@page import="com.dogma.bean.administration.WidgetBean"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.WidgetVo"%><%@include file="../components/scripts/server/startInc.jsp" %><%
boolean busy=((Boolean)(  (request.getSession().getAttribute("busy")!=null?request.getSession().getAttribute("busy"):new Boolean(false))    )    ).booleanValue();
Integer widId = new Integer(request.getParameter("widId"));
String viewMode = request.getParameter("viewMode");
Double widgetWidth = Double.valueOf(350); //ancho del widget
Double widgetHeight = Double.valueOf(300); //largo del widget
Date nowDate = new Date();
String biError = "";

Integer dshChildId=null;
boolean viewBtnComments = false; //valor por defecto
boolean viewBtnInfo = false; //valor por defecto
boolean viewBtnRefresh = false; //valor por defecto
boolean viewWidName = "true".equals(request.getParameter("viewWidName"));
boolean hasChilds = "true".equals(request.getParameter("hasChilds"));

String widName = request.getParameter("widName");
String widTitle = request.getParameter("widTitle");
String widDesc = request.getParameter("widDesc");

if (request.getParameter("biError")!=null) {
	biError = "&biError=" + request.getParameter("biError");
}

//Seteamos los valores de las propiedades del widget
if (request.getParameter("dshChildId")!=null && !"null".equals(request.getParameter("dshChildId"))){
	dshChildId = new Integer(request.getParameter("dshChildId"));
}
	
if (request.getParameter("viewBtnComments")!=null && "true".equals(request.getParameter("viewBtnComments"))){
	viewBtnComments = true;
}
if (request.getParameter("viewBtnInfo")!=null && "true".equals(request.getParameter("viewBtnInfo"))){
	viewBtnInfo = true;
}
if (request.getParameter("viewBtnRefresh")!=null && "true".equals(request.getParameter("viewBtnRefresh"))){
	viewBtnRefresh = true;
}


%><html><head><system:util show="baseStyles" /><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><script language="javascript">
function init(){
	document.getElementById('jPivotForm').submit();
}
function showSpinner() {
	var content = $('body');
	if( ! content.spinner) {
		content.spinner = new Spinner(content,{message:' '});
		content.spinner.show(true);
	}
}
</script><%
if (busy){%><meta http-equiv="REFRESH" content="5"><%//Hacemos que en 5 segundos intente nuevamente %></head><body id="body" onload="showSpinner()"></body><%}else{
request.getSession().setAttribute("busy",new Boolean(true));
request.getSession().setAttribute("widgetBusy",new Boolean(true));
%></head><body onload="init()" style="padding:0px;margin:0px;background:transparent;"><iframe name="jpivot" frameborder="no" style="height:<%=widgetHeight%>px;width:100%;"></iframe><form accept-language="en-us" id="jPivotForm" action="<%=Parameters.ROOT_PATH%>/jpivot/widgetSchemaLoader.jsp?&schemaId=<%=request.getParameter("schemaId")%>&dshId=<%=request.getParameter("dshId")%>&widId=<%=widId%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>&entityCube=<%=request.getParameter("entityCube")%>&viewWidName=<%=viewWidName%>&viewBtnComments=<%=viewBtnComments%>&viewBtnInfo=<%=viewBtnInfo%>&viewBtnRefresh=<%=viewBtnRefresh%>&widName=<%=widName%>&widTitle=<%=widTitle%>&widDesc=<%=widDesc%>&dshChildId=<%=dshChildId%>&viewMode=<%=viewMode%>&widWidth=<%=widgetWidth%>&widHeight=<%=widgetHeight%>&tokenId=<%=request.getParameter("tokenId")%><%=biError%>" method="POST" target="jpivot"></form></body><%}%></html>
