<%@page import="java.sql.ResultSet"%>
<%@page import="com.st.db.dataAccess.DBManagerDB2"%>
<%@page import="com.st.db.dataAccess.DBManagerMySQL"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage="/tiles/errorMain.jsp"%>
<%@page import="org.apache.commons.dbcp.BasicDataSource"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="com.st.db.dataAccess.DBManagerOracle"%>
<%@page import="com.st.db.dataAccess.DBManagerPostgre"%>
<%@page import="com.st.db.dataAccess.DBManagerSQLServer"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.st.db.dataAccess.StatementFactory"%>
<%@page import="java.util.Date"%>

<%@include file="_commonValidate.jsp" %>

<%!

private String getDriver(String db) throws Exception {
	if (Configuration.ORACLE.equalsIgnoreCase(db)) {
		return DBManagerOracle.getDriverName();
	} else if (Configuration.POSTGRE.equalsIgnoreCase(db)) {
		return DBManagerPostgre.getDriverName();
	} else if (Configuration.SQLSERVER.equalsIgnoreCase(db)) {
		return DBManagerSQLServer.getDriverName();
	} else if (Configuration.MY_SQL.equalsIgnoreCase(db)) {
		return DBManagerMySQL.getDriverName();
	} else if (Configuration.DB2.equalsIgnoreCase(db)) {
		return DBManagerDB2.getDriverName();
	} else {
	    throw new Exception("Invalid Database Manager: " + db);
	}
}

private String testDefaultPool(String db, String user, String pass, String url, int minConnection, int maxConnections,int maxIdleConns, long maxWait, String sql, int timeBetweenEvictionRuns, int dnConRenewTime, int dbTestPerEviction, int queryTimeout) {
	StringBuffer buffer = new StringBuffer();
	buffer.append("Start creation of pool<br>");
	Connection conn = null;
	try {
		BasicDataSource pooledDatasource = new BasicDataSource();
		pooledDatasource.setDriverClassName(this.getDriver(db));
		pooledDatasource.setUsername(user);
		pooledDatasource.setPassword(pass);
		pooledDatasource.setUrl(url);

		buffer.append(System.currentTimeMillis() + " - Database used: " + db + "<br>");
		buffer.append(System.currentTimeMillis() + " - Url used: " + url + "<br>");
		
		buffer.append(System.currentTimeMillis() + " - pool.setMaxActive: " + maxConnections + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setMaxIdle: " + maxIdleConns + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setMinIdle: " + minConnection + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setInitialSize: " + minConnection + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setMaxWait: " + maxWait + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setTimeBetweenEvictionRunsMillis: " + timeBetweenEvictionRuns + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setMinEvictableIdleTimeMillis: " + dnConRenewTime + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setNumTestsPerEvictionRun: " + dbTestPerEviction + "<br>");
		buffer.append(System.currentTimeMillis() + " - pool.setDefaultAutoCommit: " + false + "<br>");
		
		pooledDatasource.setMaxActive(maxConnections);
		pooledDatasource.setMaxIdle(maxIdleConns);
		pooledDatasource.setMinIdle(minConnection);
		pooledDatasource.setInitialSize(minConnection);
		pooledDatasource.setMaxWait(maxWait);
		pooledDatasource.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRuns);
		pooledDatasource.setMinEvictableIdleTimeMillis(dnConRenewTime);
		pooledDatasource.setNumTestsPerEvictionRun(dbTestPerEviction);
		pooledDatasource.setDefaultAutoCommit(false);
		
		buffer.append(System.currentTimeMillis() + " - Get connection<br>");
		conn = pooledDatasource.getConnection();
		
		sql = sql == null ? null : sql.trim();
		
		if (sql != null && sql.length() > 0 && sql.toLowerCase().startsWith("select")) {
			buffer.append(System.currentTimeMillis() + " - Create sql: " + sql + "<br>");
			PreparedStatement statement = StatementFactory.getStatement(conn,sql,false);
			statement.setQueryTimeout(queryTimeout);
			
			ResultSet resultSet = statement.executeQuery();
			buffer.append(System.currentTimeMillis() + " - Execute sql: ok<br>");
			
			int count = 0;
			while (resultSet.next()) count++;
			buffer.append(System.currentTimeMillis() + " - Amount of records: " + count + "<br>");
			
			buffer.append(System.currentTimeMillis() + " - Close statement: <br>");
			statement.close();
		}

		buffer.append(System.currentTimeMillis() + " - Test ended OK<br>");
	} catch (Exception e) {
		buffer.append(System.currentTimeMillis() + " - Error: " + e.getMessage() + "<br>");
	} finally {
		if (conn != null) {
			try {
				buffer.append(System.currentTimeMillis() + " - Close connection: <br>");
				conn.close();
			} catch (Exception e) {
				buffer.append(System.currentTimeMillis() + " - Error: " + e.getMessage() + "<br>");
			}
		}
	}

	return buffer.toString();
}

%>

<html>
<head>
	<title>Test connection</title>

	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		<% if (_logged) { %>
			.fieldGroup { display: inline-block; vertical-align: top; }
			form div.field span { width: 100px !important; }
		<% } %>
	</style>
	
	<%@include file="_commonInclude.jsp" %>
	
	<script type="text/javascript">
		<%@include file="_commonScript.jsp" %>
	</script>
</head>
<body>
	<%@include file="_commonLogin.jsp" %>

<% if (_logged) {
	String dbType = request.getParameter("dbType");
	String dbUrl  = request.getParameter("dbUrl");
	String dbUser = request.getParameter("dbUser");
	String dbPwd  = request.getParameter("dbPwd");
	String dbSql  = request.getParameter("dbSql"); 
	
	String minConnection  = request.getParameter("minConnection"); 
	String maxConnections = request.getParameter("maxConnections"); 
	String maxIdleConns   = request.getParameter("maxIdleConns"); 
	String maxWait        = request.getParameter("maxWait"); 
	
	String timeBetweenEvictionRuns = request.getParameter("timeBetweenEvictionRuns"); 
	String dnConRenewTime          = request.getParameter("dnConRenewTime"); 
	String dbTestPerEviction       = request.getParameter("dbTestPerEviction"); 
	
	String queryTimeout			   = request.getParameter("queryTimeout");
	
	String refreshTime = request.getParameter("refreshTime");
	
	if (minConnection == null || minConnection.length() == 0) minConnection = Integer.toString(Configuration.DB_MIN_CONNECTIONS);
	if (maxConnections == null || maxConnections.length() == 0) maxConnections = Integer.toString(Configuration.DB_MAX_CONNECTIONS);
	if (maxIdleConns == null || maxIdleConns.length() == 0) maxIdleConns = Integer.toString(Configuration.DB_MAX_IDLE_CONNECTIONS);
	if (maxWait == null || maxWait.length() == 0) maxWait = Long.toString(Configuration.DB_CON_WAIT_TIMEOUT);
	if (timeBetweenEvictionRuns == null || timeBetweenEvictionRuns.length() == 0) timeBetweenEvictionRuns = Integer.toString(Configuration.DB_TEST_PER_EVICTION);
	if (dnConRenewTime == null || dnConRenewTime.length() == 0) dnConRenewTime = Long.toString(Configuration.DB_CONN_RENEW_TIME);
	if (dbTestPerEviction == null || dbTestPerEviction.length() == 0) dbTestPerEviction = Integer.toString(Configuration.DB_TEST_PER_EVICTION);
	if (queryTimeout == null || queryTimeout.length() == 0) queryTimeout = "10000";
	
	if (refreshTime != null && refreshTime.length() == 0) refreshTime = null;
	
	%>
	
	<form method="post">
		<%@include file="_commonLogout.jsp" %>
		<div class="fieldGroup">
			<h3>Test pool creation</h3>
			<div class="field"><span>Type:</span><select name="dbType">
				<option value=""></option>
				<option value="<%= Configuration.ORACLE %>" <%= Configuration.ORACLE.equals(dbType)?"selected":"" %>><%= Configuration.ORACLE %></option>
				<option value="<%= Configuration.MY_SQL %>" <%= Configuration.MY_SQL.equals(dbType)?"selected":"" %>><%= Configuration.MY_SQL %></option>
				<option value="<%= Configuration.POSTGRE %>" <%= Configuration.POSTGRE.equals(dbType)?"selected":"" %>><%= Configuration.POSTGRE %></option>
				<option value="<%= Configuration.SQLSERVER %>" <%= Configuration.SQLSERVER.equals(dbType)?"selected":"" %>><%= Configuration.SQLSERVER %></option>
				<option value="<%= Configuration.DB2 %>" <%= Configuration.DB2.equals(dbType)?"selected":"" %>><%= Configuration.DB2 %></option>
			</select></div>
			<div class="field"><span>URL:</span><input type="text" name="dbUrl" value="<%= (dbUrl == null)?"":dbUrl %>"></div>
			<div class="field"><span>User:</span><input type="text" name="dbUser" value="<%= (dbUser == null)?"":dbUser %>"></div>
			<div class="field"><span>Password:</span><input type="text" name="dbPwd" value="<%= (dbPwd == null)?"":dbPwd %>"></div>
		</div>
		
		<div class="fieldGroup">
			<h3>Connections amount</h3>
			<div class="field"><span>Min. Con.:</span><input type="text" name="minConnection" value="<%= (minConnection == null)?"":minConnection %>"></div>
			<div class="field"><span>Max. Con.:</span><input type="text" name="maxConnections" value="<%= (maxConnections == null)?"":maxConnections %>"></div>
			<div class="field"><span>Max. Idle. Con.:</span><input type="text" name="maxIdleConns" value="<%= (maxIdleConns == null)?"":maxIdleConns %>"></div>
			<div class="field"><span>Max. wait.:</span><input type="text" name="maxWait" value="<%= (maxWait == null)?"":maxWait %>"></div>
		</div>
		
		<div class="fieldGroup">
			<h3>Pool properties</h3>
			<div class="field"><span>Time eviction:</span><input type="text" name="timeBetweenEvictionRuns" value="<%= (timeBetweenEvictionRuns == null)?"":timeBetweenEvictionRuns %>"></div>
			<div class="field"><span>Renew time:</span><input type="text" name="dnConRenewTime" value="<%= (dnConRenewTime == null)?"":dnConRenewTime %>"></div>
			<div class="field"><span>Test per eviction:</span><input type="text" name="dbTestPerEviction" value="<%= (dbTestPerEviction == null)?"":dbTestPerEviction %>"></div>
		</div>
	
		<div class="fieldGroup">
			<h3>SQL test</h3>
			<div class="field"><span>SQL:</span><input type="text" name="dbSql" value="<%= (dbSql == null)?"":dbSql %>"></div>
			<div class="field"><span>Timeout SQL:</span><input type="text" name="queryTimeout" value="<%= (queryTimeout == null)?"":queryTimeout %>"></div>
			<div class="field"><span>Auto refresh:</span><input type="text" name="refreshTime" value="<%= (refreshTime == null)?"":refreshTime	 %>"></div>
			<div class="field"><span></span><input type="submit" value="Test"></div>
		</div>

	</form>
	
	
	<%
	
	if (dbType != null && ! "".equals(dbType)) { %>
		<h3>Test start</h3>
		Type: <b><%=dbType%></b><br>
		Url: <b><%=dbUrl%></b><br>
		User: <b><%=dbUser%></b><br>
		Pwd: <b><%=dbPwd%></b><br>
		Sql: <b><%=dbSql%></b><br>
		<br><%
		try { %>
			<h3>Test (<%= new Date() %>)</h3>
			<%= this.testDefaultPool(dbType,dbUser,dbPwd,dbUrl,Integer.parseInt(minConnection),Integer.parseInt(maxConnections),Integer.parseInt(maxIdleConns),Long.parseLong(maxWait),dbSql,Integer.parseInt(timeBetweenEvictionRuns),Integer.parseInt(dnConRenewTime),Integer.parseInt(dbTestPerEviction),Integer.parseInt(queryTimeout)) %><%
		} catch (Exception e) { %>
			<b>Ouch!!! Error:</b><br><%
			java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
			e.printStackTrace(new java.io.PrintStream(bout));
			%><pre><%= bout.toString() %></pre><%
		} 		
	} 
	
	if (refreshTime != null) { %>
	
		<script type="text/javascript">
		
		setTimeout(doRefresh,<%= refreshTime %>);
		
		function doRefresh() {
			document.getElementById("refreshForm").submit();
		}
		</script>
	<% } 
} %>

</body>
</html>