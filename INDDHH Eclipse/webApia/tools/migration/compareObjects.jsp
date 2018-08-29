<%@page import="java.util.*"%><%@page import="com.st.util.*"%><%@page import="com.st.db.dataAccess.*"%><%@page import="com.dogma.dataAccess.*"%><%@page import="com.dogma.migration.tools.*"%><%@page import="com.dogma.dao.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML XMLNS:CONTROL><%!

	// Selected DBMS
	String srcDbms = null;
	String dstDbms = null;

	// Store the connections in the generated servlet
	DBConnection srcCnx = null;
	DBConnection dstCnx = null;

	String message = null;

	ArrayList results = null;

	Collection srcEnvs = null;
	Collection dstEnvs = null;
%><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><%
		// Execute the action
		String action = request.getParameter("action");
		if (action != null && action.startsWith("compare")) {
			// Check the connections
			if (srcCnx == null || dstCnx == null) {
				message = "Not all the connections are established";
			}

			// Check both environments
			String srcEnvIdS = request.getParameter("cmbSrcEnv");
			String dstEnvIdS = request.getParameter("cmbDstEnv");

			Integer srcEnvId = null;
			Integer dstEnvId = null;

			try {
				srcEnvId = new Integer(srcEnvIdS);
				dstEnvId = new Integer(dstEnvIdS);
			} catch (Exception ex) {
				message = "You must select both environments";
			}			

			try {
	  			if ("compareForms".equals(action)) {
					FormComparator cmp = new FormComparator();
					cmp.clean();
					cmp.loadData(srcCnx, srcEnvId, dstCnx, dstEnvId);
					cmp.compare();
					results = cmp.getResults();
				} else if ("compareBusClasses".equals(action)) {
					BusClassComparator cmp = new BusClassComparator();
					cmp.clean();
					cmp.loadData(srcCnx, srcEnvId, dstCnx, dstEnvId);
					cmp.compare();
					results = cmp.getResults();
				}
			} catch (Exception ex) {
				message = "Error in the comparison: " + ex.getMessage();
			}			

		} else if("src_connect".equals(action)) {
			try {
				srcCnx = DogmaDBManager.getConnection(request.getParameter("cmbSrcDriver") + "·srcdb",
												      request.getParameter("txtSrcUser"),
													  request.getParameter("txtSrcPwd"),
													  request.getParameter("txtSrcURL"));

				srcDbms = request.getParameter("cmbSrcDriver");

				// Populate the environment combo
				srcEnvs = EnvironmentDAO.getInstance().getAllEnvs(srcCnx);

			} catch (Exception ex) {
				message = "Error creating source connection: " + ex.getMessage();
			} 
		} else if("dst_connect".equals(action)) {
			try {
				dstCnx = DogmaDBManager.getConnection(request.getParameter("cmbDstDriver") + "·dstdb",
												      request.getParameter("txtDstUser"),
													  request.getParameter("txtDstPwd"),
													  request.getParameter("txtDstURL"));

				dstDbms = request.getParameter("cmbDstDriver");

				// Populate the environment combo
				dstEnvs = EnvironmentDAO.getInstance().getAllEnvs(dstCnx);

			} catch (Exception ex) {
				message = "Error creating target connection: " + ex.getMessage();
			} 
		}
	%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Object comparator</TD><TD></TD></TR></TABLE><% 
		if (message != null) {
	%><DIV class="subTit">Messages</DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td colspan=4 align='left'><%=message%></td></tr></table><%
		}
	%><DIV id="divContent" class="divContent"><FORM id="frmMain" name="frmMain" method="POST" ><DIV class="subTit">Source database information <%= (srcCnx != null ? "(Connected)":"(Not connected)") %></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td>Database Driver</td><td colspan=3><SELECT name="cmbSrcDriver" onchange="cmbSrcDriver_onchange(this)"><OPTION value="SQLServer" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("SQLServer")) ? "selected" : "" %> >SQL Server</OPTION><OPTION value="Oracle" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("Oracle")) ? "selected" : "" %>>Oracle</OPTION><OPTION value="Postgre" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("Postgre")) ? "selected" : "" %>>PostgreSQL</OPTION></SELECT></td></tr><tr><td>Database URL</td><td colspan=3><INPUT type="text" name="txtSrcURL" size=100 value="<%=request.getParameter("txtSrcURL")!=null?request.getParameter("txtSrcURL"):""%>"></td></tr><tr><td>Database User</td><td colspan=3><INPUT type="text" name="txtSrcUser" size=70 value="<%=request.getParameter("txtSrcUser")!=null?request.getParameter("txtSrcUser"):""%>"></td></tr><tr><td>Database Password</td><td colspan=2><INPUT type="password" name="txtSrcPwd" size=70 value="<%=request.getParameter("txtSrcPwd")!=null?request.getParameter("txtSrcPwd"):""%>"></td><td><button onclick="src_connect_onclick()">Connect</button></td></tr></table><DIV class="subTit">Target database information <%= (dstCnx != null ? "(Connected)":"(Not connected)") %></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td>Database Driver</td><td colspan=3><SELECT name="cmbDstDriver" onchange="cmbDstDriver_onchange(this)"><OPTION value="SQLServer" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("SQLServer")) ? "selected" : "" %>>SQL Server</OPTION><OPTION value="Oracle" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("Oracle")) ? "selected" : "" %>>Oracle</OPTION><OPTION value="Postgre" <%= (request.getParameter("cmbSrcDriver") != null && request.getParameter("cmbSrcDriver").equalsIgnoreCase("Postgre")) ? "selected" : "" %>>PostgreSQL</OPTION></SELECT></td></tr><tr><td>Database URL</td><td colspan=3><INPUT type="text" name="txtDstURL" size=100 value="<%=request.getParameter("txtDstURL")!=null?request.getParameter("txtDstURL"):""%>"></td></tr><tr><td>Database User</td><td colspan=3><INPUT type="text" name="txtDstUser" size=70 value="<%=request.getParameter("txtDstUser")!=null?request.getParameter("txtDstUser"):""%>"></td></tr><tr><td>Database Password</td><td colspan=2><INPUT type="password" name="txtDstPwd" size=70 value="<%=request.getParameter("txtDstPwd")!=null?request.getParameter("txtDstPwd"):""%>"></td><td><button onclick="dst_connect_onclick()">Connect</button></td></tr></table><% if (srcEnvs != null && dstEnvs != null) { %><DIV class="subTit">Source environment</DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td>Environments:</td><td colspan=3><SELECT name="cmbSrcEnv"><OPTION value="">&nbsp</OPTION><% if (srcEnvs != null) { 
									Iterator itEnvs = srcEnvs.iterator();
									while (itEnvs.hasNext()) {
										EnvironmentVo envVo = (EnvironmentVo)itEnvs.next();
							%><OPTION value="<%=envVo.getEnvId()%>"><%=envVo.getEnvName()%></OPTION><% 		} 
								}
							%></SELECT></td></tr></table><DIV class="subTit">Target environment</DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td>Environments:</td><td colspan=3><SELECT name="cmbDstEnv"><OPTION value="">&nbsp</OPTION><% if (dstEnvs != null) { 
									Iterator itEnvs = dstEnvs.iterator();
									while (itEnvs.hasNext()) {
										EnvironmentVo envVo = (EnvironmentVo)itEnvs.next();
							%><OPTION value="<%=envVo.getEnvId()%>"><%=envVo.getEnvName()%></OPTION><% 		} 
								}
							%></SELECT></td></tr></table><%  } %><%  
				if (results != null) { 
			%><DIV class="subTit">Comparison results</DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
		   			for (int i = 0; i < results.size(); i++) {
						String line = (String)results.get(i);
						String[] data = StringUtil.split(line, ":");
			%><tr><td align='left'><%=data[0]%></td><td colspan='3' align='left'><%=data[1]%></td></tr><%
					}
				}					
			%></table></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button onclick="compareForms_onclick()">Compare forms</button><button onclick="compareBusClasses_onclick()">Compare business classes</button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">

	function compareForms_onclick(){
		frmMain.action="compareObjects.jsp?action=compareForms"
		frmMain.submit();
	}

	function compareBusClasses_onclick(){
		frmMain.action="compareObjects.jsp?action=compareBusClasses"
		frmMain.submit();
	}

	function src_connect_onclick(){
		frmMain.action="compareObjects.jsp?action=src_connect"
		frmMain.submit();
	}

	function dst_connect_onclick(){
		frmMain.action="compareObjects.jsp?action=dst_connect"
		frmMain.submit();
	}

	cmbSrcDriver_onchange(document.getElementById("cmbSrcDriver"));
	cmbDstDriver_onchange(document.getElementById("cmbDstDriver"));
	
	function cmbSrcDriver_onchange(x) {
		if(x.value == 'SQLServer'){
			document.getElementById("txtSrcURL").value = "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=apia22;SelectMethod=Cursor";
		}
		if(x.value == 'Oracle'){
			document.getElementById("txtSrcURL").value = "jdbc:oracle:thin:@sttest01:1521:apiadesa";	
		}
		if(x.value == 'Postgre'){
			document.getElementById("txtSrcURL").value = "jdbc:postgresql://<HOST>:<PORT>/<DATABASE_NAME>";	
		}	
	}

	function cmbDstDriver_onchange(x) {
		if(x.value == 'SQLServer'){
			document.getElementById("txtDstURL").value = "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=apia22;SelectMethod=Cursor";
		}
		if(x.value == 'Oracle'){
			document.getElementById("txtDstURL").value = "jdbc:oracle:thin:@sttest01:1521:apiadesa";	
		}
		if(x.value == 'Postgre'){
			document.getElementById("txtDstURL").value = "jdbc:postgresql://<HOST>:<PORT>/<DATABASE_NAME>";	
		}	
	}

</script>