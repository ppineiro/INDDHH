<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><HTML><head><script language="javascript">


var MSG_BI_IMPL_NOT_FOUND = "<%=LabelManager.getName("msgBIImplNotFound")%>"; //BIDB_IMPLMENTATION
var MSG_BI_WRNG_IMPLEMENTATION = "<%=LabelManager.getName("msgBIWrngImpl")%>"; //WRONG BIDB_IMPLMENTATION 
var MSG_BI_URL_NOT_FOUND = "<%=LabelManager.getName("msgBIUrlNotFound")%>"; //BIDB_URL
var MSG_BI_PWD_NOT_FOUND = "<%=LabelManager.getName("msgBIPwdNotFound")%>"; //BIDB_PWD
var MSG_BI_USR_NOT_FOUND = "<%=LabelManager.getName("msgBIUsrNotFound")%>"; //BIDB_USR
var MSG_ERR_LOADING_SCHEMA = "<%=LabelManager.getName("msgBIErrLoadingSchema")%>"; //LOADING SCHEMA
var MSG_ERR_EMPTY_FACT_TABLES = "<%=LabelManager.getName("msgBIErrEmptyFactTables")%>"; //EMPTING FACT TABLES
var MSG_NO_SPECIFIED_ERROR = "<%=LabelManager.getName("msgDwNoSpecError")%>";
var MSG_NO_EXIST_ENTITY_TABLE = "<%=LabelManager.getName("msgNoExiEntTable")%>";
var MSG_EMPTY_ENTITY_TABLE = "<%=LabelManager.getName("msgEmptyEntTable")%>";
var MSG_NO_EXIST_PROCESS_TABLE = "<%=LabelManager.getName("msgNoExiProTable")%>";
var MSG_EMPTY_PROCESS_TABLE = "<%=LabelManager.getName("msgEmptyProTable")%>";
var MSG_ERR_SCHEMA_OR_VIEW = "<%=LabelManager.getName("msgErrSchOrView")%>";
var MSG_URL_NOT_CORRESPOND_WITH_IMPLEMENTATION = "<%=LabelManager.getName("msgBIUrlNotCorWithImpl")%>";
var MSG_ERR_SCHEMA_NOT_EXIST = "<%=LabelManager.getName("msgErrSchNotExist")%>";
var MSG_ERR_CUBE_NOT_EXIST = "<%=LabelManager.getName("msgErrCbeNotExist")%>";

var ERROR = "<%=request.getParameter("error")%>";
var ERRORMSG = "<%=request.getParameter("errorMsg")%>";

if (this.parent.document.getElementById('blocker_<%=request.getParameter("widId")%>')!=null){
	this.parent.document.getElementById('blocker_<%=request.getParameter("widId")%>').style.display = 'none';
}

</script></head><body style="align:center;vertical-align:middle;background:transparent;"><%
	 if (!"14".equals(request.getParameter("error"))){%><table style="width:475px;height:200px"><tr><td valign="middle"><%}
	//<div style="font-family:Verdana;font-size: 10px;border-radius:2px;color:white;text-align:center;background-color:#303030;display: block;height: 22px;margin-left: auto;margin-right: auto;margin-top: 40%;width: 133px;">
	//<span style="position: relative;top: 2px;">
	%><div style="text-align: center;font-family:Verdana;font-size: 11px;font-weight: bold; border-radius:2px;color:#4094AB;background-color:transparent;display: block;height: 45px;margin-left: auto;margin-right: auto;margin-top: 20%;"><span style="position: relative;top: 2px;"><%
	if ("1".equals(request.getParameter("error"))){//BIDB_IMPLMENTATION %><%=LabelManager.getName("msgBIImplNotFound")%><%
	}else if ("2".equals(request.getParameter("error"))){//BIDB_IMPLMENTATION not oracle, postgres or sqlserver%><%=LabelManager.getName("msgBIWrngImpl")%><%
	}else if ("3".equals(request.getParameter("error"))){//BIDB_URL%><%=LabelManager.getName("msgBIUrlNotFound")%><%
	}else if ("4".equals(request.getParameter("error"))){//BIDB_PWD%><%=LabelManager.getName("msgBIPwdNotFound")%><%
	}else if ("5".equals(request.getParameter("error"))){//BIDB_USR%><%=LabelManager.getName("msgBIUsrNotFound")%><%
	}else if ("6".equals(request.getParameter("error"))){//SCHEMA_id or CUbe_id is null%>
		SchemaId or CubeId was not specified - imposible to load cube<%
	}else if ("7".equals(request.getParameter("error"))){//FACT TABLES EMPTY%><%=LabelManager.getName("msgBIErrEmptyFactTables")%><%
	}else if ("8".equals(request.getParameter("error"))){//ENV ID IS NULL%>
		Parameter envId not found - imposible to load cube<%
	}else if ("9".equals(request.getParameter("error"))){//ENTITY TABLE NOT EXIST%><%=LabelManager.getName("msgNoExiEntTable")%><%
	}else if ("10".equals(request.getParameter("error"))){//ENTITY TABLE IS EMPTY%><%=LabelManager.getName("msgEmptyEntTable")%><%
	}else if ("11".equals(request.getParameter("error"))){//PROCESS TABLE NOT EXIST%><%=LabelManager.getName("msgNoExiProTable")%><%
	}else if ("12".equals(request.getParameter("error"))){//PROCESS TABLE IS EMPTY%><%=LabelManager.getName("msgEmptyProTable")%><%
	}else if ("13".equals(request.getParameter("error"))){//ERROR LOADING SCHEMA (No modificar el numero de este error pq es usado en schema loader)%><%=LabelManager.getName("msgBIErrLoadingSchema")%><%
  //}else if ("14".equals(request.getParameter("error"))){ //No modificar el numero de este error pq es usado en schema loader%>
	 
	}else if ("15".equals(request.getParameter("error"))) { //URL NOT CORRESPOND WITH IMPLEMENTATION%><%=LabelManager.getName("msgBIUrlNotCorWithImpl")%><%
	}else if ("16".equals(request.getParameter("error"))) { //SCHEMA NOT EXIST%><%=LabelManager.getName("msgErrSchNotExist")%><%
	}else if ("17".equals(request.getParameter("error"))) { //CUBE NOT EXIST%><%=LabelManager.getName("msgErrCbeNotExist")%><%
	}else if ("18".equals(request.getParameter("error"))) { //VIEW NOT EXIST%><%=LabelManager.getName("msgErrSchOrView")%><%
	}else if ("19".equals(request.getParameter("error"))) { //VIEW NOT EXIST%><%=LabelManager.getName("msgBiErrConBiDb")%><%
	}else{ //UNKNOWN ERROR%><%=request.getParameter("msgError")%><%}%></span></div><%
	if (!"14".equals(request.getParameter("error"))){%></td></tr></table><%} %></body></html>
