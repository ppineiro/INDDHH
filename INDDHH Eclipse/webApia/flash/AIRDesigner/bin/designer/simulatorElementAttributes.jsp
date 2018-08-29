<%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.SimScenarioBean"></jsp:useBean><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
String currentEntity = null;
if(dBean.currentEntity!=null){
	currentEntity =dBean.currentEntity.toString();
}
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
out.clear();
%><?xml version="1.0" ?><elements><%@include file="elementsAttributes/task.jsp" %><%@include file="elementsAttributes/csubflow.jsp" %><%@include file="elementsAttributes/esubflow.jsp" %><%@include file="elementsAttributes/startevent.jsp" %><%@include file="elementsAttributes/middleevent.jsp" %><%@include file="elementsAttributes/endevent.jsp" %><%@include file="elementsAttributes/gateway.jsp" %><%@include file="elementsAttributes/mflow.jsp" %><%@include file="elementsAttributes/association.jsp" %><%@include file="elementsAttributes/sflow.jsp" %><%@include file="elementsAttributes/pool.jsp" %><%@include file="elementsAttributes/textannotation.jsp" %><%@include file="elementsAttributes/group.jsp" %><%@include file="elementsAttributes/swimlane.jsp" %><%@include file="elementsAttributes/dataobject.jsp" %><%@include file="elementsAttributes/back.jsp" %></elements>