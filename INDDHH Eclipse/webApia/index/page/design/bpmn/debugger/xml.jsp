<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%
	response.setContentType("text/xml");
	BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
	
%><%=dBean.getDebuggerXml()%>