<%
response.setContentType("text/xml");
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
String responseXML=request.getAttribute("responseXML")!=null?request.getAttribute("responseXML").toString():"";
out.clear();
if(!"".equals(responseXML))
	out.println(responseXML);
%>