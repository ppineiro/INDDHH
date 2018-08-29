<%@page import="biz.statum.apia.web.bean.design.FormsBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.design.FormsAction"%><%
if(request.getHeader("User-Agent").indexOf("Firefox") < 0)
	response.setHeader("Pragma","public no-cache");
else
	response.setHeader("Pragma","no-cache");

response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

String acc = request.getParameter("action");
String values = "";
if("definition".equals(acc)) {
	
} else {
	FormsBean dBean = FormsAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
	values = dBean.getModalData(request);	
}

%><?xml version="1.0" ?><forms><data><level width="0" name="id" label="id" type="label" hidden="true" /><level width="30%" name="qryid" label="Id" type="label" /><level width="70%" name="name" label="Name" type="label" /><level width="0" name="label" label="Label" type="label" /></data><values><%=values%></values></forms>
