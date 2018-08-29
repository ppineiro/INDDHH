<%@page import="com.dogma.dao.EnvironmentDAO"%>
<%@page import="com.dogma.vo.EnvironmentVo"%>
<%@page import="java.io.FileFilter"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.io.File"%>
<%@page import="com.dogma.dao.BusClassDAO"%>
<%@page import="com.dogma.vo.filter.BusClassFilterVo"%>
<%@page import="com.dogma.vo.BusClassVo"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.FileUtil"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="com.st.util.StringUtil"%>

<%@page import="com.dogma.dataAccess.DBManagerUtil"%><html>
<head>
	<title>BusClassVerifier</title>
	<style type="text/css">
		body {
			font-family: verdana;
			font-size: 10px;
		}
		td {
			font-family: verdana;
			font-size: 10px;
		}
		pre {
			font-family: verdana;
			font-size: 10px;
		}
		input {
			font-family: verdana;
			font-size: 10px;
		}
		select {
			font-family: verdana;
			font-size: 10px;
		}
		
		a {
			text-decoration: none;
			color: blue;
		}
	</style>
</head>
<body>

<%!
protected static final String MIG_PATH_PREFIX	= "_mig_";

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class MigFilesFileFilter implements FileFilter {
	public boolean accept(File aFile) {
		if (! aFile.isDirectory()) return false;
		return aFile.getName().indexOf(MIG_PATH_PREFIX) != -1;
	}
}

protected class MigJsFilesFileFilter implements FileFilter {
	public boolean accept(File aFile) {
		if (! aFile.isFile()) return false;
		return aFile.getName().endsWith(".js");
	}
}

protected class Test extends DBAdmin {
	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
		return this.getConnection(dbConn);
	}
	
	private Connection getConnection(DBConnection dbConn) throws Exception {
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
	}
	
	private File newFileName(String currentFile, String extension) {
		File result = null;
		int index = 1;
		do {
			result = new File(currentFile + "_" + (index++) + extension);
		} while (result.exists());
		
		return result;
	}
	
	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(System.currentTimeMillis() + ": " + msg + "<br>");
	}
	
	private void addError(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> " + msg);
	}
	
	private void addFatal(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'><b>[FATAL]</b></font> " + msg);
	}
	
	private void addDebug(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"[DEBUG] " + msg);
	}
	
	private void addInfo(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='blue'>[INFO]</font> " + msg);
	}
	
	private void addWarning(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='orange'>[WARNING]</font> " + msg);
	}
	
	//--------------------------------
	
	public String verifyJava(boolean showOk) {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			
			this.addMessage(buffer,"Searching classes...");
			BusClassFilterVo filterVo = new BusClassFilterVo();
			filterVo.setType(BusClassVo.TYPE_JAVA_PROGRAMMING);
			Collection busClasses = BusClassDAO.getInstance().getAllBusClass(conn,filterVo);
			
			if (busClasses != null && busClasses.size() > 0) {
				this.addMessage(buffer,"Classes to verifiy: <b>" + busClasses.size() + "</b>.");
				HashMap usedExecutables = new HashMap();
				
				int totalErrors = 0;
				int totalWarning = 0;
				
				for (Iterator it = busClasses.iterator(); it.hasNext(); ) {
					BusClassVo busClaVo = (BusClassVo) it.next();
					try {
						Class myClass = Class.forName(busClaVo.getBusClaExecutable());
						myClass.newInstance();
						
						if (usedExecutables.containsKey(busClaVo.getBusClaExecutable())) {
							String otherBusClaVo = (String) usedExecutables.get(busClaVo.getBusClaExecutable());
							totalWarning ++;
							this.addWarning(buffer,"Bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + "</b> is <b>OK</b>, but executable is being used by <b>" + otherBusClaVo + "</b>.");						
						} else {
							usedExecutables.put(busClaVo.getBusClaExecutable(), busClaVo.getBusClaName());
							if (showOk) this.addMessage(buffer,"Bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + "</b> is <b>OK</b>.");
						}
					} catch (Exception e) {
						totalErrors++;
						this.addError(buffer,"Can't get instance for bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + "</b>. Error: " + e.toString() + ".");
					}
				}
				
				this.addMessage(buffer,"Total warning: <b>" + totalWarning + "</b>");
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (busClasses.size() - totalWarning - totalErrors) + "</b>");
				
			} else {
				this.addMessage(buffer,"No Java classes to verify.");
			}
		} catch (Throwable e) {
			this.addError(buffer,e.getMessage());
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				DBManagerUtil.close(conn);
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}

	public String verifiyJS(boolean showOk) {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			
			this.addMessage(buffer,"Searching classes...");
			BusClassFilterVo filterVo = new BusClassFilterVo();
			filterVo.setType(BusClassVo.TYPE_JSCPT_PROGRAMMING);
			Collection busClasses = BusClassDAO.getInstance().getAllBusClass(conn,filterVo);
			
			if (busClasses != null && busClasses.size() > 0) {
				this.addMessage(buffer,"Classes to verifiy: <b>" + busClasses.size() + "</b>.");
				HashMap usedExecutables = new HashMap();
				
				HashMap environments = new HashMap();
				
				int totalErrors = 0;
				int totalWarning = 0;
				
				for (Iterator it = busClasses.iterator(); it.hasNext(); ) {
					BusClassVo busClaVo = (BusClassVo) it.next();
					
					if (! environments.containsKey(busClaVo.getEnvId())) environments.put(busClaVo.getEnvId(), EnvironmentDAO.getInstance().getEnvironmentVo(conn, busClaVo.getEnvId()));
					EnvironmentVo envVo = (EnvironmentVo) environments.get(busClaVo.getEnvId());
					
					try {
						File file = new File(Parameters.APP_PATH + File.separator + "customScripts" + File.separator + busClaVo.getFunctionName() + ".js");
				       	String jsContent = FileUtil.readFile(file);
						String idBusClass = "fnc_" + busClaVo.getEnvId().toString() + "_" + busClaVo.getBusClaId().toString();
						boolean reusedFile = usedExecutables.containsKey(busClaVo.getBusClaExecutable());
						
						boolean errorFound = false;
						
						if (reusedFile) {
							String otherBusClaVo = (String) usedExecutables.get(busClaVo.getBusClaExecutable());
							totalWarning ++;
							this.addWarning(buffer,"Bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + ".js</b> is <b>OK</b>, but executable is being used by <b>" + otherBusClaVo + "</b>.");						
							this.addInfo(buffer,"Recomended actions: clone file, rename file and update database information.");
							
							errorFound = true;
						} else {
							usedExecutables.put(busClaVo.getBusClaExecutable(), busClaVo.getBusClaName());
						}

						if (jsContent.indexOf(idBusClass) == -1) {
							int idx1 = jsContent.indexOf("fnc_");
							int idx2 = jsContent.indexOf("(");
							String idFound = jsContent.substring(idx1,idx2);

							this.addError(buffer,"The bussines class <b>" + busClaVo.getBusClaName() + "</b> has the wrong ID in file <b>" + busClaVo.getBusClaExecutable() + ".js</b>. Expected <b>" + idBusClass + "</b> found <b>" + idFound + "</b>.");
							this.addInfo(buffer,"Recomended action: update " + (reusedFile?"cloned ":"") + "file information.");
							
							errorFound = true;
						}
						
						if (BusClassVo.TYPE_JSCPT_PROGRAMMING.equals(busClaVo.getBusClaType())) {
							if (! busClaVo.getBusClaExecutable().startsWith(envVo.getEnvName())) {
								this.addError(buffer,"The bussines class <b>" + busClaVo.getBusClaName() + "</b> has the wrong executable file <b>" + busClaVo.getBusClaExecutable() + ".js</b>. Expected to start with <b>" + envVo.getEnvName() + "</b>.");
								this.addInfo(buffer,"Recomended action: execute <b>[ Update migrated JS files ]</b>.");
								
								errorFound = true;
							}
						}

						if (showOk && ! errorFound) this.addMessage(buffer,"Bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + ".js</b> is <b>OK</b>.");
						
					} catch (FileNotFoundException e) {
						totalErrors++;
						this.addError(buffer,"Can't verify bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + ".js</b>. Error: " + e.toString() + ".");
					} catch (Exception e) {
						e.printStackTrace();
						this.addFatal(buffer,"Error while verifying bussines class <b>" + busClaVo.getBusClaName() + "</b> (see console log). Error: " + e.toString() + ".");
						break;
					}
				}
				
				this.addMessage(buffer,"Total warning: <b>" + totalWarning + "</b>");
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (busClasses.size() - totalWarning - totalErrors) + "</b>");
				
			} else {
				this.addMessage(buffer,"No Java classes to verify.");
			}
		} catch (Exception e) {
			this.addError(buffer,e.getMessage());
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				DBManagerUtil.close(conn);
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}

	public String migFiles() {
		StringBuffer buffer = new StringBuffer();
		
		File customScriptsPath = new File(Parameters.APP_PATH + File.separator + "customScripts");
		this.addMessage(buffer,"Searching directories (&lt;origin&gt;<b>" + MIG_PATH_PREFIX + "</b>&lt;destination&gt;) at: " + Parameters.APP_PATH + File.separator + "customScripts");
		
		File[] migCandidates = customScriptsPath.listFiles(new MigFilesFileFilter());
		this.addMessage(buffer,"Directories found: " + ((migCandidates != null) ? migCandidates.length : 0));
		
		if (migCandidates != null && migCandidates.length > 0) {
			boolean correctionDone = false;
			
			for (int i = 0; i < migCandidates.length; i++) {
				File path = migCandidates[i];
				int index = path.getName().indexOf(MIG_PATH_PREFIX);
				
				String origin = path.getName().substring(0, index);
				String destination = path.getName().substring(index + MIG_PATH_PREFIX.length());
				
				this.addMessage(buffer, "Migrating files from <b>" + origin + "</b> to <b>" + destination + "</b> from path <b>" + path.getAbsolutePath() + "</b>");
				
				File[] files = path.listFiles(new MigJsFilesFileFilter());
				this.addMessage(buffer,"JS's found: " + ((files != null) ? files.length : 0));
				
				if  (files != null && files.length > 0) {
					for (int j = 0; j < files.length; j++) {
						File file = files[j];
						
						if (file.getName().startsWith(origin)) {
							String newFileName = destination + file.getName().substring(origin.length());
							
							boolean result = file.renameTo(new File(customScriptsPath, newFileName));
							if (result) correctionDone = true;
							this.addMessage(buffer, "Moveing file <b>" + file.getName() + "</b> to <b>" + newFileName + "</b> result <b>" + result + "</b>");
						} else {
							this.addWarning(buffer, "Skipping file " + file.getName() + ". Origin <b>" + origin + "<b> not found.");
						}
					}
				}
			}
			
			if (correctionDone) {
				this.addMessage(buffer, "Execute <a href=\"?action=isUpdateMigFiles\" title=\"Migrates files from <origine>_mig_<destination> environments\" onclick=\"return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');\" >[ Update migrated JS files ]</a> to correct data base information");
			}
		}
		
		return buffer.toString();
	}
	
	public String updateMigFiles() {
		StringBuffer buffer = new StringBuffer();
		
		File customScriptsPath = new File(Parameters.APP_PATH + File.separator + "customScripts");
		this.addMessage(buffer,"Searching directories (&lt;origin&gt;<b>" + MIG_PATH_PREFIX + "</b>&lt;destination&gt;) at: " + Parameters.APP_PATH + File.separator + "customScripts");
		
		File[] migCandidates = customScriptsPath.listFiles(new MigFilesFileFilter());
		this.addMessage(buffer,"Directories found: " + ((migCandidates != null) ? migCandidates.length : 0));
		
		if (migCandidates != null && migCandidates.length > 0) {
			DBConnection conn = null;
			PreparedStatement statement = null;
			
			try {
				this.addMessage(buffer,"Getting Apia connection...");
				conn = this.getDbConnection();
				
				statement = StatementFactory.getStatement(this.getConnection(conn), "SELECT * FROM bus_class WHERE env_id = ? AND bus_cla_type = ? AND bus_cla_executable LIKE ?", false);
				statement.setString(2, BusClassVo.TYPE_JSCPT_PROGRAMMING);
				
				for (int i = 0; i < migCandidates.length; i++) {
					File path = migCandidates[i];
					int index = path.getName().indexOf(MIG_PATH_PREFIX);
					
					String origin = path.getName().substring(0, index);
					String destination = path.getName().substring(index + MIG_PATH_PREFIX.length());
					
					this.addMessage(buffer, "Updateing migrated files from <b>" + origin + "</b> to <b>" + destination + "</b> from path <b>" + path.getAbsolutePath() + "</b>");
					
					EnvironmentVo envVo = EnvironmentDAO.getInstance().getEnvironment(conn, destination);
					
					if (envVo == null) {
						this.addWarning(buffer, "Can't find environment <b>" + destination + "</b> in database");
					} else {
						statement.setInt(1, envVo.getEnvId());
						statement.setString(3, origin + "%");
						
						ResultSet resultSet = statement.executeQuery();
						Collection busClasses = new ArrayList();
						while (resultSet.next()) busClasses.add(BusClassDAO.getInstance().createVo(conn, resultSet));
						
						this.addMessage(buffer, "Found <b>" + busClasses.size() + "</b> to correct in environment <b>" + destination + "</b>");
						
						for (Iterator it = busClasses.iterator(); it.hasNext(); ) {
							BusClassVo vo = (BusClassVo) it.next();
							String newFileName = destination + vo.getBusClaExecutable().substring(origin.length());
							
							this.addMessage(buffer, "Updateing business class <b>" + vo.getBusClaName() + "</b> from <b>" + vo.getBusClaExecutable() + "</b> to <b>" + newFileName + "</b>");
							
							vo.setBusClaExecutable(newFileName);
							vo.setEntitySyncType(BusClassVo.UPDATE);
							BusClassDAO.getInstance().synchronizeDB(conn,vo,"busClass");
						}
					}
				}
				
				this.addMessage(buffer,"Doing commit in database...");
				DBManagerUtil.commit(conn);
			} catch (Exception e) {
				this.addError(buffer,e.getMessage());
				try {
					this.addMessage(buffer,"Doing rollback in database");
					DBManagerUtil.rollback(conn);
				} catch (Exception ee) {
					this.addError(buffer,ee.getMessage());
				}
			} finally {
				if (statement != null) {
					try {
						statement.close();
					} catch (SQLException e) {
					}
				}
				if (conn != null) {
					this.addMessage(buffer,"Closeing connection...");
					DBManagerUtil.close(conn);
				}
			}
		}
		
		return buffer.toString();
	}
	
	public String correctJS() {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			
			this.addMessage(buffer,"Searching classes...");
			BusClassFilterVo filterVo = new BusClassFilterVo();
			filterVo.setType(BusClassVo.TYPE_JSCPT_PROGRAMMING);
			Collection busClasses = BusClassDAO.getInstance().getAllBusClass(conn,filterVo);
			
			if (busClasses != null && busClasses.size() > 0) {
				this.addMessage(buffer,"Classes to verifiy: <b>" + busClasses.size() + "</b>.");
				HashMap usedExecutables = new HashMap();
				
				int totalErrors = 0;
				int totalWarning = 0;
				
				boolean doRollback = false;
				
				for (Iterator it = busClasses.iterator(); it.hasNext(); ) {
					BusClassVo busClaVo = (BusClassVo) it.next();
					try {
						boolean reusedFile = usedExecutables.containsKey(busClaVo.getBusClaExecutable());
						boolean	validateFncId = true;
						
						if (reusedFile) {
							String otherBusClaVo = (String) usedExecutables.get(busClaVo.getBusClaExecutable());
							totalWarning ++;
							this.addWarning(buffer,"Bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + ".js</b> is <b>OK</b>, but executable is being used by <b>" + otherBusClaVo + "</b>.");						
							this.addInfo(buffer,"Recomended actions: clone file, rename file and update database information.");
							
							//--- Copy file and rename it
							File file = new File(Parameters.APP_PATH + File.separator + "customScripts" + File.separator + busClaVo.getFunctionName() + ".js");
							File newFile = this.newFileName(Parameters.APP_PATH + File.separator + "customScripts" + File.separator + busClaVo.getFunctionName(),".js");
							try {
								this.addDebug(buffer,"New file for bussines class <b>" +  busClaVo.getBusClaName() + "</b> file <b>" + newFile.getAbsolutePath() + "</b>.");
								FileUtil.copyFile(file,newFile);
															
								//--- Update database information
								String oldBusClaExecutable = busClaVo.getBusClaExecutable();
								String newBusClaExecutable = newFile.getName().substring(0,newFile.getName().lastIndexOf("."));
								
								this.addDebug(buffer,"Updateing database information for bussines class <b>" + busClaVo.getBusClaName() + "</b> from <b>" + oldBusClaExecutable + "</b> to <b>" + newBusClaExecutable + "</b>.");
								busClaVo.setBusClaExecutable(newBusClaExecutable);
								busClaVo.setEntitySyncType(BusClassVo.UPDATE);
								try {
									BusClassDAO.getInstance().synchronizeDB(conn,busClaVo,"busClass");
								} catch (DAOException e) {
									this.addError(buffer,"Error updateing information for bussines class <b>" + busClaVo.getBusClaName() + "</b>. Error: " + e.getMessage());
									doRollback = true;
									break;
								}
							} catch (FileNotFoundException e) {
								this.addError(buffer,"Unable to create new file for bussines class <b>" + busClaVo.getBusClaName() + "</b>. Error: " + e.getMessage() + ".");
								validateFncId = false;
							}
							
						} else {
							usedExecutables.put(busClaVo.getBusClaExecutable(), busClaVo.getBusClaName());
						}

						if (validateFncId) {
							File file = new File(Parameters.APP_PATH + File.separator + "customScripts" + File.separator + busClaVo.getFunctionName() + ".js");
					       	String jsContent = FileUtil.readFile(file);
							String idBusClass = "fnc_" + busClaVo.getEnvId().toString() + "_" + busClaVo.getBusClaId().toString();
	
							if (jsContent.indexOf(idBusClass) == -1) {
								int idx1 = jsContent.indexOf("fnc_");
								int idx2 = jsContent.indexOf("(");
								String idFound = jsContent.substring(idx1,idx2);
	
								this.addError(buffer,"The bussines class <b>" + busClaVo.getBusClaName() + "</b> has the wrong ID in file <b>" + busClaVo.getBusClaExecutable() + ".js</b>. Expected <b>" + idBusClass + "</b> found <b>" + idFound + "</b>.");
								this.addInfo(buffer,"Recomended action: update " + (reusedFile?"cloned ":"") + "file information.");
								
								this.addDebug(buffer,"Updateing bussines class <b>" + busClaVo.getBusClaName() + "</b> ID in file <b>" + file.getName() + "</b> to <b>" + idBusClass + "</b>.");
								jsContent = StringUtil.replace(jsContent,idFound,idBusClass);
								FileUtil.saveFile(jsContent,file);
							}
						} else {
							this.addInfo(buffer,"Function validation for bussiness class <b>" + busClaVo.getBusClaName() + "</b> not done.");
						}

					} catch (FileNotFoundException e) {
						totalErrors++;
						this.addError(buffer,"Can't verify bussines class <b>" + busClaVo.getBusClaName() + "</b> for executable <b>" + busClaVo.getBusClaExecutable() + ".js</b>. Error: " + e.toString() + ".");
					} catch (Exception e) {
						e.printStackTrace();
						doRollback = true;
						this.addFatal(buffer,"Error while verifying bussines class <b>" + busClaVo.getBusClaName() + "</b> (see console log). Error: " + e.toString() + ".");
						break;
					}
				}
				
				this.addMessage(buffer,"Total warning: <b>" + totalWarning + "</b>");
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (busClasses.size() - totalWarning - totalErrors) + "</b>");
				
				if (doRollback) {
					this.addMessage(buffer,"Doing rollback in database...");
					DBManagerUtil.rollback(conn);
				} else {
					this.addMessage(buffer,"Doing commit in database...");
					DBManagerUtil.commit(conn);
				}
				
			} else {
				this.addMessage(buffer,"No Java classes to verify.");
			}
		} catch (Exception e) {
			this.addError(buffer,e.getMessage());
			try {
				this.addMessage(buffer,"Doing rollback in database");
				DBManagerUtil.rollback(conn);
			} catch (Exception ee) {
				this.addError(buffer,ee.getMessage());
			}
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				DBManagerUtil.close(conn);
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}	
}
%>
<%
String action = request.getParameter("action");

boolean isVerifiyJava		= "verifyJava".equals(action);
boolean isVerifiyJavaE		= "verifyJavaE".equals(action);
boolean isVerifiyJS			= "verifyJS".equals(action);
boolean isVerifiyJSE		= "verifyJSE".equals(action);
boolean isCorrectJS			= "correctJS".equals(action);
boolean isMigFiles			= "migFiles".equals(action);
boolean isUpdateMigFiles	= "isUpdateMigFiles".equals(action);

%>

Options: 
	<%= isVerifiyJava?"<b>":"" %>    <a href="?action=verifyJava" title="Check if all require .class are available">[ Verify Java ]</a><%= isVerifiyJava?"</b>":"" %>
	<%= isVerifiyJavaE?"<b>":"" %>   <a href="?action=verifyJavaE" title="Check if all require .class are available (only shows errors/warnings)">[ Verify Java OE ]</a><%= isVerifiyJavaE?"</b>":"" %>
	<%= isVerifiyJS?"<b>":"" %>      <a href="?action=verifyJS" title="Check if all require .js are available and correct">[ Verifiy JavaScript ]</a><%= isVerifiyJS?"</b>":"" %>
	<%= isVerifiyJSE?"<b>":"" %>     <a href="?action=verifyJSE" title="Check if all require .js are available and correct (only shows errors/warnings)">[ Verifiy JavaScript OE ]</a><%= isVerifiyJSE?"</b>":"" %>
	<%= isCorrectJS?"<b>":"" %>      <a href="?action=correctJS" title="Implements 'Verifiy JavaScript' and tries to correct the files (backup of files is recomended)" onclick="return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');" >[ Correct JavaScript ]</a><%= isCorrectJS?"</b>":"" %>
	<%= isMigFiles?"<b>":"" %>       <a href="?action=migFiles" title="Migrates files from <origine>_mig_<destination> environments">[ Migrate files ]</a><%= isMigFiles?"</b>":"" %>
	<%= isUpdateMigFiles?"<b>":"" %> <a href="?action=isUpdateMigFiles" title="Migrates files from <origine>_mig_<destination> environments" onclick="return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');" >[ Update migrated JS files ]</a><%= isUpdateMigFiles?"</b>":"" %>
	<a href="?" title="Init the screen">[ Init ]</a>
	<br>
<hr>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (isVerifiyJava) {
		actionResult = test.verifyJava(true);
	} else if (isVerifiyJavaE) {
		actionResult = test.verifyJava(false);
	} else if (isVerifiyJS) {
		actionResult = test.verifiyJS(true);
	} else if (isVerifiyJSE) {
		actionResult = test.verifiyJS(false);
	} else if (isCorrectJS) {
		actionResult = test.correctJS();
	} else if (isMigFiles) {
		actionResult = test.migFiles();
	} else if (isUpdateMigFiles) {
		actionResult = test.updateMigFiles();
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div>
</body>
</html>