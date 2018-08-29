<%@page import="java.sql.SQLWarning"%>
<%@page import="com.st.db.dataAccess.DBManagerDBCP"%>
<%@page import="com.dogma.BIParameters"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.st.db.dataAccess.StatementFactory"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.st.db.dataAccess.BIDBConnViewer"%>
<%@page import="com.st.db.dataAccess.DBConnViewer"%>
<%@page import="biz.statum.sdk.util.DateUtil"%>
<%@page import="com.dogma.dataAccess.DBManagerUtil"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.BIDBAdmin"%>
<%@page import="com.dogma.bi.BIConstants"%>
<%@page import="java.util.Set"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>


<%@include file="_commonValidate.jsp" %>

<%

boolean executeAction = _logged && "true".equals(request.getParameter("doExecution"));

%>

<%!

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected interface IConnectionHelper {
	public Set<String> getKeys();
	public String getSource();
	public boolean isMainManager(String managerId);
	public void createNewPool(String managerId, Integer min, Integer max) throws Exception;
	
	public String test(String managerId, int amount, long timeSleep, boolean showTest);
	public String info(String managerId, boolean timed);
	public String size(String managerId, HttpServletRequest request);
	public String init(String managerId, HttpServletRequest request, boolean forced);
	public String sql(String managerId, HttpServletRequest request, boolean showInfo);
}

protected class ConnectionHelperGlobal {
	public String getTime() 					{ return DateUtil.formatDateTime(new java.util.Date(), DateUtil.FMT_TIME); }
	public String generateText(String text)		{ return this.getTime() + ": " + text + "<br>"; }
	public String generateStart(String text)	{ return StringUtil.EMPTY_STRING; /* this.getTime() + ": Method <b>" + text + "</b> started at: " + DateUtil.formatDateTime(new java.util.Date(), DateUtil.FMT_MILITAR) + " (server time)<br>"; */ }
	public String generateEnd(String text)		{ return StringUtil.EMPTY_STRING; /* this.getTime() + ": Method <b>" + text + "</b> ended at: " + DateUtil.formatDateTime(new java.util.Date(), DateUtil.FMT_MILITAR) + " (server time)<br><br>"; */ }
	
	public String size(IConnectionHelper caller, String managerid, DBManager manager, HttpServletRequest request) {
		StringBuffer buffer = new StringBuffer();
		
		if (caller.isMainManager(managerid)) {
			Integer min = null;
			Integer max = null;
			
			try { min = Integer.valueOf(request.getParameter("min")); } catch (Exception e) {}
			try { max = Integer.valueOf(request.getParameter("max")); } catch (Exception e) {}
			
			buffer.append("<form action='?' method='post'>");
			buffer.append("<input type='hidden' name='doExecution' value='true'>");
			buffer.append("<input type='hidden' name='action' value='size'>");
			buffer.append("<input type='hidden' name='connection' value='" + managerid + "'>");
			buffer.append("<input type='hidden' name='src' value='" + caller.getSource() + "'>");
			buffer.append("<div class='field'><span>Min. size:</span> <input type='text' name='min' value='" + (min == null ? "" : min.toString()) + "'></div>");
			buffer.append("<div class='field'><span>Max. size:</span> <input type='text' name='max' value='" + (max == null ? "" : max.toString()) + "'></div>");
			buffer.append("<div class='field'><span>&nbsp;</span><input type='submit' value='Change'></div>");
			buffer.append("</form>");

			buffer.append(caller.info(managerid, false));
			
			if (min != null && max != null) {
				try {
					buffer.append("<br>");
					buffer.append(this.generateText("Changing pool size..."));
					buffer.append(caller.init(managerid, request, true));
					caller.createNewPool(managerid, min, max);
					buffer.append(this.generateText("Pool has new size"));
					
					buffer.append(caller.info(managerid, false));
					
				} catch (Exception e) {
					buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
				}
			}
		} else {
			buffer.append(this.generateText("Action not allowed for user pool. Go to Desgine - DB Connetions"));
		}
		
		return buffer.toString();
	}
	
	public String sql(IConnectionHelper caller, String managerid, DBManager manager, HttpServletRequest request, boolean showInfo) {
		StringBuffer buffer = new StringBuffer();
		
		if (manager != null) {
			int maxToShow = 20;
			boolean doCommit = false;
			boolean doExecutionSQL = false;
			
			try { maxToShow = Integer.parseInt(request.getParameter("maxToShow")); } catch (Exception e) {}
			try { doCommit = "true".equals(request.getParameter("doCommit")); } catch (Exception e) {}
			try { doExecutionSQL = "true".equals(request.getParameter("doExecutionSQL")); } catch (Exception e) {}
			
			String inputSql = doExecutionSQL ? request.getParameter("sql") : StringUtil.EMPTY_STRING;
			if (inputSql == null) inputSql = StringUtil.EMPTY_STRING;
			
			doExecutionSQL = StringUtil.notEmpty(inputSql);
			
			buffer.append("<span class='block hidden' id='sqlWait'>loading...</span>");
			buffer.append("<form action='?' id='sqlForm' class='sql'>");
			buffer.append("<input type='hidden' name='doExecution' value='true'>");
			buffer.append("<input type='hidden' name='doExecutionSQL' value='true'>");
			buffer.append("<input type='hidden' name='action' value='" + (showInfo ? "sql + info" : "sql") +"'>");
			buffer.append("<input type='hidden' name='connection' value='" + managerid + "'>");
			buffer.append("<input type='hidden' name='src' value='" + caller.getSource() + "'>");
			buffer.append("<table class='container'>");
				buffer.append("<tr>");
					buffer.append("<td class='sentence'>");
						buffer.append("SQL: <textarea name='sql'>" + inputSql + "</textarea><br>");
					buffer.append("</td>");
					buffer.append("<td class='options'>");
						buffer.append("Show: <input type='text' name='maxToShow' id='maxToShow' value='" + maxToShow + "'><br>");
						buffer.append("Commit: <input type='checkbox' name='doCommit' value='true'><br>");
						buffer.append("<input type='submit' value='Execute'>");
					buffer.append("</td>");
				buffer.append("</tr>");
			buffer.append("</table>");
			buffer.append("</form>");
			
			buffer.append("<div class='resultContent'>");
			
			if (showInfo) buffer.append(caller.info(managerid, false));
			
			if (doExecutionSQL) {
				
				ConnectionGetter conGetter = new ConnectionGetter();
			
				DBConnection dbConn = null;
				try {
					dbConn = manager.getConnection(null,null,null,0,0,0,0);
					Connection conn = conGetter.getDBConnection2(dbConn);
					if (!conn.isClosed()) {
						String[] sqls = StringUtil.split(inputSql, ";--");
						
						int selectSql = 0;
						int insertSql = 0;
						int updateSql = 0;
						int deleteSql = 0;

						for (String sql : sqls) {
							sql = sql.trim();
							PreparedStatement statement = StatementFactory.getStatement(conn,sql,false);
							buffer.append(this.generateText("Executing statement"));
							boolean executedOK = false;
							
							selectSql += sql.toLowerCase().startsWith("select ") ? 1 : 0;
							insertSql += sql.toLowerCase().startsWith("insert ") ? 1 : 0;
							updateSql += sql.toLowerCase().startsWith("update ") ? 1 : 0;
							deleteSql += sql.toLowerCase().startsWith("delete ") ? 1 : 0;
							
							boolean isSelectSql = sql.toLowerCase().startsWith("select ");
							
							ResultSet resultSet = null;
							long start = System.currentTimeMillis();
							if (isSelectSql) {
								resultSet = statement.executeQuery();
								executedOK = true;
							} else {
								executedOK = statement.execute();
							}
							long end = System.currentTimeMillis();
							if (sqls.length > 1) buffer.append(this.generateText("Statement: <b>" + sql + "</b> (is select: " + isSelectSql + ")"));
							buffer.append(this.generateText("Statement executed: <b>" + executedOK + "</b> in: <b>" + (end-start) + " milisec</b>"));
							buffer.append(this.generateText("Fetch size: <b>" + statement.getFetchSize() + "</b> - <b>" + ((resultSet != null) ? resultSet.getFetchSize() : -1) + "</b>"));
							if (isSelectSql) {
								buffer.append(this.generateText("Loading select result (max: <b>" + maxToShow + "</b>)..."));
								start = System.currentTimeMillis();
								StringBuffer sqlResult = new StringBuffer();
								ResultSetMetaData rsmd = resultSet.getMetaData();
								
								sqlResult.append("<br><table cellpading='0' cellspacing='0' class='result'>");
								sqlResult.append("<thead>");
								sqlResult.append("<tr>");
	
								for (int i = 0; i < rsmd.getColumnCount(); i++) {
					     			sqlResult.append("<th>" + rsmd.getColumnName(i+1) + "</th>");
					     		}
					     		sqlResult.append("</tr>");
					     		sqlResult.append("</thead>");
					     		int cantReg = 0;
					     		sqlResult.append("<tbody>");
					     		
					     		boolean hasResultSetNext = resultSet.next();
					     		while (cantReg < maxToShow && hasResultSetNext) {
					     			sqlResult.append("<tr>");
	
					     			for (int i = 0; i < rsmd.getColumnCount(); i++) {
					     				Object value = resultSet.getObject(i+1);
					     				sqlResult.append("<td>" + (value == null ? "<i>null</i>" : value) + "</td>");
					     			}	
					     			sqlResult.append("</tr>");
					     			cantReg++;
					     			hasResultSetNext = resultSet.next();
					     		}
					     		boolean addPoints = false;
					     		while (hasResultSetNext) {
					     			addPoints = true;
					     			cantReg++;
					     			hasResultSetNext = resultSet.next();
					     		}
				     			if (addPoints) {
				     				maxToShow = maxToShow * 2;
				     				if (maxToShow > cantReg) maxToShow = cantReg;
				     				sqlResult.append("<tr><td colspan=" + rsmd.getColumnCount() + " class=noHover>... (<a href=\"#\" onclick=\"$('maxToShow').value = " + maxToShow + "; $('sqlForm').submit(); return false;\">Show " + maxToShow + "</a>)</td></tr>");
				     			}
					     		sqlResult.append("<tr><td colspan=" + rsmd.getColumnCount() + " class=noHover>Total reg: <b>" + cantReg + "</b></td></tr>");
								sqlResult.append("</tbody></table><br>");
								
								buffer.append(sqlResult.toString());
							} else if (! isSelectSql) {
								buffer.append(this.generateText("SQL select result information not available"));
								buffer.append(this.generateText("Records affected: " + statement.getUpdateCount()));
							}
							
							end = System.currentTimeMillis();
							buffer.append(this.generateText("SQL executed in: <b>" + (end - start) + " milisec</b>"));
							
							SQLWarning sqlWarning = statement.getWarnings();
							
							while (sqlWarning != null) {
								buffer.append(this.generateText("[warning] " + sqlWarning.getMessage()));
								sqlWarning = sqlWarning.getNextWarning();
							}
							
							statement.close();
						}
						
						if (insertSql > 0 || updateSql > 0 || deleteSql > 0) {
							if (doCommit) {
								buffer.append(this.generateText("<b>Commit connection</b>"));
								DBManagerUtil.commit(dbConn);
							} else {
								buffer.append(this.generateText("<b>Commit not supported</b>"));
							}
						}
						
						if (sqls.length > 1) {
							buffer.append(this.generateText("Select executed: <b>" + selectSql + "</b>"));
							buffer.append(this.generateText("Insert executed: <b>" + insertSql + "</b>"));
							buffer.append(this.generateText("Update executed: <b>" + updateSql + "</b>"));
							buffer.append(this.generateText("Delete executed: <b>" + deleteSql + "</b>"));
						}
					}
				} catch (Exception e) {
					try {
						buffer.append(this.generateText("Rollback connection"));
						DBManagerUtil.rollback(dbConn);
					} catch (Exception ee) {
						ee.printStackTrace();
						buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
						java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
						ee.printStackTrace(new java.io.PrintStream(bout));
						buffer.append("<pre>" + bout.toString() + "</pre>");

					}
					e.printStackTrace();
					buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<pre>" + bout.toString() + "</pre>");

				} finally {
					if (dbConn != null) {
						try { DBManagerUtil.rollback(dbConn); } catch (Exception e) {}
						DBManagerUtil.close(dbConn);
					}
				}
	
				buffer.append("</div>");
			}
		}
		
		return buffer.toString();
	}

	public String test(IConnectionHelper caller, String managerid, DBManager manager, int numCon, long timeSleep, boolean showInfo) {
		StringBuffer buffer = new StringBuffer();
		buffer.append(this.generateStart("Test pool connection"));
		buffer.append(this.generateText("Testing: <b>" + managerid + "</b>"));
		buffer.append("<br>");
		buffer.append(this.generateText("Getting pool: " + managerid));
	
		if (manager == null) {
			buffer.append(this.generateText("Pool not present"));
			
		} else {
			ConnectionGetter conGetter = new ConnectionGetter();
		
			DBConnection[] dbConns = new DBConnection[numCon];
			try {
				buffer.append(this.generateText("Getting <b>" + numCon + "</b> connections..."));
				for (int i = 0; i < dbConns.length; i++) {
					buffer.append(this.generateText("Testing connection " + (i+1) + "..."));
					long start = System.currentTimeMillis();
					dbConns[i] = manager.getConnection(null,null,null,0,0,0,0);
					long end = System.currentTimeMillis();
					buffer.append(this.generateText("Connection recived in: <b>" + (end-start) + " milisec</b>"));
					Connection conn = conGetter.getDBConnection2(dbConns[i]);
					
					buffer.append(this.generateText("Connection ok: " + (!conn.isClosed())));
				}
				
				
				if (showInfo) buffer.append(caller.info(managerid, false));
				
				buffer.append(this.generateText("Sleeping for <b>" + timeSleep + " milisec</b>"));
				buffer.append("<br>");

				try {
					Thread.sleep(timeSleep);
				} catch (Exception e) {
				} finally {
					buffer.append(this.generateText("Sleep end"));
				}
				
				buffer.append("<br>");
				
				if (showInfo) buffer.append(caller.info(managerid, false));
				
			} catch (Exception e) {
				buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
			} finally {
				for (int i = 0; i < dbConns.length; i++) {
					if (dbConns[i] != null) {
						buffer.append(this.generateText("closing connection " + (i+1) + "..."));
						long start = System.currentTimeMillis();
						DBManagerUtil.close(dbConns[i]);
						long end = System.currentTimeMillis();
						buffer.append(this.generateText("Closed in: <b>" + (end-start) + " milisec</b>")	);
					}
				}
				
				buffer.append("<br>");
				
				if (showInfo) buffer.append(caller.info(managerid, false));
			}
		}
		buffer.append(this.generateEnd("Test pool connection"));
		
		return buffer.toString();
	}
	
	public String info(String managerId, DBConnViewer.PoolInfo poolInfo, BIDBConnViewer.BIPoolInfo poolInfoBI, boolean timed) {
		StringBuffer buffer = new StringBuffer();
		
		boolean bi = poolInfoBI != null;
	
		if (poolInfo != null) {
			buffer.append(this.generateStart("Information"));
			buffer.append("<br>");
			
			buffer.append(this.generateText("Information for pool: <b>" + (bi ? poolInfoBI.name : poolInfo.name) + "</b>"));
			buffer.append(this.generateText("Min-Max connections: <b>" + (bi ? poolInfoBI.minCon : poolInfo.minCon) + "</b> - <b>" + (bi ? poolInfoBI.minCon : poolInfo.maxCon) + "</b>"));
			buffer.append(this.generateText("Timeout: <b>" + (bi ? poolInfoBI.timeout : poolInfo.timeout) + "</b>"));
			buffer.append(this.generateText("Actual connections: <b>" + (bi ? poolInfoBI.actCon : poolInfo.actCon) + "</b>"));
			
			if (timed) {
				buffer.append("<br>");
				buffer.append(this.generateText("Automatic refresh in: <b>10000 milisec</b>"));
				buffer.append("<script language=\"javascript\">function func() {document.location=document.location;}setTimeout( func , 10000 );</script>");
			}
			
			buffer.append(this.generateEnd("Information"));
		}
		
		return buffer.toString();
	}
}

protected class ConnectionHelperApia extends DBAdmin implements IConnectionHelper {
	public String getTime() 					{ return DateUtil.formatDateTime(new java.util.Date(), DateUtil.FMT_TIME); }
	public String generateText(String text)		{ return this.getTime() + ": " + text + "<br>"; }
	
	public Set<String> getKeys() { return managersMap.keySet(); }
	public String getSource() { return "apia"; }
	public boolean isMainManager(String managerId) { return DBAdmin.DOGMA_MANAGER_ID.equals(managerId); }
	
	public void createNewPool(String managerId, Integer min, Integer max) throws Exception {
		DBManagerUtil.getApiaConnection(DBAdmin.DOGMA_MANAGER_ID,
			Configuration.DB_USR,
			Configuration.DB_PWD,
			Configuration.DB_URL,
			min.intValue(),
			max.intValue(),
			max.intValue(),
			Configuration.DB_MAX_WAIT_TIME_MILISEC).close();
	}
	
	public String test(String managerId, int amount, long timeSleep, boolean showInfo) { return new ConnectionHelperGlobal().test(this, managerId, (DBManager) managersMap.get(managerId), amount, timeSleep, showInfo); }
	public String sql(String managerId, HttpServletRequest request, boolean showInfo) { return new ConnectionHelperGlobal().sql(this, managerId, (DBManager) managersMap.get(managerId), request, showInfo); }
	public String size(String managerId, HttpServletRequest request) { return new ConnectionHelperGlobal().size(this, managerId, (DBManager) managersMap.get(managerId), request); }

	public String info(String managerId, boolean timed) { 
		DBConnViewer conView = new DBConnViewer();
		DBConnViewer.PoolInfo poolInfo = null;
		for (Object obj : conView.getAllPoolInfo()) {
			DBConnViewer.PoolInfo pool = (DBConnViewer.PoolInfo) obj;
			if (managerId.equals(pool.name)) {
				poolInfo = pool;
				break;
			}
		}
		
		return new ConnectionHelperGlobal().info(managerId, poolInfo, null, timed);
	}
	
	public String init(String managerId, HttpServletRequest request, boolean forced) {
		StringBuffer buffer = new StringBuffer();
		if (managerId != null) {
			boolean confirmInit = forced || "true".equals(request.getParameter("confirmInit"));
			
			if (! confirmInit) {
				buffer.append("<form action='?' method='post'>");
				buffer.append("<input type='hidden' name='doExecution' value='true'>");
				buffer.append("<input type='hidden' name='action' value='init'>");
				buffer.append("<input type='hidden' name='connection' value='" + managerId + "'>");
				buffer.append("<input type='hidden' name='src' value='" + this.getSource() + "'>");
				buffer.append("<div class='field'><span>Confirm:</span> <input type='checkbox' name='confirmInit' value='true'> (must be checked to init <b>" + managerId + "</b>)</div>");
				buffer.append("<div class='field'><span>&nbsp;</span><input type='submit' value='Init'></div>");
				buffer.append("</form>");
				
				buffer.append(this.info(managerId, false));
			} else {
				Object obj = managersMap.remove(managerId);
				boolean error = false;
				buffer.append(this.generateText("Initializing pool <b>" + managerId + "</b>"));
				if (obj instanceof DBManagerDBCP) {
					try {
						buffer.append(this.generateText("Closing pool connections"));
						((DBManagerDBCP) obj).shutdown();
						buffer.append(this.generateText("Pool connections closed"));
					} catch (Exception e) {
						error = true;
						buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
					}
				}
				if (! error) {
					buffer.append(this.generateText("Pool <b>" + managerId + "</b> initialized"));
				}
			}
		}
		return buffer.toString();
	}
}

protected class ConnectionHelperBI extends BIDBAdmin implements IConnectionHelper {
	public String getTime() 					{ return DateUtil.formatDateTime(new java.util.Date(), DateUtil.FMT_TIME); }
	public String generateText(String text)		{ return this.getTime() + ": " + text + "<br>"; }
	
	public Set<String> getKeys() { return managersMap.keySet(); }
	public String getSource() { return "bi"; }
	public boolean isMainManager(String managerId) { return BIDBAdmin.BI_MANAGER_ID.equals(managerId); }
	
	public void createNewPool(String managerId, Integer min, Integer max) throws Exception {
		DBManagerUtil.getBiConnection(BIDBAdmin.BI_MANAGER_ID,
			BIParameters.BIDB_USR,
			BIParameters.BIDB_PWD,
			BIParameters.BIDB_URL,
			min.intValue(),
			max.intValue(),
			max.intValue(),
			BIParameters.BIDB_MAX_WAIT_TIME_MILISEC).close();	
	}
	
	public String test(String managerId, int amount, long timeSleep, boolean showInfo) { return new ConnectionHelperGlobal().test(this, managerId, (DBManager) managersMap.get(managerId), amount, timeSleep, showInfo); }
	public String sql(String managerId, HttpServletRequest request, boolean showInfo) { return new ConnectionHelperGlobal().sql(this, managerId, (DBManager) managersMap.get(managerId), request, showInfo); }
	public String size(String managerId, HttpServletRequest request) { return new ConnectionHelperGlobal().size(this, managerId, (DBManager) managersMap.get(managerId), request); }
	
	public String info(String managerId, boolean timed) { 
		BIDBConnViewer conView = new BIDBConnViewer();
		BIDBConnViewer.BIPoolInfo poolInfo = null;
		for (Object obj : conView.getAllPoolInfo()) {
			BIDBConnViewer.BIPoolInfo pool = (BIDBConnViewer.BIPoolInfo) obj; 
			if (managerId.equals(pool.name)) {
				poolInfo = pool;
				break;
			}
		}
		
		return new ConnectionHelperGlobal().info(managerId, null, poolInfo, timed);
	}
	
	public String init(String managerId, HttpServletRequest request, boolean forced) {
		StringBuffer buffer = new StringBuffer();
		if (managerId != null) {
			boolean confirmInit = forced || "true".equals(request.getParameter("confirmInit"));
			
			if (! confirmInit) {
				buffer.append("<form action='?' method='post'>");
				buffer.append("<input type='hidden' name='doExecution' value='true'>");
				buffer.append("<input type='hidden' name='action' value='init'>");
				buffer.append("<input type='hidden' name='connection' value='" + managerId + "'>");
				buffer.append("<input type='hidden' name='src' value='" + this.getSource() + "'>");
				buffer.append("<div class='field'><span>Confirm:</span> <input type='checkbox' name='confirmInit' value='true'> (must be checked to init <b>" + managerId + "</b>)</div>");
				buffer.append("<div class='field'><span>&nbsp;</span><input type='submit' value='Init'></div>");
				buffer.append("</form>");
				
				buffer.append(this.info(managerId, false));
			} else {
				Object obj = managersMap.remove(managerId);
				boolean error = false;
				buffer.append(this.generateText("Initializing pool <b>" + managerId + "</b>"));
				if (obj instanceof DBManagerDBCP) {
					try {
						buffer.append(this.generateText("Closing pool connections"));
						((DBManagerDBCP) obj).shutdown();
						buffer.append(this.generateText("Pool connections closed"));
					} catch (Exception e) {
						error = true;
						buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
					}
				}
				if (! error) {
					buffer.append(this.generateText("Pool <b>" + managerId + "</b> initialized"));
				}
			}
		}
		return buffer.toString();
	}
}

%>

<html>
	<head>
		<title>Apia Testpool 3.0</title>

		<style type="text/css">
			<%@include file="_commonStyles.jsp" %>
			
			<% if (_logged) { %>
				/* INICIO - Estilo visual de ejecución */
				form { border-bottom: 1px solid #D3D3D3; margin-bottom: 2px; padding: 0 0 2px; margin-top: 2px; }
				
				.sql { background-color: #FFFFFF; position: fixed; top: 0; width: 100%; margin: 0; }
				.sql .container { width: 100%; }
				.sql .container .options { vertical-align: top; width: 100px; }
				.sql .container textarea { width: 100%; height: 50px; }
				.sql .container input[type=text] { width: 50px; }
				.sql .container input { margin-top: 2px; }
				
				.resultContent { margin-top: 80px; }
				
				.result 								{ border-width: 0px; background-color: #FFFFFF; }
				.result thead th						{ border-style: solid; border-color: #000000; border-width: thin; background-color: #DDDDDD; font-weight: bold; text-align: center; }
				.result tbody td						{ border-style: solid; border-color: #DDDDDD; border-width: thin; white-space: nowrap; padding-left: 2px; padding-right: 5px; empty-cells: show; }
				.result thead tr th						{ border-style: solid; border-color: #DDDDDD; border-width: thin; }
				.result tbody tr:hover 					{ background-color: #DDDDDD; }
				.result tbody tr:hover td.noHover:hover	{ background-color: #FFFFFF; border-color: #FFFFFF; }
				.result tbody tr td.noHover				{ background-color: #FFFFFF; border-color: #FFFFFF; }
				/* FIN - Estilo visual de ejecución */
			<% } %>
		</style>
		
		<%@include file="_commonInclude.jsp" %>
				
		<script type="text/javascript">
			<%@include file="_commonScript.jsp" %>
			
			var count = 0;
		
			window.addEvent('load', function() {
				<% if (_logged && ! executeAction) { //parte principal%>
				
					$('btnExecuteAction').addEvent('click', fncBtnExecuteAction);
					
					$('help').addEvent('click', function() {
						var helpWindow = $('helpWindow');
						var helpWindowContent = $('helpWindowContent');
						helpWindow.removeClass('hidden');
						helpWindowContent.position('center');
						return false;
					});
					
					$('help2').addEvent('click', function() {
						var helpWindow = $('helpWindow');
						var helpWindowContent = $('helpWindowContent');
						helpWindow.removeClass('hidden');
						helpWindowContent.position('center');
						return false;
					});
					
					$('helpWindowHide').addEvent('click', function() { 
						$('helpWindow').addClass('hidden'); 
					});
					
					var ieWarning = $('ieWarning');
					if (! isIE() && ieWarning) $('ieWarning').destroy();
					
				<% } else if (_logged && executeAction) { //parte de ejecución %>
					var sqlForm = $('sqlForm');
					if (sqlForm) {
						sqlForm.addEvent('submit', function() {
							$('sqlWait').removeClass('hidden');
							
							setInterval(function() {
								count++;
								$('sqlWait').innerHTML = 'loading... (' + count + ' sec)';
							}, 1000);
						});
					}
					
					$$('textarea').each(function(ele) {
						ele.addEvent('keyup', function() {
							var event = new DOMEvent(arguments[0].event);
							if (event.control && event.key == 'enter' ) {
								this.getParent('form').fireEvent('submit');
								this.getParent('form').submit();
							}
						});
					});
					
					$$('table.result').each(function(ele) {
						ele.addEvent('dblclick', function() {
							var body = document.body, range, sel;
					        if (document.createRange && window.getSelection) {
					            range = document.createRange();
					            sel = window.getSelection();
					            sel.removeAllRanges();
					            try {
					                range.selectNodeContents(this);
					                sel.addRange(range);
					            } catch (e) {
					                range.selectNode(this);
					                sel.addRange(range);
					            }
					        } else if (body.createTextRange) {
					            range = body.createTextRange();
					            range.moveToElementText(this);
					            range.select();
					        }
						});
					});
				<% } %>
			});
			
			window.addEvent('resize', function(){
			});
			
			<% if (_logged && ! executeAction) { //parte principal%>
				var windowCounter = 1;

				function fncBtnExecuteAction() {
					var connectionId = $('connectionId');
					var connectionAction = $('connectionAction');
					
					var windowNumber = windowCounter++;
					var src = connectionId.options[connectionId.selectedIndex].get('src');
					connectionId = connectionId.options[connectionId.selectedIndex].value;
					connectionAction = connectionAction.options[connectionAction.selectedIndex].value;
					
					var aditionalCss = (connectionAction == 'sql' || connectionAction == 'sql + info') ? ' windowExtended' : '';
					
					var theWindow = new Element('div', {'class': 'window' + aditionalCss}).inject($('workarea'));
					var theWindowContent = new Element('div.windowContent').inject(theWindow);
					var theWindowHeader = new Element('div.header').inject(theWindowContent);
					new Element('h3', {html: connectionId + " - " + connectionAction + " " + windowNumber}).inject(theWindowHeader);
					var theButtons = new Element('div.buttons').inject(theWindowHeader);
					new Element('div', {'class': 'button buttonReload', html: '[ r ]', title: 'restart'}).inject(theButtons).addEvent('click', fncButtonReload);
					new Element('div', {'class': 'button buttonExpand', html: '[ e ]', title: 'expand'}).inject(theButtons).addEvent('click', fncButtonExpand);
					new Element('div', {'class': 'button buttonCompress', html: '[ c ]', title: 'compress'}).inject(theButtons).addEvent('click', fncButtonCompress);
					var buttonMaximize = new Element('div', {'class': 'button buttonMaximize', html: '[ M ]', title: 'maximize'}).inject(theButtons).addEvent('click', fncButtonMaximize);
					new Element('div', {'class': 'button buttonMinimize', html: '[ m ]', title: 'minimize'}).inject(theButtons).addEvent('click', fncButtonMinimize);
					new Element('div', {'class': 'button buttonClose', html: '[ C ]', title: 'close'}).inject(theButtons).addEvent('click', fncButtonClose);
					
					if (new DOMEvent(arguments[0].event).shift) buttonMaximize.fireEvent('click');
					
					var url = document.URL;
					if (url.indexOf("?") != -1) url = url.substring(0, url.indexOf("?"));
					url += "?doExecution=true&connection=" + connectionId + "&action=" + connectionAction + "&src=" + src;
					
					theWindow.theIframe = new Element('iframe.content', {src: url}).inject(theWindowContent);
					$('getStarted').addClass('hidden');
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
					
					if (workArea.getChildren().length == 2) $('getStarted').removeClass('hidden');
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
			<% } else { //parte de ejecución%>
				
			<% } %>

		</script>
	</head>
	<body>
		<%@include file="_commonLogin.jsp" %>
		
		<% if (_logged) { 
			if (! executeAction) { //se tiene que mostrar el contenedor %>
			
				<div class="mainHeader">
					<div class="field"><span>Connection:</span><select name="connection" id="connectionId"><%
							
						for (String connection : new ConnectionHelperApia().getKeys()) { %> 
							<option value="<%= connection %>" src="apia"><%= connection %></option><% 
						} 
						
						if (BIConstants.BI_CORRECTLY_INSTALLED) {
							for (String connection : new ConnectionHelperBI().getKeys()) { %> 
								<option value="<%= connection %>" src="bi"><%= connection %></option><% 
							}
						} %>
					
					</select></div>
					<div class="field"><span>Action:</span><select name="action" id="connectionAction">
						<option>sql</option>
						<option>sql + info</option>
						<option>test</option>
						<option>info</option>
						<option>info timmed</option>
						<option>info + test</option>
						<option>size</option>
						<option>init</option>
					</select></div>
					<div class="field"><input type="button" value="Open window" id="btnExecuteAction"></div>
					<span class="field ieWarning" id="ieWarning">You are using Internet Explorer, experience may not be as desire.</span>
					<%@include file="_commonLogout.jsp" %>
					<a href="" class="right" id="help">[ help ]</a>
				</div>
				<div class="workarea" id="workarea">
					<div class="getStarted" id="getStarted">
						To start select a <b>Connection</b>, an <b>Action</b> and click in <b>Open window</b> or click <a herf="" id="help2"><b>here</b></a> to see the help screen.
					</div>
					<div class="window windowMaximized windowHelp hidden" id="helpWindow">
						<div class="windowContent" id="helpWindowContent">
							<div class="header">
								<h3>Help</h3>
								<div class="buttons">
									<div class="button" title="hide" id="helpWindowHide">[ H ]</div>
								</div>
							</div>
							<div class="content">
								<table>
									<tr>
										<td>
											<h3>Main options</h3>
											<ul>
												<li><b>Connection:</b> list all availbale connections pools, <b>Apia</b> and <b>BI</b> (if available).</li>
												<li><b>Action:</b> list all possible actions that can be done to the pools.</li>
												<li><b>Open window:</b> opens a new window with the selected <b>connection</b> and <b>action</b>. Actions <b>sql</b> and <b>sql + info</b> will be open <b>extended</b>. To open a new windows <b>maximized</b> hold down the <b>SHIFT</b> key and do click in <b>New window</b>.
													<ul>
														<li><b>r:</b> restart window content, like when opening the window again.</li>
														<li><b>e:</b> expand window content.</li>
														<li><b>c:</b> compress window content.</li>
														<li><b>M:</b> maximize window content.</li>
														<li><b>m:</b> minimize window content.</li>
														<li><b>C:</b> close window, a confirmation will not be ask.</li>
														<li><b>H:</b> hide content window.</li>
													</ul>
												</li>
											</ul>
										</td><td>
											<h3>Actions</h3>
											<ul>
												<li><b>sql:</b> allows to execute a SQL sentences and see the result. Use <b>CTRL + ENTER</b> to execute the SQL query. Doble click in the table result will select all the result; use <b>CTRL+C</b> to copy content to clipboard and <b>CTRL+V</b> in Excel to past the result. To execute multiple SQL sentence, end each sentence with <b>;--</b>.</li> 
												<li><b>sql + info:</b> like <b>sql</b> but it adds the information of <b>info</b>.</li>
												<li><b>test:</b> opens 5 connections and keeps them open for 2 seconds, then all 5 connections are close.</li> 
												<li><b>info:</b> shows information about the pool connection, such as:</li>
													<ul>
														<li>Minimum amount of connections that must be all time open.</li>
														<li>Maximim amount of connections that can be open.</li>
														<li>The timeout defined, before an error ocurrs while trying to open a connection.</li>
														<li>The number of actual active connections</li>
													</ul> 
												<li><b>info timmed:</b> like <b>info</b> but it will reload itself every 10 seconds.</li> 
												<li><b>info + test:</b> like <b>test</b> but adds the information of <b>info</b> when waiting the 2 seconds and after closing the connections.</li> 
												<li><b>size:</b> allows to change the size of the connection pool. It is require to set:
													<ul>
														<li><b>Min. size:</b> the minimum amount of connections to be open.</li>
														<li><b>Min. size:</b> the maximum amount of connections to open.</li>
														<li><b>Change:</b> will close the pool and open a new one. If system is stopped, all changes will be lost.</li>
													</ul>
												</li> 
												<li><b>init:</b> allows to close a connection pool and be reloaded. You will need to confirm the init before it is done.</li>
											</ul>
										</td>
									</tr>
								</table>
								<p class="disclaimer"><b>Apia Testpool 3.0</b> has been developed by STATUM for internal and support usage, it is not included as part of the <b>Apia</b> installation.</p>
							</div>
						</div>
					</div>
				</div>
			<%	
			} else { //se tiene que mostrar el resultado de una ejecución de algo
				boolean forApiaConnection = ! "bi".equals(request.getParameter("src"));
				String managerId = request.getParameter("connection");
				String action = request.getParameter("action");
				
				IConnectionHelper helper = (IConnectionHelper) (forApiaConnection ? new ConnectionHelperApia() : new ConnectionHelperBI());
				
				String htmlActionResult = "";
				
				if ("test".equals(action)) htmlActionResult = helper.test(managerId, 5, 2000, false);
				else if ("size".equals(action)) htmlActionResult = helper.size(managerId, request);
				else if ("init".equals(action)) htmlActionResult = helper.init(managerId, request, false);
				else if ("info".equals(action)) htmlActionResult = helper.info(managerId, false);
				else if ("info timmed".equals(action)) htmlActionResult = helper.info(managerId, true);
				else if ("info   test".equals(action)) htmlActionResult = helper.test(managerId, 5, 2000, true);
				else if ("sql".equals(action)) htmlActionResult = helper.sql(managerId, request, false);
				else if ("sql   info".equals(action)) htmlActionResult = helper.sql(managerId, request, true);
				else if ("sql + info".equals(action)) htmlActionResult = helper.sql(managerId, request, true);
				else htmlActionResult = action;
				
				%>
				<%= htmlActionResult %><%
			}
		} %>
	</body>
</html>