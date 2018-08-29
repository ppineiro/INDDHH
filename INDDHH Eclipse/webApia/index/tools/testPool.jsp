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
<html>
<head><title>PoolTest</title></head>
<body>

<%!

private String getDriver(String db) throws Exception {
	if (Configuration.ORACLE.equalsIgnoreCase(db)) {
		return DBManagerOracle.getDriverName();
	} else if (Configuration.POSTGRE.equalsIgnoreCase(db)) {
		return DBManagerPostgre.getDriverName();
	} else if (Configuration.SQLSERVER.equalsIgnoreCase(db)) {
		return DBManagerSQLServer.getDriverName();
	} else {
	    throw new Exception("Invalid Database Manager: " + db);
	}
}

private String testDefaultPool(String db, String user, String pass, String url, int minConnection, int maxConnections,int maxIdleConns, int maxWait, String sql, int timeBetweenEvictionRuns, int dnConRenewTime, int dbTestPerEviction, int queryTimeout) {
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
		
		buffer.append(System.currentTimeMillis() + " - Create sql: " + sql + "<br>");
		PreparedStatement statement = StatementFactory.getStatement(conn,sql,false);
		statement.setQueryTimeout(queryTimeout);
		
		buffer.append(System.currentTimeMillis() + " - Execute sql: " + statement.execute() + "<br>");
		
		buffer.append(System.currentTimeMillis() + " - Close statement: <br>");
		statement.close();

		buffer.append(System.currentTimeMillis() + " - Test end OK<br>");
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

<%
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

%>

<form method="post">
<b>Test pool creation</b><br>
<table>
<tr><td>Type:</td><td><select name="dbType">
	<option value=""></option>
	<option value="oracle" <%= "oracle".equals(dbType)?"selected":"" %>>oracle</option>
	<option value="postgresql" <%= "postgresql".equals(dbType)?"selected":"" %>>postgresql</option>
	<option value="sqlserver" <%= "sqlserver".equals(dbType)?"selected":"" %>>sqlserver</option>
</select></td></tr>
<tr><td>Url:</td>      <td><input type="text" name="dbUrl" value="<%= (dbUrl == null)?"":dbUrl %>"></td></tr>
<tr><td>User:</td>     <td><input type="text" name="dbUser" value="<%= (dbUser == null)?"":dbUser %>"></td></tr>
<tr><td>Password:</td> <td><input type="text" name="dbPwd" value="<%= (dbPwd == null)?"":dbPwd %>"></td></tr>
<tr><td>SQL:</td>      <td><input type="text" name="dbSql" value="<%= (dbSql == null)?"":dbSql %>"></td></tr>

<tr><td>&nbsp;</td><td></td></tr>

<tr><td>Min. Con.:</td>       <td><input type="text" name="minConnection" value="<%= (minConnection == null)?"":minConnection %>"></td></tr>
<tr><td>Max. Con.:</td>       <td><input type="text" name="maxConnections" value="<%= (maxConnections == null)?"":maxConnections %>"></td></tr>
<tr><td>Max. Idle. Con.:</td> <td><input type="text" name="maxIdleConns" value="<%= (maxIdleConns == null)?"":maxIdleConns %>"></td></tr>
<tr><td>Max. wait.:</td>      <td><input type="text" name="maxWait" value="<%= (maxWait == null)?"":maxWait %>"></td></tr>

<tr><td>&nbsp;</td><td></td></tr>

<tr><td>Time eviction:</td>       <td><input type="text" name="timeBetweenEvictionRuns" value="<%= (timeBetweenEvictionRuns == null)?"":timeBetweenEvictionRuns %>"></td></tr>
<tr><td>Renew time:</td>          <td><input type="text" name="dnConRenewTime" value="<%= (dnConRenewTime == null)?"":dnConRenewTime %>"></td></tr>
<tr><td>Test per eviction:</td>   <td><input type="text" name="dbTestPerEviction" value="<%= (dbTestPerEviction == null)?"":dbTestPerEviction %>"></td></tr>
<tr><td>Time sql:</td>            <td><input type="text" name="queryTimeout" value="<%= (queryTimeout == null)?"":queryTimeout %>"></td></tr>

<tr><td>&nbsp;</td><td></td></tr>

<tr><td>Refresh time:</td> <td><input type="text" name="refreshTime" value="<%= (refreshTime == null)?"":refreshTime	 %>"></td></tr>
</table>
<input type="submit" value="Test">
</form>


<%

if (dbType != null && ! "".equals(dbType)) { %>
	<b>Test start</b><br>
	Type: <b><%=dbType%></b><br>
	Url: <b><%=dbUrl%></b><br>
	User: <b><%=dbUser%></b><br>
	Pwd: <b><%=dbPwd%></b><br>
	Sql: <b><%=dbSql%></b><br>
	<br><%
	try { %>
		<b>Test (<%= new Date() %>)</b><br><%= this.testDefaultPool(dbType,dbUser,dbPwd,dbUrl,Integer.parseInt(minConnection),Integer.parseInt(maxConnections),Integer.parseInt(maxIdleConns),Integer.parseInt(maxWait),dbSql,Integer.parseInt(timeBetweenEvictionRuns),Integer.parseInt(dnConRenewTime),Integer.parseInt(dbTestPerEviction),Integer.parseInt(queryTimeout)) %>
		<%
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
<% } %>

</body>
</html>