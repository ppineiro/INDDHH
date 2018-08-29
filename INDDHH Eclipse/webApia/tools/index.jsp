<%@page import="java.util.HashMap"%>
<%@page import="java.io.File"%>

<%@include file="_commonValidate.jsp" %>

<%!

private class ApiaTool {
	private String jsp;
	private String name;
	private String description;
	private boolean active = false;
	
	public ApiaTool(String jsp, String name, String description) {
		this.jsp = jsp;
		this.name = name;
		this.description = description;
		this.active = false;
	}
}

HashMap<String, ApiaTool> tools = new HashMap<String, ApiaTool>();

private void addApiaTool(String jsp, String name, String description) {
	if (this.tools == null) this.tools = new HashMap<String, ApiaTool>();
	if (this.tools.containsKey(jsp)) return;
	this.tools.put(jsp, new ApiaTool(jsp, name, description));
}

private void activateTool(String jsp) {
	if (this.tools.containsKey(jsp)) this.tools.get(jsp).active = true;
}
%>

<html>
	<head>
		<title>Apia 3.0 - Tools</title>

		<style type="text/css">
			<%@include file="_commonStyles.jsp" %>
			
			.toolActive { font-weight: bold; cursor: pointer; }
			.toolInactive { color: gray; }
		</style>
		
		<%@include file="_commonInclude.jsp" %>
		
		<script type="text/javascript">
			<%@include file="_commonScript.jsp" %>
			
			window.addEvent('load', function() {
				<% if (_logged) { %>
					var tools = $('tools');
					tools.accessTool = $('accessTool');
					tools.addEvent('change', function(evt) {
						this.accessTool.disabled = this.options[this.selectedIndex].get('active') == 'false';
					});
					
					tools.accessTool.addEvent('click', fncBtnAccessTool);
				<% } %>
				
			});
			
			var windowCounter = 1;
			
			function fncBtnAccessTool() {
				var tools = $('tools');
				var toolOption = tools.options[tools.selectedIndex];
				
				var windowNumber = windowCounter++;
				
				var theWindow = new Element('div', {'class': 'window'}).inject($('workarea'));
				var theWindowContent = new Element('div.windowContent').inject(theWindow);
				var theWindowHeader = new Element('div.header').inject(theWindowContent);
				new Element('h3', {html: toolOption.text + " (" + windowNumber + ")"}).inject(theWindowHeader);
				var theButtons = new Element('div.buttons').inject(theWindowHeader);
				new Element('div', {'class': 'button buttonReload', html: '[ r ]', title: 'restart'}).inject(theButtons).addEvent('click', fncButtonReload);
				new Element('div', {'class': 'button buttonExpand', html: '[ e ]', title: 'expand'}).inject(theButtons).addEvent('click', fncButtonExpand);
				new Element('div', {'class': 'button buttonCompress', html: '[ c ]', title: 'compress'}).inject(theButtons).addEvent('click', fncButtonCompress);
				var buttonMaximize = new Element('div', {'class': 'button buttonMaximize', html: '[ M ]', title: 'maximize'}).inject(theButtons).addEvent('click', fncButtonMaximize);
				new Element('div', {'class': 'button buttonMinimize', html: '[ m ]', title: 'minimize'}).inject(theButtons).addEvent('click', fncButtonMinimize);
				new Element('div', {'class': 'button buttonClose', html: '[ C ]', title: 'close'}).inject(theButtons).addEvent('click', fncButtonClose);
				
				if (new DOMEvent(arguments[0].event).shift) buttonMaximize.fireEvent('click');
				
				theWindow.theIframe = new Element('iframe.content', {src: toolOption.value + "?_avoidLogout=true"}).inject(theWindowContent);
				var getStarted = $('getStarted');
				if (getStarted) $('getStarted').addClass('hidden');
			}
			
			function fncButtonReload() {
				var theWindow = this.getParent('div.window');
				var iframe = theWindow.theIframe;
				iframe.src = iframe.src;
			}
			
			function fncButtonClose() {
				var theWindow = this.getParent('div.window');
				var workArea = theWindow.getParent();
				theWindow.destroy();
				
				var getStarted = $('getStarted');
				if (workArea.getChildren().length == 2 && getStarted) getStarted.removeClass('hidden');
			}
			
			function fncButtonExpand() {
				var theWindow = this.getParent('div.window');
				theWindow.addClass('windowExtended');
			}
			
			function fncButtonCompress() {
				var theWindow = this.getParent('div.window');
				theWindow.removeClass('windowExtended');
			}
			
			function fncButtonMaximize() {
				var theWindow = this.getParent('div.window');
				var theWindowContent = theWindow.getChildren('div.windowContent');
				
				theWindow.addClass('windowMaximized');
				theWindow.removeClass('removeMootoolsCenterPosition');
				theWindowContent.removeClass('removeMootoolsCenterPosition');
				
				//theWindow.position('center');
				theWindow.getChildren('div.windowContent').position('center', {relativeTo: 'theWindow'});
			}

			function fncButtonMinimize() {
				var theWindow = this.getParent('div.window');
				var theWindowContent = theWindow.getChildren('div.windowContent');
				
				theWindow.removeClass('windowMaximized');
				theWindow.addClass('removeMootoolsCenterPosition');
				theWindowContent.addClass('removeMootoolsCenterPosition');
				
				//theWindow.position('');
				theWindowContent.position('');
			}
		</script>
	</head>
<body>

	<%@include file="_commonLogin.jsp" %>
	
	<% if (_logged) {
		File jspLocation = new File(getServletContext().getRealPath("/") + File.separator + "tools");
		File[] fileTools = jspLocation.listFiles();

		this.addApiaTool("classVerifier.jsp", "Class verifier", "Allows to see where a Java class is located (file system or jar) and lists all the metdhos and fields of it.");
		this.addApiaTool("testPool.jsp", "Test pool", "Allows access to Apia and Apia BI database, in order to execute SQL sentences to obtain information from it.");
		this.addApiaTool("graphDesigner.jsp", "Grpah designer", "Allows to create a map of the process and subprocesses of instance of an specific process.");
		this.addApiaTool("ldapVerifier.jsp", "LDAP verifier", "Allows to test and check LDAP Apia parameters.");
		this.addApiaTool("testConnection.jsp", "Test connection", "Allows to test and open a connection to any of the DBMS supported by Apia and execute a SQL select sentence.");
		this.addApiaTool("daoLogActivity.jsp", "DAO Log activity", "Allows to see and change the log level of each table in the Apia database.");
		this.addApiaTool("dateVerifier.jsp", "Date verifier", "Allows to see the current date used by the system and the date with different timezones configurations.");
		this.addApiaTool("viewMemory.jsp", "View memory", "Allows to see a graph with the available free memory and allocated memory to the application.");
		this.addApiaTool("verification.jsp", "Verification", "Shows information of a series of verification done to the system.");
		this.addApiaTool("reloadLabels.jsp", "Reload parameters and labels", "Allows to reload database parameters and labels into the memory.");
		this.addApiaTool("securityServerInfo.jsp", "Security server information", "Shows information of a security server and all the users connected to it.");
		
		if (tools != null) {
			for (File tool : fileTools) {
				this.activateTool(tool.getName());
			}
		} %>
		
		<div class="mainHeader">
			<div class="field"><span>Select a tool:</span><select id="tools">
					<option active="false"></option><%
					for (ApiaTool tool : this.tools.values()) { 
						String toolStyle = tool.active ? "toolActive" : "toolInactive"; %>
						<option active="<%= tool.active %>" class='<%= toolStyle %>' value="<%= tool.jsp %>"><%= tool.name %></option><%
					} %>
				</select>
			</div>
			<div class="field"><input type="button" value="Access" id="accessTool" disabled></div>
			<span class="field ieWarning" id="ieWarning">You are using Internet Explorer, experience may not be as desire.</span>
			<%@include file="_commonLogout.jsp" %>
			<a href="" class="right" id="help">[ help ]</a>
		</div>
		
		
		<div class="workarea" id="workarea">
			<div class="window windowMaximized windowHelp hidden" id="helpWindow">
				<div class="windowContent" id="helpWindowContent">
					<div class="header">
						<h3>Help</h3>
						<div class="buttons">
							<div class="button" title="hide" id="helpWindowHide">[ H ]</div>
						</div>
					</div>
					<div class="content contentHelp">
						<h3>Main options</h3>
						<b>Select a tool:</b> list all the tools available to access and mark those installed in the application.
						<b>Access:</b> opens a new window with the selected <b>tool</b>. To open a new windows <b>maximized</b> hold down the <b>SHIFT</b> key and do click in <b>New window</b>.
						<ul>
							<li><b>r:</b> restart window content, like when opening the window again.</li>
							<li><b>e:</b> expand window content.</li>
							<li><b>c:</b> compress window content.</li>
							<li><b>M:</b> maximize window content.</li>
							<li><b>m:</b> minimize window content.</li>
							<li><b>C:</b> close window, a confirmation will not be ask.</li>
							<li><b>H:</b> hide content window.</li>
						</ul>
						<p>When the tool name is <span class="toolActive">like these</span> then the tool is installed and can be access. When the tool name is <span class="toolInactive">like these</span> then the tools is not installed and you need to ask for it to apiasupport@statum.biz.</p>
						<h3>Tools</h3>
						<ul><%
							for (ApiaTool tool : this.tools.values()) { 
								String toolStyle = tool.active ? "toolActive" : "toolInactive"; %>
								<li><b><%= tool.name %>: </b> <%= tool.description %> (<%= tool.active ? "Available" : "Not available" %>)</li><%
							} %>
						</ul>
					</div>
				</div>
			</div>
		</div><%
	} %>
</body>
</html>
