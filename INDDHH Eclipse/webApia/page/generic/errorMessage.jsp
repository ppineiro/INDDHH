<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><%@ taglib uri="/WEB-INF/system-tags.tld" prefix="system"%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){
	response.setHeader("Pragma","public no-cache");
}else{	
	response.setHeader("Pragma","no-cache");
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/html");
out.clear();//no colocar enters ni nada antes del tag system:edit, sino no es tomado bien el xml !!!!

%><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/generic/errorMessage.js"></script></head><body onload="doLoad()"><textarea id="txt" style="display:none"><system:edit show="value" from="request:ajaxXml" /></textarea></body></html>

