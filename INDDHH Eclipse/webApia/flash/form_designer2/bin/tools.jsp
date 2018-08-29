<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><%
if(request.getHeader("User-Agent").indexOf("Firefox") < 0) {
	response.setHeader("Pragma","public no-cache");
} else {
	response.setHeader("Pragma","no-cache");
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
/*
String labelSet = Parameters.DEFAULT_LABEL_SET.toString();
Integer langId = Parameters.DEFAULT_LANG;

//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
com.dogma.UserData uData = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
if (uData != null) {
	labelSet = uData.getStrLabelSetId();
	langId = uData.getLangId();
}

String tab = request.getParameter("tabId");
*/
%><?xml version="1.0" ?><elements><element name="input" action="dragAndDrop" elementClass="view.fields.InputField"/><element name="combo" action="dragAndDrop" elementClass="view.fields.ComboboxField"/><element name="checkbox" action="dragAndDrop" elementClass="view.fields.CheckboxField"/><element name="textarea" action="dragAndDrop" elementClass="view.fields.TextareaField"/><element name="file" action="dragAndDrop" elementClass="view.fields.FileField"/><element name="radio" action="dragAndDrop" elementClass="view.fields.RadiobuttonField"/><element name="button" action="dragAndDrop" elementClass="view.fields.ButtonField"/><element name="label" action="dragAndDrop" elementClass="view.fields.LabelField"/><element name="table" action="dragAndDrop" elementClass="view.fields.GridField"/><element name="more" action="press" elementClass="showMoreAction"><element name="title" action="dragAndDrop" elementClass="view.fields.TitleField"/><element name="password" action="dragAndDrop" elementClass="view.fields.PasswordField"/><element name="image" action="dragAndDrop" elementClass="view.fields.ImageField"/><element name="tree" action="dragAndDrop" elementClass="view.fields.TreeField"/><element name="listbox" action="dragAndDrop" elementClass="view.fields.ListboxField"/><element name="editor" action="dragAndDrop" elementClass="view.fields.EditorField"/><element name="link" action="dragAndDrop" elementClass="view.fields.LinkField"/><element name="hidden" action="dragAndDrop" elementClass="view.fields.HiddenField"/><element name="captcha" action="dragAndDrop" elementClass="view.fields.CaptchaField"/></element><element name="undo" action="click" elementClass="undo"/><element name="redo" action="click" elementClass="redo"/><element name="layout" action="press" elementClass="editWorkareaAction"/><element name="clear" action="click" elementClass="clearForm" /></elements>