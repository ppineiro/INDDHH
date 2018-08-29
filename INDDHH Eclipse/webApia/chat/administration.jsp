<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@page import="biz.statum.sdk.util.CollectionUtil"%><%@page import="biz.statum.chat.web.external.websocket.chat.ExternalManager"%><%@page import="biz.statum.chat.web.external.websocket.chat.ExternalComunicator"%><%@page import="java.util.ArrayList"%><%@page import="biz.statum.chat.web.external.websocket.ConfigurationInformation"%><%@page import="biz.statum.chat.web.external.websocket.Configuration"%><%@page import="java.util.Collection"%><%@page import="biz.statum.sdk.configuration.ConfigurationLoader"%><%@page import="biz.statum.sdk.configuration.ConfigurationParameter"%><%@page import="biz.statum.sdk.configuration.ConfigurationPackage"%><%@page import="biz.statum.sdk.configuration.BaseConfiguration"%><%@page import="java.lang.reflect.Field"%><%@page import="java.lang.reflect.Modifier"%><%@page import="java.io.File"%><%@page import="biz.statum.sdk.util.ClassUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.sdk.util.BooleanUtils"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><title>Generic Chat Web Client - Diagnosis</title><style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
		
		span.resource {color: grey; }
	</style></head><%

Object paramLogged = request.getSession().getAttribute("logged");
Boolean logged = null;
if (paramLogged instanceof Boolean) logged = (Boolean) paramLogged;

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "chatdiagnosis".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}

logged = Boolean.TRUE;

String action = request.getParameter("action");

if ("startManager".equals(action)) {
	Configuration.getInstance().apply();
}

%><body><% if (logged.booleanValue()) { %><fieldset><legend><b>Load</b></legend><form action="?" method="post"><input type="hidden" name="doLoad" value="true"><table><tr><td>Load result:</td><td><%
						String doLoad = request.getParameter("doLoad");
						String resultLoad = "<font style='color:gray'>not done</font>";
						
						if (doLoad != null && "true".equals(doLoad)) {
							ConfigurationLoader.load(Configuration.getInstance());
							Configuration.getInstance().apply();
							resultLoad = "<font style='color:green'>loaded</font>";
						}
					%><%= resultLoad %></td></tr><tr><td>&nbsp;</td><td><input type="submit" value="Load"></td></tr></table></form></fieldset><%
	
	BaseConfiguration configContainer = Configuration.getInstance();
		
	ConfigurationPackage configuration = configContainer.getClass().getAnnotation(ConfigurationPackage.class);
	
	Collection<Field> configFieldList = new ArrayList<Field>();

	Field[] configFields = configContainer.getClass().getFields();
	for (Field field : configFields) {
		configFieldList.add(field); 
	} %><fieldset><legend><b><%= ClassUtil.getClassName(configContainer.getClass()) %></b></legend><table><%
			for (Field field : configFieldList) {
				field.setAccessible(true);
				
				int fieldModifiers = field.getModifiers();
				String type = field.getType().toString();
				if (type.startsWith(ClassUtil.TYPE_CLASS)) type = type.substring(ClassUtil.TYPE_CLASS.length());
				
				if (Modifier.isPrivate(fieldModifiers) || !Modifier.isStatic(fieldModifiers)) continue;
				
				Object value = null;
				Object paramValue = null;
				try {
					value = field.get(null);
					paramValue = value;
					if (value instanceof String && field.getName().toLowerCase().indexOf("password") == -1) value = StringUtil.toXml((String) value);
					if (value instanceof String && field.getName().toLowerCase().indexOf("password") != -1) value = "<i>**************</i>";
				} catch (IllegalArgumentException e) {
					value = "[n/a]";
				} catch (IllegalAccessException e) {
					value = "[n/a]";
				}
	
				String title = StringUtil.EMPTY_STRING;
				String test = StringUtil.EMPTY_STRING;
				
				ConfigurationParameter configParameter = field.getAnnotation(ConfigurationParameter.class);
				if (configParameter != null) {
					title = "title=\"Property: " + configParameter.propertyName() + " - Required: " + BooleanUtils.toString(configParameter.required());
					if (StringUtil.notEmpty(configParameter.defValue())) title += " - Default value: " + configParameter.defValue();
					title += "\"";
					
					if (paramValue != null && paramValue instanceof String) {
						if (configParameter.represents() == ConfigurationParameter.Represents.PATH) {
							File aPath = new File((String) paramValue);
							test = "Path exists: <b>" + (aPath.exists() && aPath.isDirectory()) + "</b>";
							test += " - Can read: <b>" + aPath.canRead() + "</b>";
							test += " - Can write: <b>" + aPath.canWrite() + "</b>";
							
						} else if (configParameter.represents() == ConfigurationParameter.Represents.FILE) {
							File aPath = new File((String) paramValue);
							test = "File exists: <b>" + (aPath.exists() && aPath.isFile()) + "</b>";
							test += " - Can read: <b>" + aPath.canRead() + "</b>";
						}
					}
				}
				
				String name = field.getName().toLowerCase();
				name = StringUtil.replace(name, "_", " ");
				name = StringUtil.firstUp(name);
				
				%><tr><td <%=title%>><%=name%></td><td><%=type%></td><td><b><%=value%></b></td><td><%=test%></td></tr><%
			} %><% if (! Configuration.inApiaConfiguration()) { %><tr><td colspan="4"><span class="resource">Resource file: ...<%= File.separator + StringUtil.replace(configuration.configurationFile(),".",File.separator) %>.properties</span></td></tr><% } %><tr><td>Manager running:</td><td><%= ExternalManager.getInstance().isActive() %></td><td><% if (! ExternalManager.getInstance().isActive()) { %><a href="?action=startManager">[ Start ]</a><% } %></td><td></td></tr><tr><td>Client connected:</td><td><%= ExternalManager.getInstance().getComunicator().isConnected() %></td><td></td><td></td></tr><tr><td>Amount conversations:</td><td><%= ExternalManager.getInstance().getComunicator().getAmountConversations() %></td><td></td><td></td></tr></table></fieldset><fieldset><legend><b>Test available</b></legend><form action="?" method="post"><input type="hidden" name="doTest" value="true"><%
			String requestTo = request.getParameter("requestTo");
			if (requestTo == null) requestTo = "";  %><table><tr><td>Verify request group:</td><td><input type="text" name="requestTo" value="<%= requestTo %>"></td></tr><tr><td>Test result:</td><td><%
						String doTest = request.getParameter("doTest");
						String result = "<font style='color:gray'>not done</font>";
						
						if (doTest != null && "true".equals(doTest)) {
							if (requestTo == null || requestTo.length() == 0) {
								result = "Need to insert a group to test for.";
							} else if (! ExternalManager.getInstance().getComunicator().isConnected()) {
								result = "Can't access server, tray again in " + Configuration.getInstance().getVerifiationFrequency() + " ms.";
							} else {
								result = ExternalManager.getInstance().getComunicator().getActiveGroups().contains(requestTo) ? "<font style='color:green'>group <b>" + requestTo + "</b> present.</font>" : "<font style='color:red'>group <b>" + requestTo + "</b> not present.</font>";
							}
						}
					%><%= result %></td></tr><tr><td>&nbsp;</td><td><input type="submit" value="test"></td></tr></table></form></fieldset><fieldset><legend><b>ID condiguration</b></legend><%
		String idToLoad = request.getParameter("idToLoad");
		if (idToLoad == null) idToLoad = ""; %><table><tr><td>ID</td><td>Style (s)</td><td>From (f)</td><td>Join to (j)</td><td>Request to (r)</td><td># Status</td><td>Active</td></tr><%
			Collection<ConfigurationInformation> configurations = Configuration.getInstance().getConfigurations(); 
			if (CollectionUtil.notEmpty(configurations)) {
				for (ConfigurationInformation configInfo : configurations) { 
					if (StringUtil.isEmpty(configInfo.getId())) continue; %><tr><td><%= configInfo.getId() %></td><td><%= configInfo.getStyle() %></td><td><%= configInfo.getFrom() %></td><td><%= configInfo.getJoinTo() %></td><td><%= configInfo.getRequestTo() %></td><td><%= configInfo.getAmountNotifyTo() %><td><%= CollectionUtil.notEmpty(configInfo.getCurrentActive()) %></tr><%
				}
			} %></table></fieldset><fieldset><legend><b>Options</b></legend><form action="?" method="post"><input type="submit" value="Refresh"></form></fieldset><%
} else { %><form action="" method="post"><b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br><input type="submit" value="Login"></form><% } %></body></html>