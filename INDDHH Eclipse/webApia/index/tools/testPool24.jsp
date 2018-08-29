<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.logger.FileLogger"%>
<%@page import="com.st.util.logger.Logger"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="com.dogma.dao.DbConnectionDAO"%>
<%@page import="com.dogma.vo.DbConnectionVo"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="com.dogma.dao.EnvironmentDAO"%>
<%@page import="com.dogma.vo.EnvironmentVo"%>
<%@page import="com.dogma.dao.ProcessDAO"%>
<%@page import="com.dogma.dao.ProInstanceDAO"%>
<%@page import="com.dogma.dataAccess.DBManagerUtil"%><html>
<head>
	<title>PoolTest 2</title>
	<style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
		
		table.conns									{ border-width: 0px; background-color: #FFFFFF; }
		table.conns	thead tr th						{ background-color: #EEEEEE; border-width: 1px; border-color: #EEEEEE; border-style: solid; }
		table.conns	thead tr th:hover				{ background-color: #EEEEEE; background-color: #DDDDDD; border-color: #DDDDDD; }
		table.conns	thead tr th.noHover:hover		{ background-color: #EEEEEE; background-color: #EEEEEE; }
		table.conns tbody tr td				 		{ border-color: #FFFFFF; border-style: solid; border-width: thin; padding: 1px; }
		table.conns tbody tr:hover 					{ background-color: #EEEEEE; }
		table.conns tbody tr:hover td				{ border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td:hover 		{ background-color: #DDDDDD; border-color: #DDDDDD; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.noHover:hover { background-color: #EEEEEE; border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.bold			{ font-weight: bold; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		
		table.sql 									{ border-width: 0px; background-color: #FFFFFF; }
		table.sql thead th							{ border-style: solid; border-color: #000000; border-width: thin; background-color: #DDDDDD; font-weight: bold; text-align: center; }
		table.sql tbody td							{ border-style: solid; border-color: #DDDDDD; border-width: thin; white-space: nowrap; padding-left: 2px; padding-right: 5px; }
		table.sql thead tr th						{ border-style: solid; border-color: #DDDDDD; border-width: thin; }
		table.sql tbody tr:hover 					{ background-color: #DDDDDD; }
		table.sql tbody tr:hover td.noHover:hover	{ background-color: #FFFFFF; border-color: #FFFFFF; }
		table.sql tbody tr td.noHover				{ background-color: #FFFFFF; border-color: #FFFFFF; }
		
		a			{ text-decoration: none; color: blue; }
	</style>
</head>
<body>

<%! 

private static Logger logger = null;

static {
	Map map = new HashMap();
	map.put(FileLogger.PARAMETER_DIRECTORY,Parameters.LOG_DIRECTORY);
	map.put(FileLogger.PARAMETER_DISPLAY_TIME,Parameters.LOG_SHOW_TIME);
	map.put(FileLogger.PARAMETER_PREFIX,"LOG_TEST_POOL2");
	map.put(FileLogger.PARAMETER_SUFFIX,".log");
	map.put(FileLogger.PARAMETER_PERIODICITY,"Daily");
	logger = new FileLogger(true,map);
}

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class Test extends DBAdmin {
	
	protected String generateText(String txt) {
		if (logger != null) logger.log(txt.replaceAll("\\<.*?\\>",""));
		return System.currentTimeMillis() + ": " + txt + "<br>";
	}

	protected String generateStart(String test) {
		long start = System.currentTimeMillis();
		if (logger != null) logger.log("Method " + test + " started");
		return start + ": Method <b>" + test + "</b> started at: " + new java.util.Date(start) + " (server time)<br>";
	}
	
	protected String generateEnd(String test) {
		long start = System.currentTimeMillis();
		if (logger != null) logger.log("Method " + test + " ended");
		return start + ": Method <b>" + test + "</b> ended at: " + new java.util.Date(start) + " (server time)<br><br>";
	}
	
	public String size(String name, String min, String max) {
		StringBuffer buffer = new StringBuffer();
		if (name != null && DBAdmin.DOGMA_MANAGER_ID.equals(name)) {
			
			if (min == null) min = "";
			if (max == null) max = "";
			
			buffer.append("<form action=\"?size=" + name + "\" method=\"post\">");
			buffer.append("<b>Min. size:</b> <input type=\"text\" name=\"min\" value=\"" + min + "\"><br>");
			buffer.append("<b>Max. size:</b> <input type=\"text\" name=\"max\" value=\"" + max + "\"><br>");
			buffer.append("<input type=\"submit\" value=\"Change\">");
			buffer.append("</form>");
			
			buffer.append(this.info(name,false));

			if ((min != null && min.length() > 0) || (max != null && max.length() > 0)) {
				buffer.append(this.init(name));
				buffer.append("<br>");
				Integer maxCon = null;
				Integer minCon = null;
				try {minCon = Integer.valueOf(min); } catch (Exception e) {}
				try {maxCon = Integer.valueOf(max); } catch (Exception e) {}
				
				buffer.append(this.generateText("Createing new <b>DOGMA_MANAGER</b> pool"));
				
				try {
					DBManagerUtil.getApiaConnection(DBAdmin.DOGMA_MANAGER_ID,
							Configuration.DB_USR,
							Configuration.DB_PWD,
							Configuration.DB_URL,
							(minCon == null) ? Configuration.DB_MIN_CONNECTIONS : minCon.intValue(),
							(maxCon == null) ? Configuration.DB_MAX_IDLE_CONNECTIONS : maxCon.intValue(),
							(maxCon == null) ? Configuration.DB_MAX_IDLE_CONNECTIONS : maxCon.intValue(),
							Configuration.DB_MAX_WAIT_TIME_MILISEC);
				} catch (Exception e) {
					buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
				}
				buffer.append(this.info(name,false));
			}
		}
		return buffer.toString();
	}
	
	public String info(String name, boolean timed) {
		StringBuffer buffer = new StringBuffer();
		if (name != null && ! "".equals(name)) {
	
			DBConnViewer conView = new DBConnViewer();
			Collection col = conView.getAllPoolInfo();
			
			if (col != null) {
				buffer.append(this.generateStart("Information"));
				for (Iterator it = col.iterator(); it.hasNext();) {
					DBConnViewer.PoolInfo pool = (DBConnViewer.PoolInfo) it.next();
					if ("all".equals(name) || name.equals(pool.name)) {
						buffer.append(this.generateText("Information for pool: <b>" + pool.name + "</b>"));
						buffer.append(this.generateText("Min-Max connections: <b>" + pool.minCon + "</b> - <b>" + pool.maxCon + "</b>"));
						buffer.append(this.generateText("Timeout: <b>" + pool.timeout + "</b>"));
						buffer.append(this.generateText("Actual connections: <b>" + pool.actCon + "</b>"));
					}
					if ("all".equals(name)) buffer.append("<br>");
				}
				
				if (timed) {
					buffer.append(this.generateText("Automatic refresh in: <b>10000 milisec</b>"));
					buffer.append("<script language=\"javascript\">function func() {document.location=\"?infoTimedManagerId=" + name + "\";}setTimeout( func , 10000 );</script>");
				}
				
				buffer.append(this.generateEnd("Information"));
			}
		}
		return buffer.toString();
	}
	
	public String start(String step, String strEnvId, String strPoolId) {
		StringBuffer buffer = new StringBuffer();
		
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = null;
		if (step != null) {
			try {
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Collection cons = EnvironmentDAO.getInstance().getAllEnvs(dbConn);
				
				buffer.append("<form action=\"?start=pool\" method=\"post\"><b>Environment</b>: <select name=\"envId\">"); 
				for (Iterator it = cons.iterator(); it.hasNext(); ) { 
					EnvironmentVo envVo = (EnvironmentVo) it.next();
					buffer.append("<option value=\"" + envVo.getEnvId() + "\" " + (envVo.getEnvId().toString().equals(strEnvId)?"selected":"") + ">" + envVo.getEnvName() + "</option>");
				}
				buffer.append("</select> ");
				buffer.append("<input type=\"submit\" value=\"List\"> </form>");
			} catch (Exception e) {
				buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
			} finally {
				DBManagerUtil.close(dbConn);
			}
		}
		
		Collection cons = null;
		StringBuffer bufferAux = new StringBuffer();
		
		if (step != null && strEnvId != null) {
			try {
				dbConn =  manager.getConnection(null,null,null,0,0,0,0);
				cons = DbConnectionDAO.getInstance().getEnvDbConns(dbConn, new Integer(strEnvId));
				
				for (Iterator it = cons.iterator(); it.hasNext(); ) { 
					DbConnectionVo dbConVo = (DbConnectionVo) it.next();
					String managerId = "";
					if(DbConnectionVo.TYPE_ORACLE.equals(dbConVo.getDbConType())){
						managerId = Configuration.ORACLE + "·" + dbConVo.getDbConId();
					}
					if(DbConnectionVo.TYPE_POSTGRE.equals(dbConVo.getDbConType())){
						managerId = Configuration.POSTGRE + "·" + dbConVo.getDbConId();
					}
					if(DbConnectionVo.TYPE_SQLSERVER.equals(dbConVo.getDbConType())){
						managerId = Configuration.SQLSERVER + "·" + dbConVo.getDbConId();
					}
					
					if ((! managersMap.containsKey(managerId)) && ("all".equals(strPoolId) || dbConVo.getDbConId().toString().equals(strPoolId))) {
						bufferAux.append(this.generateText("Starting pool <b>" + dbConVo.getDbConName() + " (" + managerId + ")</b>"));
						try {
							DBManagerUtil.getApiaConnection(managerId,
									dbConVo.getDbConUser(),
									dbConVo.getDbConPassword(),
									dbConVo.getDbConString(),
									dbConVo.getDbConMinCon().intValue(),
									dbConVo.getDbConMaxCon().intValue(),
									dbConVo.getDbConIdleCon().intValue(),
									dbConVo.getDbConWaitCon().intValue());
							bufferAux.append(this.generateText("Pool started <b>" + dbConVo.getDbConName() + " (" + dbConVo.getDbConId() + ")</b>"));
							bufferAux.append(this.generateText("Pool min connections <b>" + dbConVo.getDbConMinCon().intValue() + "</b>"));
							bufferAux.append(this.generateText("Pool max connections <b>" + dbConVo.getDbConMaxCon().intValue() + "</b>"));
							bufferAux.append(this.generateText("Pool idle connections <b>" + dbConVo.getDbConIdleCon().intValue() + "</b>"));
							bufferAux.append(this.generateText("Pool wait connections <b>" + dbConVo.getDbConWaitCon().intValue() + "</b>"));
						} catch (Exception e) {
							bufferAux.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
							Object obj = managersMap.remove(managerId);
							boolean error = false;
							bufferAux.append(this.generateText("Initializeing pool <b>" + dbConVo.getDbConName() + " (" + dbConVo.getDbConId() + ")</b>"));
							if (obj instanceof DBManagerDBCP) {
								try {
									bufferAux.append(this.generateText("Closeing pool connections"));
									((DBManagerDBCP) obj).shutdown();
									bufferAux.append(this.generateText("Pool connections closed"));
								} catch (Exception ee) {
									error = true;
									bufferAux.append(this.generateText("<b>Error: " + ee.getMessage() + "</b>"));
								}
							}
							if (! error) bufferAux.append(this.generateText("Pool <b>" + dbConVo.getDbConName() + " (" + dbConVo.getDbConId() + ")</b> initialized"));
						}
					}
				}
				
				buffer.append("<form action=\"?start=pool\" method=\"post\"><b>Connection</b>: <input type=\"hidden\" name=\"envId\" value=\"" + strEnvId + "\"> <select name=\"poolId\">");
				buffer.append("<option value=\"all\">ALL</option>");
				for (Iterator it = cons.iterator(); it.hasNext(); ) { 
					DbConnectionVo dbConVo = (DbConnectionVo) it.next();
					String managerId = "";
					if(DbConnectionVo.TYPE_ORACLE.equals(dbConVo.getDbConType())){
						managerId = Configuration.ORACLE + "·" + dbConVo.getDbConId();
					}
					if(DbConnectionVo.TYPE_POSTGRE.equals(dbConVo.getDbConType())){
						managerId = Configuration.POSTGRE + "·" + dbConVo.getDbConId();
					}
					if(DbConnectionVo.TYPE_SQLSERVER.equals(dbConVo.getDbConType())){
						managerId = Configuration.SQLSERVER + "·" + dbConVo.getDbConId();
					}
					
					if (! managersMap.containsKey(managerId)) {
						buffer.append("<option value=\"" + dbConVo.getDbConId() + "\"" + (dbConVo.getDbConId().toString().equals(strPoolId)?"selected":"") + ">" + dbConVo.getDbConName() + " (" + managerId + ")</option>");
					}
				}
				buffer.append("</select> ");
				buffer.append("<input type=\"submit\" value=\"Start\"> </form>");
			} catch (Exception e) {
				buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
			} finally {
				DBManagerUtil.close(dbConn);
				buffer.append(bufferAux.toString());
			}
		}
		
		return buffer.toString();
	}
	
	public String init(String name) {
		StringBuffer buffer = new StringBuffer();
		if (name != null) {
			Collection toInit = new ArrayList();
			for (Iterator it = managersMap.keySet().iterator(); it.hasNext(); ) {
				Object key = it.next();
				if (name.equals(key) || ("all".equals(name) && ! "DOGMA_MANAGER".equals(key))) {
					toInit.add(key);
				}
			}

			if (toInit.size() > 0) {
				for (Iterator it = toInit.iterator(); it.hasNext(); ) {
					Object key = it.next();
					Object obj = managersMap.remove(key);
					boolean error = false;
					buffer.append(this.generateText("Initializeing pool <b>" + key.toString() + "</b>"));
					if (obj instanceof DBManagerDBCP) {
						try {
							buffer.append(this.generateText("Closeing pool connections"));
							((DBManagerDBCP) obj).shutdown();
							buffer.append(this.generateText("Pool connections closed"));
						} catch (Exception e) {
							error = true;
							buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
						}
					}
					if (! error) {
						buffer.append(this.generateText("Pool <b>" + key.toString() + "</b> initialized"));
					}
				}
			} else {
				if ("all".equals(name)) {
					buffer.append(this.generateText("No pools to initialize"));
				} else {
					buffer.append(this.generateText("Pool <b>" + name + "</b> not found"));
				} 
			}
		}
		return buffer.toString();
	}
	
	public Iterator getKeys() {
		return managersMap.keySet().iterator();
	}
	
	public String test(String name, String info, int numCon, int timeSleep) {
		StringBuffer buffer = new StringBuffer();
		if (name != null) {
			
			if ("all".equals(name)) {
				Test test = new Test();
				for (Iterator it = test.getKeys(); it.hasNext(); ) { 
					Object obj = it.next();
					buffer.append(this.test((String) obj, info,2,1000));
					if (it.hasNext()) buffer.append("<hr><br>");
				}
			
			} else {
				buffer.append(this.generateStart("Test pool connection"));
				buffer.append(this.generateText("Testing: <b>" + name + "</b>"));
				buffer.append(this.generateText("Getting pool: " + name));
				DBManager manager = (DBManager) managersMap.get(name);
	
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
						buffer.append(this.generateText("Sleeping for <b>" + timeSleep + " milisec</b>"));
						buffer.append("<br>");
						buffer.append(this.info(info, false));

						try {
							Thread.sleep(timeSleep);
						} catch (Exception e) {
						} finally {
							buffer.append(this.generateText("Sleep end"));
						}
						
						buffer.append("<br>");
						buffer.append(this.info(info, false));
						
					} catch (Exception e) {
						buffer.append(this.generateText("<b>Error: " + e.getMessage() + "</b>"));
					} finally {
						for (int i = 0; i < dbConns.length; i++) {
							if (dbConns[i] != null) {
								buffer.append(this.generateText("Closeing connection " + (i+1) + "..."));
								long start = System.currentTimeMillis();
								DBManagerUtil.close(dbConns[i]);
								long end = System.currentTimeMillis();
								buffer.append(this.generateText("Closed in: <b>" + (end-start) + " milisec</b>")	);
							}
						}
						
						buffer.append("<br>");
						buffer.append(this.info(info, false));
					}
				}
				buffer.append(this.generateEnd("Test pool connection"));
			}
		}
		
		return buffer.toString();
	}
	
	public String sql1(String name, String sql, int maxToShow, String createVo) {
		StringBuffer buffer = new StringBuffer();
		
		if (sql == null) sql = "";
		
		if (name != null) {
			buffer.append("<form action=\"?\" method=\"post\" id=\"sqlForm\"><b>SQL for</b>: <select name=\"sqlManagerId\">"); 
			for (Iterator it = this.getKeys(); it.hasNext(); ) { 
				Object obj = it.next();
				buffer.append("<option value=\"" + obj + "\" " + (name.equals(obj)?"selected":"") + ">" + obj + "</option>");
			}
			buffer.append("</select> ");
			buffer.append("Show: <input type=\"input\" size=\"4\" name=\"maxToShow\" id=\"maxToShow\" size=\"20\" value=\"" + maxToShow + "\"> ");
			buffer.append("Try create: <select name=\"createVo\">");
			buffer.append("<option value=''></option>");
			buffer.append("<option value='ProcessVo' " + ("ProcessVo".equals(createVo) ? "selected": "") + ">ProcessVo</option>");
			buffer.append("<option value='ProInstanceVo' " + ("ProInstanceVo".equals(createVo) ? "selected": "") + ">ProInstanceVo</option>");
			buffer.append("</select><br>");
			buffer.append("SQL: <textarea cols=80 rows=10 name=\"sql\">" + sql + "</textarea><br>");
			buffer.append("<input type=\"submit\"> ");
			buffer.append("<input type=\"checkbox\" name=\"doCommit\" value=\"true\">Try to do commit ");
			buffer.append("</form>");
		}
		
		return buffer.toString();
	}
	
	public String infoSql1(String name, String sql, int maxToShow) {
		StringBuffer buffer = new StringBuffer();

		if (sql == null) sql = "";
		
		if (name != null) {
			buffer.append("<form action=\"?\"><b>SQL for</b>: <select name=\"infoSqlManagerId\">"); 
			for (Iterator it = this.getKeys(); it.hasNext(); ) { 
				Object obj = it.next();
				buffer.append("<option value=\"" + obj + "\" " + (name.equals(obj)?"selected":"") + ">" + obj + "</option>");
			}
			buffer.append("</select>");
			buffer.append("Show: <input type=\"input\" name=\"maxToShow\" size=\"20\" value=\"" + maxToShow + "\"> (default = 20)<br>");
			buffer.append("SQL: <textarea cols=80 rows=10 name=\"sql\">" + sql + "</textarea><br>");
			buffer.append("<input type=\"submit\"> </form>");
		}
		
		return buffer.toString();
	}
	
	
	public String poolConnectionTest(String doTest, HttpServletRequest request) {
		StringBuffer buffer = new StringBuffer();
		
		if (doTest != null) {
			String dbType = request.getParameter("dbType");
			String dbUrl  = request.getParameter("dbUrl");
			String dbUser = request.getParameter("dbUser");
			String dbPwd  = request.getParameter("dbPwd");
			String refreshTime = request.getParameter("refreshTime");

			buffer.append("<form action=\"?\">");
			buffer.append("<table>");
			buffer.append("<b>Driver:</b> <select name=\"dbType\"><option value=\"\"></option>");
			buffer.append("<option value=\"oracle\" " + ("oracle".equals(dbType)?"selected":"") + ">oracle</option>");
			buffer.append("<option value=\"postgresql\" " + ("postgresql".equals(dbType)?"selected":"") + ">postgresql</option>");
			buffer.append("<option value=\"sqlserver\" " + ("sqlserver".equals(dbType)?"selected":"") + ">sqlserver</option>");
			buffer.append("</select><br>");
			buffer.append("Url: <input type=\"text\" name=\"dbUrl\" size=\"80\" value=\"" + ((dbUrl == null)?"":dbUrl) + "\"><br>");
			buffer.append("User: <input type=\"text\" name=\"dbUser\" value=\"" + ((dbUser == null)?"":dbUser) +"\"><br>");
			buffer.append("Password: <input type=\"text\" name=\"dbPwd\" value=\"" + ((dbPwd == null)?"":dbPwd) + "\"><br>");
			buffer.append("<input type=\"hidden\" name=\"poolConnectionTest\" value=\"true\">");
			buffer.append("<input type=\"submit\" value=\"Test connection\">");
			buffer.append("</form>");

			if (dbType != null && ! "".equals(dbType)) {
				buffer.append(this.generateStart("Pool connection test"));
				
				buffer.append(this.generateText("Type: <b>" + dbType + "</b>"));
				buffer.append(this.generateText("Url: <b>" + dbUrl + "</b>"));
				buffer.append(this.generateText("User: <b>" + dbUser + "</b>"));
				buffer.append(this.generateText("Pwd: <b>" + dbPwd + "</b>"));
				buffer.append("<br>");
				try {
					String driverClassName = null;
					
					if ("postgresql".equals(dbType)) { driverClassName = "org.postgresql.Driver";
					} else if ("sqlserver".equals(dbType)) { driverClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
					} else if ("oracle".equals(dbType)) { driverClassName = "oracle.jdbc.driver.OracleDriver"; }
					
					buffer.append(this.generateText("<b>Driver...</b>"));
					java.sql.Driver driver = (java.sql.Driver) Class.forName(driverClassName).newInstance();
					buffer.append(this.generateText("<b>Connection...</b>"));
					java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl,dbUser,dbPwd);
					buffer.append(this.generateText("<b>Close...</b>"));
					conn.close(); 
				} catch (Exception e) {
					buffer.append(this.generateText("<b>Error:</b>"));
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<pre>" + bout.toString() + "</pre>");
				}
				buffer.append(this.generateEnd("Pool connection test"));
			}
		}

		return buffer.toString();
	}
	
	public String infoSql2(String name, String sql, int maxToShow, String createVoClass, boolean doCommit) {
		StringBuffer buffer = new StringBuffer();
		
		buffer.append(this.info(name,false));
		buffer.append(this.sql2(name,sql,maxToShow, createVoClass, doCommit));
		
		return buffer.toString();
	}
	
	public String sql2(String name, String sql, int maxToShow, String createVoClass, boolean doCommit) {
		StringBuffer buffer = new StringBuffer();
		
		if (name != null && sql != null && ! "".equals(sql)) {
			buffer.append(this.generateStart("Sql test"));
			buffer.append(this.generateText("Testing sql on: <b>" + name + "</b>"));
			buffer.append(this.generateText("Sql: <b>" + sql + "</b>"));
			buffer.append(this.generateText("Getting pool: " + name));
			DBManager manager = (DBManager) managersMap.get(name);
			if (manager == null) {
				buffer.append(this.generateText("Pool not present"));
			} else {
				ConnectionGetter conGetter = new ConnectionGetter();
			
				DBConnection dbConn = null;
				try {
					buffer.append(this.generateText("Getting connection"));
					long start = System.currentTimeMillis();
					dbConn = manager.getConnection(null,null,null,0,0,0,0);
					long end = System.currentTimeMillis();
					buffer.append(this.generateText("Connection recived in: <b>" + (end-start) + " milisec</b>"));
					Connection conn = conGetter.getDBConnection2(dbConn);
					buffer.append(this.generateText("Connection ok: <b>" + (!conn.isClosed()) + "</b>"));
					if (!conn.isClosed()) {
						buffer.append(this.generateText("Createing statement"));
						PreparedStatement statement = StatementFactory.getStatement(conn,sql,false);
						buffer.append(this.generateText("Executeing statement"));
						boolean executedOK = false;
						boolean selectSql = sql.toLowerCase().startsWith("select ");
						ResultSet resultSet = null;
						start = System.currentTimeMillis();
						// statement.setFetchSize(50);
						if (selectSql) {
							resultSet = statement.executeQuery();
							executedOK = true;
						} else {
							executedOK = statement.execute();
						}
						end = System.currentTimeMillis();
						buffer.append(this.generateText("Statement executed: <b>" + executedOK + "</b> in: <b>" + (end-start) + " milisec</b>"));
						buffer.append(this.generateText("Fetch size: <b>" + statement.getFetchSize() + "</b> - <b>" + ((resultSet != null) ? resultSet.getFetchSize() : -1) + "</b>"));
						if (selectSql) {
							buffer.append(this.generateText("Loading select result (max: <b>" + maxToShow + "</b>)..."));
							start = System.currentTimeMillis();
							StringBuffer sqlResult = new StringBuffer();
							ResultSetMetaData rsmd = resultSet.getMetaData();
							
							sqlResult.append("<br><table cellpading=0 cellspacing=0 class=sql>");
							sqlResult.append("<thead>");
							sqlResult.append("<tr>");

							boolean createVo = (createVoClass != null && createVoClass.length() > 0);
				     		
							if (createVo) {
								sqlResult.append("<th>Create Vo</th>");
							}
							
							for (int i = 0; i < rsmd.getColumnCount(); i++) {
				     			sqlResult.append("<th>" + rsmd.getColumnName(i+1) + "</th>");
				     		}
				     		sqlResult.append("</tr>");
				     		sqlResult.append("</thead>");
				     		int cantReg = 0;
				     		sqlResult.append("<body>");
				     		
				     		
				     		while (cantReg < maxToShow && resultSet.next()) {
				     			sqlResult.append("<tr>");

				     			boolean createVoResult = false;
				     			if (createVo) {
				     				try {
				     					if ("ProcessVo".equals(createVoClass)) {
				     						ProcessDAO.getInstance().createVo(dbConn,resultSet);
				     						createVoResult = true;
				     					} else if ("ProInstanceVo".equals(createVoClass)) {
				     						ProInstanceDAO.getInstance().createVo(dbConn,resultSet);
				     						createVoResult = true;
				     					}
				     				} catch (Exception e) {
				     					createVoResult = false;
				     				}
				     			}
				     			
				     			if (createVo) sqlResult.append("<td>" + createVoResult + "</td>");
				     			
				     			for (int i = 0; i < rsmd.getColumnCount(); i++) {
				     				sqlResult.append("<td>" + resultSet.getObject(i+1) + "</td>");
				     			}	
				     			sqlResult.append("</tr>");
				     			cantReg++;
				     		}
				     		boolean addPoints = false;
				     		while (resultSet.next()) {
				     			addPoints = true;
				     			cantReg++;
				     		}
			     			if (addPoints) {
			     				maxToShow = maxToShow * 2;
			     				if (maxToShow > cantReg) maxToShow = cantReg;
			     				sqlResult.append("<tr><td colspan=" + rsmd.getColumnCount() + " class=noHover>... (<a href=\"#\" onclick=\"document.getElementById('maxToShow').value = " + maxToShow + "; document.getElementById('sqlForm').submit(); return false;\">Show " + maxToShow + "</a>)</td></tr>");
			     			}
				     		sqlResult.append("<tr><td colspan=" + rsmd.getColumnCount() + " class=noHover>Total reg: <b>" + cantReg + "</b></td></tr>");
							sqlResult.append("</tbody></table><br>");
				     		
							end = System.currentTimeMillis();
							
							buffer.append(sqlResult.toString());
							buffer.append(this.generateText("Select result loaded in: <b>" + (end - start) + " milisec</b>"));
						} else {
							buffer.append(this.generateText("Sql select information not available"));
						}
						buffer.append(this.generateText("Closeing statement"));
						statement.close();
						
						if (!selectSql) {
							if (doCommit) {
								buffer.append(this.generateText("<b>Commit connection</b>"));
								DBManagerUtil.commit(dbConn);
							} else {
								buffer.append(this.generateText("<b>Commiti not supported</b>"));
							}
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
						buffer.append(this.generateText("Closeing connection"));
						long start = System.currentTimeMillis();
						try { DBManagerUtil.rollback(dbConn); } catch (Exception e) {}
						DBManagerUtil.close(dbConn);
						long end = System.currentTimeMillis();
						buffer.append(this.generateText("Closed in: " + (end-start) + " milisec"));
					}
				}
			}
			buffer.append(this.generateEnd("Sql test"));
		}
		
		return buffer.toString();
	}

	public String dateFormate() {
		return new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	}
} 


%>

<% 

Object paramLogged = request.getSession().getAttribute("logged");
Boolean logged = null;
if (paramLogged instanceof Boolean) logged = (Boolean) paramLogged;

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}

Test test = new Test();
StringBuffer resultExecution = new StringBuffer();
if (logged.booleanValue()) {
	int maxToShow = 20;
	try {
		maxToShow = Integer.parseInt(request.getParameter("maxToShow")); 
	} catch (Exception e) {
	}
	
	resultExecution.append(test.start(request.getParameter("start"),request.getParameter("envId"),request.getParameter("poolId")));
	resultExecution.append(test.init(request.getParameter("initManagerId")));
	resultExecution.append(test.info(request.getParameter("infoManagerId"),false));
	resultExecution.append(test.info(request.getParameter("infoTimedManagerId"),true));
	resultExecution.append(test.test(request.getParameter("testManagerId"),request.getParameter("infoManagerId"),5,2000));
	resultExecution.append(test.sql1(request.getParameter("sqlManagerId"),request.getParameter("sql"),maxToShow,request.getParameter("createVo")));
	resultExecution.append(test.sql2(request.getParameter("sqlManagerId"),request.getParameter("sql"),maxToShow,request.getParameter("createVo"),"true".equals(request.getParameter("doCommit"))));
	resultExecution.append(test.infoSql1(request.getParameter("infoSqlManagerId"),request.getParameter("sql"),maxToShow));
	resultExecution.append(test.infoSql2(request.getParameter("infoSqlManagerId"),request.getParameter("sql"),maxToShow,request.getParameter("createVo"),"true".equals(request.getParameter("doCommit"))));
	resultExecution.append(test.poolConnectionTest(request.getParameter("poolConnectionTest"),request));
	resultExecution.append(test.size(request.getParameter("size"),request.getParameter("min"),request.getParameter("max")));
}
%>

<html>
<head>
</head>
<body>
<% if (logged.booleanValue()) { %>
<table border="1" cellpadding="10" cellspacing="0" height="99%" style="max-height: 99%; "><tr><td valign="top" height="100%">
	<div style="float: left;">
	<center><b>User Options</b></center>
	<center><a href="?">Refresh</a> | <a href="?logout=yes">Logout</a></center>
	<br>
	</div>

	<div>
	<center><b>Global Pool Options</b></center>
	<center>
		<a href="?start=list">Start</a> |
		<a href="?initManagerId=all" title="init">init</a> |
		<a href="?testManagerId=all" title="test all">test</a> |
		<a href="?infoManagerId=all" title="info all">info</a> |
		<a href="?infoTimedManagerId=all" title="info timed all">info T</a>
	</center>
	<br>
	</div>

	<center><b>Database pools</b></center>
	<div style="height: 200px; overflow: auto;">
	<table class="conns" cellpadding="0" cellspacing="0">
		<tbody><%
			int count = 0;
			for (Iterator it = test.getKeys(); it.hasNext(); ) { 
				Object obj = it.next(); 
				count ++;%>
				<tr>
					<td style="white-space: nowrap;" class="bold noHover" width="120px"><%= obj %></td>
					<td style="white-space: nowrap;">
						<% if (! "DOGMA_MANAGER".equals(obj)) { %>
							<a href="?initManagerId=<%= obj %>" title="init">init</a>
						<% } else { %>
							<a href="?size=<%= obj %>" title="size">size</a>
						<% } %></td>
					<td style="white-space: nowrap;"><a href="?testManagerId=<%= obj %>" title="test">test</a></td>
					<td style="white-space: nowrap;"><a href="?infoManagerId=<%= obj %>" title="info">info</a></td>
					<td style="white-space: nowrap;"><a href="?infoTimedManagerId=<%= obj %>" title="info timed">info T</a></td>
					<td style="white-space: nowrap;"><a href="?infoManagerId=<%= obj %>&testManagerId=<%= obj %>" title="info + test">info+test</a></td>
					<td style="white-space: nowrap;"><a href="?sqlManagerId=<%= obj %>" title="sql">sql</a></td>
					<td style="white-space: nowrap;"><a href="?infoSqlManagerId=<%= obj %>" title="info + sql">info+sql</a></td>
				</tr><% 
			} %>
		</tbody>
	</table></div>
	Total pools: <b><%= count %>
	<br>

	<center><b>Tools</b></center>
	<a href="?poolConnectionTest=true" title="test all">Pool connection test</a><br>
	Log location: <b><%= Parameters.LOG_DIRECTORY + File.separator%>LOG_TEST_POOL2.<%= test.dateFormate() %>.log</b><br>
	<br>

	<div style="height: 200px; overflow: auto;"><jsp:include page="testPool2Info.txt"></jsp:include></div>
	
	<center><b>Information</b></center>
	Version: <b>1.7.2009.10.17 (designed for FF)</b><br>

	</td><td valign="top" width="600px" height="100%"><div style="overflow: auto; white-space: nowrap; width: 600px; height: 100%"><%= resultExecution.toString() %></div></td></tr></table>
<% } else { %>
	<form action="" method="post">
		<b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br>
		<input type="submit" value="Login">
	</form>
<% } %>
</body>
</html>