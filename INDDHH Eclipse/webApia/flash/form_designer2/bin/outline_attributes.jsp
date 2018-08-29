<%@page import="biz.statum.apia.web.bean.design.FormsBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="biz.statum.apia.web.action.design.FormsAction"%><%
if(request.getHeader("User-Agent").indexOf("Firefox") < 0)
	response.setHeader("Pragma","public no-cache");
else
	response.setHeader("Pragma","no-cache");

response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
com.dogma.UserData uData = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
if (uData != null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}

FormsBean dBean = FormsAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
String values = dBean.getOutlineAttributesList(request, response);
%><?xml version="1.0" ?><forms><data><level width="0%" name="id" label="id" type="label" hidden="true" /><level width="9%" name="type" label="<%=LabelManager.getName(labelSet, langId, "flaTip")%>" type="label" /><level width="0%" name="max" label="Max" type="label" hidden="true"/><level width="79%" name="name" label="<%=LabelManager.getName(labelSet, langId, "flaNom")%>" type="label" /><level width="0%" name="label" label="<%=LabelManager.getName(labelSet, langId, "flaEti")%>" type="label" /><level width="12%" name="details" label="<%=LabelManager.getName(labelSet, langId, "btnDetails")%>" type="info"/></data><%=values%></forms>