<%@page import="com.st.util.StringUtil"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BusinessEntitiesAction"%><%@page import="biz.statum.apia.web.bean.design.BusEntitiesBean"%><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
BusEntitiesBean dBean= (BusEntitiesBean)session.getAttribute("flashBean");

if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");

if (dBean.getMessages().size()==0) {
	out.clear();
	String xmlAtt = dBean.getAttributesXML(http);
	out.print(xmlAtt);
} else {
	out.print(dBean.getMessages());
	dBean.clearMessages();
}
%>