<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%
BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");
Collection tasks = null;

if (!dBean.hasMessages()) {
	out.clear();
	try {
		out.print(dBean.getProDefinitionXMLProVo());
//		out.print(com.dogma.business.execution.ProInstanceService.getInstance().getProInstXML(new Integer(1), new Integer(1007)));
	} catch (Exception e) {
		e.printStackTrace();
	}
	
} else {

	out.print(dBean.getMessagesAsXml(new HttpServletRequestResponse(request, response)));
	dBean.clearMessages();
}
%>