
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.dogma.vo.FunctionalityVo"%>
<%@page import="java.util.Collection"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.st.db.dataAccess.StatementFactory"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="com.dogma.dataAccess.DBManagerUtil"%><html>
<head>
	<title>Repeated Imported Functionality Verifier</title>
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

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
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
	
	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(System.currentTimeMillis() + ": " + msg + "<br>");
	}
	
	private void addLine(StringBuffer buffer) {
		buffer.append("<br>");
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
	
	private void updateProcessToUse(Connection conn, Integer fncIdToKeep, Collection<Integer> idsWithError) throws SQLException {
		String sql = "update process set fnc_id = ? where fnc_id in (";
		for (int i = 0; i < idsWithError.size() - 1; i++) {
			if (i > 0) sql += ",";
			sql += "?";
		}
		sql += ")";
		
		PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
		int pos = 1; 
		statement.setInt(pos++, fncIdToKeep.intValue());
		for (Integer id : idsWithError) if (! fncIdToKeep.equals(id)) statement.setInt(pos++, id.intValue());
		
		try {
			statement.execute();
		} finally {
			statement.close();
		}
	}
	
	private void updatePrfFunctionalityToUse(Connection conn, Integer fncIdToKeep, Collection<Integer> idsWithError) throws SQLException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		Collection<Integer> profilesToDeleteFrom = null;
		
		//Determinar en que perfiles ya está la funcionadlidad ingresada
		statement = StatementFactory.getStatement(conn, "select prf_id from prf_funcionality where fnc_id = ?" , false);
		statement.setInt(1, fncIdToKeep);
		
		try {
			resultSet = statement.executeQuery();
			profilesToDeleteFrom = new ArrayList<Integer>();
			while (resultSet.next()) {
				profilesToDeleteFrom.add(Integer.valueOf(resultSet.getInt("prf_id")));
			}
		} finally {
			statement.close();
		}
		
		//Eliminar las funcionalidades para que no den error de pk
		if(profilesToDeleteFrom != null && profilesToDeleteFrom.size() > 0) {
			statement = StatementFactory.getStatement(conn, "delete from prf_funcionality where fnc_id = ? and prf_id = ?" , false);
			try {
				for (Integer fncId : idsWithError) {
					if (fncIdToKeep.equals(fncId)) continue;
					statement.setInt(1, fncId.intValue());
					
					for (Integer prfId : profilesToDeleteFrom) {
						statement.setInt(2, prfId.intValue());
						statement.execute();
					}
				}
			} finally {
				statement.close();
			}
		}
		
		//Actualizar los perfiles para apuntar a la nueva funcionalidad
		String sql = "update prf_funcionality set fnc_id = ? where fnc_id in (";
		for (int i = 0; i < idsWithError.size() - 1; i++) {
			if (i > 0) sql += ",";
			sql += "?";
		}
		sql += ")";
		
		statement = StatementFactory.getStatement(conn, sql, false);
		int pos = 1; 
		statement.setInt(pos++, fncIdToKeep.intValue());
		for (Integer id : idsWithError) if (! fncIdToKeep.equals(id)) statement.setInt(pos++, id.intValue());
		
		try {
			statement.execute();
		} finally {
			statement.close();
		}
	}
	
	private void updateEnvPrfFunctionalityToUse(Connection conn, Integer fncIdToKeep, Collection<Integer> idsWithError) throws SQLException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		Collection<Integer[]> profilesToDeleteFrom = null;
		
		//Determinar en que perfiles ya está la funcionadlidad ingresada
		statement = StatementFactory.getStatement(conn, "select env_id, prf_id from env_prf_functionality where fnc_id = ?" , false);
		statement.setInt(1, fncIdToKeep);
		
		try {
			resultSet = statement.executeQuery();
			profilesToDeleteFrom = new ArrayList<Integer[]>();
			while (resultSet.next()) {
				profilesToDeleteFrom.add(new Integer[] { Integer.valueOf(resultSet.getInt("env_id")), Integer.valueOf(resultSet.getInt("prf_id")) } );
			}
		} finally {
			statement.close();
		}
		
		//Eliminar las funcionalidades para que no den error de pk
		if(profilesToDeleteFrom != null && profilesToDeleteFrom.size() > 0) {
			statement = StatementFactory.getStatement(conn, "delete from env_prf_functionality where fnc_id = ? and env_id = ? and prf_id = ?" , false);
			try {
				for (Integer fncId : idsWithError) {
					if (fncIdToKeep.equals(fncId)) continue;
					statement.setInt(1, fncId.intValue());
					
					for (Integer[] envPrfId : profilesToDeleteFrom) {
						statement.setInt(2, envPrfId[0].intValue());
						statement.setInt(3, envPrfId[1].intValue());
						statement.execute();
					}
				}
			} finally {
				statement.close();
			}
		}
		
		//Actualizar los perfiles para apuntar a la nueva funcionalidad
		String sql = "update env_prf_functionality set fnc_id = ? where fnc_id in (";
		for (int i = 0; i < idsWithError.size() - 1; i++) {
			if (i > 0) sql += ",";
			sql += "?";
		}
		sql += ")";
		
		statement = StatementFactory.getStatement(conn, sql, false);
		int pos = 1; 
		statement.setInt(pos++, fncIdToKeep.intValue());
		for (Integer id : idsWithError) if (! fncIdToKeep.equals(id)) statement.setInt(pos++, id.intValue());
		
		try {
			statement.execute();
		} finally {
			statement.close();
		}
	}
	
	private void deleteFunctionalitiesExcept(Connection conn, Integer fncIdToKeep, Collection<Integer> idsWithError) throws SQLException {
		String sql = "delete from functionality where fnc_id_auto in (";
		for (int i = 0; i < idsWithError.size() - 1; i++) {
			if (i > 0) sql += ",";
			sql += "?";
		}
		sql += ")";
		
		PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
		int pos = 1; 
		for (Integer id : idsWithError) if (! fncIdToKeep.equals(id)) statement.setInt(pos++, id.intValue());
		
		try {
			statement.execute();
		} finally {
			statement.close();
		}
	}
	
	private Collection<FunctionalityVo> findFunctionalities(Connection conn) throws SQLException {
		PreparedStatement statement = StatementFactory.getStatement(conn, "select * from ( select fnc_title, count(fnc_id_auto) as amount from functionality where fnc_name like 'PRO%' group by fnc_title ) a where amount > 1", false);
		ResultSet resultSet = statement.executeQuery();
		Collection<FunctionalityVo> result = new ArrayList<FunctionalityVo>();
		while (resultSet.next()) {
			FunctionalityVo vo = new FunctionalityVo();
			vo.setFncTitle(resultSet.getString("fnc_title"));
			result.add(vo);
		}
		return result;
	}
	
	private Collection<FunctionalityVo> findFunctionalitiesFor(Connection conn, String fncTitle) throws SQLException {
		PreparedStatement statement = StatementFactory.getStatement(conn, "select fnc_id_auto, fnc_name, fnc_title, fnc_url from functionality where fnc_name like 'PRO%' and fnc_title = ?", false);
		statement.setString(1, fncTitle);
		
		try {
			ResultSet resultSet = statement.executeQuery();
			Collection<FunctionalityVo> result = new ArrayList<FunctionalityVo>();
			while (resultSet.next()) {
				FunctionalityVo vo = new FunctionalityVo();
				vo.setFncId(Integer.valueOf(resultSet.getInt("fnc_id_auto")));
				vo.setFncName(resultSet.getString("fnc_name"));
				vo.setFncTitle(resultSet.getString("fnc_title"));
				vo.setFncUrl(resultSet.getString("fnc_url"));
				result.add(vo);
			}
			return result;
		} finally {
			statement.close();
		}
	}
	
	private Integer findFncIdToKeep(Connection conn, Collection<Integer> ids) throws SQLException {
		String sql = "select fnc_id, reg_status, p.* from process p where fnc_id in (";
		for (int i = 0; i < ids.size(); i++) {
			if (i > 0) sql += ",";
			sql += "?";
		}
		sql += ")";
		
		PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
		int pos = 1; 
		for (Integer id : ids) statement.setInt(pos++, id.intValue());
		
		int maxVersion = -1;
		Integer candidateResult = null;
		
		try {
			ResultSet resultSet = statement.executeQuery();
			Integer proId = null;
			Integer result = null;
			
			while (resultSet.next()) {
				if (proId == null) proId = Integer.valueOf(resultSet.getInt("pro_id_auto"));
				int regStatus = resultSet.getInt("reg_status");
				
				if (! proId.equals(Integer.valueOf(resultSet.getInt("pro_id_auto")))) throw new SQLException("Found a different process while searching process with fnc ids: " + ids.toString());
				
				int proVerId = resultSet.getInt("pro_ver_id");
				if (maxVersion < proVerId) {
					maxVersion = proVerId;
					candidateResult = Integer.valueOf(resultSet.getInt("fnc_id"));
				}
				
				if (regStatus == 0) result = Integer.valueOf(resultSet.getInt("fnc_id"));
			}
			
			if (result == null) result = candidateResult;
			
			return result;
		} finally {
			statement.close();
		}
	}
	
	//--------------------------------
	
	public String verify(boolean doSolution) {
		StringBuffer buffer = new StringBuffer();
		DBConnection dbConn = null;
		Connection conn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			dbConn = this.getDbConnection();
			this.addMessage(buffer,"Getting database connection...");
			conn = this.getConnection(dbConn);
			
			this.addMessage(buffer,"Searching functionalities...");
			Collection<FunctionalityVo> functionalities = this.findFunctionalities(conn);
			this.addMessage(buffer,"Functionalities found: " + functionalities.size());
			this.addLine(buffer);
			
			for (FunctionalityVo fncVo : functionalities) {
				this.addMessage(buffer,"Testing functionality: " + fncVo.getFncTitle());
				
				Collection<FunctionalityVo> sameFunctionalties = this.findFunctionalitiesFor(conn, fncVo.getFncTitle());
				if (sameFunctionalties.size() < 2) {
					this.addInfo(buffer, "Functionality is ok. There are no functionalities with the same TITLE for the process");
					this.addLine(buffer);
					continue;
				}
				
				String fncUrl = null;
				Collection<Integer> idsWithError = new ArrayList<Integer>();
				for (FunctionalityVo vo : sameFunctionalties) {
					if (fncUrl == null) {
						fncUrl = vo.getFncUrl();
						idsWithError.add(vo.getFncId());
					} else if (fncUrl.equals(vo.getFncUrl())) {
						idsWithError.add(vo.getFncId());
					}
				}
				
				if (idsWithError.size() < 2) {
					this.addInfo(buffer, "Functionality is ok. There are no functionalities with the same URL for the process");
					this.addLine(buffer);
					continue;
				}
				
				this.addWarning(buffer, "There are <b>" + idsWithError.size() + "</b> functionalities with error for functionality <b>" + fncVo.getFncTitle() + "</b>");
				if (! doSolution) {
					this.addLine(buffer);
					continue;
				}
						
				this.addInfo(buffer, "Doing solution for functionality: <b>" + fncVo.getFncTitle() + "</b>");
				this.addInfo(buffer, "Detecting functionality to keep...");
				Integer fncIdToKeep = this.findFncIdToKeep(conn, idsWithError);
				if (fncIdToKeep == null) {
					this.addWarning(buffer, "Could not found funcionality to keep. Skipping");
					this.addLine(buffer);
					continue;
				}
				this.addInfo(buffer, "Final functionality will be <b>" + fncIdToKeep + "</b> from: " + idsWithError);
				
				this.addInfo(buffer, "Doing solution for processes...");
				this.updateProcessToUse(conn, fncIdToKeep, idsWithError);
						
				this.addInfo(buffer, "Doing solution for profiles...");
				this.updatePrfFunctionalityToUse(conn, fncIdToKeep, idsWithError);
				this.updateEnvPrfFunctionalityToUse(conn, fncIdToKeep, idsWithError);
				
				this.addInfo(buffer, "Doing solution for functionality...");
				this.deleteFunctionalitiesExcept(conn, fncIdToKeep, idsWithError);
						
				this.addInfo(buffer, "Functionality <b>" + fncVo.getFncTitle() + "</b> fixed");
				this.addLine(buffer);
				
				//eliminar
//				this.addWarning(buffer, "Only one fix to avoid lose of data for testing");
//				this.addLine(buffer);
//				break;
			}
			
			if (doSolution) {
				this.addInfo(buffer, "Doing commit....");
				DBManagerUtil.commit(dbConn); //cambiar por commit
			}
					
		} catch (Throwable e) {
			this.addError(buffer,e.getMessage());
			try {
				this.addInfo(buffer, "Doing rollback....");
				DBManagerUtil.rollback(dbConn);
			} catch (Exception ee) {
				this.addError(buffer,ee.getMessage());
			}
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"Closeing connection...");
				DBManagerUtil.close(dbConn);
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
}
%>
<%
String action = request.getParameter("action");

boolean verify		= "verify".equals(action);
boolean doSolution		= "doSolution".equals(action);

%>

Options: 
	<%= verify?"<b>":"" %>    <a href="?action=verify" title="Check process functionalities">[ Verify ]</a><%= verify?"</b>":"" %>
	<%= doSolution?"<b>":"" %>   <a href="?action=doSolution" title="Check and correct process functionalities">[ Verify &amp; Correct ]</a><%= doSolution?"</b>":"" %>
	<a href="?" title="Init the screen">[ Init ]</a>
	<br>
<hr>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (verify) {
		actionResult = test.verify(false);
	} else if (doSolution) {
		actionResult = test.verify(true);
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div>
</body>
</html>