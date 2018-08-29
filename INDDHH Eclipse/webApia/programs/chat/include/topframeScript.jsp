
	function openChat() {
		<% if (Parameters.APIACHAT_MODE_CLIENT && com.dogma.EnvParameters.getEnvParameterBoolean(environmentId,com.dogma.EnvParameters.CHAT_ENABLE)) { %>
			if (window.parent.ui.isLogged()) {
				window.parent.ui.toggleMainUi();
			}
		<% } %>
	}
	
	function checkChatStatus() {
		<% if (Parameters.APIACHAT_MODE_CLIENT && com.dogma.EnvParameters.getEnvParameterBoolean(environmentId,com.dogma.EnvParameters.CHAT_ENABLE)) { %>
			document.getElementById('chatIcon').src = window.parent.ui.isLogged() ? "<%=Parameters.ROOT_PATH%>/programs/chat/images/connected.png" : "<%=Parameters.ROOT_PATH%>/programs/chat/images/disconnected.png";
			setTimeout("checkChatStatus()", 2000);
			if (! window.parent.ui.isLogged() && ! window.parent.ui.checkingStatus) window.parent.ui.checkStatus();
		<% } %>
	}
