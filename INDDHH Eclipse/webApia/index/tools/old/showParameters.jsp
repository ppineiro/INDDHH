<b>Parameters:</b><BR><BR><%
	String[] pars = com.dogma.Parameters.getParameterNames();
	if (pars != null) {
		for (int i = 0; i < pars.length; i++) {
			String name  = pars[i];
			String value = com.dogma.Parameters.getParameter(name);
%><%=name%>: <%=value%><br><%
		}
	}
%><BR><BR><b>Environment Parameters:</b><BR><BR><%
	String[] envpars = com.dogma.EnvParameters.getParameterNames();
	if (envpars != null) {
		for (int i = 0; i < envpars.length; i++) {
			String envname  = envpars[i];
			
			String envStr = envname.substring(0, envname.indexOf("-"));
			Integer envId = new Integer(envStr);
			String name = envname.substring(envname.indexOf("-") + 1);

			String value = com.dogma.EnvParameters.getEnvParameter(envId, name);
%><%=name%>: <%=value%> (Environment = <%=envId%>)<br><%
		}
	}
%><BR><BR><b>Database Parameters:</b><BR><BR>
	URL: <%=com.dogma.Configuration.DB_URL%><br>
	User: <%=com.dogma.Configuration.DB_USR%><br>
	Password: <%=com.dogma.Configuration.DB_PWD%><br>
	Implementation: <%=com.dogma.Configuration.DB_IMPLEMENTATION%><br>
	Max connections: <%=com.dogma.Configuration.DB_MAX_CONNECTIONS%><br>
	Min connections: <%=com.dogma.Configuration.DB_MIN_CONNECTIONS%><br>
	Connection renew time: <%=com.dogma.Configuration.DB_CONN_RENEW_TIME%><br>
	Connection renew time: <%=com.dogma.Configuration.DB_CONN_RENEW_TIME%><br><BR><BR><b>Application Parameters:</b><BR><BR>
	Application Path: <%=com.dogma.Configuration.APP_PATH%><br>
	Root Path: <%=com.dogma.Configuration.ROOT_PATH%><br>
	Temporal Storage Path: <%=com.dogma.Configuration.TMP_FILE_STORAGE%><br>
	Dispatcher XML : <%=com.dogma.Configuration.MONITOR_XML_DIR%><br>
	Log Directory: <%=com.dogma.Configuration.LOG_DIRECTORY%><br>
	Debug Log File: <%=com.dogma.Configuration.DEBUG_LOG_FILE%><br><BR><BR>


