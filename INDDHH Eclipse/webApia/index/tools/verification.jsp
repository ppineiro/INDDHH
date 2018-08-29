<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="com.dogma.BIParameters"%>
<%@page import="com.dogma.dao.gen.GenericDAO"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.DogmaConstants"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.io.File"%>
<%@page import="com.st.util.FileUtil"%>
<%@page import="com.dogma.util.DogmaUtil"%>
<%@page import="com.st.util.email.EmailData"%>
<%@page import="java.util.Collection"%>
<%@page import="org.netbeans.lib.cvsclient.connection.PServerConnection"%>
<%@page import="org.netbeans.lib.cvsclient.connection.StandardScrambler"%>
<%@page import="org.netbeans.lib.cvsclient.admin.StandardAdminHandler"%>
<%@page import="org.netbeans.lib.cvsclient.Client"%>
<%@page import="org.netbeans.lib.cvsclient.commandLine.BasicListener"%>
<%@page import="org.netbeans.lib.cvsclient.command.update.UpdateCommand"%>
<%@page import="org.netbeans.lib.cvsclient.command.add.AddCommand"%>
<%@page import="org.netbeans.lib.cvsclient.command.GlobalOptions"%>
<%@page import="org.netbeans.lib.cvsclient.command.commit.CommitCommand"%>
<%@page import="org.netbeans.lib.cvsclient.command.commit.CommitBuilder"%>
<%@page import="org.netbeans.lib.cvsclient.command.remove.RemoveCommand"%>
<%@page import="com.dogma.dao.DbDocumentDAO"%>
<%@page import="com.st.db.dataAccess.BIDBAdmin"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.dogma.dataAccess.DogmaDBManager"%>
<%@page import="com.dogma.dataAccess.BIDBManager"%>

<%!

public static class Util {

	protected static class ConnectionGetter extends ConnectionDAO {
		public Connection getDBConnection2(DBConnection dbConn) {
			return ConnectionDAO.getDBConnection(dbConn);
		}
	}

	public static String verifyAConnection(String dbType, String dbUrl, String dbUser, String dbPwd, boolean showErrorCodes) {
		StringBuffer buffer = new StringBuffer();
		
		String driverClassName = null;
		
		boolean doVerification = dbType != null && dbUrl != null && dbUser != null && dbPwd != null;
		
		if (dbType == null)	buffer.append(showErrorCodes ? "1021" : "<dic class=error>Database implementation type is not defined</div>");
		if (dbUrl == null)	buffer.append(showErrorCodes ? "1022" : "<div class=error>Database URL is not defined</div>");
		if (dbUser == null)	buffer.append(showErrorCodes ? "1023" : "<div class=error>Database user is not defined</div>");
		if (dbPwd == null)	buffer.append(showErrorCodes ? "1024" : "<div class=error>Database user password is not defined</div>");
		
		if (doVerification) {
			if ("postgres".equalsIgnoreCase(dbType)) { driverClassName = "org.postgresql.Driver";
			} else if ("sqlserver".equalsIgnoreCase(dbType)) { driverClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
			} else if ("oracle".equalsIgnoreCase(dbType)) { driverClassName = "oracle.jdbc.driver.OracleDriver"; }
			
			try {
				java.sql.Driver driver = (java.sql.Driver) Class.forName(driverClassName).newInstance();
				java.sql.Connection conn = java.sql.DriverManager.getConnection(dbUrl,dbUser,dbPwd);
				conn.close();
				buffer.append(showErrorCodes ? "0" : "<div class=ok>ok</div>");
			} catch (Exception e) {
				buffer.append(showErrorCodes ? "1001" : "<div class=error>Error found: " + e.getMessage() + "</div>");
				
				if (! showErrorCodes) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			}
			if (! showErrorCodes) {
				buffer.append("<div class=information>Db type: " + dbType + "<br>");
				buffer.append("Url: " + dbUrl + "<br>");
				buffer.append("User: " + dbUser + "<br>");
				buffer.append("Password: " + (dbPwd != null && dbPwd.length() > 0) + "</div>");
			}
		}
		
		return buffer.toString();
	}
	
	private static String verifyPoolConnection(String pool, HashMap managersMap, boolean showErrorCode) {
		StringBuffer buffer = new StringBuffer();
		DBManager manager = (DBManager) managersMap.get(pool);
		
		if (manager == null) {
			if (showErrorCode) {
				buffer.append("1002");
			} else {
				buffer.append("<div class=error>Can't retrieve pool manager " + managersMap.size() + "</div>");
				buffer.append("<div class=information>Check connection configuration</div>");
			}
		} else {
			try {
				ConnectionGetter conGetter = new ConnectionGetter();
				DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
				dbConn.close();
				buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
			} catch (Exception e) {
				buffer.append(showErrorCode ? "1003" : "<div class=error>Error found: " + e.getMessage() + "</div>");
				
				if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			}
		}
		
		return buffer.toString();
	}
}

protected class VerificationBi extends BIDBAdmin {
	private boolean showErrorCodes = false;
	
	private String CODE_OK = "0";
	private String CODE_ERROR_POOL = "2001";
	
	public VerificationBi(boolean showErrorCodes) {
		this.showErrorCodes = showErrorCodes;
	}
	
	public String verifyConnectionBi() {
		StringBuffer buffer = new StringBuffer();
		if (! showErrorCodes) buffer.append("<div class=verify><b>Database connection BI:</b>");
		if(BIParameters.biInstalled()){
			
			if ("BIDb.implementation".equals(BIParameters.BIDB_IMPLEMENTATION)) {
				if (showErrorCodes) {
					buffer.append("0");
				} else {
					buffer.append("<div class=ok>ok</div>");
					buffer.append("<div class=information>Not installed</div>");
				}
			} else {
				buffer.append(Util.verifyAConnection(BIParameters.BIDB_IMPLEMENTATION, BIParameters.BIDB_URL, BIParameters.BIDB_USR, BIParameters.BIDB_PWD, showErrorCodes));
			}
			
		}else{
			if (showErrorCodes) {
				buffer.append("0");
			} else {
				buffer.append("<div class=ok>ok</div>");
				buffer.append("<div class=information>Not installed</div>");
			}
		}
		if (! showErrorCodes) buffer.append("</div>");
		return buffer.toString();
	}
	
	public String verifyBiPoolConnection()			{ 
		StringBuffer buffer = new StringBuffer();
		if (! showErrorCodes) buffer.append("<div class=verify><b>Database BI pool:</b>");
		if(BIParameters.biInstalled()){
			
			
			try {
				BIDBManager.getConnection().BIclose();
				buffer.append(showErrorCodes ? CODE_OK : "<div class=ok>ok</div>");
			} catch (Exception e) {
				buffer.append(showErrorCodes ? CODE_ERROR_POOL : "<div class=error>Error found: " + e.getMessage() + "</div>");
				
				if (! showErrorCodes) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			}
			
			
		}else{
			if (showErrorCodes) {
				buffer.append("0");
			} else {
				buffer.append("<div class=ok>ok</div>");
				buffer.append("<div class=information>Not installed</div>");
			}
		}
		if (! showErrorCodes) buffer.append("</div>");
		return buffer.toString();
	}
}

protected class Verification extends DBAdmin {
	
	private String verifyAPath(String aPath, boolean showErrorCode) {
		StringBuffer buffer = new StringBuffer();
		
		File aFile = new File(aPath);
		
		if (!aFile.exists()) {
			if (showErrorCode) {
				buffer.append("1014");
			} else {
				buffer.append("<div class=error>The path '" + aPath + "' does not exists</div>");
				buffer.append("<div class=information>Create the path: " + aPath + "</div>");
			}
		} else if (!aFile.isDirectory()) {
			if (showErrorCode) {
				buffer.append("1015");
			} else {
				buffer.append("<div class=error>The path '" + aPath + "' is not a directory</div>");
				buffer.append("<div class=information>The path '" + aPath + "' must be a directory where Apia can create files</div>");
			}
		} else {
			String aFilePath = aPath + File.separator + "verification_test_" + System.currentTimeMillis() + ".txt";
			boolean tryDelete = false;
			try {
				FileUtil.saveFile("TestFile", aFilePath);
				tryDelete = true;
			} catch (Exception e) {
				buffer.append(showErrorCode ? "1016" : "<div class=error>Can't create file '" + aFilePath + "'. Error: " + e.getMessage() + "</div>");
				if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			}
			if (tryDelete) {
				if (! new File(aFilePath).delete()) {
					if (showErrorCode) {
						buffer.append("1025");
					} else {
						buffer.append("<div class=error>Can't delete file '" + aFilePath + "'</div>");
					}
				} else {
					buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
				}
			}
		}
		
		return buffer.toString();
	}
	
	private boolean showErrorCode = false;
	
	public Verification(boolean showErrorCode) {
		this.showErrorCode = showErrorCode;
	}
	
	public String verifyConnectionApia()			{
		StringBuffer buffer = new StringBuffer();

		if (! this.showErrorCode) buffer.append("<div class=verify><b>Database connection Apia:</b>");
		
		buffer.append(Util.verifyAConnection(Configuration.DB_IMPLEMENTATION, Configuration.DB_URL, Configuration.DB_USR, Configuration.DB_PWD, this.showErrorCode)); 
		
		if (! this.showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifyApiaPoolConnection()		{
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Database Apia pool:</b>");
		
		buffer.append(Util.verifyPoolConnection("DOGMA_MANAGER", this.managersMap, showErrorCode));
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifyParameters() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Database parameters:</b>");
		
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		
		if (manager == null) {
			if (showErrorCode) {
				buffer.append("1004");
			} else {
				buffer.append("<div class=error>Can't retrieve pool manager</div>");
				buffer.append("<div class=information>Check connection configuration</div>");
			}
		} else {
			DBConnection dbConn = null;
			try {
				dbConn = DogmaDBManager.getConnection();
				HashMap pars = GenericDAO.getInstance().getParameters(dbConn);
				
				if (pars == null || pars.size() == 0) {
					buffer.append(showErrorCode ? "1005" : "<div class=error>No parameters where retrieve from the database</div>");
				
				} else if (! pars.containsKey("prmtCurrentVersion")) {
					buffer.append(showErrorCode ? "1006" : "<div class=error>Parameter 'prmtCurrentVersion' not found in database parameters</div>");
				
				} else if (pars.get("prmtCurrentVersion") == null || ((String) pars.get("prmtCurrentVersion")).length() == 0) {
					buffer.append(showErrorCode ? "1007" : "<div class=error>Parameter 'prmtCurrentVersion' with wrong value</div>");
				
				} else {
					buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
				}
			} catch (Exception e) {
				buffer.append(showErrorCode ? "1026" : "<div class=error>Error found: " + e.getMessage() + "</div>");
				
				if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			} finally {
				if (dbConn != null) {
					try {
						dbConn.close();
					} catch (Exception e) {
						buffer.append(showErrorCode ? "1008" : "<div class=error>Error found: " + e.getMessage() + "</div>");
						
						if (! showErrorCode) {
							java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
							e.printStackTrace(new java.io.PrintStream(bout));
							
							buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
						}
					}
				}
			}
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifyVersion() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia version:</b>");
		
		if ((!"[ApiaVersion]".equals(DogmaConstants.APIA_VERSION)) && ! DogmaConstants.APIA_VERSION.equals(Parameters.CURRENT_APIA_VERSION)) {
			if (showErrorCode) {
				buffer.append("1009");
			} else {
				buffer.append("<div class=error>Wrong versions</div>");
				buffer.append("<div class=information>Code version: " + DogmaConstants.APIA_VERSION + " - Database version: " + Parameters.CURRENT_APIA_VERSION + "</div>");
			}
		} else {
			buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyContext(HttpServletRequest request) {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia context:</b>");
		
		if (! Configuration.ROOT_PATH.equals(request.getContextPath())) {
			if (showErrorCode) {
				buffer.append("1010");
			} else {
				buffer.append("<div class=error>Wrong context</div>");
				buffer.append("<div class=information>Configuration context: " + Configuration.ROOT_PATH + " - Web server context: " + request.getContextPath() + "</div>");
			}
		} else {
			buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyPath() {
		String path = Configuration.APP_PATH;
		File aFile = new File(path);
		
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia path:</b>");
		
		if (!aFile.isDirectory()) {
			if (showErrorCode) {
				buffer.append("1011");
			} else {
				buffer.append("<div class=error>Wrong Apia installation path</div>");
				buffer.append("<div class=information>The path '" + path + "' is not a directory or does not exists</div>");
			}
		} else if (path.endsWith(File.separator)) {
			if (showErrorCode) {
				buffer.append("1012");
			} else {
				buffer.append("<div class=error>Apia installation path bad formed</div>");
				buffer.append("<div class=information>The path '" + path + "' must not end with '" + File.separator + "'</div>");
			}
		} else {
			path = Configuration.APP_PATH + File.separator + "WEB-INF" + File.separator + "lib" + File.separator + "Apia.jar";
			aFile = new File(path);
			if (!aFile.exists() && !aFile.isFile()) {
				if (showErrorCode) {
					buffer.append("1013");
				} else {
					buffer.append("<div class=error>Wrong Apia.jar file location</div>");
					buffer.append("<div class=information>The path '" + path + "' is not a file or does not exists</div>");
				}
			} else {
				buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
			}
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyTemp() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia temp:</b>");
		
		buffer.append(this.verifyAPath(Configuration.TMP_FILE_STORAGE, showErrorCode));
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyLogs() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia logs:</b>");
		
		buffer.append(this.verifyAPath(Configuration.LOG_DIRECTORY, showErrorCode));
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyQuerys() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia querys:</b>");
		
		buffer.append(this.verifyAPath(Parameters.QUERY_STORAGE, showErrorCode));
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifiyIndex() {
		if(Parameters.DOC_INDEX_ACTIVE){
			StringBuffer buffer = new StringBuffer();
			
			if (! showErrorCode) buffer.append("<div class=verify><b>Apia index:</b>");
			
			buffer.append(this.verifyAPath(Parameters.DOC_INDEX_PATH, showErrorCode));
	
			if (! showErrorCode) buffer.append("</div>");
			
			return buffer.toString();
		} else {
			return "0";
		}
	}
	
	public String verifiyDocs() {
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia documents:</b>");
		
		if (Parameters.DOC_TYPE == null || Parameters.DOC_TYPE_FILE.equals(Parameters.DOC_TYPE)) {
			buffer.append(this.verifyAPath(Parameters.DOCUMENT_STORAGE, showErrorCode)); 

		} else if (Parameters.DOC_TYPE_CVS.equals(Parameters.DOC_TYPE)){
		    String unencodedPassword = null;
		    String encodedPassword = "";
		    
		    if (unencodedPassword==null || encodedPassword.equals("")) encodedPassword = StandardScrambler.getInstance().scramble(Parameters.DOC_CVS_PAS);

		    try {
				PServerConnection c = new PServerConnection();
			    c.setUserName(Parameters.DOC_CVS_USU);
			    c.setEncodedPassword(encodedPassword);
			    c.setHostName(Parameters.DOC_CVS_HOST);
			    c.setUserName(Parameters.DOC_CVS_USU);
			    c.setRepository(Parameters.DOC_CVS_REP); 
			    c.open();       
	
			    BasicListener listener = new BasicListener();
			    
				Client client = new Client(c, new StandardAdminHandler());
				client.setLocalPath(Parameters.DOCUMENT_STORAGE + File.separator + Parameters.DOC_CVS_ROOT);
				client.getEventManager().addCVSListener(listener);
				client.getEventManager().setFireEnhancedEventSet(true);
				
				GlobalOptions globalOptions = new GlobalOptions();  
			    globalOptions.setCVSRoot(Parameters.DOC_CVS_ROOT);
				
				String aFilePath = System.getProperty("java.io.tmpdir") + File.separator + "cvsParamsVerification.txt";
				FileUtil.saveFile("Test cvs file", aFilePath);
				
				AddCommand addCmd = new AddCommand();
				addCmd.setBuilder(null);
				addCmd.setMessage("ADD_MESSAGE_" + System.currentTimeMillis());
				addCmd.setFiles(new File[] {new File(aFilePath)});
				
				client.executeCommand(addCmd,globalOptions);
				
				CommitCommand commitCmd = new CommitCommand();
				commitCmd.setMessage("MESSAGE_" + System.currentTimeMillis());
				commitCmd.setForceCommit(true);
				commitCmd.setFiles(new File[] {new File(aFilePath)});
				commitCmd.setBuilder(new CommitBuilder(client.getEventManager(), Parameters.DOCUMENT_STORAGE + File.separator + Parameters.DOC_CVS_ROOT ,""));
				
				client.executeCommand(commitCmd,globalOptions);
				
				RemoveCommand removeCmd = new RemoveCommand();
				removeCmd.setBuilder(null);
				removeCmd.setFiles(new File[] {new File(aFilePath)});
				removeCmd.setDeleteBeforeRemove(true);
				
				client.executeCommand(removeCmd,globalOptions);
				
				client.executeCommand(commitCmd,globalOptions);
				
				new File(aFilePath).delete();
				
				buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
		    } catch (Exception e) {
		    	buffer.append(showErrorCode ? "1017" : "<div class=error>Can't add a file to CVS. Error: " + e.getMessage() + "</div>");
		    	if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
		    	}
		    }
			
		} else if (Parameters.DOC_TYPE_DB_DOCUMENT.equals(Parameters.DOC_TYPE)){
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			
			if (manager == null) {
				if (showErrorCode) {
					buffer.append("1018");
				} else {
					buffer.append("<div class=error>Can't retrieve pool manager</div>");
					buffer.append("<div class=information>Check connection configuration</div>");
				}
			} else {
				DBConnection dbConn = null;
				try {
					dbConn = DogmaDBManager.getConnection();
					DbDocumentDAO.getInstance().getDbDocumentVo(dbConn,Integer.valueOf(-1));
					buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
				} catch (Exception e) {
					buffer.append(showErrorCode ? "1019" : "<div class=error>Can't add a file to CVS. Error: " + e.getMessage() + "</div>");
					
					if (! showErrorCode) {
						java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
						e.printStackTrace(new java.io.PrintStream(bout));
						buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
					}
				} finally {
					if (dbConn != null) {
						try {
							dbConn.close();
						} catch (Exception e) {
							buffer.append(showErrorCode ? "1020" : "<div class=error>Can't add a file to CVS. Error: " + e.getMessage() + "</div>");
							
							if (! showErrorCode) {
								java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
								e.printStackTrace(new java.io.PrintStream(bout));
								buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
							}
						} 
					}
				}
			}
		} else {
			buffer.append(showErrorCode ? "1027" : "<div class=error>Can't test</div>");
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}

	public String verifiyDispatcher() {
		File aFile = new File(Configuration.MONITOR_XML_DIR);
		StringBuffer buffer = new StringBuffer();
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Apia dispatcher:</b>");
		
		if (!aFile.exists()) {
			buffer.append(showErrorCode ? "1028" : "<div class=error>The dispatcher file does not exit</div>");
			if (! showErrorCode) buffer.append("<div class=information>The file '" + Configuration.MONITOR_XML_DIR + "' must exist in order to work the scheduler</div>");
		} else if (!aFile.isFile()) {
			buffer.append(showErrorCode ? "1029" : "<div class=error>The dispatcher file does not exit</div>");
			if (! showErrorCode) buffer.append("<div class=information>The file '" + Configuration.MONITOR_XML_DIR + "' must be a file in order to work the scheduler</div>");
		} else {
			buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifyEmail(HttpServletRequest request) {
		StringBuffer buffer = new StringBuffer(); 
		
		String email = request.getParameter("email");
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Email sender:</b>");
		
		if (email == null || email.length() == 0) {
			buffer.append(showErrorCode ? "0" : "<div class=information>Use <u>?email=xxx</u> to test sending an email. Replace xxx for the email that will recibe the test</div>");
		} else {
			String[] to = new String[] {email};
			String[] cc = null;
			String[] cco = null;
			String subject = "Email verification";
			String message = "Email for parameters verification";
			Collection files = null;
			
			try {
				DogmaUtil.sendMail(to,cc,cco,subject,message,files,
						Parameters.MAIL_HOST,
						Parameters.MAIL_SMTP_HOST,
						Parameters.MAIL_SMTP_USER,
						Parameters.MAIL_SMTP_PORT,
						Parameters.MAIL_SMTP_SSL,
						Parameters.MAIL_FROM,
						Parameters.MAIL_USER,
						Parameters.MAIL_REQUIERE_AUTH,
						Parameters.MAIL_AUTH_PASSWORD,
						Parameters.MAIL_DEBUG.equalsIgnoreCase("true"),
						Parameters.USE_MAIL_QUEUE,
						true,
						request);
				buffer.append(showErrorCode ? "0" : "<div class=ok>ok</div>");
			} catch (Exception e) {
				buffer.append(showErrorCode ? "1020" : "<div class=error>Error found: " + e.getMessage() + "</div>");
				
				if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			}
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
	
	public String verifyTablesApia() {
		StringBuffer buffer = new StringBuffer();
		
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		
		if (! showErrorCode) buffer.append("<div class=verify><b>Table verification:</b>");
		
		if (manager == null) {
			if (showErrorCode) {
				buffer.append("1030");
			} else {
				buffer.append("<div class=error>Can't retrieve pool manager</div>");
				buffer.append("<div class=information>Check connection configuration</div>");
			}
		} else {
			DBConnection dbConn = null;
			try {
				dbConn = DogmaDBManager.getConnection();
				DbDocumentDAO.getInstance().getDbDocumentVo(dbConn,Integer.valueOf(-1));
				Util.ConnectionGetter conGetter = new Util.ConnectionGetter();
				Connection conn = conGetter.getDBConnection2(dbConn);
				conn.setAutoCommit(false);
				
				Collection toCheck = new ArrayList();
				
				toCheck.add("REP_PARAMETER");
				toCheck.add("REP_QUERY");
				toCheck.add("REPORT");
				toCheck.add("ws_pub_attribute");
				toCheck.add("ws_publication");
				toCheck.add("PRO_DOC_EVENTS");
				toCheck.add("TSK_DOC_EVENTS");
				toCheck.add("PRO_DOC_FIELDS");
				toCheck.add("TSK_DOC_FIELDS");
				toCheck.add("PRO_DOC_EVENTS_LOG");
				toCheck.add("TSK_DOC_EVENTS_LOG");
				toCheck.add("PRO_DOC_FIELDS_LOG");
				toCheck.add("TSK_DOC_FIELDS_LOG");
				toCheck.add("FRM_DOC_EVENTS");
				toCheck.add("FRM_DOC_EVENTS_LOG");
				toCheck.add("users_substitutes");
				toCheck.add("users_substitutes_log");
				toCheck.add("usr_substitute_pool");
				toCheck.add("usr_substitute_pool_log");
				toCheck.add("usr_substitute_profile");
				toCheck.add("usr_substitute_profile_log");
				toCheck.add("ENV_DOCUMENT");
				toCheck.add("ENV_DOCUMENT_LOG");
				toCheck.add("ATTRIBUTE");
				toCheck.add("ATTRIBUTE_LOG");
				toCheck.add("BUS_CLA_PAR_BINDING");
				toCheck.add("BUS_CLA_PAR_BINDING_LOG");
				toCheck.add("BUS_CLA_PARAMETER");
				toCheck.add("BUS_CLA_PARAMETER_LOG");
				toCheck.add("BUS_CLASS");
				toCheck.add("BUS_CLASS_LOG");
				toCheck.add("BUS_ENT_DOCUMENT");
				toCheck.add("BUS_ENT_DOCUMENT_LOG");
				toCheck.add("BUS_ENT_EVT_BUS_CLASS");
				toCheck.add("BUS_ENT_EVT_BUS_CLASS_LOG");
				toCheck.add("BUS_ENT_FORM");
				toCheck.add("BUS_ENT_FORM_LOG");
				toCheck.add("BUS_ENT_INST_ATTRIBUTE");
				toCheck.add("BUS_ENT_INST_ATTRIBUTE_LOG");
				toCheck.add("BUS_ENT_INST_DOCUMENT");
				toCheck.add("BUS_ENT_INST_DOCUMENT_LOG");
				toCheck.add("BUS_ENT_INST_RELATION");
				toCheck.add("BUS_ENT_INSTANCE");
				toCheck.add("BUS_ENT_INSTANCE_LOG");
				toCheck.add("BUS_ENT_PROCESS");
				toCheck.add("BUS_ENT_PROCESS_LOG");
				toCheck.add("BUS_ENT_RELATED");
				toCheck.add("BUS_ENT_RELATED_LOG");
				toCheck.add("BUS_ENT_STA_RELATION");
				toCheck.add("BUS_ENT_STA_RELATION_LOG");
				toCheck.add("BUS_ENT_STATUS");
				toCheck.add("BUS_ENT_STATUS_LOG");
				toCheck.add("BUS_ENTITY");
				toCheck.add("BUS_ENTITY_LOG");
				toCheck.add("CALENDAR");
				toCheck.add("CALENDAR_LOG");
				toCheck.add("CALENDAR_FREE_DAYS");
				toCheck.add("CALENDAR_FREE_DAYS_LOG");
				toCheck.add("USR_DESK_CALENDAR");
				toCheck.add("USR_DESK_CALENDAR_LOG");
				toCheck.add("CALENDAR_LABORAL_DAYS");
				toCheck.add("CALENDAR_LABORAL_DAYS_LOG");
				toCheck.add("CLA_TREE");
				toCheck.add("CLA_TREE_LOG");
				toCheck.add("DB_CONNECTION");
				toCheck.add("DB_CONNECTION_LOG");
				toCheck.add("DOC_LOCK");
				toCheck.add("DOC_PERMISSION");
				toCheck.add("DOC_VERSION");
				toCheck.add("DOCUMENT");
				toCheck.add("DOCUMENT_LOG");
				toCheck.add("DB_DOCUMENT");
				toCheck.add("DB_DOC_ENCRIPTION");
				toCheck.add("ENV_DW_ATTRIBUTE");
				toCheck.add("ENV_DW_ATTRIBUTE_LOG");
				toCheck.add("ENV_MESSAGE");
				toCheck.add("ENV_MESSAGE_LOG");
				toCheck.add("ENV_MSG_POOL");
				toCheck.add("ENV_MSG_POOL_LOG");
				toCheck.add("ENV_PARAMETER");
				toCheck.add("ENV_POOL");
				toCheck.add("ENV_POOL_LOG");
				toCheck.add("ENV_PRF_FUNCTIONALITY");
				toCheck.add("ENV_PRF_FUNCTIONALITY_LOG");
				toCheck.add("ENV_PROFILE");
				toCheck.add("ENV_PROFILE_LOG");
				toCheck.add("ENV_USER");
				toCheck.add("ENV_USER_LOG");
				toCheck.add("ENVIRONMENT");
				toCheck.add("ENVIRONMENT_LOG");
				toCheck.add("EVENT");
				toCheck.add("FLD_TYP_EVENT");
				toCheck.add("FLD_TYP_PROPERTY");
				toCheck.add("FLD_TYPE");
				toCheck.add("FORM");
				toCheck.add("FORM_LOG");
				toCheck.add("FRM_DOCUMENT");
				toCheck.add("FRM_DOCUMENT_LOG");
				toCheck.add("FRM_EVT_BUS_CLASS");
				toCheck.add("FRM_EVT_BUS_CLASS_LOG");
				toCheck.add("FRM_FIELD");
				toCheck.add("FRM_FIELD_LOG");
				toCheck.add("FRM_FLD_ENT_BINDING");
				toCheck.add("FRM_FLD_ENT_BINDING_LOG");
				toCheck.add("FRM_FLD_EVT_BUS_CLASS");
				toCheck.add("FRM_FLD_EVT_BUS_CLASS_LOG");
				toCheck.add("FRM_FLD_PROPERTY");
				toCheck.add("FRM_FLD_PROPERTY_LOG");
				toCheck.add("FRM_PROPERTY");
				toCheck.add("FRM_PROPERTY_LOG");
				toCheck.add("FUNCTIONALITY");
				toCheck.add("FUNCTIONALITY_LOG");
				toCheck.add("LABELS");
				toCheck.add("LABELS_LOG");
				toCheck.add("LANGUAGE");
				toCheck.add("LANGUAGE_LOG");
				toCheck.add("LBL_SET");
				toCheck.add("LBL_SET_LOG");
				toCheck.add("LICENCE");
				toCheck.add("LICENCE_DATA");
				toCheck.add("LOG_ACCESS");
				toCheck.add("MON_BUS_ENT_FORM");
				toCheck.add("MON_BUS_ENT_FORM_LOG");
				toCheck.add("MON_PRO_FORM");
				toCheck.add("MON_PRO_FORM_LOG");
				toCheck.add("NOT_POOL");
				toCheck.add("NOT_POOL_LOG");
				toCheck.add("NOTIFICATION");
				toCheck.add("NOTIFICATION_LOG");
				toCheck.add("OBJECT_ID_NUMBERS");
				toCheck.add("OPERATOR");
				toCheck.add("PARAMETERS");
				toCheck.add("POOL");
				toCheck.add("POOL_HIERARCHY");
				toCheck.add("POOL_HIERARCHY_LOG");
				toCheck.add("POOL_LOG");
				toCheck.add("PRF_FUNCIONALITY");
				toCheck.add("PRF_FUNCIONALITY_LOG");
				toCheck.add("PRO_DOCUMENT");
				toCheck.add("PRO_DOCUMENT_LOG");
				toCheck.add("PRO_ELE_BUS_ENT_FORM");
				toCheck.add("PRO_ELE_BUS_ENT_FORM_LOG");
				toCheck.add("PRO_ELE_BUS_ENT_STATUS");
				toCheck.add("PRO_ELE_BUS_ENT_STATUS_LOG");
				toCheck.add("PRO_ELE_DEP_INSTANCE");
				toCheck.add("PRO_ELE_DEP_INSTANCE_LOG");
				toCheck.add("PRO_ELE_DEPENDENCY");
				toCheck.add("PRO_ELE_DEPENDENCY_LOG");
				toCheck.add("PRO_ELE_EVT_BUS_CLASS");
				toCheck.add("PRO_ELE_EVT_BUS_CLASS_LOG");
				toCheck.add("PRO_ELE_FORM");
				toCheck.add("PRO_ELE_FORM_LOG");
				toCheck.add("PRO_ELE_INST_HISTORY");
				toCheck.add("PRO_ELE_INSTANCE");
				toCheck.add("PRO_ELE_INSTANCE_LOG");
				toCheck.add("PRO_ELE_POOL");
				toCheck.add("PRO_ELE_POOL_LOG");
				toCheck.add("PRO_ELEMENT");
				toCheck.add("PRO_ELEMENT_LOG");
				toCheck.add("PRO_EVT_BUS_CLASS");
				toCheck.add("PRO_EVT_BUS_CLASS_LOG");
				toCheck.add("PRO_INST_ATTRIBUTE");
				toCheck.add("PRO_INST_ATTRIBUTE_LOG");
				toCheck.add("PRO_INST_COMMENT");
				toCheck.add("PRO_INST_COMMENT_LOG");
				toCheck.add("PRO_INST_DOCUMENT");
				toCheck.add("PRO_INST_DOCUMENT_LOG");
				toCheck.add("PRO_INSTANCE");
				toCheck.add("PRO_INSTANCE_LOG");
				toCheck.add("PRO_NOT_MESSAGE");
				toCheck.add("PRO_NOT_MESSAGE_LOG");
				toCheck.add("PRO_NOT_POOL");
				toCheck.add("PRO_NOT_POOL_LOG");
				toCheck.add("PRO_NOTIFICATION");
				toCheck.add("PRO_NOTIFICATION_LOG");
				toCheck.add("PROCESS");
				toCheck.add("PROCESS_LOG");
				toCheck.add("PROFILE");
				toCheck.add("PROFILE_LOG");
				toCheck.add("PROJECT");
				toCheck.add("PROJECT_LOG");
				toCheck.add("PROPERTY");
				toCheck.add("QRY_CHART");
				toCheck.add("QRY_CHART_LOG");
				toCheck.add("QRY_CHT_PROPERTY");
				toCheck.add("QRY_CHT_PROPERTY_LOG");
				toCheck.add("QRY_CHT_SERIE");
				toCheck.add("QRY_CHT_SERIE_LOG");
				toCheck.add("QRY_COLUMN");
				toCheck.add("QRY_COLUMN_LOG");
				toCheck.add("QRY_EVT_BUS_CLASS");
				toCheck.add("QRY_EVT_BUS_CLASS_LOG");
				toCheck.add("QRY_NAVIGATION");
				toCheck.add("QRY_NAVIGATION_LOG");
				toCheck.add("QUERY");
				toCheck.add("QUERY_LOG");
				toCheck.add("ROL_MAPPING");
				toCheck.add("ROLE");
				toCheck.add("ROLE_LOG");
				toCheck.add("SCH_BUS_CLA_ACTIVITY");
				toCheck.add("SCH_BUS_CLA_ACTIVITY_LOG");
				toCheck.add("SERVER");
				toCheck.add("TASK");
				toCheck.add("TASK_LOG");
				toCheck.add("TMP_OBJ_NUMBER");
				toCheck.add("TSK_DOCUMENT");
				toCheck.add("TSK_DOCUMENT_LOG");
				toCheck.add("TSK_NOT_MESSAGE");
				toCheck.add("TSK_NOT_MESSAGE_LOG");
				toCheck.add("TSK_NOT_POOL");
				toCheck.add("TSK_NOT_POOL_LOG");
				toCheck.add("TSK_NOTIFICATION");
				toCheck.add("TSK_NOTIFICATION_LOG");
				toCheck.add("USERS");
				toCheck.add("USERS_LOG");
				toCheck.add("USR_POOL");
				toCheck.add("USR_POOL_LOG");
				toCheck.add("USR_PROFILE");
				toCheck.add("USR_PROFILE_LOG");
				toCheck.add("LICENCE");
				toCheck.add("LICENCE_DATA");
				toCheck.add("SERVER");
				toCheck.add("USR_NOT_READ");
				toCheck.add("USR_NOT_READ_LOG");
				toCheck.add("PRO_ELE_INST_ATTRIBUTE");
				toCheck.add("PRO_ELE_INST_ATTRIBUTE_LOG");
				toCheck.add("USR_DESK");
				toCheck.add("USR_DESK_LOG");
				toCheck.add("USR_PWD_HISTORY");
				toCheck.add("USR_CERTIFICATES");
				toCheck.add("USR_SIGNS");
				toCheck.add("IMAGES");
				toCheck.add("TRANSLATION");
				toCheck.add("BLOCK_PRO");
				toCheck.add("BLOCK_ENT");
				toCheck.add("PRO_INST_NUMBERS");
				toCheck.add("ENT_INST_NUMBERS");

				boolean errorFound = false;
				
				for (Iterator it = toCheck.iterator(); it.hasNext() && ! errorFound; ) {
					String tableToCheck	= (String) it.next();
					StringBuffer sql = new StringBuffer("select * from ");
					sql.append(tableToCheck);
					sql.append(" where 1=2");
					
					Statement statement = conn.createStatement();
					try {
						statement.execute(sql.toString());
						if (! showErrorCode) buffer.append("<div class=information>Table " + tableToCheck + " is ok.</div>");
					} catch (Exception e) {
						buffer.append(showErrorCode ? "1031" : "<div class=error>Can't execute SQL for table: " + tableToCheck + ". Error: " + e.getMessage() + "</div>");
						
						if (! showErrorCode) {
							java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
							e.printStackTrace(new java.io.PrintStream(bout));
							buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
						} else {
							errorFound = true;
						}
					} finally {
						statement.close();
					}
				}
				
				toCheck.clear();
				
				if (! errorFound) {
				toCheck.add("VW_DOC_LOCKED_01");
				toCheck.add("VW_PRO_TO_CANCEL_WITH_FILTERS");
				toCheck.add("VW_QRY_ENV_GROUPS");
				toCheck.add("VW_QRY_ENV_PROFILES");
				toCheck.add("VW_QRY_GEN_MON_PROCESSES");
				toCheck.add("VW_QRY_GEN_MON_TASK");
				toCheck.add("VW_BUS_CLA_PARAMETERS_01");
				toCheck.add("VW_BUS_ENTITIES_INSTANCES_01");
				toCheck.add("VW_CONSULTS_MONITOR_PROCESSES");
				toCheck.add("VW_INF_BUS_ENT_ATTRIBUTE");
				toCheck.add("VW_INF_BUS_ENT_BUS_CLA_REL");
				toCheck.add("VW_INF_FRM_ATTRIBUTES");
				toCheck.add("VW_INF_FRM_BUS_CLA_RELATION");
				toCheck.add("VW_INF_FRM_FIELDS");
				toCheck.add("VW_INF_FRM_FLD_BUS_CLA_REL");
				toCheck.add("VW_INF_PRO_ATTRIBUTE");
				toCheck.add("VW_INF_PRO_BUS_CLA_RELATION");
				toCheck.add("VW_INF_PRO_CONDITION");
				toCheck.add("VW_INF_PRO_TASK");
				toCheck.add("VW_INF_PRO_TSK_BUS_CLA_REL");
				toCheck.add("VW_INF_PRO_TSK_FORM");
				toCheck.add("VW_INF_QRY_EVT_BUS_CLASS");
				toCheck.add("VW_PRO_ELEMENT_01");
				toCheck.add("VW_BUS_ENT_FORM_DEP_01");
				toCheck.add("VW_CONS_USER_MESSAGES_01");
				toCheck.add("VW_CONSULTS_MONITOR_PROCESSES");
				toCheck.add("VW_CONSULTS_MONITOR_TASKS");
				toCheck.add("VW_CUSTOM_PRF_FNC_01");
				toCheck.add("VW_DATAWARE_ATTRIBUTES");
				toCheck.add("VW_DOCUMENTS_01");
				toCheck.add("VW_FORM_BUS_CLA_DEP");
				toCheck.add("VW_GLOBAL_PRF_FNC_01");
				toCheck.add("VW_NOTIFICATION_01");
				toCheck.add("VW_POOL_DEPENDENCIES_01");
				toCheck.add("VW_POOL_PROCESS_INSTANCES_01");
				toCheck.add("VW_PRO_ELE_DEP_INSTANCE_01");
				toCheck.add("VW_PRO_ELE_FORM_DEP_01");
				toCheck.add("VW_PRO_ELE_INST_DEP_01");
				toCheck.add("VW_PRO_ELE_INSTANCE_01");
				toCheck.add("VW_PRO_INST_COMMENT_01");
				toCheck.add("VW_PRO_INSTANCE_01");
				toCheck.add("VW_PRO_TO_CANCEL_01");
				toCheck.add("VW_PROCESS_01");
				toCheck.add("VW_PROCESS_BUS_CLA_DEP");
				toCheck.add("VW_PROCESS_START_01");
				toCheck.add("VW_PROCESS_TO_VERIFIE");
				toCheck.add("VW_QRY_GENERIC_BUSINESS");
				toCheck.add("VW_QRY_GENERIC_ENTITY");
				toCheck.add("VW_QRY_GENERIC_PROCESS");
				toCheck.add("VW_QRY_GENERIC_TASK_LIST");
				toCheck.add("VW_QRY_GEN_TSK_LIST_READY");
				toCheck.add("VW_QRY_GEN_TSK_LIST_ACQUIRED");
				toCheck.add("VW_SEC_ENV_PROFILE_01");
				toCheck.add("VW_SEC_GLOBAL_PROFILE_01");
				toCheck.add("VW_TASK_TO_VERIFIE");
				toCheck.add("VW_TASKS_LIST_INPROCESS_01");
				toCheck.add("VW_TASKS_LIST_INPROCESS_02");
				toCheck.add("VW_TASKS_LIST_READY_01");
				toCheck.add("VW_TREE_VIEW_02");
				toCheck.add("VW_TREE_VIEW_03");
				toCheck.add("VW_USR_FNC_URL");
				toCheck.add("VW_MON_BUS_ENT_FORM_DEP_01");
				toCheck.add("VW_TASKS_LIST_READY_COUNT_01");
				toCheck.add("vw_pro_rollback_tasks");
	
					for (Iterator it = toCheck.iterator(); it.hasNext(); ) {
						String tableToCheck	= (String) it.next();
						StringBuffer sql = new StringBuffer("select * from ");
						sql.append(tableToCheck);
						sql.append(" where 1=2");
						
						Statement statement = conn.createStatement();
						try {
							statement.execute(sql.toString());
							if (! showErrorCode) buffer.append("<div class=information>View " + tableToCheck + " is ok.</div>");
						} catch (Exception e) {
							buffer.append(showErrorCode ? "1032" : "<div class=error>Can't execute SQL for table: " + tableToCheck + ". Error: " + e.getMessage() + "</div>");
							
							if (! showErrorCode) {
								java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
								e.printStackTrace(new java.io.PrintStream(bout));
								buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
							} else {
								errorFound = true;
							}
						} finally {
							statement.close();
						}
					}
				}
				
				if(showErrorCode){
					if(!errorFound){
						buffer.append("0");
					}
						
				}
				
			} catch (Exception e) {
				buffer.append(showErrorCode ? "1033" : "<div class=error>Can't test tables/views. Error: " + e.getMessage() + "</div>");
				
				if (! showErrorCode) {
					java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
					e.printStackTrace(new java.io.PrintStream(bout));
					buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
				}
			} finally {
				if (dbConn != null) {
					try {
						dbConn.close();
					} catch (Exception e) {
						buffer.append(showErrorCode ? "1034" : "<div class=error>Can't add a file to CVS. Error: " + e.getMessage() + "</div>");
						
						if (! showErrorCode) {
							java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
							e.printStackTrace(new java.io.PrintStream(bout));
							buffer.append("<div class=information>Stacktrace: <pre>" + bout.toString() + "</pre></div>");
						}
					} 
				}
			}
		}
		
		if (! showErrorCode) buffer.append("</div>");
		
		return buffer.toString();
	}
}

%>

<%
boolean errorCodes = request.getParameter("errorCodes") != null && request.getParameter("errorCodes").equalsIgnoreCase("true");

boolean avoidVerifyConnectionApia		= request.getParameter("avoidVCA")	!= null && request.getParameter("avoidVCA").equalsIgnoreCase("true");
boolean avoidVerifyConnectionBi			= request.getParameter("avoidVCB")	!= null && request.getParameter("avoidVCB").equalsIgnoreCase("true");
boolean avoidVerifyApiaPoolConnection	= request.getParameter("avoidVAPC")	!= null && request.getParameter("avoidVAPC").equalsIgnoreCase("true");
boolean avoidVerifyBiPoolConnection		= request.getParameter("avoidVBPC")	!= null && request.getParameter("avoidVBPC").equalsIgnoreCase("true");
boolean avoidVerifyParameters			= request.getParameter("avoidVP")	!= null && request.getParameter("avoidVP").equalsIgnoreCase("true");
boolean avoidVerifiyVersion				= request.getParameter("avoidVV")	!= null && request.getParameter("avoidVV").equalsIgnoreCase("true");
boolean avoidVerifiyContext				= request.getParameter("avoidVC")	!= null && request.getParameter("avoidVC").equalsIgnoreCase("true");
boolean avoidVerifiyPath				= request.getParameter("avoidVH")	!= null && request.getParameter("avoidVH").equalsIgnoreCase("true");
boolean avoidVerifiyTemp				= request.getParameter("avoidVT")	!= null && request.getParameter("avoidVT").equalsIgnoreCase("true");
boolean avoidVerifiyLogs				= request.getParameter("avoidVL")	!= null && request.getParameter("avoidVL").equalsIgnoreCase("true");
boolean avoidVerifiyDocs				= request.getParameter("avoidVD")	!= null && request.getParameter("avoidVD").equalsIgnoreCase("true");
boolean avoidVerifiyQuerys				= request.getParameter("avoidVQ")	!= null && request.getParameter("avoidVQ").equalsIgnoreCase("true");
boolean avoidVerifiyIndex				= request.getParameter("avoidVI")	!= null && request.getParameter("avoidVI").equalsIgnoreCase("true");
boolean avoidVerifiyDispatcher			= request.getParameter("avoidVR")	!= null && request.getParameter("avoidVR").equalsIgnoreCase("true");
boolean avoidVerifiyEmail				= request.getParameter("avoidVE")	!= null && request.getParameter("avoidVE").equalsIgnoreCase("true");
boolean avoidVerifiyTableApia			= request.getParameter("avoidVTA")	!= null && request.getParameter("avoidVTA").equalsIgnoreCase("true");

Verification verification = new Verification(errorCodes);
VerificationBi verificationBi = new VerificationBi(errorCodes);

if (errorCodes) { 
	int errorCode = 0;
	
	if (errorCode == 0 && ! avoidVerifyConnectionApia)	errorCode = Integer.parseInt(verification.verifyConnectionApia());
	if (errorCode == 0 && ! avoidVerifyConnectionBi)	errorCode = Integer.parseInt(verificationBi.verifyConnectionBi());
	
	if (errorCode == 0 && ! avoidVerifyApiaPoolConnection)	errorCode = Integer.parseInt(verification.verifyApiaPoolConnection());
	if (errorCode == 0 && ! avoidVerifyBiPoolConnection)	errorCode = Integer.parseInt(verificationBi.verifyBiPoolConnection());
	
	if (errorCode == 0 && ! avoidVerifyParameters) errorCode = Integer.parseInt(verification.verifyParameters());
	
	if (errorCode == 0 && ! avoidVerifiyVersion) errorCode = Integer.parseInt(verification.verifyVersion());
	if (errorCode == 0 && ! avoidVerifiyContext) errorCode = Integer.parseInt(verification.verifiyContext(request));
	
	if (errorCode == 0 && ! avoidVerifiyPath)	errorCode = Integer.parseInt(verification.verifiyPath());
	if (errorCode == 0 && ! avoidVerifiyTemp)	errorCode = Integer.parseInt(verification.verifiyTemp());
	if (errorCode == 0 && ! avoidVerifiyLogs)	errorCode = Integer.parseInt(verification.verifiyLogs());
	if (errorCode == 0 && ! avoidVerifiyDocs)	errorCode = Integer.parseInt(verification.verifiyDocs());
	if (errorCode == 0 && ! avoidVerifiyQuerys)	errorCode = Integer.parseInt(verification.verifiyQuerys());
	if (errorCode == 0 && ! avoidVerifiyIndex)	errorCode = Integer.parseInt(verification.verifiyIndex());
	
	if (errorCode == 0 && ! avoidVerifiyDispatcher) errorCode = Integer.parseInt(verification.verifiyDispatcher());
	
	if (errorCode == 0 && ! avoidVerifiyEmail) errorCode = Integer.parseInt(verification.verifyEmail(request));
	
	if (errorCode == 0 && ! avoidVerifiyTableApia) errorCode = Integer.parseInt(verification.verifyTablesApia()); %>
	
	<%= errorCode %><%
} else {%>
	<head>
		<title>Verification of Apia</title>
		<style type="text/css">
			body				{ font-family: verdana; font-size: 10px; }
			pre					{ font-family: verdana; font-size: 10px; }
			div.verify			{ margin-bottom: 5px; border: solid 1px black; padding: 5px; }
			div.ok				{ color: #00FF00; font-weight: bold; }
			div.error			{ color: #FF0000; }
			div.verify b		{ float: left; margin-right: 5px; }
			div.information		{ margin-left: 10px; }
			div.information pre { margin-top: 0px; }
		</style>
	</head>
	<body>
		<%= avoidVerifyConnectionApia ? "" : verification.verifyConnectionApia() %>
		<%= avoidVerifyConnectionBi ? "" : verificationBi.verifyConnectionBi() %>
		
		<%= avoidVerifyApiaPoolConnection ? "" : verification.verifyApiaPoolConnection() %>
		<%= avoidVerifyBiPoolConnection ? "" : verificationBi.verifyBiPoolConnection() %>
		
		<%= avoidVerifyParameters ? "" : verification.verifyParameters() %>
		
		<%= avoidVerifiyVersion ? "" : verification.verifyVersion() %>
		<%= avoidVerifiyContext ? "" : verification.verifiyContext(request) %>
		
		<%= avoidVerifiyPath ? "" : verification.verifiyPath() %>
		<%= avoidVerifiyTemp ? "" : verification.verifiyTemp() %>
		<%= avoidVerifiyLogs ? "" : verification.verifiyLogs() %>
		<%= avoidVerifiyDocs ? "" : verification.verifiyDocs() %>
		<%= avoidVerifiyQuerys ? "" : verification.verifiyQuerys() %>
		<%= avoidVerifiyIndex ? "" : verification.verifiyIndex() %>
		
		<%= avoidVerifiyDispatcher ? "" : verification.verifiyDispatcher() %>
		
		<%= avoidVerifiyEmail ? "" : verification.verifyEmail(request) %>
		<%= avoidVerifiyTableApia ? "" : verification.verifyTablesApia() %>
	</body>
<% } %>

