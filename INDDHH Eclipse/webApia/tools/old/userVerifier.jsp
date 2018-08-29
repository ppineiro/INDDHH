<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.st.db.dataAccess.DBConnection"%><%@page import="java.sql.Connection"%><%@page import="com.st.db.dataAccess.ConnectionDAO"%><%@page import="com.st.db.dataAccess.DBAdmin"%><%@page import="com.st.db.dataAccess.DBManager"%><%@page import="com.dogma.dao.UserDAO"%><%@page import="java.util.Collection"%><%@page import="com.dogma.vo.UserVo"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.dao.PoolDAO"%><%@page import="com.dogma.vo.PoolVo"%><%@page import="com.dogma.vo.UsrPoolVo"%><%@page import="com.dogma.dao.UsrPoolDAO"%><%@page import="com.dogma.dao.EnvUserDAO"%><%@page import="com.dogma.vo.EnvUserVo"%><%@page import="com.dogma.vo.EnvPoolVo"%><%@page import="com.dogma.dao.EnvPoolDAO"%><html><head><title>UserVerifier</title><style type="text/css">
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
	</style></head><body><%!
protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class Test extends DBAdmin {
	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
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
	public String correctUsers(boolean doCommit) {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;
		
		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			
			this.addMessage(buffer,"Searching users...");
			Collection users = UserDAO.getInstance().getAllUsers(conn);
			
			if (users == null || users.size() == 0) {
				this.addMessage(buffer,"No users where found to process.");
			} else {
				this.addMessage(buffer,"Users loaded: " + users.size());
				
				int countError = 0;
				
				for(Iterator it = users.iterator(); it.hasNext(); ) {
					UserVo usrVo = (UserVo) it.next();
					
					Collection usrPools = PoolDAO.getInstance().getUserPools(conn, usrVo.getUsrLogin());
					boolean mustCheckAutogeneratedExists = false;
					boolean mustCreateAndAssociatePool = false;
					boolean mustAssociatePool = false;
					PoolVo associateWithPool = null;
					
					if (usrPools == null || usrPools.size() == 0) {
						this.addWarning(buffer,"User <b>" + usrVo.getUsrLogin() + "</b> has no autogenerated pool asociated.");
						countError ++;
						mustCheckAutogeneratedExists = true;
					} else {
						PoolVo poolGeneratedVo = null;
						for (Iterator itP = usrPools.iterator(); itP.hasNext(); ) {
							PoolVo poolVo = (PoolVo) itP.next();
							if (poolVo.getPoolName().equals(usrVo.getUsrLogin())) {
								poolGeneratedVo = poolVo;
								break;
							}
						}
						
						if (poolGeneratedVo == null) {
							mustCheckAutogeneratedExists = true;
						} else if ("0".equals(poolGeneratedVo.getPoolGenerated())) {
							mustCreateAndAssociatePool = true;
						}
					}
					
					if (mustCheckAutogeneratedExists) {
						PoolVo poolVo = PoolDAO.getInstance().getPoolVo(conn, usrVo.getUsrLogin(), new Boolean(true));
						if (poolVo == null) {
							mustCreateAndAssociatePool = true;
						} else if ("1".equals(poolVo.getPoolGenerated())) {
							associateWithPool = poolVo;
							mustAssociatePool = true;
						} else {
							mustCreateAndAssociatePool = true;
						}
					}
					
					if (mustCreateAndAssociatePool) {
						this.addInfo(buffer,"Createing pool");
						PoolVo poolVo = new PoolVo();
						poolVo.setEntitySyncType(PoolVo.INSERT);
						poolVo.setPoolGenerated(PoolVo.POOL_AUTOGENERATED);
						poolVo.setPoolName(usrVo.getUsrLogin().toLowerCase());
						poolVo.setPoolAllEnvs(new Integer(usrVo.getFlagValue(UserVo.FLAG_ALL_ENV) ? 1 : 0));
						poolVo.setPoolDesc("Autogenerated for user " + usrVo.getUsrLogin());
						PoolDAO.getInstance().synchronizeDB(conn, poolVo, "userVerifier.jsp");
						this.addInfo(buffer,"Pool created with id: " + poolVo.getPoolId());

						if (! usrVo.getFlagValue(UserVo.FLAG_ALL_ENV)) {
							this.addInfo(buffer, "Associateing pool to user environments");
							Collection usrEnvs = EnvUserDAO.getInstance().getEnvironmentsUsers(conn, usrVo.getUsrLogin());
							if (usrEnvs != null) {
								for (Iterator itE = usrEnvs.iterator(); itE.hasNext();) {
									EnvUserVo envUserVo = (EnvUserVo) itE.next();
									
									EnvPoolVo envPoolVo = new EnvPoolVo();
									envPoolVo.setEntitySyncType(EnvPoolVo.INSERT_RELATION);
							        envPoolVo.setEnvId(envUserVo.getEnvId());
							        envPoolVo.setPoolId(poolVo.getPoolId());
							        EnvPoolDAO.getInstance().synchronizeDB(conn, envPoolVo, "userVerifier.jsp");
								}
							}
						}
						
						this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> has been created.");
						mustAssociatePool = true;
						associateWithPool = poolVo;
					}
					
					if (mustAssociatePool) {
						this.addInfo(buffer,"Associateing user with pool: " + associateWithPool.getPoolId());
						UsrPoolVo vo = new UsrPoolVo();
						vo.setEntitySyncType(UsrPoolVo.INSERT);
						vo.setUsrLogin(usrVo.getUsrLogin());
						vo.setPoolId(associateWithPool.getPoolId());
						UsrPoolDAO.getInstance().synchronizeDB(conn, vo, "userVerifier.jsp");
						
						this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> has been associated.");
					}
				}
				
				this.addMessage(buffer,"Users ok: " + (users.size() - countError));
				this.addMessage(buffer,"Users with error: " + countError);
			}

			if (doCommit) {
				this.addMessage(buffer,"Doing commit in database...");
				conn.commit();
			} else {
				this.addMessage(buffer,"Doing rollback in database");
				conn.rollback();
			}
				
		} catch (Throwable e) {
			this.addError(buffer,e.getMessage());
			try {
				this.addMessage(buffer,"Doing rollback in database");
				conn.rollback();
			} catch (Exception ee) {
				this.addError(buffer,ee.getMessage());
			}
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				conn.close();
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
	
	public String checkUsers() {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;
		
		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			
			this.addMessage(buffer,"Searching users...");
			Collection users = UserDAO.getInstance().getAllUsers(conn);
			
			if (users == null || users.size() == 0) {
				this.addMessage(buffer,"No users where found to process.");
			} else {
				this.addMessage(buffer,"Users loaded: " + users.size());
				
				int countError = 0;
				
				for(Iterator it = users.iterator(); it.hasNext(); ) {
					UserVo usrVo = (UserVo) it.next();
					
					Collection usrPools = PoolDAO.getInstance().getUserPools(conn, usrVo.getUsrLogin());
					boolean mustCheckAutogeneratedExists = false;
					if (usrPools == null || usrPools.size() == 0) {
						this.addWarning(buffer,"User <b>" + usrVo.getUsrLogin() + "</b> has no autogenerated pool asociated.");
						countError ++;
						mustCheckAutogeneratedExists = true;
					} else {
						PoolVo poolGeneratedVo = null;
						for (Iterator itP = usrPools.iterator(); itP.hasNext(); ) {
							PoolVo poolVo = (PoolVo) itP.next();
							if (poolVo.getPoolName().equals(usrVo.getUsrLogin())) {
								poolGeneratedVo = poolVo;
								break;
							}
						}
						
						if (poolGeneratedVo == null) {
							mustCheckAutogeneratedExists = true;
						} else if ("0".equals(poolGeneratedVo.getPoolGenerated())) {
							this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> exists but is not an autogenerated pool. Id: " + poolGeneratedVo.getPoolId() + ". Recomended action: create pool and associate it.");
						}
					}
					
					if (mustCheckAutogeneratedExists) {
						PoolVo poolVo = PoolDAO.getInstance().getPoolVo(conn, usrVo.getUsrLogin(), new Boolean(true));
						if (poolVo == null) {
							this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> does not exists. Recomented action: create autogenerated pool and associate it.");
						} else if ("1".equals(poolVo.getPoolGenerated())) {
							this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> exists. Id: " + poolVo.getPoolId() + ". Recomended action: associate pool.");
						} else {
							this.addInfo(buffer,"The autogenerated pool for user <b>" + usrVo.getUsrLogin() + "</b> exists but is not an autogenerated pool. Id: " + poolVo.getPoolId() + ". Recomended action: create pool and associate it.");
						}
					}
				}
				
				this.addMessage(buffer,"Users ok: " + (users.size() - countError));
				this.addMessage(buffer,"Users with error: " + countError);
			}

		} catch (Throwable e) {
			this.addError(buffer,e.getMessage());
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				conn.close();
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
}
%><%
String action = request.getParameter("action");

boolean isCheckUsers	= "checkUsers".equals(action);
boolean isCorrectUsers	= "correctUsers".equals(action);
boolean isCorrectUsersC	= "correctUsersC".equals(action);

%>
Options: 
	<%= isCheckUsers?"<b>":"" %><a href="?action=checkUsers" title="Check if all users have a corresponding autogenerated group">[ Check users ]</a><%= isCheckUsers?"</b>":"" %><%= isCorrectUsers?"<b>":"" %><a href="?action=correctUsers" title="For those users that don't have an autogenerated group, it creats and associate one">[ Correct users ]</a><%= isCorrectUsers?"</b>":"" %><%= isCorrectUsersC?"<b>":"" %><a href="?action=correctUsersC" title="For those users that don't have an autogenerated group, it creats and associate one and impacts changes into the database">[ Correct users and impact ]</a><%= isCorrectUsersC?"</b>":"" %><br><hr><div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (isCheckUsers) {
		actionResult = test.checkUsers();
	} else if (isCorrectUsers) {
		actionResult = test.correctUsers(false);
	} else if (isCorrectUsersC) {
		actionResult = test.correctUsers(true);
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div></body></html>