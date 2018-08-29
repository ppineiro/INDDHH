<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.dogma.dao.QueryDAO"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="com.dogma.action.query.TaskMonitorAction"%>
<%@page import="com.dogma.action.query.ProcessMonitorAction"%>
<%@page import="com.dogma.action.query.TaskListAction"%>
<%@page import="com.dogma.action.query.QueryAction"%>
<%@page import="com.dogma.action.query.OffLineAction"%>
<%@page import="com.dogma.action.query.EntInstanceAction"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<html>
<head>
	<title>FunctionalityVerifier</title>
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
public class QryColumnVo {

	//--- Public constants ----------------------
	public static final String COLUMN_TYPE_SHOW 		= "S";
	public static final String COLUMN_TYPE_FILTER 		= "F";
	public static final String COLUMN_TYPE_USER_FILTER	= "U";
	public static final String COLUMN_TYPE_HIDDEN		= "H";
	public static final String COLUMN_TYPE_FUNCTION		= "T";
	
	//--- Private attributes --------------------
	private Integer envId;
	private Integer qryId;
	private Integer qryColId;
	private String qryColName;
	private String qryColValue;
	private String qryColType;
	
	//--- Public methods ------------------------
	public String getQueryPk() {
		return this.envId + "-" + this.qryId;
	}
	
	//--- Getters and Setters -------------------
	public Integer getQryColId() {
		return qryColId;
	}
	public void setQryColId(Integer qryColId) {
		this.qryColId = qryColId;
	}
	public String getQryColName() {
		return qryColName;
	}
	public void setQryColName(String qryColName) {
		this.qryColName = qryColName;
	}
	public String getQryColType() {
		return qryColType;
	}
	public void setQryColType(String qryColType) {
		this.qryColType = qryColType;
	}
	public String getQryColValue() {
		return qryColValue;
	}
	public void setQryColValue(String qryColValue) {
		this.qryColValue = qryColValue;
	}
	public Integer getQryId() {
		return qryId;
	}
	public void setQryId(Integer qryId) {
		this.qryId = qryId;
	}
	public void setEnvId(Integer envId) {
		this.envId = envId;
	}
	public Integer getEnvId() {
		return this.envId;
	}
}

public class QueryVo {

	//--- Public constants ----------------------
	public static final String TYPE_QUERY			= "Q"; //fnc
	public static final String TYPE_MODAL			= "M";
	public static final String TYPE_ENTITY			= "E"; //fnc
	public static final String TYPE_TASK_LIST		= "T"; //fnc
	public static final String TYPE_ENTITY_MODAL	= "A";
	public static final String TYPE_OFF_LINE		= "O"; //fnc
	public static final String TYPE_FORM			= "F";
	public static final String TYPE_DEPRECATED		= "D";
	public static final String TYPE_PROCESS_MONITOR	= "P"; //fnc
	public static final String TYPE_TASK_MONITOR	= "N"; //fnc
	public static final String TYPE_PRO_CANCEL		= "C";
	public static final String TYPE_PRO_ALTER		= "L";

	//--- Private attributes --------------------
	private Integer envId;
	private Integer qryId;
	private String qryName;
	private String qryTitle;
	private Integer fncId;
	private String qryFlags;
	private String qryType;
	
	private FunctionalityVo functionalityVo;
	private BusEntityVo busEntityVo;
	private Collection columns;

	private boolean correctly;
	private boolean regenerate;
	private boolean update;
	private boolean updateModal;
	
	private boolean functionalityUsed;
	private boolean altered;
	
	//--- Public methods ------------------------
	public void addColumn(QryColumnVo qryColVo) {
		if (this.columns == null) this.columns = new ArrayList();
		this.columns.add(qryColVo);
	}
	
	public String getUrl() {
		if (QueryVo.TYPE_MODAL.equals(this.getQryType()) || 
				QueryVo.TYPE_ENTITY_MODAL.equals(this.getQryType()) || 
				QueryVo.TYPE_PRO_ALTER.equals(this.getQryType()) ||
				QueryVo.TYPE_PRO_CANCEL.equals(this.getQryType())) {
				return null;
			}
			
			StringBuffer buffer = new StringBuffer();
			buffer.append("redirect.jsp?link=query.");

			if (QueryVo.TYPE_ENTITY.equals(this.getQryType())) {
				buffer.append("EntInstanceAction");
				
			} else if (QueryVo.TYPE_ENTITY_MODAL.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_FORM.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_MODAL.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_OFF_LINE.equals(this.getQryType())) {
				buffer.append("OffLineAction");
				
			} else if (QueryVo.TYPE_QUERY.equals(this.getQryType())) {
				buffer.append("QueryAction");
				
			} else if (QueryVo.TYPE_TASK_LIST.equals(this.getQryType())) {
				buffer.append("TaskListAction");
				
			} else if (QueryVo.TYPE_PROCESS_MONITOR.equals(this.getQryType())) {
				buffer.append("ProcessMonitorAction");
				
			} else if (QueryVo.TYPE_TASK_MONITOR.equals(this.getQryType())) {
				buffer.append("TaskMonitorAction");
			}
			
			buffer.append(".do%3Faction=");
			
			if (QueryVo.TYPE_ENTITY.equals(this.getQryType())) {
				buffer.append(EntInstanceAction.ACTION_VIEW_ENTITY);
				
			} else if (QueryVo.TYPE_ENTITY_MODAL.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_FORM.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_MODAL.equals(this.getQryType())) {
				return null;
				
			} else if (QueryVo.TYPE_OFF_LINE.equals(this.getQryType())) {
				buffer.append(OffLineAction.ACTION_VIEW_QUERY_OFF);
				
			} else if (QueryVo.TYPE_QUERY.equals(this.getQryType())) {
				buffer.append(QueryAction.ACTION_VIEW_QUERY);
				
			} else if (QueryVo.TYPE_TASK_LIST.equals(this.getQryType())) {
				buffer.append(TaskListAction.ACTION_VIEW_TASK_LIST);
				
			} else if (QueryVo.TYPE_PROCESS_MONITOR.equals(this.getQryType())) {
				buffer.append(ProcessMonitorAction.ACTION_VIEW_MONITOR);
				
			} else if (QueryVo.TYPE_TASK_MONITOR.equals(this.getQryType())) {
				buffer.append(TaskMonitorAction.ACTION_VIEW_MONITOR);
			}

			buffer.append("&amp;query=");
			buffer.append(this.getQryId().toString());
			
			return buffer.toString();
		}
	
	public boolean requiredFnc() {
		return 	QueryVo.TYPE_QUERY.equals(this.getQryType()) || 
				QueryVo.TYPE_ENTITY.equals(this.getQryType()) || 
				QueryVo.TYPE_TASK_LIST.equals(this.getQryType()) || 
				QueryVo.TYPE_OFF_LINE.equals(this.getQryType()) || 
				QueryVo.TYPE_PROCESS_MONITOR.equals(this.getQryType()) || 
				QueryVo.TYPE_TASK_MONITOR.equals(this.getQryType());
	}
	
	public boolean hasSql() {
		return this.regenerate || this.update || this.updateModal;
	}
	
	public String genSql() {
		StringBuffer buffer = new StringBuffer();
		if (this.regenerate) buffer.append("update query set fnc_id = null where qry_id_auto = " + this.qryId.toString() + ";");
		if (this.update && buffer.length() > 0) buffer.append("\r\n\t");
		if (this.update) buffer.append("update query set fnc_id = " + this.functionalityVo.getFncId().toString() + " where qry_id_auto = " + this.qryId.toString() + ";");
		if (this.updateModal && buffer.length() > 0) buffer.append("\r\n\t");
		if (this.updateModal) {
			QryColumnVo qryColVo = this.getColumnFilter("BUS_ENT_ID");
			if (qryColVo == null) {
				buffer.append(this.qryName + " no es una consulta modal de entidad automática");
			} else {
				buffer.append("update qry_column set qry_col_value = " + this.busEntityVo.getBusEntId().toString() + " where qry_col_id_auto = " + qryColVo.getQryColId().toString() + " and qry_id = " + this.qryId.toString() + ";");
			}
		}
		
		if (buffer.length() == 0) buffer.append("NOT REQURIED");
		
		return buffer.toString();
	}
	
	public QryColumnVo getColumnFilter(String qryColName) {
		if (this.columns == null) return null;
		
		QryColumnVo result = null;
		
		for (Iterator it = this.columns.iterator(); it.hasNext(); ) {
			result = (QryColumnVo) it.next();
			if (result.getQryColName().equals(qryColName) && result.getQryColType().equals("F") ) break;
				
			result = null;
		}

		return result;
	}
	
	public String getPk() {
		return this.envId + "-" + this.qryId;
	}
	
	public String getFncPk() {
		return this.envId + "-" + this.fncId;
	}
	
	//--- Getters and Setters -------------------
	public FunctionalityVo getFunctionalityVo() {
		return functionalityVo;
	}
	public void setFunctionalityVo(FunctionalityVo functionalityVo) {
		if (this.requiredFnc()) this.functionalityVo = functionalityVo;
	}
	public boolean isCorrectly() {
		return correctly;
	}
	public void setCorrectly(boolean correctly) {
		this.correctly = correctly;
	}
	public boolean isRegenerate() {
		return regenerate;
	}
	public void mustRegenerate(boolean regenerate) {
		this.regenerate = regenerate;
		this.altered = true;
	}
	public boolean isFunctionalityUsed() {
		return functionalityUsed;
	}
	public void setFunctionalityUsed(boolean functionalityUsed) {
		this.functionalityUsed = functionalityUsed;
	}
	public Integer getFncId() {
		return fncId;
	}
	public void setFncId(Integer fncId) {
		this.fncId = fncId;
	}
	public String getQryFlags() {
		return qryFlags;
	}
	public void setQryFlags(String qryFlags) {
		this.qryFlags = qryFlags;
	}
	public Integer getQryId() {
		return qryId;
	}
	public void setQryId(Integer qryId) {
		this.qryId = qryId;
	}
	public String getQryName() {
		return qryName;
	}
	public void setQryName(String qryName) {
		this.qryName = qryName;
	}
	public String getQryTitle() {
		return qryTitle;
	}
	public void setQryTitle(String qryTitle) {
		this.qryTitle = qryTitle;
	}
	public String getQryType() {
		return qryType;
	}
	public void setQryType(String fncType) {
		this.qryType = fncType;
	}
	public boolean isUpdate() {
		return update;
	}
	public void setUpdate(boolean update) {
		this.update = update;
		this.altered = true;
	}
	public boolean isAltered() {
		return altered;
	}
	public void setAltered(boolean altered) {
		this.altered = altered;
	}
	public Collection getColumns() {
		return columns;
	}
	public void setColumns(Collection columns) {
		this.columns = columns;
	}
	public boolean isUpdateModal() {
		return updateModal;
	}
	public void mustUpdateModal(boolean updateModal) {
		this.updateModal = updateModal;
		this.altered = true;
	}
	public BusEntityVo getBusEntityVo() {
		return busEntityVo;
	}
	public void setBusEntityVo(BusEntityVo busEntityVo) {
		this.busEntityVo = busEntityVo;
	}
	public void setEnvId(Integer envId) {
		this.envId = envId;
	}
	public Integer getEnvId() {
		return this.envId;
	}
}

public class FunctionalityVo {

	//--- Private attributes
	private Integer envId;
	private Integer fncId;
	private Integer fncFatherId;
	private String fncName;
	private String fncUrl;
	private String fncFlags;
		
	private QueryVo queryVo;
	private BusEntityVo busEntityVo;
	
	private boolean correctly;
	private boolean badUrl;
	private boolean delete;
	private boolean update;
	
	private Collection childs = new ArrayList();
	
	private boolean altered;
	
	//--- Public methods ------------------------
	public String getUpdateToId() {
		if (this.busEntityVo != null) return this.busEntityVo.getBusEntId().toString();
		if (this.queryVo != null) return this.queryVo.getQryId().toString();
		return "";
	}
	
	public String getCorrectUrl() {
		if (this.queryVo != null) return this.queryVo.getUrl();
		if (this.busEntityVo != null) return this.busEntityVo.getUrl();
		
		return this.fncUrl;
	}
	
	public String genSql() {
		if (this.update || this.badUrl) {
			return "update functionality set fnc_url = '" + this.getCorrectUrl() + "' where fnc_id_auto = " + this.fncId.toString() + ";";
		} else if (this.delete) {
			return "delete from functionality where fnc_id_auto = " + this.fncId.toString() + ";";
		}
		
		return "NOT REQUIRED";
	}
	
	public String getSqlDel1(String sql) {
		return sql.startsWith("delete from ") ? "delete from prf_funcionality where fnc_id = " + this.fncId.toString() + ";" : null;
	}
	
	public String getSqlDel2(String sql) {
		return sql.startsWith("delete from ") ? "delete from env_prf_functionality where fnc_id = " + this.fncId.toString() + ";" : null;
	}
	
	public String getPk() {
		return this.envId + "-" + this.fncId;
	}
	
	//--- Getters and Setters -------------------
	public BusEntityVo getBusEntityVo() {
		return busEntityVo;
	}
	public void setBusEntityVo(BusEntityVo busEntityVo) {
		this.busEntityVo = busEntityVo;
	}
	public QueryVo getQueryVo() {
		return queryVo;
	}
	public void setQueryVo(QueryVo queryVo) {
		if (queryVo.requiredFnc()) { 
			this.queryVo = queryVo; 
		}
	}
	public boolean isCorrectly() {
		return correctly;
	}
	public void setCorrectly(boolean correctly) {
		this.correctly = correctly;
	}
	public boolean isBadUrl() {
		return badUrl;
	}
	public void setBadUrl(boolean badUrl) {
		this.badUrl = badUrl;
		this.altered = true;
	}
	public String getFncFlags() {
		return fncFlags;
	}
	public void setFncFlags(String fncFlags) {
		this.fncFlags = fncFlags;
	}
	public Integer getFncId() {
		return fncId;
	}
	public void setFncId(Integer fncId) {
		this.fncId = fncId;
	}
	public String getFncName() {
		return fncName;
	}
	public void setFncName(String fncTitle) {
		this.fncName = fncTitle;
	}
	public String getFncUrl() {
		return fncUrl;
	}
	public void setFncUrl(String fncUrl) {
		this.fncUrl = fncUrl;
	}
	public boolean isDelete() {
		return delete;
	}
	public void setDelete(boolean delete) {
		this.delete = delete;
		this.altered = true;
	}
	public boolean isUpdate() {
		return update;
	}
	public void setUpdate(boolean update) {
		this.update = update;
		this.altered = true;
	}
	public boolean isAltered() {
		return altered;
	}
	public void setAltered(boolean altered) {
		this.altered = altered;
	}
	public Collection getChilds() {
		return childs;
	}
	public void setChilds(Collection childs) {
		this.childs = childs;
	}
	public Integer getFncFatherId() {
		return fncFatherId;
	}
	public void setFncFatherId(Integer fncFatherId) {
		this.fncFatherId = fncFatherId;
	}
	public void setEnvId(Integer envId) {
		this.envId = envId;
	}
	public Integer getEnvId() {
		return this.envId;
	}
}

private class BusEntityVo {
	
	//--- Public constants ----------------------
	public static final int FLAG_HAS_QUERY_MODAL = 0;

	//--- Private attribtues --------------------
	private Integer envId;
	private Integer busEntId;
	private String busEntName;
	private String busEntTitle;
	private String busAdminType;
	private String busEntFlags;
	private Integer fncId;
	
	private FunctionalityVo functionalityVo;
	private QueryVo queryVo;

	private boolean correctly;
	private boolean correctlyModal = false;
	private boolean regenerateFunctionality;
	private boolean regenerateQuery;
	private boolean update;

	private boolean functionalityUsed;
	private boolean altered;
	
	//--- Public methods ------------------------
	public boolean getFlagValue(int pos) {
		if ((this.busEntFlags != null) && (this.busEntFlags.length() >= (pos + 1))) {
			return this.busEntFlags.charAt(pos) == '1';
		} else return false;
	}
	
	public String genSql() {
		if (this.regenerateFunctionality) {
			return "update bus_entity set fnc_id = null where bus_ent_id_auto = " + this.busEntId.toString() + ";";
		} else if (this.update) {
			return "update bus_entity set fnc_id = " + this.functionalityVo.getFncId().toString() + " where bus_ent_id_auto = " + this.busEntId.toString() + ";";
		}
		
		return "NOT REQUIRED";
	}
	
	public String getUrl() {
		return "execution.EntInstanceAction.do%3Faction=init&amp;txtBusEntId=" + this.busEntId.toString() + "&amp;txtBusEntAdm=" + this.busAdminType;
	}
	
	public String getPk() {
		return this.envId + "-" + this.busEntId;
	}
	
	public String getFncPk() {
		return this.envId + "-" + this.fncId;
	}
	
	//--- Getters and Setters -------------------
	public FunctionalityVo getFunctionalityVo() {
		return functionalityVo;
	}
	public void setFunctionalityVo(FunctionalityVo functionalityVo) {
		this.functionalityVo = functionalityVo;
	}
	public boolean isCorrectly() {
		return correctly;
	}
	public void setCorrectly(boolean correctly) {
		this.correctly = correctly;
	}
	public boolean isRegenerateFunctionality() {
		return regenerateFunctionality;
	}
	public void mustRegenerateFunctionality(boolean regenerateQuery) {
		this.regenerateQuery = regenerateQuery;
		this.altered = true;
	}
	public boolean isRegenerateQuery() {
		return regenerateQuery;
	}
	public boolean isRegenerate() {
		return regenerateQuery || regenerateFunctionality;
	}
	public void mustRegenerateQuery(boolean regenerateQuery) {
		this.regenerateQuery = regenerateQuery;
		this.altered = true;
	}
	public boolean isFunctionalityUsed() {
		return functionalityUsed;
	}
	public void setFunctionalityUsed(boolean functionalityUsed) {
		this.functionalityUsed = functionalityUsed;
	}
	public Integer getBusEntId() {
		return busEntId;
	}
	public void setBusEntId(Integer busEntId) {
		this.busEntId = busEntId;
	}
	public String getBusEntName() {
		return busEntName;
	}
	public void setBusEntName(String busEntName) {
		this.busEntName = busEntName;
	}
	public String getBusEntTitle() {
		return busEntTitle;
	}
	public void setBusEntTitle(String busEntTitle) {
		this.busEntTitle = busEntTitle;
	}
	public Integer getFncId() {
		return fncId;
	}
	public void setFncId(Integer fncId) {
		this.fncId = fncId;
	}
	public boolean isUpdate() {
		return update;
	}
	public void setUpdate(boolean update) {
		this.update = update;
		this.altered = true;
	}
	public boolean isAltered() {
		return altered;
	}
	public void setAltered(boolean altered) {
		this.altered = altered;
	}
	public String getBusAdminType() {
		return busAdminType;
	}
	public void setBusAdminType(String busAdminType) {
		this.busAdminType = busAdminType;
	}
	public QueryVo getQueryVo() {
		return queryVo;
	}
	public void setQueryVo(QueryVo queryVo) {
		this.queryVo = queryVo;
	}
	public String getBusEntFlags() {
		return busEntFlags;
	}
	public void setBusEntFlags(String busEntFlags) {
		this.busEntFlags = busEntFlags;
	}
	public boolean isCorrectlyModal() {
		return correctlyModal;
	}
	public void setCorrectlyModal(boolean correctlyModal) {
		this.correctlyModal = correctlyModal;
	}
	public void setEnvId(Integer envId) {
		this.envId = envId;
	}
	public Integer getEnvId() {
		return this.envId;
	}
}

private class Test extends DBAdmin {

	private BusEntityVo findBusEntity(HashMap entities, String title) {
		BusEntityVo result = null;
		
		for (Iterator it = entities.values().iterator(); it.hasNext() && result == null; ) {
			result = (BusEntityVo) it.next();
			if (result.getFunctionalityVo() == null && result.getBusEntTitle().equals(title) && ! result.isAltered()) continue;
			
			result = null;
		}
		
		return result;
	}
	
	private QueryVo findQuery(HashMap querys, String title) {
		QueryVo result = null;
		
		for (Iterator it = querys.values().iterator(); it.hasNext() && result == null; ) {
			result = (QueryVo) it.next();
			if (result.getFunctionalityVo() == null && result.getQryTitle().equals(title) && result.requiredFnc() && ! result.isAltered()) continue;
			
			result = null;
		}
		
		return result;
	}
	
	private QueryVo findQueryModal(HashMap querys, String name) {
		QueryVo result = null;
		
		for (Iterator it = querys.values().iterator(); it.hasNext() && result == null; ) {
			result = (QueryVo) it.next();
			if (result.getQryName().equals(name) && (!result.requiredFnc())) continue;
			
			result = null;
		}
		
		return result;
	}
	
	private QueryVo findQueryModal(HashMap querys, Integer busEntId) {
		QueryVo result = null;
		
		for (Iterator it = querys.values().iterator(); it.hasNext() && result == null; ) {
			result = (QueryVo) it.next();
			QryColumnVo qryColVo = result.getColumnFilter("BUS_ENT_ID");
			if (qryColVo != null && qryColVo.getQryColValue().equals(busEntId.toString())) continue;
			
			result = null;
		}
		
		return result;
	}
	
	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(msg + "<br>");
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
	
	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
		return this.getConnection(dbConn);
	}
	
	private Connection getConnection(DBConnection dbConn) {
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
	}
	
	private HashMap getQuerys(Connection conn) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement("select * from query where reg_status = 0");
			ResultSet resultSet = statement.executeQuery();
			
			HashMap result = new HashMap();
			
			while (resultSet.next()) {
				QueryVo qryVo = new QueryVo();
				qryVo.setEnvId(new Integer(resultSet.getInt("env_id")));
				qryVo.setQryId(new Integer(resultSet.getInt("qry_id_auto")));
				qryVo.setQryName(resultSet.getString("qry_name"));
				qryVo.setQryTitle(resultSet.getString("qry_title"));
				qryVo.setQryType(resultSet.getString("qry_type"));
				if (resultSet.getString("fnc_id") != null) qryVo.setFncId(new Integer(resultSet.getInt("fnc_id")));
				
				result.put(qryVo.getPk(),qryVo);
			}
			
			return result;
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private int getQryColumns(Connection conn, HashMap querys) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement("select * from qry_column where reg_status = 0");
			ResultSet resultSet = statement.executeQuery();
			
			int result = 0;
			while (resultSet.next()) {
				QryColumnVo qryColVo = new QryColumnVo();
				
				qryColVo.setEnvId(new Integer(resultSet.getInt("env_id")));
				qryColVo.setQryId(new Integer(resultSet.getInt("qry_id")));
				qryColVo.setQryColId(new Integer(resultSet.getInt("qry_col_id_auto")));
				qryColVo.setQryColName(resultSet.getString("qry_col_name"));
				qryColVo.setQryColValue(resultSet.getString("qry_col_value"));
				qryColVo.setQryColType(resultSet.getString("qry_col_type"));

				QueryVo qryVo = (QueryVo) querys.get(qryColVo.getQueryPk());
				qryVo.addColumn(qryColVo);
				
				result++;
			}
			
			return result;
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private HashMap getEntities(Connection conn) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement("select * from bus_entity where reg_status = 0");
			ResultSet resultSet = statement.executeQuery();
			
			HashMap result = new HashMap();
			
			while (resultSet.next()) {
				BusEntityVo busEntVo = new BusEntityVo();
				
				busEntVo.setEnvId(new Integer(resultSet.getInt("env_id")));
				busEntVo.setBusEntId(new Integer(resultSet.getInt("bus_ent_id_auto")));
				busEntVo.setBusEntName(resultSet.getString("bus_ent_name"));
				busEntVo.setBusEntTitle(resultSet.getString("bus_ent_title"));
				busEntVo.setBusAdminType(resultSet.getString("bus_ent_admin_type"));
				busEntVo.setBusEntFlags(resultSet.getString("bus_ent_flags"));
				if (resultSet.getString("fnc_id") != null) busEntVo.setFncId(new Integer(resultSet.getString("fnc_id")));

				result.put(busEntVo.getPk(),busEntVo);
			}
			
			return result;
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private HashMap getFunctionalities(Connection conn) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement("select * from functionality where reg_status = 0");
			ResultSet resultSet = statement.executeQuery();
			
			HashMap result = new HashMap();
			
			while (resultSet.next()) {
				FunctionalityVo fncVo = new FunctionalityVo();
				
				if (resultSet.getString("env_id") != null) fncVo.setEnvId(new Integer(resultSet.getInt("env_id")));
				fncVo.setFncId(new Integer(resultSet.getInt("fnc_id_auto")));
				fncVo.setFncName(resultSet.getString("fnc_name"));
				fncVo.setFncUrl(resultSet.getString("fnc_url"));

				result.put(fncVo.getPk(),fncVo);
			}
			
			return result;
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	private void execute(Connection conn, String sql) throws SQLException {
		PreparedStatement statement = null;
		try {
			statement = conn.prepareStatement(sql);
			statement.execute();
		} finally {
			if (statement != null) statement.close();
		}
	}
	
	//--------------------------------
	
	public String verifyFunctionality(boolean impactInDataBase) throws Exception {
		StringBuffer buffer = new StringBuffer();
		StringBuffer html = new StringBuffer();
		
		DBConnection dbConn = null;
		Connection conn = null;

		try {
			this.addMessage(buffer,"<b>Getting Apia connection...</b>");
			dbConn = this.getDbConnection();
			conn = this.getConnection(dbConn);
			
			//Cargar los parámetros
			this.addMessage(buffer,"<b>Loading querys...</b>");
			HashMap querys = this.getQuerys(conn);				//cargar todas las consultas
			this.addMessage(buffer,"Queries loaded: " + querys.size() + "<br>");
			
			this.addMessage(buffer,"<b>Loading querys columns...</b>");
			int amountColumns = this.getQryColumns(conn,querys);	//cargar todas las columnas de las consutlas
			this.addMessage(buffer,"Columns loaded: " + amountColumns + "<br>");
			
			this.addMessage(buffer,"<b>Loading entities...</b>");
			HashMap entities = this.getEntities(conn);			//cargar todas las entidades
			this.addMessage(buffer,"Entities loaded: " + entities.size() + "<br>");
			
			this.addMessage(buffer,"<b>Loading functionalities...</b>");
			HashMap fncs = this.getFunctionalities(conn);	//cargar todas las funcionalidades
			this.addMessage(buffer,"Functionalities loaded: " + fncs.size() + "<br>");
			
			this.addMessage(buffer,"<b>Procesing information</b>");
			this.addMessage(buffer,"Procesing querys...");
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {				// para cada consulta buscar la funcionalidad correspondiente
				QueryVo qryVo			= (QueryVo) it.next();								//   marcar las consultas que tienen funcionalidades
				FunctionalityVo fncVo	= (FunctionalityVo) fncs.get(qryVo.getFncPk());		//     marcar la funcionalidad como de la consulta
																							//   marcar las consultas que no tienen funcionalidades			
				if (fncVo != null) {
					if (fncVo.getQueryVo() != null) {	
						qryVo.setFunctionalityUsed(true);
					} else {
						qryVo.setFunctionalityVo(fncVo);
						fncVo.setQueryVo(qryVo);
					}
				} 
			}
		
			this.addMessage(buffer,"Procesing entities...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {				// para cada entidad buscar la funcionalidad correspondiente
				BusEntityVo entVo		= (BusEntityVo) it.next();							//   marcar las entidades que tienen funcionalidades
				FunctionalityVo fncVo	= (FunctionalityVo) fncs.get(entVo.getFncPk());		//     marcar la funcionalidad como de la entidad
																							//	 marcar las entidades que no tienen funcionalidades
				if (fncVo != null) {
					if (fncVo.getQueryVo() != null || fncVo.getBusEntityVo() != null) {
						entVo.setFunctionalityUsed(true);
					} else {
						entVo.setFunctionalityVo(fncVo);
						fncVo.setBusEntityVo(entVo);
					}
				} 
			}
			
			this.addMessage(buffer,"Procesing querys functionality...");
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {	//para las consultas que tienen una funcionalidad
				QueryVo qryVo			= (QueryVo) it.next();					//  determinar si la funcionalidad apunta a la consulta correcta
				FunctionalityVo fncVo	= qryVo.getFunctionalityVo();			//    si no apunta .....
				if (fncVo == null) continue;									//    si apunta marcar la consulta y funcionalidad como correctas
				if (fncVo.getFncUrl().indexOf(qryVo.getQryId().toString()) != -1) {
					fncVo.setCorrectly(true);
					qryVo.setCorrectly(true);
				} else {
					fncVo.setBadUrl(true);
				}
			}
		
			this.addMessage(buffer,"Procesing entities functionality...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {	//para las entidades que tienen una funcionalidad
				BusEntityVo entVo		= (BusEntityVo) it.next();				//  determinar si la funcionalidad apunta a la entidad correcta
				FunctionalityVo fncVo	= entVo.getFunctionalityVo();			//    si no apunta .....
																				//    si apunta marcar la entidad y funcionalidad como correctas
				if (fncVo == null) continue;
				
				if (fncVo.getFncUrl().indexOf(entVo.getBusEntId().toString()) != -1) {
					fncVo.setCorrectly(true);
					entVo.setCorrectly(true);
				} else {
					fncVo.setBadUrl(true);
				}
			}
			
			/*
			para las funcionalidades que no tienen consulta o entidad
			si la funcionalidad es de entidad
			buscar la entidad en función del id
			  si la entidad ya tiene una funcionalidad marcar la funcionalidad como erronea (innecesaria - borrar)
			  si la entidad no tiene una funcionalidad marcar la entidad para actualizar (para que apunta a la funcionalidad)
			si la funcionalidad es de consulta
			buscar la consulta en función del id
			  si la consulta ya tiene una funcionalidad marcar la funcionalidad como erronea (innecesaria - borrar)
			  si la consulta no tiene una funcionalidad marcar la consulta para actualizar (para que apunta a la funcionalidad)
			 */
		
			 this.addMessage(buffer,"Procesing functinalities...");
			for (Iterator it = fncs.values().iterator(); it.hasNext(); ) {
				FunctionalityVo fncVo = (FunctionalityVo) it.next();
				if (fncVo.getQueryVo() != null || fncVo.getBusEntityVo() != null) continue;
				
				if (fncVo.getFncUrl() == null) continue;
				
				
				if (fncVo.getFncUrl().indexOf("execution.EntInstanceAction.do%3Faction=init") == 0) {
					String id = fncVo.getFncUrl().substring(fncVo.getFncUrl().indexOf("txtBusEntId=") + 12);
					Integer busEntId = new Integer(id.substring(0,id.indexOf("&")));
					BusEntityVo busEntVo = (BusEntityVo) entities.get(fncVo.getEnvId() + "-" + busEntId);
					if (busEntVo == null) {
						fncVo.setDelete(true);
					} else if (busEntVo.getFunctionalityVo() != null) {
						fncVo.setDelete(true);
					} else {
						fncVo.setBusEntityVo(busEntVo);
						busEntVo.setFncId(fncVo.getFncId());
						busEntVo.setFunctionalityVo(fncVo);
						busEntVo.setUpdate(true);
					}
					
				} else if (fncVo.getFncUrl().indexOf("redirect.jsp?link=query.") == 0 && 
						fncVo.getFncUrl().indexOf("AdministrationAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorProcessesAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorTasksAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorBlockedDocumentsAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorDocumentsAction") == -1) {
					
					String id = fncVo.getFncUrl().substring(fncVo.getFncUrl().indexOf("query=") + 6);
					Integer qryId = new Integer(id);
					QueryVo qryVo = (QueryVo) querys.get(fncVo.getEnvId() + "-" + qryId);
					if (qryVo == null) {
						fncVo.setDelete(true);
					} else if (qryVo.getFunctionalityVo() != null) {
						fncVo.setDelete(true);
					} else {
						fncVo.setQueryVo(qryVo);
						qryVo.setFncId(fncVo.getFncId());
						qryVo.setFunctionalityVo(fncVo);
						qryVo.setUpdate(true);
					}
				}
			}
			
			this.addMessage(buffer,"");
			
			/* para las funcionalidades que no tienen consultas o entidades tratar de buscar la consulta o entidad en función del título y actualizar */
			this.addMessage(buffer,"Adjusting functinoalities...");
			for (Iterator it = fncs.values().iterator(); it.hasNext(); ) {
				FunctionalityVo fncVo = (FunctionalityVo) it.next();
				if (fncVo.getQueryVo() != null || fncVo.getBusEntityVo() != null) continue;
				if (fncVo.getFncUrl() == null) continue;
				
				if (fncVo.getFncUrl().indexOf("execution.EntInstanceAction.do%3Faction=init") == 0) {
					BusEntityVo busEntVo = this.findBusEntity(entities,fncVo.getFncName());
					if (busEntVo != null) {
						busEntVo.setFncId(fncVo.getFncId());
						busEntVo.setFunctionalityVo(fncVo);
						busEntVo.setUpdate(true);
						fncVo.setBusEntityVo(busEntVo);
						fncVo.setUpdate(true);
						fncVo.setDelete(false);
					}
					
				} else if (fncVo.getFncUrl().indexOf("redirect.jsp?link=query.") == 0 && 
						fncVo.getFncUrl().indexOf("AdministrationAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorProcessesAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorTasksAction") == -1 && 
						fncVo.getFncUrl().indexOf("MonitorDocumentsAction") == -1) {
					QueryVo qryVo = this.findQuery(querys,fncVo.getFncName());
					if (qryVo != null) {
						qryVo.setFncId(fncVo.getFncId());
						qryVo.setFunctionalityVo(fncVo);
						qryVo.setUpdate(true);
						fncVo.setQueryVo(qryVo);
						fncVo.setUpdate(true);
						fncVo.setDelete(false);
					}
				}
			}
			
			this.addMessage(buffer,"");
			
			this.addMessage(buffer,"Reporting querys...");
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {	//para las consultas que no tienen funcionalidades
				QueryVo qryVo	= (QueryVo) it.next();							//  actualizar para que no tenga la funcionalidad
				if (qryVo.getFunctionalityVo() != null) continue;				//  regenerar la consulta para que se consutrya la funcionalidad
				if (qryVo.requiredFnc()) qryVo.mustRegenerate(true);
			}
		
			this.addMessage(buffer,"Reporting entities...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {	//para las entidades que no tienen funcionalidades
				BusEntityVo entVo	= (BusEntityVo) it.next();					//  actualizar para que no tenga la funcionalidad
				if (entVo.getFunctionalityVo() != null) continue;				//  regenerar la entidad para que se consutrya la funcionalidad
				entVo.mustRegenerateFunctionality(true);
			}
		
			this.addMessage(buffer,"");
			
			/* para cada entidad detemrinar si requiere un modal
			 * buscar el modal de la entidad
			 * si lo encuentra asociar
			 */
			this.addMessage(buffer,"Checking entities query...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if (entVo.getFlagValue(BusEntityVo.FLAG_HAS_QUERY_MODAL)) {
					QueryVo qryVo = this.findQueryModal(querys, entVo.getBusEntId());
					if (qryVo != null) {
						entVo.setQueryVo(qryVo);
						entVo.setCorrectlyModal(true);
					}
				}
			}
			
			/* para cada entidad determianr si requiere un modal
			 * si requiere un modal y no tiene la consulta
			 * buscar la consulta por medio del nombre
			 */
			this.addMessage(buffer,"Checking entities query by name...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if (entVo.getFlagValue(BusEntityVo.FLAG_HAS_QUERY_MODAL) && entVo.getQueryVo() == null) {
					QueryVo qryVo = this.findQueryModal(querys, "MDL_" + entVo.getBusEntName());
					if (qryVo != null && qryVo.getBusEntityVo() == null) {
						entVo.setQueryVo(qryVo);
						entVo.setCorrectlyModal(true);
						qryVo.mustUpdateModal(true);
						qryVo.setBusEntityVo(entVo);
					}
				}
			}
			
			/* para cada entidad deteminar si requiere un modal
			 * si requiere un modal y no tiene la consulta
			 * regenerar
			 */
			this.addMessage(buffer,"Checking entities modal...");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if (entVo.getFlagValue(BusEntityVo.FLAG_HAS_QUERY_MODAL) && entVo.getQueryVo() == null) {
					entVo.mustRegenerateQuery(true);
				}
			}
			
			this.addMessage(buffer,"");
			
			//Mostrar el resultado
			this.addMessage(buffer,"<b>Querys analyze</b>");
			
			html = new StringBuffer();
			html.append("<table border=\"1\">");
			html.append("<tr>");
				html.append("<td><b>Fnc</b></td>");
				html.append("<td><b>Used</b></td>");
				html.append("<td><b>Ok</b></td>");
				html.append("<td><b>Regen</b></td>");
				html.append("<td><b>Update</b></td>");
				html.append("<td><b>Mod Upd</b></td>");
				html.append("<td><b>Name</b></td>");
			html.append("</tr>");
			
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {
				QueryVo qryVo = (QueryVo) it.next();
				if (! qryVo.isAltered()) continue;
				
				html.append("<tr>");
					html.append("<td>" + ((qryVo.getFunctionalityVo() != null) ? qryVo.getFunctionalityVo().getFncId().toString() : "") + "</td>");
					html.append("<td>" + qryVo.isFunctionalityUsed() + "</td>");
					html.append("<td>" + qryVo.isCorrectly() + "</td>");
					html.append("<td>" + qryVo.isRegenerate() + "</td>");
					html.append("<td>" + qryVo.isUpdate() + "</td>");
					html.append("<td>" + qryVo.isUpdateModal() + "</td>");
					html.append("<td>" + qryVo.getQryId() + "</td>");
					html.append("<td>" + qryVo.getQryName() + "</td>");
				html.append("</tr>");
			}
			html.append("</table>");
			buffer.append(html);
			this.addMessage(buffer,"");
			
			this.addMessage(buffer,"<b>SQL's to update queries</b>");
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {
				QueryVo qryVo = (QueryVo) it.next();
				if (! qryVo.isAltered()) continue;
				if (qryVo.hasSql()) {
					String sql = qryVo.genSql();
					if (! "NOT REQURIED".equals(sql)) {
						if (impactInDataBase) {
							this.addMessage(buffer,"Executing: " + sql);
							this.execute(conn, sql);
						} else {
							this.addMessage(buffer,"Please execute: " + sql);
						}
						
					}
				}
			}
			
			this.addMessage(buffer,"<b>Please regenerate the following querys" + (impactInDataBase ? "" : " after executeing the previous SQL's") + "</b>");
			for (Iterator it = querys.values().iterator(); it.hasNext(); ) {
				QueryVo qryVo = (QueryVo) it.next();
				if ((! qryVo.isAltered()) || ! qryVo.isRegenerate()) continue;
				this.addMessage(buffer,"Regenerate query: " + qryVo.getQryName());
			}
		
			this.addMessage(buffer,"");
			this.addMessage(buffer,"<b>Entities analize</b>");
			
			html = new StringBuffer();
			html.append("<table border=\"1\">");
			html.append("<tr>");
				html.append("<td><b>Fnc</b></td>");
				html.append("<td><b>Used</b></td>");
				html.append("<td><b>Ok</b></td>");
				html.append("<td><b>Regen</b></td>");
				html.append("<td><b>Update</b></td>");
				html.append("<td><b>Ok Mod</b></td>");
				html.append("<td><b>Id</b></td>");
				html.append("<td><b>Name</b></td>");
			html.append("</tr>");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if (! entVo.isAltered()) continue;
				html.append("<tr>");
					html.append("<td>" + ((entVo.getFunctionalityVo() != null) ? entVo.getFunctionalityVo().getFncId().toString() : "")  + "</td>");
					html.append("<td>" + entVo.isFunctionalityUsed() + "</td>");
					html.append("<td>" + entVo.isCorrectly() + "</td>");
					html.append("<td>" + entVo.isRegenerate() + "</td>");
					html.append("<td>" + entVo.isUpdate() + "</td>");
					html.append("<td>" + entVo.isCorrectlyModal() + "</td>");
					html.append("<td>" + entVo.getBusEntId() + "</td>");
					html.append("<td>" + entVo.getBusEntName() + "</td>");
				html.append("</tr>");
			}
			html.append("</table>");
			buffer.append(html);
			this.addMessage(buffer,"");
			
			this.addMessage(buffer,"<b>SQL's to update entities</b>");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if (! entVo.isAltered()) continue;
				String sql = entVo.genSql();
				if (! "NOT REQUIRED".equals(sql)) {
					if (impactInDataBase) {
						this.addMessage(buffer,"Executing: " + sql);
						this.execute(conn, sql);
					} else {
						this.addMessage(buffer,"Please execute: " + sql);
					}
				}
			}
			
			this.addMessage(buffer,"<b>Please regenerate the following entities" + (impactInDataBase ? "" : " after executeing the previous SQL's") + "</b>");
			for (Iterator it = entities.values().iterator(); it.hasNext(); ) {
				BusEntityVo entVo = (BusEntityVo) it.next();
				if ((! entVo.isAltered()) || ! entVo.isRegenerate()) continue;
				this.addMessage(buffer,"Regenerate entitiy: " + entVo.getBusEntName());
			}
			
			this.addMessage(buffer,"");
			this.addMessage(buffer,"<b>Functionalities analize</b>");
			
			html = new StringBuffer();
			html.append("<table border=\"1\">");
			html.append("<tr>");
				html.append("<td><b>Ok</b></td>");
				html.append("<td><b>BadUrl</b></td>");
				html.append("<td><b>Delete</b></td>");
				html.append("<td><b>Update</b></td>");
				html.append("<td><b>To</b></td>");
				html.append("<td><b>Id</b></td>");
				html.append("<td><b>Title</b></td>");
			html.append("</tr>");
			
			for (Iterator it = fncs.values().iterator(); it.hasNext(); ) {
				FunctionalityVo fncVo = (FunctionalityVo) it.next();
				if (! fncVo.isAltered()) continue;
				html.append("<tr>");
					html.append("<td>" + fncVo.isCorrectly() + "</td>");
					html.append("<td>" + fncVo.isBadUrl() + "</td>");
					html.append("<td>" + fncVo.isDelete() + "</td>");
					html.append("<td>" + fncVo.isUpdate() + "</td>");
					html.append("<td>" + fncVo.getUpdateToId() + "</td>");
					html.append("<td>" + fncVo.getFncId() + "</td>");
					html.append("<td>" + fncVo.getFncName() + "</td>");
				html.append("</tr>");
			}
			html.append("</table>");
			buffer.append(html);
			this.addMessage(buffer,"");
			
			this.addMessage(buffer,"<b>SQL's to update functionalities</b>");
			
			html = new StringBuffer();
			
			for (Iterator it = fncs.values().iterator(); it.hasNext(); ) {
				FunctionalityVo fncVo = (FunctionalityVo) it.next();
				if (! fncVo.isAltered()) continue;
				String sql = fncVo.genSql();
				String sqlDel1 = fncVo.getSqlDel1(sql);
				String sqlDel2 = fncVo.getSqlDel2(sql);
				if (! "NOT REQUIRED".equals(sql)) {
					
					if (sql.startsWith("delete from ")) {
						if (impactInDataBase) {
							html.append("The functionality " + fncVo.getFncName() + " has been removed from the profiles. Please add it again.<br>");
						} else {
							html.append("The functionality " + fncVo.getFncName() + " will be removed from the profiles. Please add it again at the end.<br>");
						}
					}
					
					if (impactInDataBase) {
						if (sqlDel1 != null) {
							this.addMessage(buffer,"Executing: " + sqlDel1);
							this.execute(conn, sqlDel1);
						}
						if (sqlDel2 != null) {
							this.addMessage(buffer,"Executing: " + sqlDel2);
							this.execute(conn, sqlDel2);
						}
						this.addMessage(buffer,"Executing: " + sql);
						this.execute(conn, sql);
					} else {
						if (sqlDel1 != null) this.addMessage(buffer,"Please execute: " + sqlDel1);
						if (sqlDel2 != null) this.addMessage(buffer,"Please execute: " + sqlDel2);
						this.addMessage(buffer,"Please execute: " + sql);
					}
				}
			}
			
			if (html.length() > 0) {
				buffer.append(html);
			}
			
			if (impactInDataBase) {
				this.addMessage(buffer,"");
				this.addMessage(buffer,"Doing commit in database...");
				conn.commit();
			}
		} catch (Exception e) {
			this.addError(buffer,e.getMessage());
			try {
				this.addMessage(buffer,"");
				this.addMessage(buffer,"Doing rollback in database");
				conn.rollback();
			} catch (Exception ee) {
				this.addError(buffer,ee.getMessage());
			}
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"");
				this.addMessage(buffer,"Closeing connection...");
				dbConn.close();
			}
		}
		
		return buffer.toString();
	}
}

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

%>

<%
String action = request.getParameter("action");

boolean isVerifyFunctionality	= "verifyFunctionality".equals(action);
boolean isCorrectFunctionality	= "correctFunctionality".equals(action);

%>

Options: 
	<%= isVerifyFunctionality?"<b>":"" %> <a href="?action=verifyFunctionality" title="Check if all functionalities are correct.">[ Verify Functionalities ]</a><%= isVerifyFunctionality?"</b>":"" %>
	<%= isCorrectFunctionality?"<b>":"" %>   <a href="?action=correctFunctionality" title="Implements 'Verifiy JavaScript' and tries to correct the files (backup of files is recomended)" onclick="return confirm('Database will be updated. Rollback not available.\n\rWant to continue?');" >[ Correct Functionalities ]</a><%= isCorrectFunctionality?"</b>":"" %>
	<a href="?" title="Init the screen">[ Init ]</a>
	<br>
<hr>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
if (action != null) {
	String actionResult = null;
	Test test = new Test();
	if (isVerifyFunctionality) {
		actionResult = test.verifyFunctionality(false);
	} else if (isCorrectFunctionality) {
		actionResult = test.verifyFunctionality(true);
	}
	
	if (actionResult != null) out.print(actionResult);
} %></div>
</body>
</html>