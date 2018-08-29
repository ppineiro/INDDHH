<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@ page import="com.st.db.dataAccess.*" %><%@ page import="java.util.*" %><%@ page import="java.sql.*" %><%@page import="java.io.File"%><%@page import="com.dogma.dao.ProEleDependencyDAO"%><%@page import="com.dogma.dao.ProEleDepInstanceDAO"%><%@page import="com.dogma.dao.ProEleBusEntFormDAO"%><%@page import="com.dogma.dao.ProEleBusEntStatusDAO"%><%@page import="com.dogma.dao.ProEleFormDAO"%><%@page import="com.dogma.dao.ProElePoolDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleDepInstanceDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleBusEntFormDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleBusEntStatusDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleFormDAO"%><%@page import="com.dogma.dao.gen.AbstractProElePoolDAO"%><%@page import="com.dogma.dao.gen.AbstractAttributeDAO"%><%@page import="com.dogma.dao.gen.AbstractProEleDependencyDAO"%><%@page import="com.dogma.vo.ProEleDependencyVo"%><%@page import="com.dogma.vo.ProEleBusEntFormVo"%><%@page import="com.dogma.vo.ProEleBusEntStatusVo"%><%@page import="com.dogma.vo.ProEleFormVo"%><%@page import="com.dogma.vo.ProElePoolVo"%><%@page import="com.dogma.vo.gen.BasicVo"%><%@page import="com.dogma.vo.AttributeVo"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.vo.custom.FrmFldValueVo"%><%@page import="com.dogma.dao.AttributeDAO"%><%@page import="java.io.StringReader"%><%@page import="java.util.Date"%><%@page import="com.st.util.ApiaTranslator"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.util.SQLUtil"%><%@page import="com.dogma.vo.ProElementVo"%><%@page import="java.io.ByteArrayOutputStream"%><%@page import="java.io.PrintWriter"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><html><head><title>Process Condition Verifier 2</title><style type="text/css">
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
	
	public Collection<ProEleDependencyVo> getAllWithCondition(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_dependency where pro_ele_dep_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection<ProEleDependencyVo> result = new ArrayList<ProEleDependencyVo>();
			
			while (resultSet.next()) result.add(this.createProEleDependencyVo(conn,resultSet));
			
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

protected class ProEleBusEntFormDaoExtension extends AbstractProEleBusEntFormDAO {
	public ProEleBusEntFormDaoExtension() {
	}
	
	public Collection<ProEleBusEntFormVo> getAllWithCondition(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_bus_ent_form where pro_ele_bus_ent_frm_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection<ProEleBusEntFormVo> result = new ArrayList<ProEleBusEntFormVo>();
			
			while (resultSet.next()) result.add(this.createProEleBusEntFormVo(conn,resultSet));
			
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
	
	public Collection<ProEleBusEntStatusVo> getAllWithCondition(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_bus_ent_status where pro_ele_bus_ent_sta_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection<ProEleBusEntStatusVo> result = new ArrayList<ProEleBusEntStatusVo>();
			
			while (resultSet.next()) result.add(this.createProEleBusEntStatusVo(conn,resultSet));
			
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

protected class ProEleFormDaoExtension extends AbstractProEleFormDAO {
	public ProEleFormDaoExtension() {
	}
	
	public Collection<ProEleFormVo> getAllWithCondition(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_form where pro_ele_frm_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection<ProEleFormVo> result = new ArrayList<ProEleFormVo>();
			
			while (resultSet.next()) result.add(this.createProEleFormVo(conn,resultSet));
			
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

protected class ProElePoolDaoExtension extends AbstractProElePoolDAO {
	public ProElePoolDaoExtension() {
	}
	
	public Collection<ProElePoolVo> getAllWithCondition(DBConnection conn) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try {
			Connection dbConn = super.getDBConnection(conn);
		
			statement = StatementFactory.getStatement(dbConn,"select * from pro_ele_pool where pro_ele_pool_eval_cond is not null",true);
			resultSet = statement.executeQuery();
			
			Collection<ProElePoolVo> result = new ArrayList<ProElePoolVo>();
			
			while (resultSet.next()) result.add(this.createProElePoolVo(conn,resultSet));
			
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
	
	private String generateEvalSql(DBConnection conn, Integer envId, String evalCond) throws Exception {
		ProEleDependencyVo depVo = new ProEleDependencyVo();
		depVo.setEnvId(envId);
		depVo.setProEleDepEvalCond(evalCond);
		depVo.setToProEleReference("to");
		depVo.setFromProEleReference("to");

		ProElementVo eleVo = new ProElementVo();
		eleVo.setDependencies(new ArrayList());
		eleVo.getDependencies().add(depVo);
		eleVo.setProEleIteration(new Integer(1));
		eleVo.getDepForValidation(conn, depVo.getEnvId());
		
		return depVo.getProEleDepEvalSql();
	}
	
	//--------------------------------
	
	public String verify(boolean showOk, boolean correct) {
		if (correct) showOk = false;
		
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();

			this.addMessage(buffer,"Searching conditions...");
			Collection result = new ArrayList();
			result.addAll(new ProEleBusEntFormDaoExtension().getAllWithCondition(conn));
			result.addAll(new ProEleBusEntStatusDaoExtension().getAllWithCondition(conn));
			result.addAll(new ProEleDependencyDaoExtension().getAllWithCondition(conn));
			result.addAll(new ProEleFormDaoExtension().getAllWithCondition(conn));
			result.addAll(new ProElePoolDaoExtension().getAllWithCondition(conn));
			
			int totalErrors = 0;
			int total = 0;
			boolean doRollback = false;
			
			if (result != null && result.size() > 0) {
				this.addMessage(buffer,"Conditions to verifiy: <b>" + result.size() + "</b>.");
				for (Iterator it = result.iterator(); it.hasNext(); ) {
					
					Object obj = it.next();
					String condition = null;
					String ids = obj.getClass().getName() + "-";
					String sqlEvalDb = null;
					String sqlEvalGen = null;
					
					((BasicVo) obj).setEntitySyncType(BasicVo.UPDATE);
					
					if (obj instanceof ProEleDependencyVo) {
						ProEleDependencyVo vo = (ProEleDependencyVo) obj;
						ids += 
							vo.getEnvId().toString() + "-" +
							vo.getProId().toString() + "-" +
							vo.getProVerId().toString() + "-" +
							vo.getProEleIdFrom().toString() + "-" +
							vo.getProEleIdTo().toString();
	
						sqlEvalDb = vo.getProEleDepEvalSql();
						sqlEvalGen = this.generateEvalSql(conn, vo.getEnvId(), vo.getProEleDepEvalCond());
						
						if (vo.getProEleDepName() == null) {
							condition = vo.getProEleDepEvalCond();
						} else {
							condition = vo.getProEleDepName() + " (" + vo.getProEleDepEvalCond() + ")";
						}
					} else if (obj instanceof ProEleBusEntFormVo) {
						ProEleBusEntFormVo vo = (ProEleBusEntFormVo) obj;
						ids +=
							vo.getEnvId().toString() + "-" +
							vo.getProId().toString() + "-" +
							vo.getProVerId().toString() + "-" +
							vo.getBusEntId().toString() + "-" +
							vo.getFrmId().toString();

						condition = vo.getProEleBusEntFrmEvalCond();
						sqlEvalDb = vo.getProEleBusEntFrmEvalSql();
						sqlEvalGen = this.generateEvalSql(conn, vo.getEnvId(), vo.getProEleBusEntFrmEvalCond());

					} else if (obj instanceof ProEleBusEntStatusVo) {
						ProEleBusEntStatusVo vo = (ProEleBusEntStatusVo) obj;
						ids +=
							vo.getEnvId().toString() + "-" +
							vo.getProId().toString() + "-" +
							vo.getProVerId().toString() + "-" +
							vo.getBusEntId().toString() + "-" +
							vo.getEntStaId().toString();

						condition = vo.getProEleBusEntStaEvalCond();
						sqlEvalDb = vo.getProEleBusEntStaEvalSql();
						sqlEvalGen = this.generateEvalSql(conn, vo.getEnvId(), vo.getProEleBusEntStaEvalCond());
					
					} else if (obj instanceof ProEleFormVo) {
						ProEleFormVo vo = (ProEleFormVo) obj;

						ids +=
							vo.getEnvId().toString() + "-" +
							vo.getProId().toString() + "-" +
							vo.getProVerId().toString() + "-" +
							vo.getFrmId().toString() + "-";

						condition = vo.getProEleFrmEvalCond();
						sqlEvalDb = vo.getProEleFrmEvalSql();
						sqlEvalGen = this.generateEvalSql(conn, vo.getEnvId(), vo.getProEleFrmEvalCond());

					} else if (obj instanceof ProElePoolVo) {
						ProElePoolVo vo = (ProElePoolVo) obj;

						ids +=
							vo.getEnvId().toString() + "-" +
							vo.getProId().toString() + "-" +
							vo.getProVerId().toString() + "-" +
							vo.getPoolId().toString() + "-";

						condition = vo.getProElePoolEvalCond();
						sqlEvalDb = vo.getProElePoolEvalSql();
						sqlEvalGen = this.generateEvalSql(conn, vo.getEnvId(), vo.getProElePoolEvalCond());
					}
					
					
					if (sqlEvalDb == null || ! sqlEvalDb.equals(sqlEvalGen)) {
						if (sqlEvalGen != null) {
							totalErrors ++;
							this.addWarning(buffer,"Condition <b>" + condition + "</b> is incorrect (" + ids + ").");
							this.addInfo(buffer,"In db: <b>" + sqlEvalDb + "</b> - excepcted: <b>" + sqlEvalGen + "</b>");
							this.addInfo(buffer,"Recomended actions: update condition.");
							
							if (correct) {
								this.addDebug(buffer,"Updateing condition to: " + sqlEvalGen + " (" + ids + ")");
								try {
									if (obj instanceof ProEleDependencyVo) {
										ProEleDependencyVo vo = (ProEleDependencyVo) obj;
										vo.setProEleDepEvalSql(sqlEvalGen);
										ProEleDependencyDAO.getInstance().synchronizeDB(conn,vo,"busClass");
									
									} else if (obj instanceof ProEleBusEntFormVo) {
										ProEleBusEntFormVo vo = (ProEleBusEntFormVo) obj;
										vo.setProEleBusEntFrmEvalSql(sqlEvalGen);
										ProEleBusEntFormDAO.getInstance().synchronizeDB(conn,vo,"busClass");
									
									} else if (obj instanceof ProEleBusEntStatusVo) {
										ProEleBusEntStatusVo vo = (ProEleBusEntStatusVo) obj;
										vo.setProEleBusEntStaEvalSql(sqlEvalGen);
										ProEleBusEntStatusDAO.getInstance().synchronizeDB(conn,vo,"busClass");
									
									} else if (obj instanceof ProEleFormVo) {
										ProEleFormVo vo = (ProEleFormVo) obj;
										vo.setProEleFrmEvalSql(sqlEvalGen);
										ProEleFormDAO.getInstance().synchronizeDB(conn,vo,"busClass");
									
									} else if (obj instanceof ProElePoolVo) {
										ProElePoolVo vo = (ProElePoolVo) obj;
										vo.setProElePoolEvalSql(sqlEvalGen);
										ProElePoolDAO.getInstance().synchronizeDB(conn,vo,"busClass");
									}
										
								} catch (Exception e) {
									e.printStackTrace();
									doRollback = true;
									this.addFatal(buffer,"Error while correcting condition: <b>" + condition + "</b> (see console log). Error: " + e.toString() + ".");
								}
							}
						}
					} else if (showOk) {
						this.addMessage(buffer,"Condition <b>" + condition + "</b> is <b>OK</b>.");						
					}
					total ++;
				}
				this.addMessage(buffer,"Total error: <b>" + totalErrors + "</b>");
				this.addMessage(buffer,"Total OK: <b>" + (result.size() - totalErrors) + "</b>");
				
				if (correct) {
					if (doRollback) {
						this.addMessage(buffer,"Doing rollback in database...");
						DBManagerUtil.rollback(conn);
					} else {
						this.addMessage(buffer,"Doing commit in database...");
						DBManagerUtil.commit(conn);
					}
				}
			} else {
				this.addMessage(buffer,"No conditions to verify");
			}
		} catch (Exception e) {
			this.addError(buffer,e);
			if (correct) {
				try {
					this.addMessage(buffer,"Doing rollback in database");
					conn.rollback();
				} catch (Exception ee) {
					this.addError(buffer,ee.getMessage());
				}
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
		actionResult = test.verify(true, false);
	} else if (isVerifiyOE) {
		actionResult = test.verify(false, false);
	} else if (isCorrect) {
		actionResult = test.verify(false, true);
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div></body></html>
	