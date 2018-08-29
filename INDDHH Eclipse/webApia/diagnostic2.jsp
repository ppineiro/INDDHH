<%@page import="java.util.TimeZone"%><%@page import="java.util.Date"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page import="com.apiamonitor.agent.Configurator"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.util.Calendar"%><%@page language="java"%><%@page import="com.dogma.bi.BIConstants"%><%@page import="com.dogma.bi.BIEngine"%><%@page import="com.dogma.Parameters"%><%
String USERNAME = "admin";
String PASSWORD = "admin22";
%><html><body><%
	boolean logged = "true".equals(request.getSession().getAttribute("logged"));

	if (! logged) {
		String user = request.getParameter("txtLogin");
		String pwd = request.getParameter("txtPassword");
		
		if((USERNAME.equals(user) && PASSWORD.equals(pwd))){
			logged = true;
			request.getSession().setAttribute("logged","true");
		}
	}
	
	if(!logged){%><form method="post" action=""><table><tr><td colspan=2>Authentication is required</td></tr><tr><td>User:</td><td><input type="text" name="txtLogin"></td></tr><tr><td>Password:</td><td><input type="password" name="txtPassword"></td></tr><tr><td colspan=2><input type="submit" value="Login"></td></tr></table></form><%}else{%><table align='center'><tr><td><b><font size=6>APIA DIAGNOSTICS</font></b></td></tr><tr><td>&nbsp;</td></tr><tr><td><b>General Parameters</b></td></tr><tr><td><table border='1'><tr><td>Real version</td><td><%= com.dogma.DogmaConstants.APIA_VERSION %></td></tr><tr><td>USE_TIMEZONE</td><td><%= com.dogma.Configuration.USE_TIMEZONE%></td></tr><tr><td>Current time:</td><td><%= new java.util.Date() %></td></tr><%
						TimeZone timezone = TimeZone.getDefault();
					    int timeZoneHours = timezone.getRawOffset() / 60 / 60 / 1000;
					    int timeZoneDaylight = timezone.getDSTSavings() / 60 / 60 / 1000;
						Date currentDate = new Date();
						Calendar calendar = GregorianCalendar.getInstance();
						calendar.setTime(currentDate);;
						calendar.add(Calendar.HOUR, -1 * (timeZoneHours + timeZoneDaylight));
						for (int i = -12; i <= 12; i++) {
							if (i == 0) continue;
							Calendar theCal = GregorianCalendar.getInstance();
							theCal.setTimeInMillis(calendar.getTimeInMillis());
							theCal.add(Calendar.HOUR, i); %><tr><td>Timezone <%= i %>:</td><td><%= theCal.getTime() %></td></tr><%
						} %><%
							String[] pars = com.dogma.Parameters.getParameterNames();
							if (pars != null) {
								for (int i = 0; i < pars.length; i++) {
									String name  = pars[i];
									String value = com.dogma.Parameters.getParameter(name,"");
									%><tr><td><%=name%></td><td><%=value%></td></tr><%
								}
							}
						%></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Environment Parameters</b></td></tr><tr><td><table border='1'><%
							String[] envpars = com.dogma.EnvParameters.getParameterNames();
							if (envpars != null) {
								for (int i = 0; i < envpars.length; i++) {
									String envname  = envpars[i];
									String envStr = envname.substring(0, envname.indexOf("-"));
									Integer envId = new Integer(envStr);
									String name = envname.substring(envname.indexOf("-") + 1);
									String value = com.dogma.EnvParameters.getEnvParameter(envId, name);
						%><tr><td><%=name%></td><td><%=value%> (Environment = <%=envId%>)</td></tr><%
								}
							}
						%></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Database Parameters</b></td></tr><tr><td><table border='1'><tr><td>Url</td><td><%=com.dogma.Configuration.DB_URL%></td></tr><tr><td>User</td><td><%=com.dogma.Configuration.DB_USR%></td></tr><%if(request.getParameter("showPassword")!=null){ %><tr><td>Password</td><td><%=com.dogma.Configuration.DB_PWD%></td></tr><%} %><tr><td>Implementation</td><td><%=com.dogma.Configuration.DB_IMPLEMENTATION%></td></tr><tr><td>Max connections</td><td><%=com.dogma.Configuration.DB_MAX_CONNECTIONS%></td></tr><tr><td>Min connections</td><td><%=com.dogma.Configuration.DB_MIN_CONNECTIONS%></td></tr><tr><td>Connection renew time</td><td><%=com.dogma.Configuration.DB_CONN_RENEW_TIME%></td></tr></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>BI Database Parameters</b></td></tr><%if (Parameters.BI_INSTALLED){ %><tr><td><table border='1'><tr><td>BI Url</td><td><%=com.dogma.BIParameters.BIDB_URL%></td></tr><tr><td>BI User</td><td><%=com.dogma.BIParameters.BIDB_USR%></td></tr><%if(request.getParameter("showPassword")!=null){ %><tr><td>BI Password</td><td><%=com.dogma.BIParameters.BIDB_PWD%></td></tr><%} %><tr><td>BI Implementation</td><td><%=com.dogma.BIParameters.BIDB_IMPLEMENTATION%></td></tr><tr><td>BI Max connections</td><td><%=com.dogma.BIParameters.BIDB_MAX_CONNECTIONS%></td></tr><tr><td>BI Min connections</td><td><%=com.dogma.BIParameters.BIDB_MIN_CONNECTIONS%></td></tr><tr><td>BI Connection renew time</td><td><%=com.dogma.BIParameters.BIDB_CONN_RENEW_TIME%></td></tr></table></td></tr><%} %><tr><td>&nbsp;</td></tr><tr><td><table border='1'><tr><td>BI Status</td><td><%= BIConstants.BI_CORRECTLY_INSTALLED %><tr><td>BI Status error</td><td><%=BIConstants.BI_STATUS_ERROR%></td></tr><tr><td>BI Configuration</td><td><%=BIEngine.checkBIConfiguration()%></td></tr><tr><td>BI Connection</td><td><%=BIEngine.checkBIConnection()%></td></tr><% String birestart = request.getParameter("birestart");
						if (birestart != null && "true".equals(birestart)) {
							BIEngine.biConfigVerifier(); %><tr><td>BI Status</td><td><%= BIConstants.BI_CORRECTLY_INSTALLED %><tr><td>BI Status error</td><td><%=BIConstants.BI_STATUS_ERROR%></td></tr><tr><td>BI Configuration</td><td><%=BIEngine.checkBIConfiguration()%></td></tr><tr><td>BI Connection</td><td><%=BIEngine.checkBIConnection()%></td></tr><% } %></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Modules versions</b></td></tr><tr><td><table border='1'><tr><td>apia.char.jar</td><td><%=chat.core.ServerEngine.VERSION%></td></tr><tr><td>APIACHAT_MODE_CLIENT</td><td><%=com.dogma.Parameters.APIACHAT_MODE_CLIENT%></td></tr><tr><td>APIACHAT_SERVER_NODE</td><td><%=com.dogma.Parameters.APIACHAT_SERVER_NODE%></td></tr></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>System varibles</b></td></tr><tr><td><table border='1'><tr><td>ANT_HOME</td><td><%=System.getenv("ANT_HOME")%></td></tr><tr><td>JAVA_HOME</td><td><%=System.getenv("JAVA_HOME")%></td></tr></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Application Parameters</b></td></tr><tr><td><table border='1'><tr><td>Application Path</td><td><%=com.dogma.Configuration.APP_PATH%></td></tr><tr><td>Root Path</td><td><%=com.dogma.Configuration.ROOT_PATH%></td></tr><tr><td>Temporal Storage Path</td><td><%=com.dogma.Configuration.TMP_FILE_STORAGE%></td></tr><tr><td>Dispatcher XML</td><td><%=com.dogma.Configuration.MONITOR_XML_DIR%></td></tr><tr><td>Log Directory</td><td><%=com.dogma.Configuration.LOG_DIRECTORY%></td></tr><tr><td>Debug Log File</td><td><%=com.dogma.Configuration.DEBUG_LOG_FILE%></td></tr><tr><td>Node name</td><td><%=com.dogma.Configuration.NODE_NAME%></td></tr></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td><b>Security Server</b></td></tr><tr><td><table border='1'><%
						// Try to connect to the common ports for the security server
						String hostPort = null;
						String status = null;
					    try {
						    //com.dogma.business.SecurityServerService service = com.dogma.business.SecurityServerService.getInstance();
							hostPort = com.dogma.business.SecurityServerService.getInstance().getHostPort();
							if(hostPort!=null){
						    status = com.dogma.business.SecurityServerService.getInstance().queryServer(hostPort); 
						    }%><tr><td><%=hostPort%></td><td>&nbsp;</td><td><%=(status != null)?status:"NO STATUS"%></td></tr><%
					    } catch (com.dogma.DogmaException ex) { %><tr><td>ERROR</td><td>&nbsp;</td><td><%=ex.toString()%> [<%=(hostPort != null)?hostPort:""%>] [<%=(status != null)?status:""%>]</td></tr><%
					    	// An error has ocurred. We do not show an error, because we want to enable the usage of apia
					    	com.st.util.log.Log.error(ex.getCompleteStackTrace());
					    } %></table></td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr></table>
					    
					    
					    	<div class="section hideContent">
			<h2><span class="showContent">+</span><span class="hideContent">-</span>Agent information</h2>
			
			<div class="row"><span class="field">Version:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_VERSION + " " + com.apiamonitor.agent.Configurator.AGENT_RELEASE_DATE %></span></div>
			
			<div class="clear">&nbsp;</div>
			
			<div class="row"><span class="field">Active:</span><span class="value"><%=!com.dogma.Configuration.DISABLE_APIAMONITOR%></span></div>
			<div class="row"><span class="field">Uptime:</span><span class="value"><%=new java.util.Date(com.apiamonitor.agent.Configurator.upTime)%></span></div>
			<div class="row"><span class="field">Name:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_NAME%></span></div>
			<div class="row"><span class="field">Command port:</span><span class="value"><%=com.apiamonitor.agent.Configurator.COMMAND_SERVER_PORT%></span></div>
			<div class="row"><span class="field">Log port:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOGGING_SERVER_PORT%></span></div>
			<div class="row"><span class="field">Server IP:</span><span class="value"><%=com.apiamonitor.agent.Configurator.SERVER_IP%></span></div>
			<div class="row"><span class="field">Launch sampler:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LAUNCH_SAMPLER%></span></div>
			<div class="row"><span class="field">Sampler sleep time:</span><span class="value"><%=com.apiamonitor.agent.Configurator.SAMPLER_SLEEP_TIME%></span></div>
			
			<div class="clear">&nbsp;</div>
			
			<div class="row"><span class="field">Keep files after transfer:</span><span class="value"><%=com.apiamonitor.agent.Configurator.KEEP_FILES_AFTER_TRANSFER%></span></div>
			<div class="row"><span class="field">Logging files:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOGGING_FILES%></span></div>
			
			<div class="clear">&nbsp;</div>

			<div class="row"><span class="field">Agent properties:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_PROPERTIES_FILE%></span></div>
			<div class="row"><span class="field">Agent log4j:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_LOG4J_FILE%></span></div>
			<div class="row"><span class="field">Agent logging:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_LOGGIN_FILE%></span></div>
			<div class="row"><span class="field">Agent logging saved :</span><span class="value"><%=com.apiamonitor.agent.Configurator.EVTS_PROPERTIES_SAVED_CORRECTLY%></span></div>
			<div class="row rowBig"><span class="field">Search files at:</span><span class="value"><%=com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION%></span></div>
			
			<div class="clear">&nbsp;</div>
			
			<div class="row rowBig"><span class="field">Log file directory:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOG_FILE_DIRECTORY%></span></div>
			<div class="row rowBig"><span class="field">Log file name:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOG_FILE_NAME%></span></div>
			
			<div class="row rowBig"><span class="field">Agent properties location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_PROPERTIES_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION) %></span></div>
			<div class="row rowBig"><span class="field">Agent logging location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_LOGGIN_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION, true) %></span></div>
			<div class="row rowBig"><span class="field">Agent lo4j location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_LOG4J_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION) %></span></div>
			
			<div class="subsection">
				<h3><span class="showContent">+</span><span class="hideContent">-</span>Logging to file / net</h3><%
				
				HashMap<Integer, String> eventsNames = new HashMap<Integer, String>();
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SQL), "SQL"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_FORM), "EXECUTE_FORM"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_BUS_CLASS), "EXECUTE_BUS_CLASS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_SCHEDULER), "EXECUTE_SCHEDULER"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_ENTITY), "SYNCH_ENTITY"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_PROCESS), "SYNCH_PROCESS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_PROCESS), "SYNCH_PRO_ELE"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_QUERY), "EXECUTE_QUERY"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_ACQUIRE_TASK), "WF_ACQUIRE_TASK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_CANCEL_PROCESS), "WF_CANCEL_PROCESS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_CHANGE_TASK_POOL), "WF_CHANGE_TASK_POOL"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_CLOSE_INITIAL_TASK), "WF_CLOSE_INITIAL_TASK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_CLOSE_TASK), "WF_CLOSE_TASK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_CREATE_PROCESS_INSTANCE), "WF_CREATE_PROCESS_INSTANCE"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_FINALIZE_PROCESS_INSTANCE), "WF_FINALIZE_PROCESS_INSTANCE"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_GET_EVALUATION_PATH), "WF_GET_EVALUATION_PATH"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_GET_INITIAL_TASK), "WF_GET_INITIAL_TASK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_GET_TASK_TO_WORK), "WF_GET_TASK_TO_WORK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_RELEASE_TASK), "WF_RELEASE_TASK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_RESUME_PROCESS), "WF_RESUME_PROCESS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_SUSPEND_PROCESS), "WF_SUSPEND_PROCESS");  
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.WF_EXECUTE_CONDITION), "WF_EXECUTE_CONDITION"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.ACTION_SERVLET_EXECUTION), "ACTION_SERVLET_EXECUTION"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.READY_TASK_LIST), "READY_TASK_LIST"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.INPROCESS_TASK_LIST), "INPROCESS_TASK_LIST"); 		
				//eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.ALL_TASK_LIST), "ALL_TASK_LIST"); 
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISingleEvtTypes.IApiaEvtType.APIA_GENERIC_EVENT), "APIA_GENERIC_EVENT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISingleEvtTypes.IApiaEvtType.BUS_CLASS_EXCEPTION), "BUS_CLASS_EXCEPTION"); 		
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISingleEvtTypes.IApiaEvtType.CONN_POOL_EMPTY), "CONN_POOL_EMPTY"); 
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.MAX_CONN_POOL_SIZE), "MAX_CONN_POOL_SIZE"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.MIN_CONN_POOL_SIZE), "MIN_CONN_POOL_SIZE"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.OPEN_CONNECTIONS), "OPEN_CONNECTIONS");  
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.SEC_SERVER_SESSION_COUNT), "SEC_SERVER_SESSION_COUNT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.SEC_SERVER_EXECUTION_COUNT), "SEC_SERVER_EXECUTION_COUNT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.SEC_SERVER_DESIGN_COUNT), "SEC_SERVER_DESIGN_COUNT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.SEC_SERVER_BI_COUNT), "SEC_SERVER_BI_COUNT"); 		
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IApiaEvtType.APIA_AVAILABILITY), "APIA_AVAILABILITY"); 
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.CPU_USED), "CPU_USED"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.MEM_USED), "MEM_USED"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.MEM_TOTAL), "MEM_TOTAL"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.MEM_PHY_AVAIL), "MEM_PHY_AVAIL"); 		
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.MEM_PAGES_SEC), "MEM_PAGES_SEC"); 

				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_HEAP_MAX), "MEM_HEAP_MAX"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_HEAP_USED), "MEM_HEAP_USED"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_HEAP_PERC), "MEM_HEAP_PERC"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_NON_HEAP_MAX), "MEM_NON_HEAP_MAX");  
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_NON_HEAP_USED), "MEM_NON_HEAP_USED"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.MEM_NON_HEAP_PERC), "MEM_NON_HEAP_PERC"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.THREAD_COUNT), "THREAD_COUNT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.THREAD_PEAK_COUNT), "THREAD_PEAK_COUNT"); 		
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IJVMEvtType.CLASS_COUNT), "CLASS_COUNT"); 
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_CONSIST_CHG), "ORA_CONSIST_CHG"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_CONSIST_GET), "ORA_CONSIST_GET"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_DB_BLCK_CHG), "ORA_DB_BLCK_CHG"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_DB_BLCK_GET), "ORA_DB_BLCK_GET");  
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_PHYS_READS), "ORA_PHYS_READS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_PHYS_WRITES), "ORA_PHYS_WRITES"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_SORTS_DSK), "ORA_SORTS_DSK"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_USR_COMMITS), "ORA_USR_COMMITS"); 		
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOracleEvtType.ORA_USR_ROLLBCK), "ORA_USR_ROLLBCK"); 
				
		
				for (Map.Entry<Integer, Boolean> entry : com.apiamonitor.agent.Configurator.getLogEvtFile().entrySet()) { 
					%><div class="row"><span class="field"><%= eventsNames.containsKey(entry.getKey()) ? eventsNames.get(entry.getKey()).toString() : entry.getKey().toString() %>:</span><span class="value"><%= entry.getValue() %> / <%= com.apiamonitor.agent.Configurator.getLogEvtNet().get(entry.getKey()) %></span></div><%
				} %>
			</div>
			
			<div class="subsection">
				<h3><span class="showContent">+</span><span class="hideContent">-</span>Sampler classes</h3>
				<% for (int i = 0; i < com.apiamonitor.agent.Configurator.SAMPLER_CLASSES.length; i++) {
				%><div class="row onlyValue"><%= com.apiamonitor.agent.Configurator.SAMPLER_CLASSES[i] %> (sleep: <%= com.apiamonitor.agent.Configurator.SAMPLER_CLASSES_SLEEP_TIME[i] %>)</div><% } %>
			</div>
			
			<div class="subsection">
				<h3><span class="showContent">+</span><span class="hideContent">-</span>Timed delays</h3><%
				com.apiamonitor.agent.logging.MonitorLogger monitorLogger = (com.apiamonitor.agent.logging.MonitorLogger) com.apiamonitor.agent.logging.MonitorLogger.getLogger(com.apiamonitor.Constants.LOGGER_MONITOR_EVENTS);
				for (Map.Entry<String, Long> entry : monitorLogger.getTypeNames().entrySet()) {
					%><div class="row onlyValue"><%= entry.getKey() %>: <%= entry.getValue() %></div><%
				} %>
			</div>
		</div>
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    
					    <%} %>
					    
					    
					    	
					    
					    
					    
					    
					    
					    
					    </body></html>
