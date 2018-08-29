<%@page import="biz.statum.apia.web.bean.design.FormsBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="biz.statum.apia.web.action.design.FormsAction"%><%
if(request.getHeader("User-Agent").indexOf("Firefox") < 0)
	response.setHeader("Pragma","public no-cache");
else
	response.setHeader("Pragma","no-cache");

response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

FormsBean dBean = FormsAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
String values = dBean.getEntitiesAttList(request, response);
%><?xml version="1.0" ?><forms><values><%=values%></values></forms>