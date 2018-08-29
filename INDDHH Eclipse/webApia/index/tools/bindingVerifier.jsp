<%@page import="com.dogma.DogmaException"%>
<%@page import="com.dogma.vo.BusClaParBindingVo"%>
<%@page import="com.dogma.dao.BusClaParBindingDAO"%>
<%@page import="com.dogma.dao.gen.GenericDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.io.File"%>
<html>
<head>
	<title>Process Condition Verifier</title>
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
		
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> <pre>" + byteArrayOut.toString() + "</pre>");
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
	private void cloneBinding(DBConnection dbConn, Connection conn, Integer bndId, Integer newBndId) throws SQLException, DAOException {
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from bus_cla_par_binding where bus_cla_par_bnd_id = ?",false);
			statement.setInt(1, bndId.intValue());
			
			ResultSet resultSet = statement.executeQuery();
			Collection toClone = new ArrayList();
			while (resultSet.next()) toClone.add(BusClaParBindingDAO.getInstance().createBusClaParBindingVo(dbConn, resultSet));
			
			for (Iterator it = toClone.iterator(); it.hasNext(); ) {
				BusClaParBindingVo vo = (BusClaParBindingVo) it.next();
				vo.setBusClaParBndId(newBndId);
				vo.setEntitySyncType(BusClaParBindingVo.INSERT);
				BusClaParBindingDAO.getInstance().synchronizeDB(dbConn, vo, "verifierUsr");
			}
			
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyBusEntEvtBusClass(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with business entity.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from bus_ent_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyFrmEvtBusClass(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with forms.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from frm_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyFrmFldEvtBusClass(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with form fields.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from frm_fld_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyProEleEvtBusClass(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with process elements.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from pro_ele_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyProEvtBusClass(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with process processes.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from pro_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyShcBusClaActivity(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding with schedulers.");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from sch_bus_cla_activity group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void verifyBusClaParBinding(StringBuffer buffer, Connection conn) throws SQLException {
		this.addMessage(buffer, "Checking binding class invocation (may defer from real correction execution)");
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn, "select * from (select bus_cla_par_bnd_id, count(distinct(bus_cla_id)) as amount from bus_cla_par_binding group by bus_cla_par_bnd_id) as p where p.amount > 1", false);
			ResultSet resultSet = statement.executeQuery();
			boolean found = false;
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				Integer amount = Integer.valueOf(resultSet.getInt("amount"));
				
				this.addWarning(buffer, "Found binding with id <b>" + bndId + "</b> with <b>" + amount + "</b> references. This is wrong.");
				found = true;
			}
			
			if (! found) this.addMessage(buffer, "No errors where found.");
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void correctBusEntEvtBusClass(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with business entity.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from bus_ent_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from bus_ent_evt_bus_class where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update bus_ent_evt_bus_class set bus_cla_par_bnd_id = ? where env_id = ? and bus_ent_id = ? and evt_id = ? and bus_cla_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "Cloneing binding from <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						Integer busEntId	= Integer.valueOf(resultSet.getInt("bus_ent_id"));
						Integer evtId		= Integer.valueOf(resultSet.getInt("evt_id"));
						Integer busClaId	= Integer.valueOf(resultSet.getInt("bus_cla_id"));
						
						this.addMessage(buffer, "Updateing business class <b>" + envId + " - " + busEntId + " - " + evtId + " - " + busClaId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, envId.intValue());
						statementUpdate.setInt(3, busEntId.intValue());
						statementUpdate.setInt(4, evtId.intValue());
						statementUpdate.setInt(5, busClaId.intValue());
						statementUpdate.setInt(6, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private void correctFrmEvtBusClass(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with forms.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from frm_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from frm_evt_bus_class where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update frm_evt_bus_class set bus_cla_par_bnd_id = ? where env_id = ? and frm_id = ? and evt_id = ? and bus_cla_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding for <b>" + bndId + "</b>");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "&nbsp;&nbsp;Cloneing binding from <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						Integer frmId		= Integer.valueOf(resultSet.getInt("frm_id"));
						Integer evtId		= Integer.valueOf(resultSet.getInt("evt_id"));
						Integer busClaId	= Integer.valueOf(resultSet.getInt("bus_cla_id"));
						
						this.addMessage(buffer, "&nbsp;&nbsp;Updateing form <b>" + envId + " - " + frmId + " - " + evtId + " - " + busClaId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, envId.intValue());
						statementUpdate.setInt(3, frmId.intValue());
						statementUpdate.setInt(4, evtId.intValue());
						statementUpdate.setInt(5, busClaId.intValue());
						statementUpdate.setInt(6, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private void correctFrmFldEvtBusClass(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with form fields.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from frm_fld_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from frm_fld_evt_bus_class where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update frm_fld_evt_bus_class set bus_cla_par_bnd_id = ? where env_id = ? and frm_fld_id = ? and frm_id = ? and evt_id = ? and bus_cla_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding for <b>" + bndId + "</b>");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "&nbsp;&nbsp;Cloneing binding from <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						Integer frmFldId	= Integer.valueOf(resultSet.getInt("frm_fld_id"));
						Integer frmId		= Integer.valueOf(resultSet.getInt("frm_id"));
						Integer evtId		= Integer.valueOf(resultSet.getInt("evt_id"));
						Integer busClaId	= Integer.valueOf(resultSet.getInt("bus_cla_id"));
						
						this.addMessage(buffer, "&nbsp;&nbsp;Updateing form field <b>" + envId + " - " + frmFldId + " - " + frmId + " - " + evtId + " - " + busClaId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, envId.intValue());
						statementUpdate.setInt(3, frmFldId.intValue());
						statementUpdate.setInt(4, frmId.intValue());
						statementUpdate.setInt(5, evtId.intValue());
						statementUpdate.setInt(6, busClaId.intValue());
						statementUpdate.setInt(7, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private void correctProEleEvtBusClass(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with process elements.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from pro_ele_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from pro_ele_evt_bus_class where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update pro_ele_evt_bus_class set bus_cla_par_bnd_id = ? where env_id = ? and pro_id = ? and pro_ver_id = ? and pro_ele_id = ? and evt_id = ? and bus_cla_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding for <b>" + bndId + "</b>");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "&nbsp;&nbsp;Cloneing binding from <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						Integer proId		= Integer.valueOf(resultSet.getInt("pro_id"));
						Integer proVerId	= Integer.valueOf(resultSet.getInt("pro_ver_id"));
						Integer proEleId	= Integer.valueOf(resultSet.getInt("pro_ele_id"));
						Integer evtId		= Integer.valueOf(resultSet.getInt("evt_id"));
						Integer busClaId	= Integer.valueOf(resultSet.getInt("bus_cla_id"));
						
						this.addMessage(buffer, "&nbsp;&nbsp;Updateing process element <b>" + envId + " - " + proId + " - " + proVerId + " - " + proEleId + " - " + evtId + " - " + busClaId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, envId.intValue());
						statementUpdate.setInt(3, proId.intValue());
						statementUpdate.setInt(4, proVerId.intValue());
						statementUpdate.setInt(5, proEleId.intValue());
						statementUpdate.setInt(6, evtId.intValue());
						statementUpdate.setInt(7, busClaId.intValue());
						statementUpdate.setInt(8, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private void correctProEvtBusClass(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with processes.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from pro_evt_bus_class group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from pro_evt_bus_class where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update pro_evt_bus_class set bus_cla_par_bnd_id = ? where env_id = ? and pro_id = ? and pro_ver_id = ? and evt_id = ? and bus_cla_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding for <b>" + bndId + "</b>");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "&nbsp;&nbsp;Cloneing binding from <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						Integer proId		= Integer.valueOf(resultSet.getInt("pro_id"));
						Integer proVerId	= Integer.valueOf(resultSet.getInt("pro_ver_id"));
						Integer evtId		= Integer.valueOf(resultSet.getInt("evt_id"));
						Integer busClaId	= Integer.valueOf(resultSet.getInt("bus_cla_id"));
						
						this.addMessage(buffer, "&nbsp;&nbsp;Updateing process <b>" + envId + " - " + proId + " - " + proVerId + " - " + evtId + " - " + busClaId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, envId.intValue());
						statementUpdate.setInt(3, proId.intValue());
						statementUpdate.setInt(4, proVerId.intValue());
						statementUpdate.setInt(5, evtId.intValue());
						statementUpdate.setInt(6, busClaId.intValue());
						statementUpdate.setInt(7, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private Integer findBusClaIdForBinding(Connection conn, Integer bndId) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = StatementFactory.getStatement(conn,
					"select bus_cla_id from bus_ent_evt_bus_class where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from frm_evt_bus_class where bus_cla_par_bnd_id = ? " + 
					"union all " +
					"select bus_cla_id from frm_fld_evt_bus_class where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from pro_ele_evt_bus_class where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from pro_evt_bus_class where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from sch_bus_cla_activity where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from bus_cla_par_binding where bus_cla_par_bnd_id = ? " +
					"union all " +
					"select bus_cla_id from bus_ent_evt_bus_class where bus_cla_par_bnd_id = ? ", false);
			
			statement.setInt(1, bndId);
			statement.setInt(2, bndId);
			statement.setInt(3, bndId);
			statement.setInt(4, bndId);
			statement.setInt(5, bndId);
			statement.setInt(6, bndId);
			statement.setInt(7, bndId);
			statement.setInt(8, bndId);
			
			ResultSet resultSet = statement.executeQuery();
			if (resultSet.next()) return new Integer(resultSet.getInt(1));
			return null;
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void correctBusClaParBinding(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding class referente");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn, "select * from (select bus_cla_par_bnd_id, count(distinct(bus_cla_id)) as amount from bus_cla_par_binding group by bus_cla_par_bnd_id) as p where p.amount > 1", false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			try {
				statement = StatementFactory.getStatement(conn, "delete from bus_cla_par_binding where bus_cla_id <> ? and bus_cla_par_bnd_id = ?", false);
				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					Integer busClaIdToKeep = this.findBusClaIdForBinding(conn, bndId);
					
					statement.setInt(1, busClaIdToKeep);
					statement.setInt(2, bndId);
					
					this.addMessage(buffer, "Keeping class " + busClaIdToKeep + " to binding " + bndId);
					
					statement.execute();
				}
			} finally {
				if (statement != null) statement.close();
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	private void correctShcBusClaActivity(StringBuffer buffer, DBConnection dbConn, Connection conn) throws SQLException, DAOException {
		this.addMessage(buffer, "Checking and correcting binding with schedulers.");
		PreparedStatement statement = null;
		Collection bndIds = new ArrayList();
		try {
			statement = StatementFactory.getStatement(conn,"select * from (select bus_cla_par_bnd_id, count(bus_cla_par_bnd_id) as amount from sch_bus_cla_activity group by bus_cla_par_bnd_id) t where t.amount > 1",false);
			ResultSet resultSet = statement.executeQuery();
			while (resultSet.next()) {
				Integer bndId = Integer.valueOf(resultSet.getInt("bus_cla_par_bnd_id"));
				bndIds.add(bndId);
			}
		} finally {
			if (statement != null) statement.close();
			statement = null;
		}
		
		if (bndIds.size() > 0) {
			PreparedStatement statementSearch = null;
			PreparedStatement statementUpdate = null;
			try {
				statementSearch = StatementFactory.getStatement(conn,"select * from sch_bus_cla_activity where bus_cla_par_bnd_id = ?",false);
				statementUpdate = StatementFactory.getStatement(conn,"update sch_bus_cla_activity set bus_cla_par_bnd_id = ? where sch_bus_cla_id_auto = ? and env_id = ? and bus_cla_par_bnd_id = ?",false);

				for (Iterator it = bndIds.iterator(); it.hasNext(); ) {
					Integer bndId = (Integer) it.next();
					
					statementSearch.setInt(1, bndId.intValue());
					ResultSet resultSet = statementSearch.executeQuery();
					
					boolean skipFirst = true;
					
					while (resultSet.next()) {
						if (skipFirst) { 
							skipFirst = false;
							this.addMessage(buffer, "Leaving one binding");
							continue; 
						}
						Integer newBndId = GenericDAO.getInstance().getNextId(dbConn, "BusClaParBindingVo");
						
						this.addMessage(buffer, "&nbsp;&nbsp;Cloneing binding schedulers <b>" + bndId + "</b> to <b>" + newBndId + "</b>");
						
						this.cloneBinding(dbConn, conn, bndId, newBndId);
						
						Integer schBusClaId	= Integer.valueOf(resultSet.getInt("sch_bus_cla_id_auto"));
						Integer envId		= Integer.valueOf(resultSet.getInt("env_id"));
						
						this.addMessage(buffer, "&nbsp;&nbsp;Updateing business class <b>" + schBusClaId + " - " + envId + "</b> to use binding <b>" + newBndId + "</b>");
						
						statementUpdate.setInt(1, newBndId.intValue());
						statementUpdate.setInt(2, schBusClaId.intValue());
						statementUpdate.setInt(3, envId.intValue());
						statementUpdate.setInt(4, bndId.intValue());
						
						statementUpdate.executeUpdate();
					}
				}
			} finally {
				try {
					if (statementSearch != null) statementSearch.close();
				} finally {
					if (statementUpdate != null) statementUpdate.close();
				}
			}
		}
		
		if (bndIds.size() == 0) this.addMessage(buffer, "No errors where found.");
	}
	
	//--------------------------------
	
	public String verify() {
		StringBuffer buffer = new StringBuffer();
		DBConnection dbConn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			dbConn = this.getDbConnection();
			Connection conn = new ConnectionGetter().getDBConnection2(dbConn);
			
			this.verifyBusEntEvtBusClass(buffer, conn);
			this.verifyFrmEvtBusClass(buffer, conn);
			this.verifyFrmFldEvtBusClass(buffer, conn);
			this.verifyProEleEvtBusClass(buffer, conn);
			this.verifyProEvtBusClass(buffer, conn);
			this.verifyShcBusClaActivity(buffer, conn);
			this.verifyBusClaParBinding(buffer, conn);
		} catch (Exception e) {
			this.addError(buffer,e);
		} finally {
			if (dbConn != null) {
				this.addMessage(buffer,"Closeing connection...");
				try {
					dbConn.close();
				} catch (DogmaException e) {
					this.addError(buffer,e);
				}
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
	
	public String correct() {
		StringBuffer buffer = new StringBuffer();
		DBConnection dbConn = null;

		try {
			this.addMessage(buffer,"Getting Apia connection...");
			dbConn = this.getDbConnection();
			Connection conn = new ConnectionGetter().getDBConnection2(dbConn);
			
			this.correctBusEntEvtBusClass(buffer, dbConn, conn);
			this.correctFrmEvtBusClass(buffer, dbConn, conn);
			this.correctFrmFldEvtBusClass(buffer, dbConn, conn);
			this.correctProEleEvtBusClass(buffer, dbConn, conn);
			this.correctProEvtBusClass(buffer, dbConn, conn);
			this.correctShcBusClaActivity(buffer, dbConn, conn);
			this.correctBusClaParBinding(buffer, dbConn, conn);
			
			this.addMessage(buffer,"Doing commit in database");
			dbConn.commit();
		} catch (Exception e) {
			this.addError(buffer,e.getMessage());
			try {
				this.addMessage(buffer,"Doing rollback in database");
				dbConn.rollback();
			} catch (Exception ee) {
				this.addError(buffer,ee.getMessage());
			}
		} finally {
			if (dbConn != null) {
				this.addMessage(buffer,"Closeing connection...");
				try {
					dbConn.close();
				} catch (DogmaException e) {
					this.addError(buffer,e);
				}
			}
		}
		
		this.addMessage(buffer,"[END]");
		
		return buffer.toString();
	}
}
%>

<%
String action = request.getParameter("action");

boolean isVerifiy	= "verify".equals(action);
boolean isVerifiyOE	= "verifyOE".equals(action);
boolean isCorrect	= "correct".equals(action);

%>

Options: 
	<%= isVerifiy?"<b>":"" %> <a href="?action=verify" title="Check if all events bindings are OK">[ Verify bindings ]</a><%= isVerifiy?"</b>":"" %>
	<%= isCorrect?"<b>":"" %> <a href="?action=correct" title="Correct all bad events bindings" onclick="return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');">[ Correct events bindings ]</a><%= isCorrect?"</b>":"" %>
	<a href="?" title="Init the screen">[ Init ]</a>
	<br>
<hr>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (isVerifiy) {
		actionResult = test.verify();
	} else if (isCorrect) {
		actionResult = test.correct();
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div>
</body>
</html>
	