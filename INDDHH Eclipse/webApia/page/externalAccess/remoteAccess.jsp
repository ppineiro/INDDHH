<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><%@page import="com.dogma.DogmaConstants"%><%@page import="com.dogma.vo.QueryVo"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.FunctionalityVo"%><%@page import="com.apia.execution.ExternalService"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="biz.statum.sdk.util.DateUtil"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.util.LDAPAccessor"%><%@page import="com.dogma.vo.TasksListVo"%><%@page import="javax.crypto.Cipher"%><%@page import="javax.crypto.spec.SecretKeySpec"%><%@page import="javax.crypto.SecretKey"%><%@page import="java.security.SecureRandom"%><%@page import="javax.crypto.KeyGenerator"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.db.dataAccess.*" %><%@page import="com.dogma.dataAccess.*" %><%@page import="com.dogma.vo.UserVo"%><%@page import="com.dogma.dao.UserDAO"%><%@page import="com.st.util.CryptUtils"%><%@ page import="java.util.*" %><%@ page import="java.util.Date" %><%@ page import="java.sql.*" %><%@page import="com.dogma.dao.DbConnectionDAO"%><%
/**************************************************************************************************************
    Este archivo permite el acceso remoto a:
	  1) Lista de tareas
	  2) Informacion adicional de cada tarea
                    
    Parámetros de entrada:

	  1) userLogin      --> Usuario
	  2) userPass       --> Password (encriptada o no)
	  3) passCrypted	--> Indica si la password viene encriptada usando el metodo ExternalService.encryptApia()
      3) envName        --> Ambiente en el cual se debe loguear el usuario
  	  4) action         --> Acción a realizar:
  		  					- TASK_LIST 	: devolver lista de tareas del usuario
  		  					- TASK_INFO 	: mostrar info adicional de una tarea
  		  					- INIT_PROCESS 	: devolver lista de procesos que el usuario puede iniciar
  		  					- QUERIES		: devolver lista de consultas que el usuario tiene acceso
  		  					
  	  5) tskName 		--> Nombre de tarea (necesario solo cuando action='TASK_INFO')
  	  6) proNumInst		--> Num Instancia del proceso (necesario solo cuando action='TASK_INFO')
  	  
  	  EJ: http://localhost:8080/Apia3.0.0/page/externalAccess/remoteAccess.jsp?userLogin=pferrari&userPass=1&envName=DEFAULT_PRODUCCION&action=TASK_LIST
                      	  
    Devuelve String con el siguiente formato: 0#1321;2343;3432;false;2342#4343;2342;2342;true;2342
    	Donde el primer numero es si hubo error o no
    	Entre cada # son los datos de una tarea
    
    Posibles errores:
    	-1 -> Error de login
    	-2 -> Ambiente no existe
    	-4 -> Error generico
    	-5 -> No se permite el acceso remoto
    	-6 -> Tarea no encontrada
          		
***************************************************************************************************************/
%><%! 

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class MyUtilClass extends DBAdmin {
	
	// 0 es un no hubo error, -1 es login o pass incorrecto, -2 es ambiente no existe, -5 apia no permite acceso remoto
	public static final int ERROR_NO = 0;
	public static final int ERROR_LOGIN = -1;
	public static final int ERROR_ENV = -2;
	public static final int ERROR_GENERIC = -4;
	public static final int ERROR_NO_REMOTE_ACCESS = -5;
	public static final int ERROR_TSK_NOT_FOUND = -6;
	public static final int ERROR_WRNG_VERSION = -7;
	
	private String GET_ENVIRONMENT = "select env_id_auto from environment where env_name = ?";
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
	}
	
	public boolean isPanelQueryAllowed() {
		DBConnection dbConn = null;
		
		boolean result = true;
		try {
			dbConn = this.getDbConnection();
			Connection conn = new ConnectionGetter().getDBConnection2(dbConn);
			
			PreparedStatement statement = StatementFactory.getStatement(conn, "select * from parameters where parameter_id = 'prmtPanAllowQuerys'", false);
			try {
				ResultSet resultSet = statement.executeQuery();
				if (resultSet.next()){
					String paramValue = resultSet.getString("parameter_value");
					
					result = "true".equals(paramValue);
				}
			} finally {
				statement.close();
			}
		} catch (Exception e) {
			
		} finally {
			if (dbConn != null) {
				DBManagerUtil.close(dbConn);
			}
		}
		
		return result;
	}
	
	
	//Retorna el id del ambiente pasado por parametro
	public Integer getEnvironmentId(String envName) {
		Integer envId = null; 
		DBConnection dbConn = null;
		ResultSet resultSet = null;
		
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				dbConn = this.getDbConnection();
				Connection conn = new ConnectionGetter().getDBConnection2(dbConn);
				
				if (!conn.isClosed()) {
					PreparedStatement statement = StatementFactory.getStatement(conn, GET_ENVIRONMENT, false);
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
		}
		return envId;
	}
	
	//Retorna true si el usuario/password son correctos
	public boolean checkLogin(String userLogin, String userPass){
		DBConnection dbConn = null;
		boolean ret = false;
		try {
			DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
			if (manager != null) {
				dbConn = this.getDbConnection();
				Connection conn = new ConnectionGetter().getDBConnection2(dbConn);
				
				if (!conn.isClosed()) {
					if (Parameters.AUTHENTICATION_METHOD.equals(Parameters.AUTHENTICATION_LDAP) && !DogmaConstants.ADMIN_LOGIN.equals(userLogin)) {
						System.out.println("Doing Login by LDAP");
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
		}
		return ret;
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
					if (Parameters.USER_VIGENCY != null && com.st.util.DateUtil.addDay(uVo.getUsrLastUsrLogin(), Parameters.USER_VIGENCY.intValue()).before(new Date())) {
						ret= false;
					}
				}
				ret = true;
			}else {
				System.out.println("Password incorrecto");
			}
		}catch (Exception e) {
			
		}finally {
		}
		return ret;
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
		}
		return ret;
	}
	
	/*
	* Devuelve string con las tareas del usuario
	* Formato: #1012;2322;4324;..#1212;2342;2342
	*/
	public String getTasksString(Collection<TasksListVo> taskList) {
 		StringBuffer strRet = new StringBuffer();
		for (TasksListVo taskListVo: taskList){
			strRet.append("#");
			strRet.append(taskListVo.getProcInstId() + ";");//proInstId
			strRet.append(taskListVo.getTaskInstId() + ";");//proEleInstId
			strRet.append(taskListVo.getProcessTitle() + ";");//process
			strRet.append(taskListVo.getTaskTitle() + ";");//task title
			strRet.append(taskListVo.getGroupName() + ";");//group
			strRet.append(DateUtil.formatDateTime(taskListVo.getProcCreationDate(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");//processDate
			strRet.append(DateUtil.formatDateTime(taskListVo.getTaskCreationDate(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");//taskDate
			strRet.append(((taskListVo.getTaskAcquired() != null)?"true":"false") + ";");//isAcquired
			strRet.append(taskListVo.getProImage() + ";");//proImage
			strRet.append(taskListVo.getTskImage() + ";");//tskImage
			strRet.append(taskListVo.isProInOverdue() + ";");//isProInOverdue
			strRet.append(taskListVo.isProInWarning() + ";");//isProInWarning
			strRet.append(taskListVo.isTskInOverdue() + ";");//isTskInOverdue
			strRet.append(taskListVo.isTskInWarning() + ";");//isTskInWarning
			strRet.append(taskListVo.getPriority() + ";");//proPriority
			strRet.append(taskListVo.getProcInstIdNum() + ";");//proInstIdNum
			strRet.append(taskListVo.getTaskName() + ";");//task name
		}
		
		return strRet.toString();
	}
	
	/*
	* Devuelve string con la información de una tarea
	* Formato: #1;true;false;false;.. ;lala#2;true;false;false;..;laal#
	*/
	public String getTaskInformationString(TasksListVo vo) {
		StringBuffer strRet = new StringBuffer();
		strRet.append("#");
		
		strRet.append(vo.getPriority() + ";"); 	  //priority
		strRet.append(vo.isProInOverdue() + ";"); //isProInOverdue
		strRet.append(vo.isProInWarning() + ";"); //isProInWarning
		strRet.append(vo.isTskInOverdue() + ";"); //isTskInOverdue
		strRet.append(vo.isTskInWarning() + ";"); //isTskInWarning
		strRet.append(vo.getProcInstIdPre() + ";"); //procInstIdPre
		strRet.append(vo.getProcInstIdNum() + ";"); //procInstIdNum
		strRet.append(vo.getProcInstIdPos() + ";"); //procInstIdPos
		strRet.append(vo.getEntInstIdPre() + ";"); 
		strRet.append(vo.getEntInstIdNum() + ";"); 
		strRet.append(vo.getEntInstIdPos() + ";"); 
		strRet.append(vo.getProcCreateUser() + ";"); 
		strRet.append(vo.getEntInstAtt1Value() + ";");
		strRet.append(vo.getEntInstAtt2Value() + ";");
		strRet.append(vo.getEntInstAtt3Value() + ";");
		strRet.append(vo.getEntInstAtt4Value() + ";");
		strRet.append(vo.getEntInstAtt5Value() + ";");
		strRet.append(vo.getEntInstAtt6Value() + ";");
		strRet.append(vo.getEntInstAtt7Value() + ";");
		strRet.append(vo.getEntInstAtt8Value() + ";");
		strRet.append(vo.getEntInstAtt9Value() + ";");
		strRet.append(vo.getEntInstAtt10Value() + ";");
		strRet.append(vo.getEntInstAtt1ValueNum() + ";");
		strRet.append(vo.getEntInstAtt2ValueNum() + ";");
		strRet.append(vo.getEntInstAtt3ValueNum() + ";");
		strRet.append(vo.getEntInstAtt4ValueNum() + ";");
		strRet.append(vo.getEntInstAtt5ValueNum() + ";");
		strRet.append(vo.getEntInstAtt6ValueNum() + ";");
		strRet.append(vo.getEntInstAtt7ValueNum() + ";");
		strRet.append(vo.getEntInstAtt8ValueNum() + ";");
		
		if (vo.getEntInstAtt1ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt1ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getEntInstAtt2ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt2ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getEntInstAtt3ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt3ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getEntInstAtt4ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt4ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getEntInstAtt5ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt5ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getEntInstAtt6ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getEntInstAtt6ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		
		strRet.append(vo.getProInstAtt1Value() + ";");
		strRet.append(vo.getProInstAtt2Value() + ";");
		strRet.append(vo.getProInstAtt3Value() + ";");
		strRet.append(vo.getProInstAtt4Value() + ";");
		strRet.append(vo.getProInstAtt5Value() + ";");
		
		strRet.append(vo.getProInstAtt1ValueNum() + ";");
		strRet.append(vo.getProInstAtt2ValueNum() + ";");
		strRet.append(vo.getProInstAtt3ValueNum() + ";");
		
		if (vo.getProInstAtt1ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getProInstAtt1ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getProInstAtt2ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getProInstAtt2ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		if (vo.getProInstAtt3ValueDte()!=null) strRet.append(DateUtil.formatDateTime(vo.getProInstAtt3ValueDte(), DateUtil.FMT_DATE_SLASH + StringUtil.SPACE_STRING + DateUtil.FMT_TIME) + ";");
		else strRet.append("null;");
		
		strRet.append(vo.getEntAttLabel1() + ";");
		strRet.append(vo.getEntAttLabel2() + ";");
		strRet.append(vo.getEntAttLabel3() + ";");
		strRet.append(vo.getEntAttLabel4() + ";");
		strRet.append(vo.getEntAttLabel5() + ";");
		strRet.append(vo.getEntAttLabel6() + ";");
		strRet.append(vo.getEntAttLabel7() + ";");
		strRet.append(vo.getEntAttLabel8() + ";");
		strRet.append(vo.getEntAttLabel9() + ";");
		strRet.append(vo.getEntAttLabel10() + ";");
		
		strRet.append(vo.getEntAttLabelNum1() + ";");
		strRet.append(vo.getEntAttLabelNum2() + ";");
		strRet.append(vo.getEntAttLabelNum3() + ";");
		strRet.append(vo.getEntAttLabelNum4() + ";");
		strRet.append(vo.getEntAttLabelNum5() + ";");
		strRet.append(vo.getEntAttLabelNum6() + ";");
		strRet.append(vo.getEntAttLabelNum7() + ";");
		strRet.append(vo.getEntAttLabelNum8() + ";");
		
		strRet.append(vo.getEntAttLabelDte1() + ";");
		strRet.append(vo.getEntAttLabelDte2() + ";");
		strRet.append(vo.getEntAttLabelDte3() + ";");
		strRet.append(vo.getEntAttLabelDte4() + ";");
		strRet.append(vo.getEntAttLabelDte5() + ";");
		strRet.append(vo.getEntAttLabelDte6() + ";");
		
		strRet.append(vo.getProAttLabel1() + ";");
		strRet.append(vo.getProAttLabel2() + ";");
		strRet.append(vo.getProAttLabel3() + ";");
		strRet.append(vo.getProAttLabel4() + ";");
		strRet.append(vo.getProAttLabel5() + ";");
		
		strRet.append(vo.getProAttLabelNum1() + ";");
		strRet.append(vo.getProAttLabelNum2() + ";");
		strRet.append(vo.getProAttLabelNum3() + ";");
		
		strRet.append(vo.getProAttLabelDte1() + ";");
		strRet.append(vo.getProAttLabelDte2() + ";");
		strRet.append(vo.getProAttLabelDte3() + ";");
		
		return strRet.toString();
	}
	
	/*
	* Devuelve string con las funcionalidades
	* Formato: #1001;Proceso1;1434#1002;Proceso2;2342#
	*/
	public String getUsrProcsString(Collection<ProcessVo> proList) {
 		StringBuffer strRet = new StringBuffer();
		for (ProcessVo proVo: proList){
			strRet.append("#");
			strRet.append(proVo.getProId() + ";");//proId
			strRet.append(proVo.getProTitle() + ";");//proTitle
			strRet.append(proVo.getEntityProcessVo().getBusEntId() + ";");//busEntId
			strRet.append(proVo.getImgPath()+";");//imgPath
		}
		
		return strRet.toString();
	}

	public String getTasksListXML(int envId, String usrLogin, Integer maxAmount, Boolean sortedByActivationDate) {
		Collection<TasksListVo> taskList = new ArrayList<TasksListVo>();
		int error = MyUtilClass.ERROR_NO;
		StringBuffer strBuffer = new StringBuffer();
		
		try {
				taskList = ExternalService.getUserTasksForRemoteCall(envId, usrLogin, maxAmount, sortedByActivationDate);
				strBuffer.append(error);
				if (taskList!=null && taskList.size()>0) strBuffer.append(this.getTasksString(taskList));
				
		}catch (Exception e) {
			System.out.println("[REMOTE ACCESS] -> ERROR GETTING TASK LIST: " + e.getMessage());
			e.printStackTrace();
			strBuffer.append(MyUtilClass.ERROR_GENERIC); //avisamos que hubo error
			strBuffer.append("#" + e.getMessage());
		}
		
		return strBuffer.toString();
	}
	
	public String getTaskInfo(Integer envId, String userId, Integer numInst, String nomTsk) {
		TasksListVo vo = null;
		int error = MyUtilClass.ERROR_NO;
		StringBuffer strBuffer = new StringBuffer();
		
		try {
			vo = ExternalService.getTaskInfo(envId, userId, numInst, nomTsk);
			
			if (vo==null) error = MyUtilClass.ERROR_TSK_NOT_FOUND; //Avisamos que no se encontro ninguna tarea con ese nombre
			strBuffer.append(error);
			
			if (error == MyUtilClass.ERROR_NO) { //Si se encontro la tarea
				strBuffer.append(this.getTaskInformationString(vo)); //Cargamos la informacion de la tarea
			}
		}catch (Exception e) {
			System.out.println("[REMOTE ACCESS] -> ERROR GETTING TASK INFO: " + e.getMessage());
			e.printStackTrace();
			strBuffer.append(MyUtilClass.ERROR_GENERIC); //avisamos que hubo error
			strBuffer.append("#" + e.getMessage());
		}
		
		return strBuffer.toString();
	}
	
	public String getStartProcess(String processAction, Integer envId, String userLogin, Integer maxCant, boolean sortDesc) {
		Collection<ProcessVo> proList = new ArrayList<ProcessVo>();
		int error = MyUtilClass.ERROR_NO;
		StringBuffer strBuffer = new StringBuffer();
		
		try {
			proList = ExternalService.getUserInitProcess(processAction, envId, userLogin, maxCant, sortDesc);
			strBuffer.append(error);
			if (proList!=null && proList.size()>0) strBuffer.append(this.getUsrProcsString(proList));
		}catch (Exception e) {
			System.out.println("[REMOTE ACCESS] -> ERROR GETTING FUNCTIONALITIES: " + e.getMessage());
			e.printStackTrace();
			strBuffer.append(MyUtilClass.ERROR_GENERIC); //avisamos que hubo error
			strBuffer.append("#" + e.getMessage());
		}
		return strBuffer.toString();
	}
	
	public String getQueries(int envId, String usrLogin, Integer maxCant, boolean sortDesc) {
		Collection<FunctionalityVo> funcList = new ArrayList<FunctionalityVo>();
		int error = MyUtilClass.ERROR_NO;
		StringBuffer strBuffer = new StringBuffer();
		
		try {
				funcList = ExternalService.getUserQueries(envId, usrLogin, maxCant, sortDesc);
				strBuffer.append(error);
				if (funcList!=null && funcList.size()>0) {
					for (FunctionalityVo funcVo: funcList) {
						String url = funcVo.getFncUrl();
						///apia.query.UserAction.run?action=init&query=1052&lala=2342
						int pos = url.indexOf("query=");
						if (pos>0) {
							pos = pos + 6;
							url = url.substring(pos); //1052&lala=2342
							pos = url.indexOf("&");
							String qryId = "";
							if (pos>0) qryId = url.substring(0, pos);
							else qryId = url;
							if (!"".equals(qryId)){
								strBuffer.append("#" + qryId + ";" + funcVo.getFncName() + ";" + funcVo.getFncTitle() + ";" + funcVo.getImgPath());
							}
						}
					}
				}
				
				
		}catch (Exception e) {
			System.out.println("[REMOTE ACCESS] -> ERROR GETTING QUERIES: " + e.getMessage());
			e.printStackTrace();
			strBuffer.append(MyUtilClass.ERROR_GENERIC); //avisamos que hubo error
			strBuffer.append("#" + e.getMessage());
		}
		
		return strBuffer.toString();
	}
	
	//Retorna la url de la imagen asignada al ambiente
	public String getApiaUrlImage(Integer envId) {
		try {
			return ExternalService.getEnvParameter(envId, "prmtEnvSplashImage");
		} catch (Exception e) {
			System.out.println("[REMOTE ACCESS] -> ERROR GETTING URL IMAGE: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	
	//Verifica si la version de Apia es compatible con este panel
	public boolean checkVersion() {
		try {
			String currentVersion = DogmaConstants.APIA_VERSION; //Versiones minimas: 2.4.0.33, 2.4.1.5, 3.0.0.1
			System.out.println("CurrentVersion:" + currentVersion);
			if (currentVersion!=null && !"".equals(currentVersion)){
				String cVArr[] = StringUtil.split(currentVersion, ".");
				if (cVArr.length > 3) {
					if (Integer.valueOf(cVArr[0]) > 2) return true;
					if (Integer.valueOf(cVArr[0]) == 2 && Integer.valueOf(cVArr[1])>4) return true;
					if (Integer.valueOf(cVArr[0]) == 2 && Integer.valueOf(cVArr[1])==4 && Integer.valueOf(cVArr[2])>1) return true;
					if (Integer.valueOf(cVArr[0]) == 2 && Integer.valueOf(cVArr[1])==4 && Integer.valueOf(cVArr[2])==0 && Integer.valueOf(cVArr[3])>32) return true;
					if (Integer.valueOf(cVArr[0]) == 2 && Integer.valueOf(cVArr[1])==4 && Integer.valueOf(cVArr[2])==1 && Integer.valueOf(cVArr[3])>4) return true;
					
					return false;
				}
			}
			
			return true;
		}catch (Exception e) {
			return true; //Si es una version de desarrollo puede dar error
		}
	}
} 

%><%
int error = MyUtilClass.ERROR_NO; // 0 es un no hubo error, -1 es login o pass incorrecto, -2 es ambiente no existe, -5 apia no permite acceso remoto
String action = request.getParameter("action");

String currentVersion = DogmaConstants.APIA_VERSION;
String[] partsVersion = StringUtil.split(currentVersion, ".");
int versionNumber = -1;
try { versionNumber = (partsVersion.length > 1) ? Integer.parseInt(partsVersion[0]) : -1; } catch (NumberFormatException e) {}
MyUtilClass utilClass = new MyUtilClass();

try {
 	if (versionNumber >= 3 && !utilClass.isPanelQueryAllowed()) { //Si el parametro de permiso acceso remoto esta en false pasamos el msg y salimos
 		error = MyUtilClass.ERROR_NO_REMOTE_ACCESS; // apia no permite acceso remoto
 		action = null;
 	}
 }catch (Throwable e){}


if("SPLASH".equals(action)) {
	if (versionNumber >= 3) {
		pageContext.forward("../../apia.security.LoginAction.run?action=redirectToSplash");
	} else {
		//redirect.jsp?link=execution.ReportAction.do%3Faction=open
		pageContext.forward("../../security.LoginAction.do?action=redirectToSplash");
	}
	
} else {
	response.setCharacterEncoding(Parameters.APP_ENCODING);
	response.setContentType("text/txt");
	
	String userLogin = request.getParameter("userLogin");
	String envName = request.getParameter("envName");
	String responseStr = "";
	
	System.out.println("[REMOTE ACCESS] user=" + userLogin + ", envName=" + envName + ", action=" + action);
	
	if (error==MyUtilClass.ERROR_NO) { //si apia permite acceso remoto o es una version anterior a la 3.0.0.1
		String userPwd = request.getParameter("userPass");
		Integer envId = Integer.valueOf(0);
		Integer maxCant = Integer.valueOf(0);
		boolean sortDesc = false;
		String processAction = "";

		String tskName = "";
		Integer proNumInst = Integer.valueOf(0);
		
		String encryptedPass = request.getParameter("encryptedPass");
		String userPass = ExternalService.decryptApia(userPwd);
			
		boolean loginOk = utilClass.checkLogin(userLogin, userPass);
		System.out.println("loginOk:" + loginOk);
		
		if (loginOk) {
			if (envName != null && !"".equals(envName) && userLogin != null && !"".equals(userLogin)) {
				envId = utilClass.getEnvironmentId(envName);
				if (envId!=null) {
					if (action!=null){
						if (action.equals("TASK_LIST")) {//Solicitud de lista de tareas
							 maxCant = Integer.valueOf(request.getParameter("maxCant")); //DEBE SER EL MAXIMO MAS UNO, ASI SI HAY MAS EL PANEL AVISA QUE HAY MAS
							 sortDesc = "true".equals(request.getParameter("sortDesc"));
							responseStr = utilClass.getTasksListXML(envId, userLogin, maxCant, sortDesc);
						
						}else if (action.equals("TASK_INFO")) { //Solicitud de info adicional de una tarea
							tskName = request.getParameter("tskName");
							proNumInst = Integer.valueOf(request.getParameter("proNumInst"));
							responseStr = utilClass.getTaskInfo(envId, userLogin, proNumInst, tskName);
						
						}else if (action.equals("INIT_PROCESS")) { //Solicitud de procesos de creacion
							 maxCant = Integer.valueOf(request.getParameter("maxCant")); //DEBE SER EL MAXIMO MAS UNO, ASI SI HAY MAS EL PANEL AVISA QUE HAY MAS
							 sortDesc = "true".equals(request.getParameter("sortDesc"));
							 processAction = request.getParameter("processAction"); //INDICA QUE TIPO DE PROCESOS SE DEBEN RECUPERAR
							responseStr = utilClass.getStartProcess(processAction, envId, userLogin, maxCant, sortDesc);
						
						}else if (action.equals("QUERIES")) { //Solicitud de consultas que el usuario puede acceder
							maxCant = Integer.valueOf(request.getParameter("maxCant")); //DEBE SER EL MAXIMO MAS UNO, ASI SI HAY MAS EL PANEL AVISA QUE HAY MAS
							sortDesc = "true".equals(request.getParameter("sortDesc"));
							responseStr = utilClass.getQueries(envId, userLogin, maxCant, sortDesc);
						
						}else if (action.equals("GET_IMG")) {
							if (utilClass.checkVersion()) {
								responseStr = MyUtilClass.ERROR_NO + "#" + utilClass.getApiaUrlImage(envId);
							}else {
								responseStr = MyUtilClass.ERROR_WRNG_VERSION + "";
							}
						}
					}
				}else {
					responseStr = MyUtilClass.ERROR_ENV + "#" + envName; //ambiente no encontrado
				}
			}
		}else {
			responseStr = MyUtilClass.ERROR_LOGIN + "#" + userLogin + "#" + envName; //login incorrecto
		}
	}else {
		System.out.println("[REMOTE ACCESS] Apia is not allowing remote access. Operation cancelled");
		responseStr = MyUtilClass.ERROR_NO_REMOTE_ACCESS + "";
	}
	
	//System.out.println(responseStr);
	out.clear();
	out.print(responseStr);
}
%>