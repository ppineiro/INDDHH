
<% if (Parameters.APIACHAT_MODE_CLIENT && com.dogma.EnvParameters.getEnvParameterBoolean(environmentId,com.dogma.EnvParameters.CHAT_ENABLE)) { %>
	setTimeout("checkChatStatus()",2000);
<% } %>