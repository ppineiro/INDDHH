<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.vo.IFldType"%><%
if(request.getHeader("User-Agent").indexOf("Firefox") < 0) {
	response.setHeader("Pragma","public no-cache");
} else {
	response.setHeader("Pragma","no-cache");
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String labelSet = Parameters.DEFAULT_LABEL_SET.toString();
Integer langId = Parameters.DEFAULT_LANG;

com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData != null) {
	labelSet = uData.getStrLabelSetId();
	langId = uData.getLangId();
}

String tab = request.getParameter("tabId");
%><?xml version="1.0" ?><elements><%@include file="elementAttributes/input.jsp" %><%@include file="elementAttributes/listbox.jsp" %><%@include file="elementAttributes/combobox.jsp" %><%@include file="elementAttributes/checkbox.jsp" %><%@include file="elementAttributes/password.jsp" %><%@include file="elementAttributes/option.jsp" %><%@include file="elementAttributes/textarea.jsp" %><%@include file="elementAttributes/label.jsp" %><%@include file="elementAttributes/button.jsp" %><%@include file="elementAttributes/title.jsp" %><%@include file="elementAttributes/file.jsp" %><%@include file="elementAttributes/hidden.jsp" %><%@include file="elementAttributes/image.jsp" %><%@include file="elementAttributes/grid.jsp" %><%@include file="elementAttributes/link.jsp" %><%@include file="elementAttributes/editor.jsp" %><%@include file="elementAttributes/form.jsp" %></elements>