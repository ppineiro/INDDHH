<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@page import="biz.statum.sdk.util.FileUtil"%><%@page import="java.io.File"%><%@page import="biz.statum.chat.web.external.websocket.ConfigurationInformation"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.chat.web.external.websocket.LabelManager"%><%@page import="biz.statum.chat.web.external.websocket.Configuration"%><% 
Configuration configuration = Configuration.getInstance();
LabelManager labelManager = configuration.getTheLabelManager(request).getLabelManager(request);
String context = configuration.getContext(request);
ConfigurationInformation configInformation = configuration.getConfiguration(request);
if (StringUtil.isEmpty(context)) context = "/";
if (! context.endsWith("/")) context += "/";
%><html><head><title><%= labelManager.getText("TIT_CHAT") %></title><meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" /><link rel="shortcut icon" href="<%= context %>chat/css/favicon.ico"><link rel="stylesheet" href="<%= context %>chat/css/client.css"><link rel="stylesheet" href="<%= context %>chat/css/<%= configInformation.getStyle() %>/client.css"><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/mootools-core-1.4.5-full-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/mootools-more-1.4.0.1-compat.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/atmosphere.js"></script><script language="JavaScript" type="text/javascript" src="<%= context %>chat/js/common.js"></script><script language="javascript" type="text/javascript" src="<%= context %>chat/js/chat.js" ></script><script language="javascript" type="text/javascript" src="<%= context %>chat/js/client.js" ></script><script language="javascript" type="text/javascript">
		var CONFIG_ID = "<%= configInformation.getId() %>";
		var SESSION_ID= "<%= request.getSession().getId() + "c" %>";
		var URL_STATUS = "<%= context + configuration.getStatusUrl() %>/configId:" + CONFIG_ID + "-" + SESSION_ID;
		var URL_CLIENT = "<%= context + configuration.getClientUrl() %>/configId:" + CONFIG_ID + "-" + SESSION_ID;
		var URL_FILE_UPDALOAD   = "<%= context + configuration.getFileUploadUrl() %>";
		var URL_FILE_DOWNLOAD   = "<%= context + configuration.getFileDownloadUrl() %>";
		
		var MSG_REQUIRED_MSG					= "<%= labelManager.getText("MSG_REQUIRED") %>";
		var MSG_CONNECTION_WITH_SERVER_LOST		= "<%= labelManager.getText("MSG_CONNECTION_WITH_SERVER_LOST") %>";
		var MSG_CONNECTION_WITH_SERVER_ACQUIRE	= "<%= labelManager.getText("MSG_CONNECTION_WITH_SERVER_ACQUIRE") %>";
		var MSG_WAITING_FOR_ATTENDANT			= "<%= labelManager.getText("MSG_WAITING_FOR_ATTENDANT") %>";
		var MSG_STILL_WAITING_FOR_ATTENDANT		= "<%= labelManager.getText("MSG_STILL_WAITING_FOR_ATTENDANT") %>";
		var MSG_ATTENDANT_NOT_AVAILABLE			= "<%= labelManager.getText("MSG_ATTENDANT_NOT_AVAILABLE") %>";
		var MSG_ATTENDANT_PRESENT				= "<%= labelManager.getText("MSG_ATTENDANT_PRESENT") %>";
		var MSG_INACTIVITY_WARNING				= "<%= labelManager.getText("MSG_INACTIVITY_WARNING") %>";
		var MSG_INACTIVITY_DISCONNECT			= "<%= labelManager.getText("MSG_INACTIVITY_DISCONNECT") %>";
		
		var MSG_FILE_ACCEPTED_BY_YOU     		= "<%= labelManager.getText("MSG_FILE_ACCEPTED_BY_YOU") %>";
		var MSG_FILE_ACCEPTED_BY_USER    		= "<%= labelManager.getText("MSG_FILE_ACCEPTED_BY_USER") %>";
		var MSG_FILE_DOWNLOADING_BY_USER 		= "<%= labelManager.getText("MSG_FILE_DOWNLOADING_BY_USER") %>";
		var MSG_FILE_DOWNLOADING_BY_YOU  		= "<%= labelManager.getText("MSG_FILE_DOWNLOADING_BY_YOU") %>";
		var MSG_FILE_DOWNLOADED_BY_YOU   		= "<%= labelManager.getText("MSG_FILE_DOWNLOADED_BY_YOU") %>";
		var MSG_FILE_DOWNLOADED_BY_USER  		= "<%= labelManager.getText("MSG_FILE_DOWNLOADED_BY_USER") %>";
		var MSG_FILE_ERROR_TRANSFER        		= "<%= labelManager.getText("MSG_FILE_ERROR_TRANSFER") %>";
		
		var MSG_FILE_WAIT_ACCEPT				= "<%= labelManager.getText("MSG_FILE_WAIT_ACCEPT") %>";
		var MSG_FILE_NEW						= "<%= labelManager.getText("MSG_FILE_NEW") %>";
		var MSG_FILE_CANCEL_BY_YOU				= "<%= labelManager.getText("MSG_FILE_CANCEL_BY_YOU") %>";
		var MSG_FILE_CANCEL_BY_USER				= "<%= labelManager.getText("MSG_FILE_CANCEL_BY_USER") %>";
		var LBL_ACCEPT							= "<%= labelManager.getText("LBL_ACCEPT") %>";
		var LBL_REJECT							= "<%= labelManager.getText("LBL_REJECT") %>";
		
		var MSG_EXIST_CONVERSATION_QUESTION		= "<%= labelManager.getText("MSG_EXIST_CONVERSATION_QUESTION") %>";
		
		window.addEvent('load', function() { initClient(URL_STATUS, URL_CLIENT, CONFIG_ID); });
		window.addEvent('resize', function() { domAdjustHeights(); });
	</script></head><body><% if (configInformation.isInvalid()) { %><div class="invalid"><p class="title"><%= labelManager.getText("TIT_INVALID_CONFIGURATION") %></p><p class="message"><%= labelManager.getText("MSG_INVALID_CONFIGURTAION") %></p></div><% } else { %><div class="bodyLoading" id="boddyLoading"><p class="title"><%= labelManager.getText("TIT_LOADING") %></p><p class="message"><%= labelManager.getText("MSG_LOADING") %></p></div><div class="bodyStart hide" id="bodyStart"><div class="header"><%= labelManager.getText("TIT_START_CHAT") %></div><div class="fields" id="bodyStartFields"><% if (configInformation.isRequestName()) { %><div class="field required"><label><%= labelManager.getText("TIT_FLD_NAME") %>:</label><input name="_name" required="required"></div><% } %><% if (configInformation.isRequestEmail()) { %><div class="field required"><label><%= labelManager.getText("TIT_FLD_EMAIL") %>:</label><input name="_email" required="required"></div><% } %><% if (configInformation.isRequestSubject()) { %><div class="field required"><label><%= labelManager.getText("TIT_FLD_SUBJECT") %>:</label><input name="_subject" required="required" placeholder="<%= StringUtil.noNull(configInformation.getDefaultSubject()) %>"></div><% } %><!-- Load HTML from file - start --><%
			if (StringUtil.notEmpty(configInformation.getAdditionalFields())) {
				File htmlFile = new File(configInformation.getAdditionalFields());
				if (htmlFile.exists() && htmlFile.canRead()) {
					String htmlContent = FileUtil.readFile(htmlFile);
					out.print(htmlContent);
				}
			}
			%><!-- Load HTML from file - end --><div class="field required"><label><%= labelManager.getText("TIT_FLD_GROUP") %>:</label><select name="_group" id="groups"></select></div></div><div class="buttons"><input type="button" id="sendRequest" value="<%= labelManager.getText("BTN_START") %>"></div><div class="progress hide" id="sendRequestProgress"></div></div><div class="bodyChat hide" id="bodyChat"><div class="chatHeader" id="chatHeader"><%= labelManager.getText("TIT_CHAT_MESSAGES") %></div><div class="chatMessagesContainer" id="chatMessagesContainer"><div class="chatMessages" id="chatMessages"></div></div><div class="chatOptions disableSend" id="chatOptions"><form method="post" enctype="multipart/form-data" class="file hide" id="defaultForm"><input type="file" class="theFile" name="theFile" id="theFileToSend" style="height: 0px;width: 0px;"><input type="button" class="file theButton" value="" title="<%= labelManager.getText("MSG_SEND_FILE") %>"></form><div clasS="exit" id="btnExit" title="<%= labelManager.getText("MSG_EXIT") %>"></div><div class="messageContainer"><div class="placeholder" id="inputPlaceholder"><%= labelManager.getText("MSG_WRITE_MESSAGE") %></div><div class="input" contenteditable="true" id="inputMessage"></div></div></div></div><% } %></body></html>