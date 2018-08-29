<%@page import="biz.statum.apia.web.action.design.ScenarioAction"%><%@page import="biz.statum.apia.web.bean.design.ScenarioBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%! 
	String lSet;
	
	String lbl(String label) {
		return LabelManager.getName(lSet, label);
	}
%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String  labelSet = Parameters.DEFAULT_LABEL_SET.toString();
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
com.dogma.UserData uData = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
	langId = uData.getLangId();
}

ScenarioBean dBean = (ScenarioBean)ScenarioAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

String currentEntity = null;
if(dBean.currentEntity!=null){
	currentEntity =dBean.currentEntity.toString();
}

String tabId = "tabId=" + request.getParameter("tabId") + "&tokenId=" + request.getParameter("tokenId");

boolean bpmnAtts = false;
boolean apiaExts = false;
boolean userAtts = false;
boolean simAtts = true;
String condRules = 	"REGLAS DE SINTAXIS: \n"+
										"String: 'string' | Number: number | Date: [date] | Null: null \n"+
										"Entity Att.: ent_att('attr_name') | Process Att.: pro_att('attr_name') \n"+
										"Arith. Operator: +, -, /,* \n"+
										"Comp. Operator : &gt;, &lt;, &gt;=, &lt;=, =, !=, &lt;&gt; \n"+
										"Boolean Operator: and, or | Unary Operator: not(expression)";
System.out.println("bpmnAttsbpmnAtts   "+bpmnAtts);

this.lSet = labelSet;

out.clear();
%><?xml version="1.0" ?><elements><%@include file="elementsAttributes/task.jsp" %><%@include file="elementsAttributes/csubflow.jsp" %><%@include file="elementsAttributes/esubflow.jsp" %><%@include file="elementsAttributes/startevent.jsp" %><%@include file="elementsAttributes/middleevent.jsp" %><%@include file="elementsAttributes/endevent.jsp" %><%@include file="elementsAttributes/gateway.jsp" %><%@include file="elementsAttributes/mflow.jsp" %><%@include file="elementsAttributes/association.jsp" %><%@include file="elementsAttributes/sflow.jsp" %><%@include file="elementsAttributes/pool.jsp" %><%@include file="elementsAttributes/textannotation.jsp" %><%@include file="elementsAttributes/group.jsp" %><%@include file="elementsAttributes/swimlane.jsp" %><%@include file="elementsAttributes/dataobject.jsp" %><%@include file="elementsAttributes/back.jsp" %></elements>