<%@page import="com.st.common.configuration.Constants"%>
<%@page import="com.st.common.db.snapshoot.TestExport"%>
<%@include file="../components/scripts/server/startInc.jsp" %>

<HTML XMLNS:CONTROL> 
<head>
<%@include file="../components/scripts/server/headInclude.jsp" %>
</head>
<body>


<TABLE class="pageTop">
		<COL class="col1"><COL class="col2">
		<TR>
			<TD>Export Database</TD>
			<TD></TD>
		</TR>
	</TABLE>
	<DIV id="divContent" class="divContent">

		<FORM id="frmMain" name="frmMain" method="POST" >
	    
			<table class="tblFormLayout">
				<COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4">
		   		<tr>
		   			<td>Database Driver</td>
					<td colspan=3>
						<SELECT name="cmbDriver" onchange="cmbDriver_onchange(this)">
							<OPTION value="<%=Constants.JDBC_CLASS_DRIVER_SQLSERVER%>">SQL Server</OPTION>
							<OPTION value="<%=Constants.JDBC_CLASS_DRIVER_ORACLE%>">Oracle</OPTION>
							<OPTION value="<%=Constants.JDBC_CLASS_DRIVER_POSTGRESQL%>">PostgreSQL</OPTION>
						</SELECT>
					</td>

		   		</tr>
		   		<tr>
		   			<td>Database URL</td>
					<td colspan=3>
						<INPUT name="txtURL" size=100 value="<%=request.getParameter("txtURL")!=null?request.getParameter("txtURL"):""%>">
					</td>
		   		</tr>
		   		<tr>
		   			<td>Database User</td>
					<td colspan=3>
						<INPUT name="txtUser" size=70 value="<%=request.getParameter("txtUser")!=null?request.getParameter("txtUser"):""%>">
					</td>
		   		</tr>
		   		<tr>
		   			<td>Database Password</td>
					<td colspan=3>
						<INPUT name="txtPwd" size=70 value="<%=request.getParameter("txtPwd")!=null?request.getParameter("txtPwd"):""%>">
					</td>
		   		</tr>
		   		<tr>
		   			<td>Export File</td>
					<td colspan=3>
						<INPUT name="txtExpFile" size=70 value="<%=request.getParameter("txtExpFile")!=null?request.getParameter("txtExpFile"):""%>">
					</td>
		   		</tr>
		   		<tr>
		   			<td>Log File</td>
					<td colspan=3>
						<INPUT name="txtLogFile" size=70 value="<%=request.getParameter("txtLogFile")!=null?request.getParameter("txtLogFile"):""%>">
					</td>
		   		</tr>
		 	</table>
		</FORM>
		
		
		<%
			if("true".equals(request.getParameter("doExp"))){
				TestExport.webExport(request);
				out.print("<B>EXPORT DONE</B>");
			}
		%>


	</DIV>
	<TABLE class="pageBottom">
	<COL class="col1"><COL class="col2">
		<TR>
			<TD></TD>
			<TD>
				<button onclick="export_onclick()" accesskey="E">Export</button>
			</TD>
		</TR>
	</TABLE>
</body>
</html>
<%@include file="../components/scripts/server/endInc.jsp" %>


<script language="javascript">

cmbDriver_onchange(document.getElementById("cmbDriver"));
document.getElementById("txtExpFile").value="/export.xml";
document.getElementById("txtLogFile").value="/export.log";


function export_onclick(){
	frmMain.action="DBExport.jsp?doExp=true"
	frmMain.submit();
}

function cmbDriver_onchange(x) {
	if(x.value == "<%=Constants.JDBC_CLASS_DRIVER_SQLSERVER%>"){
		document.getElementById("txtURL").value = "jdbc:microsoft:sqlserver://<HOST>:<PORT>;DatabaseName=<DATABASE_NAME>;SelectMethod=Cursor";
	}
	if(x.value == "<%=Constants.JDBC_CLASS_DRIVER_ORACLE%>"){
		document.getElementById("txtURL").value = "jdbc:oracle:thin:@<HOST>:<PORT>:<DATABASE_NAME>";	
	}
	if(x.value == "<%=Constants.JDBC_CLASS_DRIVER_POSTGRESQL%>"){
		document.getElementById("txtURL").value = "jdbc:postgresql://<HOST>:<PORT>/<DATABASE_NAME>";	
	}	
}
</script>