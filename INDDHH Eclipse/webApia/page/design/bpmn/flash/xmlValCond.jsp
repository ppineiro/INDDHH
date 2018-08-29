<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="com.dogma.XMLTags"%><%@page import="com.dogma.bean.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.st.util.StringUtil"%><%
BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

if(request.getHeader("User-Agent").indexOf("Firefox") < 0) {
	response.setHeader("Pragma","public no-cache");
} else {
	response.setHeader("Pragma","no-cache");
}

response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

out.clear();

if(dBean == null) {	
	out.print(StringUtil.replace(new DogmaException(DogmaException.USR_NOT_LOGGED).getMessage(), "\r", ""));	
} else {
	out.clear();
	String result = dBean.evalCondXML(request, response);
	Collection<ErrMessageVo> msg = dBean.getMessages(false);
	if (msg.size() == 0) {
		out.print(result);
	} else {
		Collection<String> errs = dBean.generateXmlMessages(new HttpServletRequestResponse(request, response), null);
		String xmlError = XMLTags.XML_HEAD + XMLTags.EXCEPTION_START;
		for(String err : errs) {
			xmlError += StringUtil.escapeXML(err) + "\n";
		}
		xmlError += XMLTags.EXCEPTION_END;
		out.print(StringUtil.replace(xmlError, "\r", ""));
		dBean.clearMessages();
	}
}

/*
if (!dBean.hasMessages()) {
	out.print(ret);
} else {
	out.print(StringUtil.replace(dBean.getMessagesAsXml(request), "\r", ""));
	dBean.clearMessages();
}
*/
%>