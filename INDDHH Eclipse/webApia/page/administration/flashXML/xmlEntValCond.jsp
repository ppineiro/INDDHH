<%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.st.util.StringUtil"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="biz.statum.apia.web.bean.BasicBean"%><%@page import="biz.statum.apia.web.bean.design.BusEntitiesBean"%><%@page import="biz.statum.apia.web.bean.design.FormsBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
BasicBean dBean = BasicAction.staticRetrieveBean(http, BasicAction.BEAN_ADMIN_NAME);

if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");

String ret="";
if (dBean instanceof BusEntitiesBean) {
	ret = ((BusEntitiesBean)dBean).evalCondXML(http);	
} else if (dBean instanceof FormsBean) {
	ret = ((FormsBean)dBean).evalCondXML(http);
}


out.clear();
if (dBean.getMessages().size()==0) {
	out.print(ret);
} else {
	DogmaAbstractBean dogmaBean = new DogmaAbstractBean(); 
	dogmaBean.setMessages(dBean.getMessages(),true);
	out.print(StringUtil.replace(dogmaBean.getMessagesAsXml(request), "\r", ""));
	dBean.clearMessages();
}
%>