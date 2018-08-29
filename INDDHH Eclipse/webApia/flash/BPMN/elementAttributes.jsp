<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="biz.statum.apia.web.action.design.BPMNProcessAction"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.design.BPMNProcessBean"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%! 
	String lSet;
	
	String lbl(String label) {
		return LabelManager.getName(lSet, label);
	}
%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String labelSet = Parameters.DEFAULT_LABEL_SET.toString();
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
com.dogma.UserData uData = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
	langId = uData.getLangId();
}

BPMNProcessBean dBean = (BPMNProcessBean)BPMNProcessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

String currentEntity = null;

if(dBean.currentEntity!=null){
	currentEntity = dBean.currentEntity.toString();
}

String tabId = "tabId=" + request.getParameter("tabId") + "&tokenId=" + request.getParameter("tokenId");

boolean bpmnAtts = true;
boolean apiaExts = true;
boolean userAtts = false;
boolean simAtts = false;

String condRules=com.st.util.StringUtil.escapeHTML(com.st.util.StringUtil.replace(LabelManager.getName(labelSet, "flaProCndRul")+LabelManager.getName(labelSet, "flaProCndRul2")+LabelManager.getName(labelSet, "flaProCndRul3"),"\r","")); //Con Rules

this.lSet = labelSet;

out.clear();
%><?xml version="1.0" ?><elements><%@include file="elementsAttributes/task.jsp" %><%@include file="elementsAttributes/csubflow.jsp" %><%@include file="elementsAttributes/esubflow.jsp" %><%@include file="elementsAttributes/startevent.jsp" %><%@include file="elementsAttributes/middleevent.jsp" %><%@include file="elementsAttributes/endevent.jsp" %><%@include file="elementsAttributes/gateway.jsp" %><%@include file="elementsAttributes/mflow.jsp" %><%@include file="elementsAttributes/association.jsp" %><%@include file="elementsAttributes/sflow.jsp" %><%@include file="elementsAttributes/pool.jsp" %><%@include file="elementsAttributes/textannotation.jsp" %><%@include file="elementsAttributes/group.jsp" %><%@include file="elementsAttributes/swimlane.jsp" %><%@include file="elementsAttributes/dataobject.jsp" %><%@include file="elementsAttributes/datainput.jsp" %><%@include file="elementsAttributes/dataoutput.jsp" %><%@include file="elementsAttributes/datastore.jsp" %><%@include file="elementsAttributes/back.jsp" %></elements>