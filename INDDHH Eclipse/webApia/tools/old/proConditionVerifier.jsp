<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.dao.ProEleBusEntStatusDAO"%><%@page import="com.dogma.vo.ProEleBusEntStatusVo"%><%@page import="com.dogma.dao.gen.AbstractProEleBusEntStatusDAO"%><%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@ page import="com.st.db.dataAccess.*" %><%@ page import="java.util.*" %><%@ page import="java.sql.*" %><%@page import="java.io.File"%><%@page import="com.dogma.dao.ProEleDependencyDAO"%><%@page import="com.dogma.dao.ProEleDepInstanceDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleDepInstanceDAO"%><%@page import="com.dogma.vo.ProEleDependencyVo"%><%@page import="com.dogma.dao.gen.AbstractAttributeDAO"%><%@page import="com.dogma.vo.AttributeVo"%><%@page import="com.dogma.dao.gen.AbstractProEleDependencyDAO"%><%@page import="com.dogma.vo.custom.FrmFldValueVo"%><%@page import="com.dogma.dao.AttributeDAO"%><%@page import="java.io.StringReader"%><%@page import="java.util.Date"%><%@page import="com.st.util.ApiaTranslator"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.util.SQLUtil"%><%@page import="com.dogma.vo.ProElementVo"%><%@page import="com.dogma.wf.WFException"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="java.io.PrintWriter"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><html><head><title>Process Condition Verifier</title><style type="text/css">
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

protected class ProEleDependencyDaoExtension extends AbstractProEleDependencyDAO {
	public ProEleDependencyDaoExtension() {
	}
	
	public Collection getDependencies(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		Collection colRet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_dependency where pro_ele_dep_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection result = new ArrayList();
			
			while (resultSet.next()) {
				result.add(this.createProEleDependencyVo(conn,resultSet));
			}
			
			return result;
		} catch (SQLException e) {
			throw new DAOException(e, statement.toString());
		}
		finally{
			try{
				statement.close();
			} catch (SQLException sqle){
				throw new DAOException(sqle);
			}
		}
	}
}

protected class ProEleBusEntStatusDaoExtension extends AbstractProEleBusEntStatusDAO {
	public ProEleBusEntStatusDaoExtension() {
	}
	
	public Collection getDependencies(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		Collection colRet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_bus_ent_status where pro_ele_bus_ent_sta_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection result = new ArrayList();
			
			while (resultSet.next()) {
				result.add(this.createProEleBusEntStatusVo(conn,resultSet));
			}
			
			return result;
		} catch (SQLException e) {
			throw new DAOException(e, statement.toString());
		}
		finally{
			try{
				statement.close();
			} catch (SQLException sqle){
				throw new DAOException(sqle);
			}
		}
	}
}


protected class Test extends DBAdmin {
	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private Connection getConnection(DBConnection dbConn) throws Exception {
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
	
	private void addError(StringBuffer buffer, Exception e) {
		ByteArrayOutputStream byteArrayOut = new ByteArrayOutputStream();
		PrintWriter printWriter = new PrintWriter(byteArrayOut);
		e.printStackTrace(printWriter);
		printWriter.flush();
		
		this.addMessage(buffer,"<font color='red'>[ERROR]</font><pre>" + byteArrayOut.toString() + "</pre>");
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
	
	public String verify(boolean showOk) {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();

			this.addMessage(buffer,"Searching conditions...");
			Collection result = new ArrayList();
			result.addAll(new ProEleDependencyDaoExtension().getDependencies(conn));
			result.addAll(new ProEleBusEntStatusDaoExtension().getDependencies(conn));
			
			int totalErrors = 0;
			int total = 0;
			
			if (result != null && result.size() > 0) {
				this.addMessage(buffer,"Conditions to verifiy: <b>" + result.size() + "</b>.");
				for (Iterator it = result.iterator(); it.hasNext(); ) {
					Object ele = it.next();
					
					String ids = null;
					String conditionType = null;
					String sqlEvalDb = null;
					String condition = null;
					
					Integer envId = null;
					
					ProEleDependencyVo useDep = null;
					
					if (ele instanceof ProEleDependencyVo) {
						ProEleDependencyVo depVo = (ProEleDependencyVo) ele;
						
						ids = 
							depVo.getEnvId().toString() + "-" +
							depVo.getProId().toString() + "-" +
							depVo.getProVerId().toString() + "-" +
							depVo.getProEleIdFrom().toString() + "-" +
							depVo.getProEleIdTo().toString();

						conditionType = "Dependency";
						sqlEvalDb = depVo.getProEleDepEvalSql();
						
						if (depVo.getProEleDepName() == null) {
							condition = depVo.getProEleDepEvalCond();
						} else {
							condition = depVo.getProEleDepName() + " (" + depVo.getProEleDepEvalCond() + ")";
						}
						
						envId = depVo.getEnvId();
						useDep = depVo;
					} else if (ele instanceof ProEleBusEntStatusVo) {
						ProEleBusEntStatusVo staVo = (ProEleBusEntStatusVo) ele;
						
						ids = 
							staVo.getEnvId().toString() + "-" +
							staVo.getProId().toString() + "-" +
							staVo.getProVerId().toString() + "-" +
							staVo.getProEleId().toString() + "-" +
							staVo.getBusEntId().toString() + "-" +
							staVo.getEntStaId().toString() + "-" +
							staVo.getEvtId().toString();

						conditionType = "Status";
						sqlEvalDb = staVo.getProEleBusEntStaEvalSql();
						condition = staVo.getProEleBusEntStaEvalCond();
						
						envId = staVo.getEnvId();
						
						useDep = new ProEleDependencyVo();
						useDep.setProEleDepEvalCond(condition);
					}

					useDep.setToProEleReference("to");
					useDep.setFromProEleReference("to");
					
					ProElementVo eleVo = new ProElementVo();
					eleVo.setDependencies(new ArrayList());
					eleVo.getDependencies().add(useDep);
					eleVo.setProEleIteration(new Integer(1));
					
					try {
						eleVo.getDepForValidation(conn, envId);
					} catch (Exception e) {
						this.addError(buffer,"Condition " + conditionType + " (envId: " + envId + ") <b>" + condition + "</b> error.");
						this.addError(buffer,e);
						
						continue;
					}
					
					String sqlEvalGen = useDep.getProEleDepEvalSql();
					
					if (ele instanceof ProEleDependencyVo) {
						ProEleDependencyVo depVo = (ProEleDependencyVo) ele;
						depVo.setProEleDepEvalSql(sqlEvalGen);
						
					} else if (ele instanceof ProEleBusEntStatusVo) {
						ProEleBusEntStatusVo staVo = (ProEleBusEntStatusVo) ele;
						staVo.setProEleBusEntStaEvalSql(sqlEvalGen);
					}
					
					if (sqlEvalDb == null || ! sqlEvalDb.equals(sqlEvalGen)) {
						if (sqlEvalGen != null) {
							totalErrors ++;
							this.addWarning(buffer,"Condition " + conditionType + " (envId: " + envId + ") <b>" + condition + "</b> is incorrect.");
							this.addInfo(buffer,"In db: <b>" + sqlEvalDb + "</b> - excepcted: <b>" + sqlEvalGen + "</b>");
							this.addInfo(buffer,"Recomended actions: update condition.");
						}
					} else if (showOk) {
						this.addMessage(buffer,"Condition " + conditionType + " (envId: " + envId + ") <b>" + condition + "</b> is <b>OK</b>.");						
					}
					total ++;
				}
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (result.size() - totalErrors) + "</b>");
			} else {
				this.addMessage(buffer,"No conditions to verify");
			}
		} catch (Exception e) {
			this.addError(buffer,e);
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				DBManagerUtil.close(conn);
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
	
	public String correct() {
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();

			this.addMessage(buffer,"Searching conditions...");
			Collection result = new ArrayList();
			result.addAll(new ProEleDependencyDaoExtension().getDependencies(conn));
			result.addAll(new ProEleBusEntStatusDaoExtension().getDependencies(conn));
			
			int totalErrors = 0;
			boolean doRollback = false;
			
			if (result != null && result.size() > 0) {
				this.addMessage(buffer,"Conditions to verifiy: <b>" + result.size() + "</b>.");
				for (Iterator it = result.iterator(); it.hasNext(); ) {
					Object ele = it.next();
					
					String ids = null;
					String conditionType = null;
					String sqlEvalDb = null;
					String condition = null;
					
					Integer envId = null;
					
					ProEleDependencyVo useDep = null;
					
					if (ele instanceof ProEleDependencyVo) {
						ProEleDependencyVo depVo = (ProEleDependencyVo) ele;
						
						ids = 
							depVo.getEnvId().toString() + "-" +
							depVo.getProId().toString() + "-" +
							depVo.getProVerId().toString() + "-" +
							depVo.getProEleIdFrom().toString() + "-" +
							depVo.getProEleIdTo().toString();

						conditionType = "Dependency";
						sqlEvalDb = depVo.getProEleDepEvalSql();
						
						if (depVo.getProEleDepName() == null) {
							condition = depVo.getProEleDepEvalCond();
						} else {
							condition = depVo.getProEleDepName() + " (" + depVo.getProEleDepEvalCond() + ")";
						}
						
						envId = depVo.getEnvId();
						useDep = depVo;
					} else if (ele instanceof ProEleBusEntStatusVo) {
						ProEleBusEntStatusVo staVo = (ProEleBusEntStatusVo) ele;

						ids = 
							staVo.getEnvId().toString() + "-" +
							staVo.getProId().toString() + "-" +
							staVo.getProVerId().toString() + "-" +
							staVo.getProEleId().toString() + "-" +
							staVo.getBusEntId().toString() + "-" +
							staVo.getEntStaId().toString() + "-" +
							staVo.getEvtId().toString();
						
						conditionType = "Status";
						sqlEvalDb = staVo.getProEleBusEntStaEvalSql();
						condition = staVo.getProEleBusEntStaEvalCond();
						
						envId = staVo.getEnvId();
						
						useDep = new ProEleDependencyVo();
						useDep.setProEleDepEvalCond(condition);
						useDep.setToProEleReference("to");
						useDep.setFromProEleReference("to");
					}

					useDep.setToProEleReference("to");
					useDep.setFromProEleReference("to");
					
					ProElementVo eleVo = new ProElementVo();
					eleVo.setDependencies(new ArrayList());
					eleVo.getDependencies().add(useDep);
					eleVo.setProEleIteration(new Integer(1));
					
					try {
						eleVo.getDepForValidation(conn, envId);
					} catch (Exception e) {
						this.addError(buffer,"Condition " + conditionType + " (envId: " + envId + ") <b>" + condition + "</b> error.");
						this.addError(buffer,e);
						
						continue;
					}
					
					String sqlEvalGen = useDep.getProEleDepEvalSql();
					
					if (ele instanceof ProEleDependencyVo) {
						ProEleDependencyVo depVo = (ProEleDependencyVo) ele;
						depVo.setEntitySyncType(ProEleDependencyVo.UPDATE);
						depVo.setProEleDepEvalSql(sqlEvalGen);
						
					} else if (ele instanceof ProEleBusEntStatusVo) {
						ProEleBusEntStatusVo staVo = (ProEleBusEntStatusVo) ele;
						staVo.setEntitySyncType(ProEleDependencyVo.UPDATE);
						staVo.setProEleBusEntStaEvalSql(sqlEvalGen);
					}

					if (sqlEvalDb == null || ! sqlEvalDb.equals(sqlEvalGen)) {
						if (sqlEvalGen != null) {
							totalErrors ++;
							this.addWarning(buffer,"Condition " + conditionType + " (envId: " + envId + ") <b>" + condition + "</b> is incorrect.");
							this.addInfo(buffer,"In db: <b>" + sqlEvalDb + "</b> - excepcted: <b>" + sqlEvalGen + "</b>");
							this.addInfo(buffer,"Recomended actions: update condition.");
							
							this.addDebug(buffer,"Updateing condition to: " + sqlEvalGen + " - " + ids);
							try {
								if (ele instanceof ProEleDependencyVo) {
									ProEleDependencyVo depVo = (ProEleDependencyVo) ele;
									ProEleDependencyDAO.getInstance().synchronizeDB(conn,depVo,"busClass");
								} else if (ele instanceof ProEleBusEntStatusVo) {
									ProEleBusEntStatusVo staVo = (ProEleBusEntStatusVo) ele;
									ProEleBusEntStatusDAO.getInstance().synchronizeDB(conn,staVo,"busClass");
								}
							} catch (Exception e) {
								e.printStackTrace();
								doRollback = true;
								this.addFatal(buffer,"Error while correcting condition " + conditionType + ": <b>" + condition + "</b> (see console log). Error: " + e.toString() + ".");
								this.addFatal(buffer,StringUtil.toString(e, true));
							}
						}
					}
				}
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (result.size() - totalErrors) + "</b>");
				
				if (doRollback) {
					this.addMessage(buffer,"Doing rollback in database...");
					DBManagerUtil.rollback(conn);
				} else {
					this.addMessage(buffer,"Doing commit in database...");
					DBManagerUtil.commit(conn);
				}
				
			} else {
				this.addMessage(buffer,"No conditions to verify");
			}
		} catch (Exception e) {
			this.addError(buffer,e);
			try {
				this.addMessage(buffer,"Doing rollback in database");
				conn.rollback();
			} catch (Exception ee) {
				this.addError(buffer,ee);
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
%><%
String action = request.getParameter("action");

boolean isVerifiy	= "verify".equals(action);
boolean isVerifiyOE	= "verifyOE".equals(action);
boolean isCorrect	= "correct".equals(action);

%>

Options: 
	<%= isVerifiy?"<b>":"" %><a href="?action=verify" title="Check if all process conditions are OK">[ Verify process conditions ]</a><%= isVerifiy?"</b>":"" %><%= isVerifiyOE?"<b>":"" %><a href="?action=verifyOE" title="Check if all process conditions are OK">[ Verify process conditions OE]</a><%= isVerifiyOE?"</b>":"" %><%= isCorrect?"<b>":"" %><a href="?action=correct" title="Correct all bad process conditions" onclick="return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');">[ Correct process conditions ]</a><%= isCorrect?"</b>":"" %><a href="?" title="Init the screen">[ Init ]</a><br><hr><div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (isVerifiy) {
		actionResult = test.verify(true);
	} else if (isVerifiyOE) {
		actionResult = test.verify(false);
	} else if (isCorrect) {
		actionResult = test.correct();
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div></body></html>
	