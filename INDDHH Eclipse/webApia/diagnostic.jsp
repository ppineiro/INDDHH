<%@page import="java.util.SortedMap"%><%@page import="biz.statum.sdk.util.DateUtil"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.security.exception.SecurityServerException"%><%@page import="com.dogma.security.info.SecurityInformation"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.security.client.SecurityClient"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><%@page import="com.st.db.dataAccess.DBConnection"%><%@page import="com.dogma.vo.CustomParametersVo"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="java.util.List"%><%@page import="java.lang.management.ManagementFactory"%><%@page import="java.lang.management.RuntimeMXBean"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.util.Calendar"%><%@page import="java.util.Date"%><%@page import="java.util.TimeZone"%><%@page import="java.util.TreeSet"%><%@page import="java.util.TreeMap"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.Map"%><%@page import="java.util.HashMap"%><%@page language="java"%><%@page import="com.dogma.bi.BIConstants"%><%@page import="com.dogma.bi.BIEngine"%><%
String USERNAME = "admin";
String PASSWORD = "admin30";

boolean logged = "true".equals(request.getSession().getAttribute("logged"));

boolean exit = "1".equals(request.getParameter("exit"));
if (exit) logged = false;

if (! logged) {
	String user = request.getParameter("txtLogin");
	String pwd = request.getParameter("txtPassword");
	
	if((USERNAME.equals(user) && PASSWORD.equals(pwd))){
		logged = true;
		request.getSession().setAttribute("logged","true");
	}
}

%><html><head><title>Apia 3.0 diagnostic tool</title><style type="text/css">
			body		{ font-family: verdana; font-size: 10px; }
			td			{ font-family: verdana; font-size: 10px; } 
			th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
			pre			{ font-family: verdana; font-size: 10px; }
			textarea	{ font-family: verdana; font-size: 10px; }
			input		{ font-family: verdana; font-size: 10px; }
			select		{ font-family: verdana; font-size: 10px; }
			
			body.compact { margin-left: 20%; width: 60%; }
			body.compact div.row { width: 100% !important;}
			
			.btnExpand {  display: none;}
			body.compact .btnCompact { display: none; }
			body.compact .btnExpand { display: inherit !important; }
			
			a:visited, a:active, a:link { text-decoration: none; color: black; font-weight: bold; }
			h2,h3,h4 { cursor: pointer; }
			h2.noClick { cursor: default; }
			
			div.option { background: none repeat scroll 0 0 #FFFFFF; margin-top: 3px; position: fixed; right: 0; top: 0; border: 1px grey solid; padding: 5px 3px 5px 5px; }
			div.option div { display: inline-block; }
			div.option span { cursor: pointer; }
			
			.right { float: right; margin-right: 5px; }
			.hidden { display: none !important; }
			
			div.splash { background-color: grey; width: 100%; height: 100%; }
			div.splashContent { background-color: white; width: 500px; padding:5px; border: 1px solid gray; }
			div.splash h2 { text-align: center;}
			div.splash div.row { display: inherit !important; width: inherit !important; }
			
			div.clear { clear: both; width: 100%; }
			
			span.showContent, span.hideContent { margin-right: 2px;}
			
			div.field { margin-bottom: 2px; }
			div.field span { display: inline-block; width: 60px;}
			div.field input[type=submit] {margin-left: 3px;}

			div.section span.showContent { display: none; }

			div.section { margin-bottom: 10px; border-bottom: 1px solid black; padding-left: 5px; padding-bottom: 5px; }
			div.lastSection { border-bottom: none !important; }
			div.onlyValue { padding-left: 20px; }
			div.row { margin-bottom: 2px; display: inline-block; width: 32% }
			div.row span.field { display: inline-block; width: 150px; text-align: right; margin-right: 3px; word-wrap: break-word;}
			div.row span.value { font-weight: bold;}
			
			div.rowBig { width: 100% !important; }
			
			div.hideContent {}
			div.hideContent span.showContent { display: inline-block; }
			div.hideContent span.hideContent { display: none !important; }
			div.hideContent h2,h3,h4 { margin-bottom: 0px; }
			div.hideContent div.row, div.hideContent div.clear, div.hideContent div.subsection{ display: none; }
			
			div.subsection { margin-left: 10px; }
			
			@media only screen and (min-width: 768px) and (max-width: 959px) { 
				body.compact { margin-left: 15%; width: 70%; }
				div.row { width: 49% !important; }
				div.rowBig { width: 100% !important; }
			}
			
			@media only screen and (max-width: 767px) {
				body.compact { margin: 0px; width: 100%; }
				div.row { width: 100% !important; }
				div.rowBig { width: 100% !important; }
			}
		</style><script type="text/javascript" src="js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript">
			window.addEvent('load', function() {
				$$('h2').each(function(ele) { ele.addEvent('click', fncShowHideContent); } );
				$$('h3').each(function(ele) { ele.addEvent('click', fncShowHideSubContent); });
				$$('h4').each(function(ele) { ele.addEvent('click', fncShowHideSubContent); });
				
				<% if (logged) { %>
					$('showAll').addEvent('click', fncShowAll); 
					$('hideAll').addEvent('click', fncHideAll);
					
					$('splash').position('center');
					$('splashContent').position('center');

					$('timeZones').position('center');
					$('timeZonesContent').position('center');
					
					$('compact').addEvent('click', function(){ $(document.body).toggleClass('compact'); });
					$('expand').addEvent('click', function(){ $(document.body).removeClass('compact'); });
					
					$('showSplash').addEvent('click', function(){
						$('splash').removeClass('hidden');
						$('hiddenOptions').addClass('hidden');
						$('splash').position('center');
						$('splashContent').position('center');
						
					});
					
					$('showTimezones').addEvent('click', function(){
						$('timeZones').removeClass('hidden');
						$('hiddenOptions').addClass('hidden');
						$('timeZones').position('center');
						$('timeZonesContent').position('center');
						return false;
					});
					
					$('closeSplash').addEvent('click', function(){
						this.getParent('div.splash').addClass('hidden');
						$('hiddenOptions').removeClass('hidden');
						return false;
					});
					$('closeTimeZones').addEvent('click', function(){
						this.getParent('div.splash').addClass('hidden');
						$('hiddenOptions').removeClass('hidden');
						return false;
					});
				<% } %>
			});
			
			window.addEvent('resize', function(){
				<% if (logged) { %>
					$('splash').position('center');
					$('splashContent').position('center');
				<% } %>
			});

			function fncShowAll() {
				$$('h2').each(function(ele) {
					if (ele.hasClass('noClick')) return;
					var parent = ele.getParent();
					parent.removeClass('hideContent');
				});
				return false;
			}
			
			function fncHideAll() {
				$$('h2').each(function(ele) { 
					if (ele.hasClass('noClick')) return;
					var parent = ele.getParent();
					parent.addClass('hideContent');
				});
				return false;
			}
			
			function fncShowHideContent() {
				if (this.hasClass('noClick')) return;
				var parent = this.getParent();
				if (parent.hasClass('hideContent')) {
					fncHideAll();
					parent.removeClass('hideContent');
				} else {
					parent.addClass('hideContent');
				}
			}
			
			function fncShowHideSubContent() {
				var parent = this.getParent();
				parent.toggleClass('hideContent');
			}
		</script></head><body><%
	if(!logged){ %><form method="post" action=""><h1>Login is required to continue</h1><br><div class="field"><span>User:</span><input type="text" name="txtLogin"></div><div class="field"><span>Password:</span><input type="password" name="txtPassword"></div><div class="field"><span>&nbsp;</span><input type="submit" value="Login"></div></form><% }else{ 
		String securityServerPort = null;
		String securityServerStatus = null;
		String securityServerError = null;
	    
	    /** Try to connect to security server **/
	    DBConnection conn = null;
	    String licensedToError = null;
		String licensedTo = "";
		String licensedExpireAt = "";
		try {
			conn = DBManagerUtil.getApiaConnection();
			SecurityClient client = DogmaUtil.getSecurityClient(conn, request.getSession());
			
			client.login(Configuration.SECURITY_MANAGER_APP, "startup", "-1", request.getServerName(), request.getServerPort(), request.getSession().getId());
			client.logout(Configuration.SECURITY_MANAGER_APP, "startup", "-1", request.getServerName(), request.getServerPort(), request.getSession().getId());
			client.cleanConnection();
			
			SecurityInformation secInfo = client.getSecurityInformation(Configuration.SECURITY_MANAGER_APP);
			if (secInfo != null) {
				licensedTo = secInfo.getCompany();
				licensedExpireAt = DateUtil.formatDateTime(secInfo.getExpirationDate(), DateUtil.FMT_DATE_SLASH);
				if(com.st.util.DateUtil.dateDiffDays(secInfo.getExpirationDate(), new Date()) <= 30){
					licensedTo  += "&nbsp;<font color=red>days " + com.st.util.DateUtil.dateDiffDays(secInfo.getExpirationDate(), new Date()) + " days.</font>";
				}
			} else {
				licensedToError = "UNREACHABLE LICENSE INFORMATION";
			}
		} catch (SecurityServerException sme) {
			licensedToError = "ERROR SECURING MANAGER INFO" + sme.getMessage();
		} catch (DogmaException e) {
			licensedToError = "ERROR SECURING MANAGER INFO :" + e.getMessage();
		} finally {
			DBManagerUtil.close(conn);
		}
		
		try {
		    //com.dogma.business.SecurityServerService service = com.dogma.business.SecurityServerService.getInstance();
			securityServerPort = com.dogma.business.SecurityServerService.getInstance().getHostPort();
			if (securityServerPort!=null) securityServerStatus = com.dogma.business.SecurityServerService.getInstance().queryServer(securityServerPort); 
	    } catch (com.dogma.DogmaException ex) { 
	    	securityServerError = ex.toString();
	    	// An error has ocurred. We do not show an error, because we want to enable the usage of apia
	    	com.st.util.log.Log.error(ex.getCompleteStackTrace());
	    } 
	    
	    TimeZone timezone = TimeZone.getDefault();
	    int timeZoneHours = timezone.getRawOffset() / 60 / 60 / 1000;
	    int timeZoneDaylight = timezone.getDSTSavings() / 60 / 60 / 1000;
	    
	    %><div class="splash" id="splash"><div class="splashContent" id="splashContent"><h2 class="noClick">Apia diagnostics v3.0 - Summary</h2><div class="row"><span class="field">Node name:</span><span class="value"><%=com.dogma.Configuration.NODE_NAME%></span></div><div class="row"><span class="field">Code version:</span><span class="value"><%= com.dogma.DogmaConstants.APIA_VERSION %></span></div><div class="row"><span class="field">Database version:</span><span class="value"><%= com.dogma.Parameters.CURRENT_APIA_VERSION %></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Start up time:</span><span class="value"><%= com.dogma.DogmaConstants.SYSTEM_START_UP_DATE%></span></div><div class="row"><span class="field">Use time zone:</span><span class="value"><%= com.dogma.Configuration.USE_TIMEZONE%></span></div><div class="row"><span class="field">Current time:</span><span class="value"><%= new java.util.Date() %></span></div><% if ("0".equals(com.dogma.Configuration.USE_TIMEZONE)) { %><div class="clear">&nbsp;</div><div class="row"><span class="field">Timezone name:</span><span class="value"><%= timezone.getDisplayName() %></span></div><div class="row"><span class="field">Timezone offset:</span><span class="value"><%= timeZoneHours %></span></div><div class="row"><span class="field">Current time (daylight):</span><span class="value"><%=java.util.TimeZone.getDefault().inDaylightTime( new java.util.Date() ) %></span></div><% } %><div class="clear">&nbsp;</div><div class="row"><span class="field">ApiaDB URL:</span><span class="value"><%=com.dogma.Configuration.DB_URL%></span></div><div class="row"><span class="field">BI DB URL:</span><span class="value"><%=com.dogma.BIParameters.BIDB_URL%></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">ANT_HOME:</span><span class="value"><%=System.getenv("ANT_HOME")%></span></div><div class="row"><span class="field">JAVA_HOME:</span><span class="value"><%=System.getenv("JAVA_HOME")%></span></div><div class="clear">&nbsp;</div><% if (licensedToError == null) { %><div class="row"><span class="field">Licensed to:</span><span class="value"><%= licensedTo %></span></div><div class="row"><span class="field">Expires:</span><span class="value"><%= licensedExpireAt %></span></div><div class="clear">&nbsp;</div><%
			   	} %><div class="row"><span class="field">Security Server Port:</span><span class="value"><%=securityServerPort%></span></div><div class="row"><span class="field">Security Server Status:</span><span class="value"><%=(securityServerStatus != null)?securityServerStatus:"NO STATUS"%></span></div><% if (securityServerError != null) { %><div class="row error"><%=securityServerError%> [<%=(securityServerPort != null)?securityServerPort:""%>] [<%=(securityServerStatus != null)?securityServerStatus:""%>]</div><% } %><a href="" id="closeSplash" class="right">[ Close ]</a></div></div><div class="splash hidden" id="timeZones"><div class="splashContent" id="timeZonesContent"><h2 class="noClick">Apia diagnostics v3.0 - Timezones table</h2><%
				
				Date currentDate = new Date();
				Calendar calendar = GregorianCalendar.getInstance();
				calendar.setTime(currentDate);;
				calendar.add(Calendar.HOUR, -1 * (timeZoneHours + timeZoneDaylight));
				
				%><div class="row"><span class="field">Use time zone:</span><span class="value"><%= com.dogma.Configuration.USE_TIMEZONE%></span></div><div class="row"><span class="field">Current time:</span><span class="value"><%= currentDate %></span></div><div class="row"><span class="field">GMT time:</span><span class="value"><%= calendar.getTime() %></span></div><% if ("0".equals(com.dogma.Configuration.USE_TIMEZONE)) { %><div class="clear">&nbsp;</div><div class="row"><span class="field">Timezone name:</span><span class="value"><%= timezone.getDisplayName() %></span></div><div class="row"><span class="field">Timezone offset:</span><span class="value"><%= timeZoneHours %></span></div><div class="row"><span class="field">Current time (daylight):</span><span class="value"><%=java.util.TimeZone.getDefault().inDaylightTime( new java.util.Date() ) %></span></div><% } %><div class="clear">&nbsp;</div><%
				
				for (int i = -12; i <= 12; i++) {
					if (i == 0) continue;
					Calendar theCal = GregorianCalendar.getInstance();
					theCal.setTimeInMillis(calendar.getTimeInMillis());
					theCal.add(Calendar.HOUR, i); %><div class="row"><span class="field">Timezone <%= i %>:</span><span class="value"><%= theCal.getTime() %></span></div><%
				} %><a href="" id="closeTimeZones" class="right">[ Close ]</a></div></div><div class="option"><div id="hiddenOptions" class="hidden"><span id="showAll">[ Show all ]</span><span id="hideAll">[ Hide all ]</span><span id="showSplash">[ Show summary ]</span><span id="compact" class="btnCompact">[ Compact ]</span><span id="expand" class="btnExpand">[ Expand ]</span></div><a href="?exit=1">[ Log-off ]</a></div><h1>Apia diagnostics v3.0</h1><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Configuration parameters</h2><div class="row"><span class="field">Code version:</span><span class="value"><%= com.dogma.DogmaConstants.APIA_VERSION %></span></div><div class="row"><span class="field">Database version:</span><span class="value"><%= com.dogma.Parameters.CURRENT_APIA_VERSION %></span></div><div class="row"><span class="field">Server mode:</span><span class="value"><%= com.dogma.Configuration.SERVER_MODE %></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Parameters loaded:</span><span class="value"><%= com.dogma.Parameters.PARAMETERS_LOADED_CORRECTLY %></span></div><div class="row"><span class="field">Custom parameters loaded:</span><span class="value"><%= com.dogma.Parameters.CUSTOM_PARAMETERS_LOADED_CORRECTLY %></span></div><div class="row"><span class="field">Fixes loaded:</span><span class="value"><%= com.dogma.Parameters.CUSTOM_FIXES_LOADED_CORRECTLY %></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Start up time:</span><span class="value"><%= com.dogma.DogmaConstants.SYSTEM_START_UP_DATE%></span></div><div class="row"><span class="field">Use time zone:</span><span class="value"><%= com.dogma.Configuration.USE_TIMEZONE%><a href="#" id="showTimezones">[ show timezones ]</a></span></div><div class="row"><span class="field">Current time:</span><span class="value"><%= new java.util.Date() %></span></div><% if ("0".equals(com.dogma.Configuration.USE_TIMEZONE)) { %><div class="row"><span class="field">Timezone name:</span><span class="value"><%= timezone.getDisplayName() %></span></div><div class="row"><span class="field">Timezone offset:</span><span class="value"><%= timeZoneHours %></span></div><div class="row"><span class="field">Current time (daylight):</span><span class="value"><%=java.util.TimeZone.getDefault().inDaylightTime( new java.util.Date() ) %></span></div><% } %><div class="clear">&nbsp;</div><div class="row"><span class="field">Application encoding:</span><span class="value"><%=com.dogma.Configuration.APP_ENCODING%></span></div><div class="row"><span class="field">Java encoding:</span><span class="value"><%=com.dogma.Configuration.JAVA_ENCODING%></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Force application and root path from properties:</span><span class="value"><%=com.dogma.Configuration.FORCE_LOAD_PATH_FROM_PROPERTIES%></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Root Path:</span><span class="value"><%=com.dogma.Configuration.ROOT_PATH%></span></div><div class="row"><span class="field">Node name:</span><span class="value"><%=com.dogma.Configuration.NODE_NAME%></span></div><div class="row"><span class="field">Port:</span><span class="value"><%=com.dogma.Configuration.PORT%></span></div><div class="row"><span class="field">SSL:</span><span class="value"><%=com.dogma.Configuration.SSL%></span></div><div class="clear">&nbsp;</div><div class="row rowBig"><span class="field">Forbidden environments:</span><span class="value"><%=com.dogma.Configuration.FORBIDDEN_ENVIRONMENTS%></span></div><div class="clear">&nbsp;</div><div class="row rowBig"><span class="field">Application Path:</span><span class="value"><%=com.dogma.Configuration.APP_PATH%></span></div><div class="row rowBig"><span class="field">Temporal Storage Path:</span><span class="value"><%=com.dogma.Configuration.TMP_FILE_STORAGE%></span></div><div class="row rowBig"><span class="field">Dispatcher XML:</span><span class="value"><%=com.dogma.Configuration.MONITOR_XML_DIR%> (File exists: <%= new java.io.File(com.dogma.Configuration.MONITOR_XML_DIR).exists() %> - Can read: <%= new java.io.File(com.dogma.Configuration.MONITOR_XML_DIR).canRead() %>)</span></div></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Log parameters</h2><div class="row"><span class="field">Log to console:</span><span class="value"><%=com.dogma.Configuration.LOG_TO_CONSOLE%></span></div><div class="row"><span class="field">ZIP log content:</span><span class="value"><%=com.dogma.Configuration.ZIP_LOGS%></span></div><div class="clear">&nbsp;</div><div class="row rowBig"><span class="field">Log Directory:</span><span class="value"><%=com.dogma.Configuration.LOG_DIRECTORY%></span></div><div class="row rowBig"><span class="field">Debug Log File:</span><span class="value"><%=com.dogma.Configuration.DEBUG_LOG_FILE%></span></div></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>System variables and versions</h2><div class="row"><span class="field">apia.char.jar:</span><span class="value"><%=chat.core.ServerEngine.VERSION%></span></div><div class="row"><span class="field">APIACHAT_MODE_CLIENT:</span><span class="value"><%=com.dogma.Parameters.APIACHAT_MODE_CLIENT%></span></div><div class="row"><span class="field">APIACHAT_SERVER_NODE:</span><span class="value"><%=com.dogma.Parameters.APIACHAT_SERVER_NODE%></span></div><div class="clear">&nbsp;</div><div class="row rowBig"><span class="field">JAVA_HOME:</span><span class="value"><%=StringUtil.noNull(System.getenv("JAVA_HOME"))%></span></div><div class="row rowBig"><span class="field">JAVA_OPTS:</span><span class="value"><%=StringUtil.noNull(System.getenv("JAVA_OPTS"))%></span></div><div class="row rowBig"><span class="field">JRE_HOME:</span><span class="value"><%=StringUtil.noNull(System.getenv("JRE_HOME"))%></span></div><div class="row rowBig"><span class="field">ANT_HOME:</span><span class="value"><%=StringUtil.noNull(System.getenv("ANT_HOME"))%></span></div><div class="clear">&nbsp;</div><div class="subsection hideContent"><h3><span class="showContent">+</span><span class="hideContent">-</span>JVM Parameters</h3><div class="row rowBig"><span class="value"><%
				RuntimeMXBean runtimeMxBean = ManagementFactory.getRuntimeMXBean();
				List<String> arguments = runtimeMxBean.getInputArguments();
				for (String argument : arguments) { %><%=argument%><% } %></span></div></div><div class="clear">&nbsp;</div><div class="subsection hideContent"><h3><span class="showContent">+</span><span class="hideContent">-</span>System properties</h3><%
				for (Object key : System.getProperties().keySet()) { %><div class="row"><span class="field"><%= key %>:</span><span class="value"><%= System.getProperty((String) key) %></span></div><%
				} %></div><div class="clear">&nbsp;</div><div class="subsection hideContent"><h3><span class="showContent">+</span><span class="hideContent">-</span>System environment properties</h3><%
				for (Object key : System.getenv().keySet()) { %><div class="row"><span class="field"><%= key %>:</span><span class="value"><%= System.getenv((String) key) %></span></div><%
				} %></div></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Apia database parameters</h2><div class="row rowBig"><span class="field">URL:</span><span class="value"><%=com.dogma.Configuration.DB_URL%></span></div><div class="row"><span class="field">User:</span><span class="value"><%=com.dogma.Configuration.DB_USR%></span></div><%if(request.getParameter("showPassword")!=null){ %><div class="row"><span class="field">Password:</span><span class="value"><%=com.dogma.Configuration.DB_PWD%></span></div><%} %><div class="row"><span class="field">Install user:</span><span class="value"><%=com.dogma.Configuration.DB_INSTALLER_USR%></span></div><%if(request.getParameter("showPassword")!=null){ %><div class="row"><span class="field">Install password:</span><span class="value"><%=com.dogma.Configuration.DB_INSTALLER_PWD%></span></div><%} %><div class="row"><span class="field">Implementation:</span><span class="value"><%=com.dogma.Configuration.DB_IMPLEMENTATION%></span></div><div class="row"><span class="field">Max connections:</span><span class="value"><%=com.dogma.Configuration.DB_MAX_CONNECTIONS%></span></div><div class="row"><span class="field">Min connections:</span><span class="value"><%=com.dogma.Configuration.DB_MIN_CONNECTIONS%></span></div><div class="row"><span class="field">Connection renew time:</span><span class="value"><%=com.dogma.Configuration.DB_CONN_RENEW_TIME%></span></div></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>BI database parameters</h2><%if (Parameters.BI_INSTALLED){ %><div class="row rowBig"><span class="field">BI Url:</span><span class="value"><%=com.dogma.BIParameters.BIDB_URL%></span></div><div class="row"><span class="field">BI User:</span><span class="value"><%=com.dogma.BIParameters.BIDB_USR%></span></div><%if(request.getParameter("showPassword")!=null){ %><div class="row"><span class="field">BI Password:</span><span class="value"><%=com.dogma.BIParameters.BIDB_PWD%></span></div><%} %><div class="row"><span class="field">BI Implementation:</span><span class="value"><%=com.dogma.BIParameters.BIDB_IMPLEMENTATION%></span></div><div class="row"><span class="field">BI Max connections:</span><span class="value"><%=com.dogma.BIParameters.BIDB_MAX_CONNECTIONS%></span></div><div class="row"><span class="field">BI Min connections:</span><span class="value"><%=com.dogma.BIParameters.BIDB_MIN_CONNECTIONS%></span></div><div class="row"><span class="field">BI Connection renew time:</span><span class="value"><%=com.dogma.BIParameters.BIDB_CONN_RENEW_TIME%></span></div><div class="clear">&nbsp;</div><%} %><div class="row"><span class="field">BI Status:</span><span class="value"><%= BIConstants.BI_CORRECTLY_INSTALLED %></span></div><div class="row"><span class="field">BI Status error:</span><span class="value"><%=BIConstants.BI_STATUS_ERROR%></span></div><div class="row"><span class="field">BI Configuration:</span><span class="value"><%=StringUtil.noNull(BIEngine.checkBIConfiguration())%></span></div><div class="row"><span class="field">BI Connection:</span><span class="value"><%=StringUtil.noNull(BIEngine.checkBIConnection())%></span></div></div><% if (!com.dogma.Configuration.DISABLE_APIAMONITOR) { %><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Agent information</h2><div class="row"><span class="field">Version:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_VERSION + " " + com.apiamonitor.agent.Configurator.AGENT_RELEASE_DATE %></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Active:</span><span class="value"><%=!com.dogma.Configuration.DISABLE_APIAMONITOR%></span></div><div class="row"><span class="field">Uptime:</span><span class="value"><%=new java.util.Date(com.apiamonitor.agent.Configurator.upTime)%></span></div><div class="row"><span class="field">Name:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_NAME%></span></div><div class="row"><span class="field">Command port:</span><span class="value"><%=com.apiamonitor.agent.Configurator.COMMAND_SERVER_PORT%></span></div><div class="row"><span class="field">Log port:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOGGING_SERVER_PORT%></span></div><div class="row"><span class="field">Server IP:</span><span class="value"><%=com.apiamonitor.agent.Configurator.SERVER_IP%></span></div><div class="row"><span class="field">Launch sampler:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LAUNCH_SAMPLER%></span></div><div class="row"><span class="field">Sampler sleep time:</span><span class="value"><%=com.apiamonitor.agent.Configurator.SAMPLER_SLEEP_TIME%></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Keep files after transfer:</span><span class="value"><%=com.apiamonitor.agent.Configurator.KEEP_FILES_AFTER_TRANSFER%></span></div><div class="row"><span class="field">Logging files:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOGGING_FILES%></span></div><div class="clear">&nbsp;</div><div class="row"><span class="field">Agent properties:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_PROPERTIES_FILE%></span></div><div class="row"><span class="field">Agent log4j:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_LOG4J_FILE%></span></div><div class="row"><span class="field">Agent logging:</span><span class="value"><%=com.apiamonitor.agent.Configurator.AGENT_LOGGIN_FILE%></span></div><div class="row"><span class="field">Agent logging saved :</span><span class="value"><%=com.apiamonitor.agent.Configurator.EVTS_PROPERTIES_SAVED_CORRECTLY%></span></div><div class="row rowBig"><span class="field">Search files at:</span><span class="value"><%=com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION%></span></div><div class="clear">&nbsp;</div><div class="row rowBig"><span class="field">Log file directory:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOG_FILE_DIRECTORY%></span></div><div class="row rowBig"><span class="field">Log file name:</span><span class="value"><%=com.apiamonitor.agent.Configurator.LOG_FILE_NAME%></span></div><div class="row rowBig"><span class="field">Agent properties location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_PROPERTIES_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION) %></span></div><div class="row rowBig"><span class="field">Agent logging location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_LOGGIN_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION, true) %></span></div><div class="row rowBig"><span class="field">Agent lo4j location:</span><span class="value"><%= com.apiamonitor.Utils.getPropertiesFileLocation(com.apiamonitor.agent.Configurator.AGENT_LOG4J_FILE, com.apiamonitor.agent.Configurator.PROPERTIES_LOCATION) %></span></div><div class="subsection"><h3><span class="showContent">+</span><span class="hideContent">-</span>Logging to file / net</h3><%
				
				Map<Integer, String> eventsNames = new TreeMap<Integer, String>();
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SQL), "SQL"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_FORM), "EXECUTE_FORM"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_BUS_CLASS), "EXECUTE_BUS_CLASS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.EXECUTE_SCHEDULER), "EXECUTE_SCHEDULER"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_ENTITY), "SYNCH_ENTITY"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_PROCESS), "SYNCH_PROCESS"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes.SYNCH_PRO_ELE), "SYNCH_PRO_ELE"); 
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
				
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISingleEvtTypes.GENERIC_EVENT), "GENERIC_EVENT"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISingleEvtTypes.AGENT_DISCONNECTED), "AGENT_DISCONNECTED"); 
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
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.PING_HOST_1), "PING_HOST_1"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.PING_HOST_2), "PING_HOST_2"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.PING_HOST_3), "PING_HOST_3"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.PING_HOST_4), "PING_HOST_4"); 
				eventsNames.put(Integer.valueOf(com.apiamonitor.events.ISamplingEvtTypes.IOSEvtType.PING_HOST_5), "PING_HOST_5"); 

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
				} %></div><% if (com.apiamonitor.agent.Configurator.LAUNCH_SAMPLER) { %><div class="subsection"><h3><span class="showContent">+</span><span class="hideContent">-</span>Sampler classes</h3><% for (int i = 0; i < com.apiamonitor.agent.Configurator.SAMPLER_CLASSES.length; i++) {
				%><div class="row onlyValue"><%= com.apiamonitor.agent.Configurator.SAMPLER_CLASSES[i] %> (sleep: <%= com.apiamonitor.agent.Configurator.SAMPLER_CLASSES_SLEEP_TIME[i] %>)</div><% } %></div><%} %><% if (!com.dogma.Configuration.DISABLE_APIAMONITOR) { %><div class="subsection"><h3><span class="showContent">+</span><span class="hideContent">-</span>Timed delays</h3><%
				com.apiamonitor.agent.logging.MonitorLogger monitorLogger = (com.apiamonitor.agent.logging.MonitorLogger) com.apiamonitor.agent.logging.MonitorLogger.getLogger(com.apiamonitor.Constants.LOGGER_MONITOR_EVENTS);
				for (Map.Entry<String, Long> entry : monitorLogger.getTypeNames().entrySet()) {
					%><div class="row onlyValue"><%= entry.getKey() %>: <%= entry.getValue() %></div><%
				} %></div><% } %></div><%} %><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Security Server</h2><% if (licensedToError == null) { %><div class="row"><span class="field">Licensed to:</span><span class="value"><%= licensedTo %></span></div><div class="row"><span class="field">Expires:</span><span class="value"><%= licensedExpireAt %></span></div><%
		    } else { %><div class="row"><span class="field">Error when getting licensed to:</span><span class="value"><%= licensedToError %></span></div><%
		    }%><div class="clear">&nbsp;</div><div class="row"><span class="field">Port:</span><span class="value"><%=securityServerPort%></span></div><div class="row rowBig"><span class="field">Status:</span><span class="value"><%=(securityServerStatus != null)?securityServerStatus:"NO STATUS"%></span></div><% if (securityServerError != null) { %><div class="row error"><%=securityServerError%> [<%=(securityServerPort != null)?securityServerPort:""%>] [<%=(securityServerStatus != null)?securityServerStatus:""%>]</div><% } %><div class="clear">&nbsp;</div><% try {
			    String dataXmlUnits = "<request><operation name='getUnits'><data application='APIA' /></operation></request>";
			    String hostPort = com.dogma.business.SecurityServerService.getInstance().getHostPort();
			    String host = "";
			    int port = -1;
				if (hostPort != null && hostPort.indexOf(":") != -1) {
					String[] hostAndPort = com.st.util.StringUtil.split(hostPort,":");
					host = hostAndPort[0];
					port = Integer.parseInt(hostAndPort[1]);
				}
			    java.net.Socket cliSocket = new java.net.Socket(host, port);
				java.io.OutputStream outStream = cliSocket.getOutputStream();
				java.io.BufferedOutputStream bos = new java.io.BufferedOutputStream(outStream);
				
				bos.write(dataXmlUnits.getBytes());
				bos.write("\n".getBytes());
				bos.flush();
				
				java.io.InputStream in = cliSocket.getInputStream();
				java.io.BufferedReader is = new java.io.BufferedReader(new java.io.InputStreamReader(in));
				String answer = is.readLine(); 
				
				if (answer != null && answer.startsWith("OK")) {
				
					String strData = answer.substring(2);
			    	Object objData = com.st.util.Base64.decodeToObject(strData);
			    	java.util.Collection units = (java.util.Collection) objData;
			    	
					java.util.Iterator itun = units.iterator();
					while (itun.hasNext()) {
						String unit  = (String)itun.next();
						String group = unit.substring(0, unit.indexOf("="));
						String size  = unit.substring(unit.indexOf("=") + 1);
			
						// We tidy the group description
						group = com.st.util.StringUtil.replaceAll(group, "&", ", ");
						
						%><div class="row"><span class="field"><%= group %>:</span><span class="value"><%=size%></span></div><%
					}
				} else {
					%><div class="row error">Error loading security server licence information: <%= answer %></div><%
				}
			} catch (Exception e) { %><div class="row error">Exception loading security server licence information: <%= e.getMessage() %></div><%
			} %></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>General Parameters</h2><div class="row"><span class="field">Encrypt passwords:</span><span class="value"><%=com.dogma.Configuration.ENCRIPT_PARAMETER_PASSWORDS%></span></div><div class="clear">&nbsp;</div><%
			String[] pars = com.dogma.Parameters.getParameterNames();
			if (pars != null) {
				TreeSet<String> allParams = new TreeSet<String>();
				TreeSet<String> allBigParams = new TreeSet<String>();
				for (int i = 0; i < pars.length; i++) allParams.add(pars[i]);
				for (String name : allParams) {
					if ("prmtDwWebPath".equals(name) 
							|| "prmtApiaChatSaveAt".equals(name) 
							|| "prmtRootCAs".equals(name) 
							|| "prmtExternalUrl".equals(name) 
							|| "prmtQryStorage".equals(name) 
							|| "prmtDwWebPathSco".equals(name) 
							|| "prmtDocumentStorage".equals(name)) {
						allBigParams.add(name);
						continue;
					}
					String value = com.dogma.Parameters.getParameter(name,""); %><div class="row"><span class="field"><%=name%>:</span><span class="value"><%=value%></span></div><%
				} %><div class="clear">&nbsp;</div><%
				
				for (String name : allBigParams) {
					String value = com.dogma.Parameters.getParameter(name,""); %><div class="row rowBig"><span class="field"><%=name%>:</span><span class="value"><%=value%></span></div><%
				}
			} %></div><div class="section hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Environment Parameters</h2><%
			String[] envpars = com.dogma.EnvParameters.getParameterNames();
			if (envpars != null) {
				TreeMap<Integer, TreeMap<String, String>> allEnvParamValues = new TreeMap<Integer, TreeMap<String, String>>();
				for (int i = 0; i < envpars.length; i++) {
					String envname  = envpars[i];
					String envStr = envname.substring(0, envname.indexOf("-"));
					Integer envId = new Integer(envStr);
					String name = envname.substring(envname.indexOf("-") + 1);
					String value = com.dogma.EnvParameters.getEnvParameter(envId, name);
					
					if (! allEnvParamValues.containsKey(envId)) allEnvParamValues.put(envId, new TreeMap<String, String>());
					TreeMap<String,String> allParamValues = allEnvParamValues.get(envId);
					allParamValues.put(name, value);
				}
				for (Map.Entry<Integer, TreeMap<String, String>> envs : allEnvParamValues.entrySet()) { %><div class="subsection hideContent"><h3><span class="showContent">+</span><span class="hideContent">-</span>Environment <%= envs.getKey() %></h3><%
						for (Map.Entry<String,String> param : envs.getValue().entrySet()) {
							String className = "row";
							if ("DAT_REG_EXP".equals(param.getKey())) className += " rowBig";
							if ("NUM_REG_EXP".equals(param.getKey())) className += " rowBig"; %><div class="<%=className%>"><span class="field"><%=param.getKey()%>:</span><span class="value"><%=param.getValue()%></span></div><%
						} %></div><%
				}
			} %></div><div class="section lastSection hideContent"><h2><span class="showContent">+</span><span class="hideContent">-</span>Custom Parameters</h2><%
			HashMap<Integer, HashMap<String,HashMap<String,CustomParametersVo>>> customParameters = (HashMap<Integer, HashMap<String,HashMap<String,CustomParametersVo>>>) Parameters.getCustomParameters();
			if (customParameters != null) {
				for (Map.Entry<Integer, HashMap<String,HashMap<String,CustomParametersVo>>> envs : customParameters.entrySet()) { %><div class="subsection hideContent"><h3><span class="showContent">+</span><span class="hideContent">-</span>Environment <%= envs.getKey() %></h3><%
						for (Map.Entry<String,HashMap<String,CustomParametersVo>> project : envs.getValue().entrySet()) { 
							String key = project.getKey();
							if (key == null) key = "no proyect"; %><div class="subsection hideContent"><h4><span class="showContent">+</span><span class="hideContent">-</span><%= key %></h4><%
								for (Map.Entry<String,CustomParametersVo> param : project.getValue().entrySet()) { %><div class="row"><span class="field" title="<%= param.getValue().getParDesc() %>"><%=param.getKey()%>:</span><span class="value"><%=param.getValue().getValue()%></span></div><%
								} %></div><%
						} %></div><%
				}
			} else {
				%><div class="subsection hideContent">No customs parameters were found.</div><%
			} %></div><%} %></body></html>
