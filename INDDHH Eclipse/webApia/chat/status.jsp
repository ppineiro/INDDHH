<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@page import="biz.statum.chat.web.external.websocket.ConfigurationInformation"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.chat.web.external.websocket.LabelManager"%><%@page import="biz.statum.chat.web.external.websocket.Configuration"%><% 
Configuration configuration = Configuration.getInstance();
LabelManager labelManager = configuration.getTheLabelManager(request).getLabelManager(request);
String context = configuration.getContext(request);
ConfigurationInformation configInformation = configuration.getConfiguration(request);
if (StringUtil.isEmpty(context)) context = com.dogma.Configuration.ROOT_PATH;
if (! context.endsWith("/")) context += "/";
%><html><head><title><%= labelManager.getText("TIT_CHAT_STATUS") %></title><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" /><link rel="shortcut icon" href="<%= context %>chat/css/favicon.ico"><link rel="stylesheet" href="<%= context %>chat/css/status.css"><link rel="stylesheet" href="<%= context %>chat/css/<%= configInformation.getStyle() %>/status.css"><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/mootools-core-1.4.5-full-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/mootools-more-1.4.0.1-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/atmosphere.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/common.js"></script><script language="javascript" type="text/javascript" src="<%= context %>chat/js/status.js" ></script><script language="javascript" type="text/javascript">
		var CONFIG_ID = "<%= configInformation.getId() %>";
		var SESSION_ID= "<%= request.getSession().getId() %>";
		var URL = "<%= context + configuration.getStatusUrl() %>/configId:" + CONFIG_ID + "-" + SESSION_ID;
		
		window.addEvent('load', function() {
			<% if (! configInformation.isInvalid()) { %> initStatus(URL, CONFIG_ID);<% } %>
		});
	</script></head><body><div id="chatStatus" class="chatStatus <% if (configInformation.isInvalid()) { %>invalid<% }  %> "></div></body></html>