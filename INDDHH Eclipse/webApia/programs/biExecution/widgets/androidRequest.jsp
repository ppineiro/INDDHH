<%@page import="com.dogma.util.LDAPAccessor"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.vo.TasksListVo"%><%@page import="javax.crypto.Cipher"%><%@page import="javax.crypto.spec.SecretKeySpec"%><%@page import="javax.crypto.SecretKey"%><%@page import="java.security.SecureRandom"%><%@page import="javax.crypto.KeyGenerator"%><%@page import="com.dogma.Parameters"%><%@ page import="com.st.db.dataAccess.*" %><%@ page import="com.dogma.dataAccess.*" %><%@page import="com.dogma.vo.UserVo"%><%@page import="com.dogma.dao.UserDAO"%><%@page import="com.st.util.CryptUtils"%><%@page import="com.st.util.DateUtil"%><%@ page import="java.util.*" %><%@ page import="java.util.Date" %><%@ page import="java.sql.*" %><%@page import="com.dogma.dao.DbConnectionDAO"%><%
/**************************************************************************************************************
                      Archivo utilizado por:
                    	  1) Widget Android ApiaTasks
                    	  2) La aplicación Android/iOS ApiaTasksPanel
                    	  3) Gadget de escritorio ApiaTasksGadget
                    
                      Parámetros de entrada:
                    	  1) app            --> Aplicación que esta solicitando la información: 'ApiaTasks', 'ApiaTasksPanel' o 'ApiaTasksGadget'
                    	  2) userLogin      --> Usuario del cual se desea recuperar las tareas
                    	  3) userPass       --> Password del usuario del cual se desea recuperar las tareas
                    	  4) encryptedPass  --> Indica si el password viene encriptado: 'true/false'
                          5) envName        --> Ambiente en el cual se debe loguear el usuario
                      	  6) action         --> Acción a realizar (cuando app=ApiaTasksPanel): 'START_PROC', 'TASK_LIST' o 'CANCEL_PROC'
                      	  7) busEntId       --> Instancia a cancelar (cuando app=ApiaTasksPanel y action=CANCEL_PROC)
                      	  
                      Devuelve XML:
                    	  1) Si app=ApiaTasks devuelve cantidad de tareas adquiridas y libres
                       
                    		   	<?xml version="1.0" encoding="ISO-8859-1" ?><xmlMessage msgType="1"> -> //1 es nuevo valor, //2 es un error
                        			<response acquired="14" free="10" error="0" />   -> // 0 es un no hubo error, -1 es login o pass incorrecto, -2 es ambiente no existe, -5 apia no permite consultas desde dispositivos móviles
                        		</xmlMessage>

                          2) Si app=ApiaTasksGadget devuelve cantidad de tareas adquiridas y libres (se debe enviar el encoding UTF-8)
                                
                    		   	<?xml version="1.0" encoding="UTF-8" ?><xmlMessage msgType="1"><response acquired="14" free="10" error="0" /></xmlMessage>
                        		
                          2) Si app=ApiaTasksPanel 
                          
                              i) Si action=TASK_LIST devuelve:
                            	  	<?xml version="1.0" encoding="ISO-8859-1" ?><xmlMessage msgType="1"><acquiredTask><task taskName=XXXX proPriority="XXX" ... />
                              				.
                              				.
                              				<task taskName=XXXX proPriority="XXX" ... /></acquiredTask><freeTask><task taskName=XXXX proPriority="XXX" ... />
                      						.
                      						.
                      						<task taskName=XXXX proPriority="XXX" ... /></freeTask></xmlMessage>
                      			   	
                      		 ii) Si action=START_PROC devuelve:	
                      			  <?xml version="1.0" encoding="ISO-8859-1" ?><xmlMessage msgType="1"><creationProcesses><process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 />
                             				.
                             				.
                             				<process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 /></creationProcesses><alterationProcesses><process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 />
				                      		.
	                         				.
	                         				<process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 /></alterationProcesses><process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 />
	                         				.
	                         				.
	                         				<process proId=3423 proTitle=ADSFASD entId=2332 envId=1111 /><cancelationProcesses></cancelationProcesses></xmlMessage>
		                      		
                          iii) Si action=CANCEL_PROC
                        		  <?xml version="1.0" encoding="ISO-8859-1" ?><xmlMessage msgType="1" error="0"><instProcToCancel><instance proId=3223 proTitle=ADFA entId=3433 envId=1111 />
                  							.
                  							.
                  							<instance proId=3223 proTitle=ADFA entId=3433 envId=1111 /></instProcToCancel></xmlMessage>
***************************************************************************************************************/
%><%! 


protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class MyUtilClass extends DBAdmin {
	
	private final int FREE_TASKS = 1;
	private final int ACQUIRED_TASKS = 2;
	
	private final int CREATION_PROCESSES = 1;
	private final int ALTERATION_PROCESSES = 2;
	private final int CANCELATION_PROCESSES = 3;
	
	private String acquiredTasksNumberSQL = "SELECT count(*) as CANT " +
			"FROM usr_pool up, pool po, pro_instance pi, pro_ele_instance pel " +
			"WHERE pel.pool_id = po.pool_id_auto AND po.reg_status = 0 AND pel.pool_id = up.pool_id AND up.reg_status = 0 AND pel.env_id = pi.env_id " +  
			"AND pel.pro_inst_id = pi.pro_inst_id_auto AND pel.pro_ele_inst_status = 'A' AND pi.pro_inst_status <> 'S' AND "+   
			"pi.env_id = ? AND up.usr_login = ?";

	private String freeTasksNumberSQL = "select count(*) as CANT from pro_ele_instance where pro_ele_inst_date_acquired is null and env_id = ?" +
		  "	and pro_ele_inst_date_ready is not null and pro_ele_inst_status = 'R' " +
		  "	and pool_id in (select pool_id from usr_pool where usr_login = ?)";
	
	private String acquiredTasksListSQL1 = "SELECT t.tsk_name, pi.pro_priority, bei.bus_ent_inst_name_pos, bei.bus_ent_inst_name_num, bei.bus_ent_inst_name_pre," +   
			"pi.pro_inst_name_pre, pi.pro_inst_name_num, pi.pro_inst_name_pos, po.pool_name, p.pro_title,  p.pro_action, " +
			"pel.pro_ele_inst_date_ready AS task_date, pi.pro_inst_create_date AS proc_date, pi.pro_inst_create_user, " +
		    "pi.pro_inst_alert_warn, pi.pro_inst_alert_over, pel.pro_ele_inst_alert_warn, pel.pro_ele_inst_alert_over, " +
		    "pel.pro_inst_warn_date AS pro_ele_inst_warn_date, pi.pro_inst_warn_date, pel.pro_inst_overdue_date AS pro_ele_inst_overdue_date, " +
		    "pi.pro_inst_overdue_date, pel.pro_ele_inst_user_acquired as user_acquired," +
		    "pi.att_value_1 AS pro_inst_att_value_1, pi.att_value_2 AS pro_inst_att_value_2, pi.att_value_3 AS pro_inst_att_value_3," +
			"pi.att_value_4 AS pro_inst_att_value_4, pi.att_value_5 AS pro_inst_att_value_5, pi.att_value_num_1 as pro_inst_att_value_num_1, pi.att_value_num_2 as pro_inst_att_value_num_2," +
			"pi.att_value_num_3 as pro_inst_att_value_num_3, pi.att_value_dte_1 as pro_inst_att_value_dte_1, pi.att_value_dte_2 as pro_inst_att_value_dte_2, pi.att_value_dte_3 as pro_inst_att_value_dte_3,"+
			"bei.att_value_1 as bus_ent_inst_att_value_1, bei.att_value_2 as bus_ent_inst_att_value_2, bei.att_value_3 as bus_ent_inst_att_value_3, bei.att_value_4 as bus_ent_inst_att_value_4," +
			"bei.att_value_5 as bus_ent_inst_att_value_5, bei.att_value_6 as bus_ent_inst_att_value_6, bei.att_value_7 as bus_ent_inst_att_value_7, bei.att_value_8 as bus_ent_inst_att_value_8," +
			"bei.att_value_9 as bus_ent_inst_att_value_9, bei.att_value_10 as bus_ent_inst_att_value_10, bei.att_value_num_1 as bus_ent_inst_att_value_num_1, bei.att_value_num_2 as bus_ent_inst_att_value_num_2," +
			"bei.att_value_num_3 as bus_ent_inst_att_value_num_3, bei.att_value_num_4 as bus_ent_inst_att_value_num_4, bei.att_value_num_5 as bus_ent_inst_att_value_num_5, bei.att_value_num_6 as bus_ent_inst_att_value_num_6," +
			"bei.att_value_num_7 as bus_ent_inst_att_value_num_7, bei.att_value_num_8 as bus_ent_inst_att_value_num_8, bei.att_value_dte_1 as bus_ent_inst_att_value_dte_1, bei.att_value_dte_2 as bus_ent_inst_att_value_dte_2," +
			"bei.att_value_dte_3 as bus_ent_inst_att_value_dte_3, bei.att_value_dte_4 as bus_ent_inst_att_value_dte_4, bei.att_value_dte_5 as bus_ent_inst_att_value_dte_5, bei.att_value_dte_6 as bus_ent_inst_att_value_dte_6" +
		  	" FROM bus_entity be, process p, task t, usr_pool up, pool po, pro_instance pi, bus_ent_instance bei, pro_element pe, pro_ele_instance pel" +
		  	" WHERE pel.pool_id = po.pool_id_auto AND po.reg_status = 0 AND pel.pool_id = up.pool_id AND up.reg_status = 0 AND pel.env_id = pi.env_id " +
		  	" AND pel.pro_inst_id = pi.pro_inst_id_auto AND pel.pro_ele_inst_status = 'A' AND pi.pro_inst_status <> 'S' " +
		    " AND pi.env_id = p.env_id AND pi.pro_id = p.pro_id_auto AND pi.pro_ver_id = p.pro_ver_id AND pi.env_id = bei.env_id AND pi.bus_ent_inst_id = bei.bus_ent_inst_id_auto " + 
		    " AND bei.env_id = be.env_id AND bei.bus_ent_id = be.bus_ent_id_auto AND pel.env_id = pe.env_id AND pel.pro_id = pe.pro_id " +
		    " AND pel.pro_ver_id = pe.pro_ver_id AND pel.pro_ele_id = pe.pro_ele_id_auto AND pe.env_id = t.env_id " +
		    " AND pe.tsk_id = t.tsk_id_auto AND pi.env_id = ? AND up.usr_login = ?";
 	private String acquiredTasksListSQL2 = " ORDER BY t.tsk_name";
	
	private String freeTaskListSQL = "SELECT t.tsk_name, pi.pro_priority, up.usr_login, bei.bus_ent_inst_name_pre, bei.bus_ent_inst_name_num, bei.bus_ent_inst_name_pos," +
			"pi.pro_inst_name_pre, pi.pro_inst_name_num, pi.pro_inst_name_pos, po.pool_name, p.pro_title, p.pro_action," +
			"pel.pro_ele_inst_date_ready AS task_date, pi.pro_inst_create_date AS proc_date, pi.pro_inst_create_user, " +
		    "pi.pro_inst_alert_warn, pi.pro_inst_alert_over, pel.pro_ele_inst_alert_warn, pel.pro_ele_inst_alert_over, " +
		    "pel.pro_inst_warn_date AS pro_ele_inst_warn_date, pi.pro_inst_warn_date, pel.pro_inst_overdue_date AS pro_ele_inst_overdue_date, " +
			"pi.pro_inst_overdue_date, pel.pro_ele_inst_user_acquired as user_acquired," +
		    "pi.att_value_1 AS pro_inst_att_value_1, pi.att_value_2 AS pro_inst_att_value_2, pi.att_value_3 AS pro_inst_att_value_3," +
			"pi.att_value_4 AS pro_inst_att_value_4, pi.att_value_5 AS pro_inst_att_value_5, pi.att_value_num_1 as pro_inst_att_value_num_1, pi.att_value_num_2 as pro_inst_att_value_num_2," +
			"pi.att_value_num_3 as pro_inst_att_value_num_3, pi.att_value_dte_1 as pro_inst_att_value_dte_1, pi.att_value_dte_2 as pro_inst_att_value_dte_2, pi.att_value_dte_3 as pro_inst_att_value_dte_3,"+
			"bei.att_value_1 as bus_ent_inst_att_value_1, bei.att_value_2 as bus_ent_inst_att_value_2, bei.att_value_3 as bus_ent_inst_att_value_3, bei.att_value_4 as bus_ent_inst_att_value_4," +
			"bei.att_value_5 as bus_ent_inst_att_value_5, bei.att_value_6 as bus_ent_inst_att_value_6, bei.att_value_7 as bus_ent_inst_att_value_7, bei.att_value_8 as bus_ent_inst_att_value_8," +
			"bei.att_value_9 as bus_ent_inst_att_value_9, bei.att_value_10 as bus_ent_inst_att_value_10, bei.att_value_num_1 as bus_ent_inst_att_value_num_1, bei.att_value_num_2 as bus_ent_inst_att_value_num_2," +
			"bei.att_value_num_3 as bus_ent_inst_att_value_num_3, bei.att_value_num_4 as bus_ent_inst_att_value_num_4, bei.att_value_num_5 as bus_ent_inst_att_value_num_5, bei.att_value_num_6 as bus_ent_inst_att_value_num_6," +
			"bei.att_value_num_7 as bus_ent_inst_att_value_num_7, bei.att_value_num_8 as bus_ent_inst_att_value_num_8, bei.att_value_dte_1 as bus_ent_inst_att_value_dte_1, bei.att_value_dte_2 as bus_ent_inst_att_value_dte_2," +
			"bei.att_value_dte_3 as bus_ent_inst_att_value_dte_3, bei.att_value_dte_4 as bus_ent_inst_att_value_dte_4, bei.att_value_dte_5 as bus_ent_inst_att_value_dte_5, bei.att_value_dte_6 as bus_ent_inst_att_value_dte_6" +
		    " FROM usr_pool up, pool po, vw_pro_ele_instance_01 pel, pro_instance pi, bus_ent_instance bei, bus_entity be, process p, task t " +
		    " WHERE pel.env_id = pi.env_id AND pel.pro_inst_id = pi.pro_inst_id_auto AND pi.env_id = bei.env_id AND pi.bus_ent_inst_id = bei.bus_ent_inst_id_auto " +
		    " AND bei.env_id = be.env_id AND bei.bus_ent_id = be.bus_ent_id_auto AND pel.env_id = p.env_id AND pel.pro_id = p.pro_id_auto AND pel.pro_ver_id = p.pro_ver_id " +
		    " AND pel.env_id = t.env_id AND pel.tsk_id = t.tsk_id_auto AND pel.pool_id = po.pool_id_auto AND pel.pro_ele_inst_status = 'R' AND pi.pro_inst_status <> 'S' AND pel.pool_id = up.pool_id AND up.reg_status = 0 " +
		    " AND pi.env_id = ? AND up.usr_login = ? ORDER BY t.tsk_name";
		    
	private String procInstancesToCancelSQL = "SELECT bei.bus_ent_inst_name_pre, bei.bus_ent_inst_name_num, bei.bus_ent_inst_name_pos, pi.pro_inst_name_pre, pi.pro_inst_name_num, pi.pro_inst_name_pos," + 
			"p.pro_title, pi.pro_inst_create_user, pi.pro_inst_create_date " +
			"FROM pro_instance pi, bus_ent_instance bei, process p, bus_entity be " +
			"WHERE p.pro_action::text <> 'Z'::text AND p.env_id = pi.env_id AND p.pro_id_auto = pi.pro_id AND p.pro_ver_id = pi.pro_ver_id AND pi.env_id = bei.env_id " + 
			"AND pi.bus_ent_inst_id = bei.bus_ent_inst_id_auto AND pi.pro_inst_status::text = 'R'::text AND pi.reg_status = 0 AND bei.env_id = be.env_id " +
			"AND bei.bus_ent_id = be.bus_ent_id_auto AND bei.reg_status = 0 " +
			"AND p.env_id = ? and bei.bus_ent_id = ?";
	
	private String getEnvironment = "select env_id_auto from environment where env_name = ?";
	
	private String creationProcessesSQL = "SELECT * FROM vw_process_start_01 where env_id=? AND usr_login = ? and pro_action='C' and reg_status=0 order by pro_name";
	private String alterationProcessesSQL = "SELECT * FROM vw_process_start_01 where env_id=? AND usr_login = ? and pro_action='A' and reg_status=0 order by pro_name";
	private String cancelationProcessesSQL = "SELECT * FROM vw_process_start_01 where env_id=? AND usr_login = ? and pro_action='Z' and reg_status=0 order by pro_name";
	
	//Retorna el id del ambiente pasado por parametro
	public Integer getEnvironmentId(String envName) {
		Integer envId = null; 
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, getEnvironment, false);
					statement.setString(1, envName);
					resultSet = statement.executeQuery();
					if (resultSet.next()){
						envId = resultSet.getInt("env_id_auto");
					}
				}
			}	
		} catch (Exception e) {

		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return envId;
		}
	}
	
	//Retorna true si el usuario/password son correctos
	public boolean checkLogin(String userLogin, String userPass){
		DBConnection dbConn = null;
		boolean ret = false;
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				
				if (!conn.isClosed()) {
					if (Parameters.AUTHENTICATION_METHOD.equals(Parameters.AUTHENTICATION_LDAP)) {
						ret = doLoginLDAP(dbConn, userLogin, userPass);
					}else {
						ret = doLogin(dbConn, userLogin, userPass);
					}
				}
			}
		} catch (Exception e) {

		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return ret;
		}
	}
	
	private boolean doLogin(DBConnection dbConn, String userLogin, String userPass){
		boolean ret = false;
		try {
			UserVo uVo = UserDAO.getInstance().getUsersVo(dbConn, userLogin);
			
			// MAKE THE MESSAGE
			String msgDigest = CryptUtils.makePasswordDigest(userLogin, userPass);
			
			String dbMessage = "";
			if (uVo != null) {
				// IF THE USER IS DELETED RETURN FALSE
				if (uVo.getRegStatus().intValue() == 1) {
					ret= false;
				}
				dbMessage = uVo.getUsrPassword();
			}else {
				System.out.println("uVo es null");
			}
			// COMPARE THE MESSAGES
			if (msgDigest.equals(dbMessage)) {
				if (!uVo.getFlagValue(UserVo.FLAG_PWD_NEVER_EXPIRES)) {
					// CHECK IF THE USER IS "EXPIRED"
					if (Parameters.USER_VIGENCY != null && DateUtil.addDay(uVo.getUsrLastUsrLogin(), Parameters.USER_VIGENCY.intValue()).before(new Date())) {
						ret= false;
					}
				}
				ret = true;
			}else {
				System.out.println("Password incorrecto");
			}
		}catch (Exception e) {
			
		}finally {
			return ret;
		}
	}
	
	private boolean doLoginLDAP(DBConnection conn, String userId, String userPwd) {
		boolean ret = false;
		try {
			// GET THE USER
			UserVo uVo = UserDAO.getInstance().getUsersVo(conn, userId);
			if (uVo != null && uVo.getRegStatus().intValue() == 0) {
				 LDAPAccessor ldapAcc = new LDAPAccessor();
				    String domainUser = "";
				    String domain = null;
				    if(Parameters.LDAP_AD_DOMAIN.trim().length() > 0) { domain = Parameters.LDAP_AD_DOMAIN.trim(); }
				    
				    if (domain == null) {
				    	domainUser = userId;
				    } else {
				    	if (Parameters.LDAP_AD_ARROBA_DOMAIN) {
				    		domainUser = userId + "@" + domain;
				    	} else {
				    		domainUser = domain + "\\" + userId;
				    	}
				    }
				    
			    if(ldapAcc.validateUser(domainUser,userPwd)) {
					ret = true;
				} 
			}
		} catch (Exception e) {
			
		} finally {
			return ret;
		}
	}
	
	//Retorna la cantidad de tareas adquiridas por el usuario pasado por parametro en el ambiente pasado por parametro
	public int getAcquiredTasks(Integer envId, String userLogin) {
		int cant = 0; 
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		String sql = acquiredTasksNumberSQL;
		
		if (Parameters.SHOW_MY_TASKS) {
			sql += " and pel.pro_ele_inst_user_acquired = up.usr_login";
		}
		
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
					statement.setInt(1, envId.intValue());
					statement.setString(2, userLogin);
					resultSet = statement.executeQuery();
					if (resultSet.next()){
						cant = resultSet.getInt("cant");
					}
				}
			}	
		} catch (Exception e) {

		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return cant;
		}
	}
	
	//Retorna la cantidad de tareas libres por el usuario pasado por parametro en el ambiente pasado por parametro	
	public int getFreeTasks(Integer envId, String userLogin) {
		int cant = 0; 
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, freeTasksNumberSQL, false);
					statement.setInt(1, envId.intValue());
					statement.setString(2, userLogin);
					resultSet = statement.executeQuery();
					if (resultSet.next()){
						cant = resultSet.getInt("cant");
					}
				}
			}	
		} catch (Exception e) {

		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return cant;
		}
	}
	
	//Retorna las tareas libres/adquiridas por el usuario pasado por parametro en el ambiente pasado por parametro	
	public Collection<TasksListVo> getTasksList(Integer envId, String userLogin, int sqlNum) {
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		Collection<TasksListVo> colRet = new ArrayList<TasksListVo>();
		String sql = "";
		if (sqlNum == FREE_TASKS){
			sql = freeTaskListSQL;
		}else {
			sql = acquiredTasksListSQL1;
				if (Parameters.SHOW_MY_TASKS) {
					sql += " and pel.pro_ele_inst_user_acquired = up.usr_login";
				}
			sql += acquiredTasksListSQL2;
		}
		
		System.out.println("sql: " + sql);
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
					statement.setInt(1, envId.intValue());
					statement.setString(2, userLogin);
					resultSet = statement.executeQuery();
					while (resultSet.next()){
						TasksListVo vo = new TasksListVo();
						vo.setTaskName(resultSet.getString("TSK_NAME"));
						vo.setPriority(Integer.valueOf(resultSet.getInt("PRO_PRIORITY")));
						vo.setEntInstIdPre(resultSet.getString("BUS_ENT_INST_NAME_PRE"));
						if(resultSet.getString("BUS_ENT_INST_NAME_NUM")!=null){
							vo.setEntInstIdNum(Integer.valueOf(resultSet.getInt("BUS_ENT_INST_NAME_NUM")));
						}
						vo.setEntInstIdPos(resultSet.getString("BUS_ENT_INST_NAME_POS"));
						vo.setProcInstIdPre(resultSet.getString("PRO_INST_NAME_PRE"));
						vo.setProcInstIdNum(Integer.valueOf(resultSet.getInt("PRO_INST_NAME_NUM")));
						vo.setProcInstIdPos(resultSet.getString("PRO_INST_NAME_POS"));
						vo.setGroupName(resultSet.getString("POOL_NAME"));
						vo.setProcessTitle(resultSet.getString("PRO_TITLE"));
						vo.setProcessType(resultSet.getString("PRO_ACTION"));
						vo.setTaskCreationDate(resultSet.getTimestamp("TASK_DATE"));
						vo.setProcCreationDate(resultSet.getTimestamp("PROC_DATE"));
						vo.setProcCreateUser(resultSet.getString("PRO_INST_CREATE_USER"));
						if (resultSet.getString("USER_ACQUIRED") != null) vo.setUserLogin(resultSet.getString("USER_ACQUIRED"));
						
						if (resultSet.getTimestamp("PRO_INST_WARN_DATE") != null) vo.setProInstAlertDate(resultSet.getTimestamp("PRO_INST_WARN_DATE"));
						if (resultSet.getString("PRO_INST_OVERDUE_DATE") != null) vo.setProInstEndDate(resultSet.getTimestamp("PRO_INST_OVERDUE_DATE"));
						if (resultSet.getString("PRO_ELE_INST_WARN_DATE") != null) vo.setProEleInstAlertDate(resultSet.getTimestamp("PRO_ELE_INST_WARN_DATE"));
						if (resultSet.getString("PRO_ELE_INST_OVERDUE_DATE") != null) vo.setProEleInstEndDate(resultSet.getTimestamp("PRO_ELE_INST_OVERDUE_DATE"));
						
						if (resultSet.getString("PRO_INST_ATT_VALUE_1") != null) vo.setProInstAtt1Value(resultSet.getString("PRO_INST_ATT_VALUE_1"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_2") != null) vo.setProInstAtt2Value(resultSet.getString("PRO_INST_ATT_VALUE_2"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_3") != null) vo.setProInstAtt3Value(resultSet.getString("PRO_INST_ATT_VALUE_3"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_4") != null) vo.setProInstAtt4Value(resultSet.getString("PRO_INST_ATT_VALUE_4"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_5") != null) vo.setProInstAtt5Value(resultSet.getString("PRO_INST_ATT_VALUE_5"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_NUM_1")!=null) vo.setProInstAtt1ValueNum(Double.valueOf(resultSet.getInt("PRO_INST_ATT_VALUE_NUM_1")));
						if (resultSet.getString("PRO_INST_ATT_VALUE_NUM_2")!=null) vo.setProInstAtt2ValueNum(Double.valueOf(resultSet.getInt("PRO_INST_ATT_VALUE_NUM_2")));
						if (resultSet.getString("PRO_INST_ATT_VALUE_NUM_3")!=null) vo.setProInstAtt3ValueNum(Double.valueOf(resultSet.getInt("PRO_INST_ATT_VALUE_NUM_3")));
						if (resultSet.getString("PRO_INST_ATT_VALUE_DTE_1") != null) vo.setProInstAtt1ValueDte(resultSet.getTimestamp("PRO_INST_ATT_VALUE_DTE_1"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_DTE_2") != null) vo.setProInstAtt2ValueDte(resultSet.getTimestamp("PRO_INST_ATT_VALUE_DTE_2"));
						if (resultSet.getString("PRO_INST_ATT_VALUE_DTE_3") != null) vo.setProInstAtt3ValueDte(resultSet.getTimestamp("PRO_INST_ATT_VALUE_DTE_3"));
						
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_1") !=null) vo.setEntInstAtt1Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_1"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_2") !=null) vo.setEntInstAtt2Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_2"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_3") !=null) vo.setEntInstAtt3Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_3"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_4") !=null) vo.setEntInstAtt4Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_4"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_5") !=null) vo.setEntInstAtt5Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_5"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_6") !=null) vo.setEntInstAtt6Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_6"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_7") !=null) vo.setEntInstAtt7Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_7"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_8") !=null) vo.setEntInstAtt8Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_8"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_9") !=null) vo.setEntInstAtt9Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_9"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_10") !=null) vo.setEntInstAtt10Value(resultSet.getString("BUS_ENT_INST_ATT_VALUE_10"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_1") !=null) vo.setEntInstAtt1ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_1")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_2") !=null) vo.setEntInstAtt2ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_2")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_3") !=null) vo.setEntInstAtt3ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_3")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_4") !=null) vo.setEntInstAtt4ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_4")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_5") !=null) vo.setEntInstAtt5ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_5")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_6") !=null) vo.setEntInstAtt6ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_6")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_7") !=null) vo.setEntInstAtt7ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_7")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_NUM_8") !=null) vo.setEntInstAtt8ValueNum(Double.valueOf(resultSet.getInt("BUS_ENT_INST_ATT_VALUE_NUM_8")));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_1") !=null) vo.setEntInstAtt1ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_1"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_2") !=null) vo.setEntInstAtt2ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_2"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_3") !=null) vo.setEntInstAtt3ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_3"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_4") !=null) vo.setEntInstAtt4ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_4"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_5") !=null) vo.setEntInstAtt5ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_5"));
						if (resultSet.getString("BUS_ENT_INST_ATT_VALUE_DTE_6") !=null) vo.setEntInstAtt6ValueDte(resultSet.getTimestamp("BUS_ENT_INST_ATT_VALUE_DTE_6"));
						
						colRet.add(vo);
					}
				}
			}	
		} catch (Exception e) {
			System.out.println("Exception :" + e.toString());
		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return colRet;
		}
	}
	
	//Retorna las instancias de procesos a cancelar	
	public Collection<String[]> getInstProcListToCancel(Integer envId, Integer busEntId) {
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		Collection<String[]> colRet = new ArrayList<String[]>();
		String sql = procInstancesToCancelSQL;
		
		System.out.println("sql: " + sql);
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
					statement.setInt(1, envId.intValue());
					statement.setInt(2, busEntId);
					resultSet = statement.executeQuery();
					while (resultSet.next()){
						String data [] = new String [5] ;
						data[0] = getInstNameNum(resultSet.getString("BUS_ENT_INST_NAME_PRE"), resultSet.getInt("BUS_ENT_INST_NAME_NUM"), resultSet.getString("BUS_ENT_INST_NAME_POS")); 
						data[1] = getInstNameNum(resultSet.getString("PRO_INST_NAME_PRE"), resultSet.getInt("PRO_INST_NAME_NUM"), resultSet.getString("PRO_INST_NAME_POS"));
						data[2] = resultSet.getString("PRO_TITLE");
						data[3] = resultSet.getString("PRO_INST_CREATE_USER");
						data[4] = resultSet.getString("PRO_INST_CREATE_DATE");
						
						colRet.add(data); 
					}
				}
			}	
		} catch (Exception e) {
			System.out.println("Exception :" + e.toString());
		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return colRet;
		}
	}
	
	public Collection<String[]> getStartProcesses(Integer envId, String userLogin, int sqlNum) {
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		Collection<String[]> colRet = new ArrayList<String[]>();
		String sql = "";
		if (sqlNum == CREATION_PROCESSES){
			sql = creationProcessesSQL;
		}else if (sqlNum == ALTERATION_PROCESSES){
			sql = alterationProcessesSQL;
		}else {
			sql = cancelationProcessesSQL;
		}
		
		System.out.println("sql: " + sql);
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				ConnectionGetter conGetter = new ConnectionGetter();
				
				dbConn = manager.getConnection(null,null,null,0,0,0,0);
				Connection conn = conGetter.getDBConnection2(dbConn);
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, sql, false);
					statement.setInt(1, envId.intValue());
					statement.setString(2, userLogin);
					resultSet = statement.executeQuery();
					while (resultSet.next()){
						String data [] = new String [4] ;
						data[0] = resultSet.getString("PRO_ID_AUTO");
						data[1] = resultSet.getString("PRO_TITLE");
						data[2] = resultSet.getString("BUS_ENT_ID");
						data[3] = resultSet.getString("ENV_ID");
						
						colRet.add(data); 
					}
				}
			}	
		} catch (Exception e) {
			System.out.println("Exception :" + e.toString());
		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
			return colRet;
		}
	}
	
	public String encryptApia(String message) {
		byte[] encrypted = message.getBytes();
		
		String ret = "";
		for (int i=0;i<encrypted.length;i++){
			
			int val = Integer.valueOf(""+encrypted[i]).intValue();
			
			if (i==0) val = val + 2;
			if (i==1) val = val * 5;
			if (i==2) val = val - 5;
			if (i==3) val = val * 19;
			if (i==4) val = val + 7;
			if (i==5) val = val - 9;
			
			if ("".equals(ret)) ret += val;
			else ret += ";" + val;
		}
		
		return ret;
	}
	
	//Recibe como mensaje un array de numeros separados por ; que representan el mensaje en bytes (encriptado)
	public String decryptApia(String message) {
		String[] mesArr = message.split(";");
		byte[] decrypted = new byte[mesArr.length];
		
		//Metodo de encriptacion/decriptacion propio de Apia y utilizado en aplicaciones Android (no modificar)
		//Se hizo de esta forma pq la utilización de algoritmos daba error
		
		for (int i=0; i<mesArr.length; i++) {
			int val = Integer.valueOf(mesArr[i]).intValue();
			
			if (i==0) val = val - 2;
			if (i==1) val = val / 5;
			if (i==2) val = val + 5;
			if (i==3) val = val / 19;
			if (i==4) val = val - 7;
			if (i==5) val = val + 9;
			
			decrypted[i] = (byte) val;
		}
		
		return new String(decrypted);
	}
	
	public String getInstNameNum(String preNum, int num, String posNum) {
		String ret = num + "";
		if (preNum!=null) ret = preNum + "_" + num;
		if (posNum!=null) ret = ret + "_" + posNum;
		
		return ret;
	}
	
	public String getTaskXml(Collection<TasksListVo> taskList) {
		StringBuffer xml = new StringBuffer();
		for (TasksListVo taskListVo: taskList){
			xml.append("<task ");
			xml.append("taskName=\"" + taskListVo.getTaskName() + "\" ");
			xml.append("proPriority=\"" + taskListVo.getPriority() + "\" ");
			xml.append("entInstNum=\"" + this.getInstNameNum(taskListVo.getEntInstIdPre(), taskListVo.getEntInstIdNum(), taskListVo.getEntInstIdPos()) + "\" ");
			xml.append("proInstNum=\"" + this.getInstNameNum(taskListVo.getProcInstIdPre(), taskListVo.getProcInstIdNum(), taskListVo.getProcInstIdPos()) + "\" ");
			xml.append("proInstIdNum=\"" + taskListVo.getProcInstIdNum() + "\" ");
			xml.append("pool=\"" + taskListVo.getGroupName() + "\" ");
			xml.append("proTitle=\"" + StringUtil.escapeXML2(taskListVo.getProcessTitle()) + "\" ");
			xml.append("proType=\"" + taskListVo.getProcessType() + "\" ");
			xml.append("tskCreateDate=\"" + taskListVo.getTaskCreationDate() + "\" ");
			xml.append("proCreateDate=\"" + taskListVo.getProcCreationDate() + "\" ");
			xml.append("proCreateUser=\"" + taskListVo.getProcCreateUser() + "\" ");
			xml.append("proInstAlertDate=\"" + ((taskListVo.getProInstAlertDate()!=null)?taskListVo.getProInstAlertDate().getTime() : "") + "\" ");
			xml.append("proInstEndDate=\"" + ((taskListVo.getProInstEndDate()!=null)?taskListVo.getProInstEndDate().getTime(): "") + "\" ");
			xml.append("proEleInstAlertDate=\"" + ((taskListVo.getProEleInstAlertDate()!=null)?taskListVo.getProEleInstAlertDate().getTime():"") + "\" ");
			xml.append("proEleInstEndDate=\"" + ((taskListVo.getProEleInstEndDate()!=null)?taskListVo.getProEleInstEndDate().getTime():"") + "\" ");
			xml.append("userAcquired=\"" + taskListVo.getUserLogin() + "\" ");
			
			if (taskListVo.getProInstAtt1Value()!=null) xml.append("proInstAttVal1=\"" + StringUtil.escapeXML2(taskListVo.getProInstAtt1Value()) + "\" ");
			if (taskListVo.getProInstAtt2Value()!=null) xml.append("proInstAttVal2=\"" + StringUtil.escapeXML2(taskListVo.getProInstAtt2Value()) + "\" ");
			if (taskListVo.getProInstAtt3Value()!=null) xml.append("proInstAttVal3=\"" + StringUtil.escapeXML2(taskListVo.getProInstAtt3Value()) + "\" ");
			if (taskListVo.getProInstAtt4Value()!=null) xml.append("proInstAttVal4=\"" + StringUtil.escapeXML2(taskListVo.getProInstAtt4Value()) + "\" ");
			if (taskListVo.getProInstAtt5Value()!=null) xml.append("proInstAttVal5=\"" + StringUtil.escapeXML2(taskListVo.getProInstAtt5Value()) + "\" ");
			if (taskListVo.getProInstAtt1ValueNum()!=null) xml.append("proInstAttValNum1=\"" + taskListVo.getProInstAtt1ValueNum() + "\" ");
			if (taskListVo.getProInstAtt2ValueNum()!=null) xml.append("proInstAttValNum2=\"" + taskListVo.getProInstAtt2ValueNum() + "\" ");
			if (taskListVo.getProInstAtt3ValueNum()!=null) xml.append("proInstAttValNum3=\"" + taskListVo.getProInstAtt3ValueNum() + "\" ");
			if (taskListVo.getProInstAtt1ValueDte()!=null) xml.append("proInstAtt1ValueDte=\"" + taskListVo.getProInstAtt1ValueDte() + "\" ");
			if (taskListVo.getProInstAtt2ValueDte()!=null) xml.append("proInstAtt2ValueDte=\"" + taskListVo.getProInstAtt2ValueDte() + "\" ");
			if (taskListVo.getProInstAtt3ValueDte()!=null) xml.append("proInstAtt3ValueDte=\"" + taskListVo.getProInstAtt3ValueDte() + "\" ");
			
			if (taskListVo.getEntInstAtt1Value()!=null) xml.append("busEntInstAttVal1=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt1Value()) + "\" ");
			if (taskListVo.getEntInstAtt2Value()!=null) xml.append("busEntInstAttVal2=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt2Value()) + "\" ");
			if (taskListVo.getEntInstAtt3Value()!=null) xml.append("busEntInstAttVal3=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt3Value()) + "\" ");
			if (taskListVo.getEntInstAtt4Value()!=null) xml.append("busEntInstAttVal4=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt4Value()) + "\" ");
			if (taskListVo.getEntInstAtt5Value()!=null) xml.append("busEntInstAttVal5=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt5Value()) + "\" ");
			if (taskListVo.getEntInstAtt6Value()!=null) xml.append("busEntInstAttVal6=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt6Value()) + "\" ");
			if (taskListVo.getEntInstAtt7Value()!=null) xml.append("busEntInstAttVal7=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt7Value()) + "\" ");
			if (taskListVo.getEntInstAtt8Value()!=null) xml.append("busEntInstAttVal8=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt8Value()) + "\" ");
			if (taskListVo.getEntInstAtt9Value()!=null) xml.append("busEntInstAttVal9=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt9Value()) + "\" ");
			if (taskListVo.getEntInstAtt10Value()!=null) xml.append("busEntInstAttVal10=\"" + StringUtil.escapeXML2(taskListVo.getEntInstAtt10Value()) + "\" ");
			if (taskListVo.getEntInstAtt1ValueNum()!=null) xml.append("busEntInstAttValNum1=\"" + taskListVo.getEntInstAtt1ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt2ValueNum()!=null) xml.append("busEntInstAttValNum2=\"" + taskListVo.getEntInstAtt2ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt3ValueNum()!=null) xml.append("busEntInstAttValNum3=\"" + taskListVo.getEntInstAtt3ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt4ValueNum()!=null) xml.append("busEntInstAttValNum4=\"" + taskListVo.getEntInstAtt4ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt5ValueNum()!=null) xml.append("busEntInstAttValNum5=\"" + taskListVo.getEntInstAtt5ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt6ValueNum()!=null) xml.append("busEntInstAttValNum6=\"" + taskListVo.getEntInstAtt6ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt7ValueNum()!=null) xml.append("busEntInstAttValNum7=\"" + taskListVo.getEntInstAtt7ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt8ValueNum()!=null) xml.append("busEntInstAttValNum8=\"" + taskListVo.getEntInstAtt8ValueNum() + "\" ");
			if (taskListVo.getEntInstAtt1ValueDte()!=null) xml.append("busEntInstAttValDte1=\"" + taskListVo.getEntInstAtt1ValueDte() + "\" ");
			if (taskListVo.getEntInstAtt2ValueDte()!=null) xml.append("busEntInstAttValDte2=\"" + taskListVo.getEntInstAtt2ValueDte() + "\" ");
			if (taskListVo.getEntInstAtt3ValueDte()!=null) xml.append("busEntInstAttValDte3=\"" + taskListVo.getEntInstAtt3ValueDte() + "\" ");
			if (taskListVo.getEntInstAtt4ValueDte()!=null) xml.append("busEntInstAttValDte4=\"" + taskListVo.getEntInstAtt4ValueDte() + "\" ");
			if (taskListVo.getEntInstAtt5ValueDte()!=null) xml.append("busEntInstAttValDte5=\"" + taskListVo.getEntInstAtt5ValueDte() + "\" ");
			if (taskListVo.getEntInstAtt6ValueDte()!=null) xml.append("busEntInstAttValDte6=\"" + taskListVo.getEntInstAtt6ValueDte() + "\" ");
			
			xml.append("/>");
		}
		return xml.toString();
	}

	public String getProcessesXml(Collection<String []> processList) {
		StringBuffer xml = new StringBuffer();
		for (String [] processArr: processList){
			xml.append("<process ");
			xml.append("proId=\"" + processArr[0] + "\" ");
			xml.append("proTitle=\"" + processArr[1] + "\" ");
			xml.append("entId=\"" + processArr[2] + "\" ");
			xml.append("envId=\"" + processArr[3] + "\" ");
			xml.append("/>");
		}
		return xml.toString();
	}
	
	public String getTasksListXML(int msgType, int error, int envId, String userLogin) {
		Collection<TasksListVo> freeTaskList = new ArrayList<TasksListVo>();
		Collection<TasksListVo> acquiredTaskList = new ArrayList<TasksListVo>();
		
		if (error==0) {
			freeTaskList = getTasksList(envId, userLogin, FREE_TASKS);	
			acquiredTaskList = getTasksList(envId, userLogin, ACQUIRED_TASKS);
		}
		
		StringBuffer xmlBuffer = new StringBuffer();
		
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\" ?>");
		
		 //1 params ok -> error=0 todo ok, error=1  2 hubo error -> error=1, 2 o 3";
		xmlBuffer.append("<xmlMessage>");
		
		xmlBuffer.append("<acquiredTask msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		xmlBuffer.append(this.getTaskXml(acquiredTaskList));
		xmlBuffer.append("</acquiredTask>");
		xmlBuffer.append("<freeTask  msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		xmlBuffer.append(this.getTaskXml(freeTaskList));
		xmlBuffer.append("</freeTask></xmlMessage>");

		return xmlBuffer.toString();
	}
	
	public String getTasksNumberXML(int msgType, int error, Integer envId, String userLogin, String app) {
		int acquired = 0;
		int free = 0;
		if (error==0){
			acquired = getAcquiredTasks(envId, userLogin);
			free = getFreeTasks(envId, userLogin);
		}
		StringBuffer xmlBuffer = new StringBuffer();
		if ("ApiaTasksGadget".equals(app)){ //Los gadgets solo funcionan con encoding UTF-8
			xmlBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
		}else {
			xmlBuffer.append("<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\" ?>");
		}
		xmlBuffer.append("<xmlMessage msgType=\"" + msgType + "\">"); //1- Es nuevo valor, //2- Es un error
		xmlBuffer.append("<response acquired=\"" + acquired + "\" free=\"" + free + "\" error=\"" + error + "\"/>");
		xmlBuffer.append("</xmlMessage>");
		return xmlBuffer.toString();
	}
	
	public String getStartProcessesXML(int msgType, int error, int envId, String userLogin) {
		Collection<String[]> creationProcesses = new ArrayList<String[]>();
		Collection<String[]> alterationProcesses = new ArrayList<String[]>();
		Collection<String[]> cancelationProcesses = new ArrayList<String[]>();
		
		if (error==0){
			creationProcesses = getStartProcesses(envId, userLogin, CREATION_PROCESSES);
			//alterationProcesses = getStartProcesses(envId, userLogin, ALTERATION_PROCESSES);
			//cancelationProcesses = getStartProcesses(envId, userLogin, CANCELATION_PROCESSES);
		}
		
		StringBuffer xmlBuffer = new StringBuffer();
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\" ?>");
		
		 //1 params ok -> error=0 todo ok, error=1  2 hubo error -> error=1, 2 o 3";
		xmlBuffer.append("<xmlMessage>");
		
		xmlBuffer.append("<creationProcesses  msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		xmlBuffer.append(this.getProcessesXml(creationProcesses));
		xmlBuffer.append("</creationProcesses>");
		xmlBuffer.append("<alterationProcesses  msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		//xmlBuffer.append(this.getProcessesXml(alterationProcesses));
		xmlBuffer.append("</alterationProcesses>");
		xmlBuffer.append("<cancelationProcesses  msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		//xmlBuffer.append(this.getProcessesXml(cancelationProcesses));
		xmlBuffer.append("</cancelationProcesses>");
		xmlBuffer.append("</xmlMessage>");
		
		return xmlBuffer.toString();
	}
	
	public String getProcInstToCancel(int msgType, int error, int envId, String busEntId) {
		Collection<String[]> proInstances = new ArrayList<String[]>();
		
		if (error == 0){
			proInstances = getInstProcListToCancel(envId, Integer.valueOf(busEntId));
		}
		
		StringBuffer xmlBuffer = new StringBuffer();
		xmlBuffer.append("<?xml version=\"1.0\" encoding=\"" + Parameters.APP_ENCODING + "\" ?>");
		
		//1 params ok -> error=0 todo ok, error=1  2 hubo error -> error=1, 2 o 3";
		xmlBuffer.append("<xmlMessage>");
		
		xmlBuffer.append("<instProcToCancel msgType=\"" + msgType + "\" error=\"" + error + "\" envId=\"" + envId + "\">");
		for (String [] processArr: proInstances){
			xmlBuffer.append("<instance ");
			xmlBuffer.append("proId=\"" + processArr[0] + "\" ");
			xmlBuffer.append("proTitle=\"" + processArr[1] + "\" ");
			xmlBuffer.append("entId=\"" + processArr[2] + "\" ");
			xmlBuffer.append("envId=\"" + processArr[3] + "\" ");
			xmlBuffer.append("/>");
		}
		xmlBuffer.append("</instProcToCancel>");
		xmlBuffer.append("</xmlMessage>");
				
		return xmlBuffer.toString();
	}
} 

%><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
int error = 0; // 0 es un no hubo error, -1 es login o pass incorrecto, -2 es ambiente no existe
int acquired = 0; 
int free = 0;
int msgType = 1; //1 es nuevo valor, //2 es un error

/////////// PARA VERSIONES IGUALES O SUPERIORES A 2.4.0.28 /////////////////////////////////////////////////////////////////////////////////
//SI SE VA A PASAR PARA USAR EN UNA VERSION INFERIOR SE DEBEN COMENTAR LAS SIGUIENTES 3 LINEAS !!
try {
	if (!Parameters.MD_QUERY_ALLOWED){ //Si el parametro de permiso de consultas de dispositivos moviles esta en false pasamos el msg y salimos
		msgType= 2; //hay un error
		error = -5; // apia no permite consultas desde dispositivos móviles
	}
}catch (Throwable e){}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

MyUtilClass utilClass = new MyUtilClass();
String xml = "";
String app = "ApiaTasks";
String userLogin = request.getParameter("userLogin");
String envName = request.getParameter("envName");
String action = request.getParameter("action");
Integer envId = Integer.valueOf(0);
String busEntId = request.getParameter("busEntId");

if (request.getParameter("app")!=null){ //Inidica quien esta solicitando informacion
	app = request.getParameter("app");
}

System.out.println("[ANDROID REQUEST] app=" + app + ", user=" + userLogin + ", envName=" + envName);

if (error==0){ //si apia permite consultas
	String encryptedPass = request.getParameter("encryptedPass");
	String userPass = request.getParameter("userPass");
	if ("true".equals(encryptedPass)) userPass = utilClass.decryptApia(request.getParameter("userPass"));
	
	boolean loginOk = utilClass.checkLogin(userLogin, userPass);
	System.out.println("loginOk:" + loginOk);
	
	if (loginOk) {
		if (envName != null && !"".equals(envName) && userLogin != null && !"".equals(userLogin)) {
			envId = utilClass.getEnvironmentId(envName);
			if (envId!=null) {
				if (app.equals("ApiaTasks") || app.equals("ApiaTasksGadget")){
					xml = utilClass.getTasksNumberXML(msgType, error, envId, userLogin, app);
				}else { //ApiaTasksPanel
					if (action!=null){
						if (action.equals("START_PROC")){ //Solicitud de procesos de creacion
							xml = utilClass.getStartProcessesXML(msgType, error, envId, userLogin);
						}else if (action.equals("TASK_LIST")) {//Solicitud de lista de tareas
							xml = utilClass.getTasksListXML(msgType, error, envId, userLogin);
						}else if (action.equals("CANCEL_PROC")){ //Solicitud de instancias de entidad para cancelar proceso
							xml = utilClass.getProcInstToCancel(msgType, error, envId, busEntId);
						}
					}
				}
				out.clear();
				System.out.println(xml);
				out.print(xml);
				return;
			}else {
				msgType= 2; //Params nok
				error = -2; //ambiente incorrecto
			}
		}
	}else {
		msgType= 2; //params nok
		error = -1; //login incorrecto
	}
}else {
	System.out.println("[ANDROID REQUEST] Apia don't allow query from movile devices. Operation cancelled");
}

//Si llego aca es porque hubo un error
if (app.equals("ApiaTasks") || app.equals("ApiaTasksGadget")){
	xml = utilClass.getTasksNumberXML(msgType, error, envId, userLogin, app);
}else {
	xml = utilClass.getTasksListXML(msgType, error, envId, userLogin);
}
//System.out.println(xml);
out.clear();
out.print(xml);
%>