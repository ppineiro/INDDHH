<%@page import="chat.commands.conversation.NewMessage"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><% if (Parameters.APIACHAT_MODE_CLIENT && com.dogma.EnvParameters.getEnvParameterBoolean(environmentId,com.dogma.EnvParameters.CHAT_ENABLE)) { %><script type='text/javascript'>
		var DATE_FORMAT	= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(environmentId,EnvParameters.FMT_DATE))%>";
		var TIME_FORMAT	= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(environmentId,EnvParameters.FMT_TIME))%>";

		var MSG_TYPE_NA 					= '<%= NewMessage.TYPE_NA %>';
		var MSG_TYPE_NEW_USER				= '<%= NewMessage.TYPE_NEW_USER %>';
		var MSG_TYPE_EXIT_USER				= '<%= NewMessage.TYPE_EXIT_USER %>';
		
		var MSG_TYPE_NEW_FILE_TRANFER		= '<%= NewMessage.TYPE_NEW_FILE_TRANFER %>';
		var MSG_TYPE_ACCEPT_FILE_TRANFER	= '<%= NewMessage.TYPE_ACCEPT_FILE_TRANFER %>';
		var MSG_TYPE_CANCEL_FILE_TRANFER	= '<%= NewMessage.TYPE_CANCEL_FILE_TRANFER %>';
		var MSG_TYPE_COMPLET_FILE_TRANFER	= '<%= NewMessage.TYPE_COMPLET_FILE_TRANFER %>';
		var MSG_TYPE_SENDING_FILE_TRANFER	= '<%= NewMessage.TYPE_SENDING_FILE_TRANFER %>';
		var MSG_TYPE_ERROR_FILE_TRANFER		= '<%= NewMessage.TYPE_ERROR_FILE_TRANFER %>';
		
		window.addEvent('domready', function() {
			var ui = new ApiaChatUI({
				hasLogin: false,
				url: '<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/apiaCommunicator/Client.chat',
				urlDownload: '<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/apiaCommunicator/chatServer.jsp',
				loginTitle: 'Login',
				mainTitle: 'Chat',
				openMainOnLogged: false,
				onCloseMainDisconect: false,
				delayRefresh: <%= Parameters.APIACHAT_FREQUENCY_CALLBACK %>
			});
			ui.checkStatus();
			window.ui = ui;
		});
		</script><style type="text/css">
			.jxDialogControls .jxBarScroller {
	 			left: auto !important;
			}
		</style><% } %>
