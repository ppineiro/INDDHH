<%@ taglib uri="/WEB-INF/system-tags.tld" prefix="system"%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){
	response.setHeader("Pragma","public no-cache");
}else{	
	response.setHeader("Pragma","no-cache");
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
//response.setCharacterEncoding("utf-8");
response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
response.setContentType("text/xml");
out.clear();//no colocar enters ni nada antes del tag system:edit, sino no es tomado bien el xml !!!!
%><system:edit show="valueAsIs" from="request:ajaxXml" />