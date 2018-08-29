<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%
BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
Collection tasks = null;

if(dBean == null) {	
	out.print(XMLTags.XML_HEAD + XMLTags.EXCEPTION_START + new DogmaException(DogmaException.USR_NOT_LOGGED).getMessage() + XMLTags.EXCEPTION_END);	
} else {
	out.clear();
	out.print(dBean.getAttributesXML(request, response));
}
/*
if (!dBean.hasMessages()) {
	out.clear();
	out.print(dBean.getAttributesXML(request));
} else {
	out.print(dBean.getMessagesAsXml(request));
	dBean.clearMessages();
}
*/
%>