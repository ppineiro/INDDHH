
	<% if (Parameters.APIACHAT_MODE_CLIENT && com.dogma.EnvParameters.getEnvParameterBoolean(environmentId,com.dogma.EnvParameters.CHAT_ENABLE)) { %> | <a href="#" onClick="openChat(); return false;"><img src="<%=Parameters.ROOT_PATH%>/programs/chat/images/disconnected.png" id="chatIcon" alt="ApiaChat" align="top" border="0" width="20px"></a><% } %> 
