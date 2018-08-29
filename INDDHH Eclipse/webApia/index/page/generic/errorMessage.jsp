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

%><html><head><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script><script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/errorMessage.js"></script><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css" ><script type="text/javascript">
		var BTN_CLOSE				= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
	</script></head><body onload="doLoad()"><textarea id="txt" style="display:none"><system:edit show="value" from="request:ajaxXml" /></textarea></body></html>

