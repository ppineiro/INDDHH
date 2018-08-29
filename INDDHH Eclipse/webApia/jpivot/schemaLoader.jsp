<%@page import="com.apiamonitor.events.ITimedEvtTypes.IApiaEvtTypes"%><%@page import="biz.statum.apia.web.action.administration.BIAction"%><%@page import="biz.statum.apia.web.bean.BasicBean"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.apia.web.bean.administration.SchemasBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.SchemaBean"%><%@ page session="true" contentType="text/html; charset=UTF-8" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><%@page import="com.tonbeller.wcf.controller.RequestContext" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.st.util.log.Log"%><%@page import="mondrian.rolap.cache.SmartCache"%><%@page import="mondrian.rolap.CacheControlImpl"%><%@page import="mondrian.rolap.RolapSchema"%><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><html><head><%
HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
SchemasBean schBean=null;
String tabId = request.getParameter("tabId");
String tokenId = request.getParameter("tokenId");
HashMap<String,String> map = (HashMap<String,String>)session.getAttribute("cubesMap");

schBean = (SchemasBean) BIAction.staticRetrieveBean(http, true);	
//setear hash de sesion
if (map==null) map = new HashMap<String, String>();
map.put(request.getParameter("schemaId"), tabId);
session.setAttribute("cubesMap", map);

//for linux
System.setProperty("java.awt.headless","true");

String styleDirectory = "default";
Integer environmentId = null;

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%><title>JPivot Test Page</title><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"></meta><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/table/mdxtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/navi/mdxnavi.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/form/xform.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/table/xtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/tree/xtree.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/tabs.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/jpivot.css"><system:util show="baseStyles" /><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/tabs.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/common.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/list.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/dimensions.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/viewBrowser.js" defer="true"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/viewInfo.js" defer="true"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js" defer="true"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/navButtons.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/modals/profiles.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/scroller.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modalController.js"></script><script type="text/javascript">
    var	sp;
    var GNR_ORDER_BY			= "Ordenar por:";//Culpa de sebasto
	var GNR_TITILE_MESSAGES		= "Messages";//Culpa de sebasto
	var GNR_TITILE_EXCEPTIONS	= "Exceptions";//Culpa de sebasto
	
	var CONTEXT					= "<%=Parameters.ROOT_PATH%>";
	var TAB_ID_REQUEST			= "<system:util show="tabIdRequest"  />";
	var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
	var GNR_MORE_RECORDS		= "<system:label show="text" label="lblNoRet" forHtml="true" forScript="true" />";
	var GNR_TOT_RECORDS			= "<system:label show="text" label="lblTotReg" forHtml="true" forScript="true" />";
	var GNR_TOT_RECORDS_REACHED	= "<system:label show="text" label="msgTotRegReached" forHtml="true" forScript="true" />";
	
	var GNR_NAV_FIRST			= "<system:label show="text" label="btnNavFirst" forHtml="true" forScript="true" />";
	var GNR_NAV_PREV			= "<system:label show="text" label="btnNavPrev" forHtml="true" forScript="true" />";
	var GNR_NAV_NEXT			= "<system:label show="text" label="btnNavNext" forHtml="true" forScript="true" />";
	var GNR_NAV_LAST			= "<system:label show="text" label="btnNavLast" forHtml="true" forScript="true" />";
	var GNR_NAV_REFRESH			= "<system:label show="text" label="btnRef" forHtml="true" forScript="true" />";
	
	var BTN_CONFIRM				= '<system:label show="text" label="btnCon" forHtml="true" forScript="true"/>';
	var BTN_CANCEL				= '<system:label show="text" label="btnCan" forHtml="true" forScript="true"/>';
	
	var BTN_CLOSE				= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
	
	var MOBILE					= <%="true".equals(session.getAttribute("mobile")) ? "true" : "false"%>;
	var WAIT_A_SECOND			= '<system:label show="text" label="lblEspUnMom" forHtml="true" forScript="true" />';
	
	var REFRESH_PARENT			= true;
	
  </script><%@include file="jPivotScriptVars.jsp" %><style><c:if test="${navi01.visible}">
	.navigatorTd{
		vertical-align:top;
		width:200px;
		padding-top:0px;
		background-color:FEFEFE;
	}
	#navi01{
		width:200px;
	}
</c:if>
#srcData {
	box-shadow: 0px 10px 8px 2px grey;
} 
</style></head><%
	CubeViewBean cubeVwBean=null;
	Integer schemaId = null;
	Integer cubeId = null;
	Integer viewId=null;
	String cubeName="";
	String cubeTitle="";
	String cubeDesc="";
	String viewName="";
	String viewDesc="";
	String envName="";
	boolean newCube=false;
	boolean justLoaded=( (request.getParameter("justLoaded")!=null && "true".equals(request.getParameter("justLoaded").toString()))  || (request.getAttribute("justLoaded")!=null && "true".equals(request.getAttribute("justLoaded").toString())) );
	boolean justSaved=( (request.getParameter("justSaved")!=null && "true".equals(request.getParameter("justSaved").toString()))  || (request.getAttribute("justSaved")!=null && "true".equals(request.getAttribute("justSaved").toString())) );
	boolean justClosedInfo =( (request.getParameter("justClosedInfo")!=null && "true".equals(request.getParameter("justClosedInfo").toString()))  || (request.getAttribute("justClosedInfo")!=null && "true".equals(request.getAttribute("justClosedInfo").toString())) ); 
	boolean navigatorMode = "navigator".equals(schBean.getLoaderType()); 
	boolean hasRoles = false;
	String usrProfiles = schBean.getUsrProfiles();//perfiles del usuario actual
	
	//Parametros de la base donde se encuentran los datos de/de los cubos
	String jdbcDriver = null;
	String jdbcUrl = null;
	String jdbcUser = null;
	String jdbcPassword = null;
	
	String lang="ES";
	if(uData.getLangId().intValue()==2){
		lang="PT";
	}else if(uData.getLangId().intValue()==3){
		lang="EN";
	}
	
	//Seteamos lenguaje del explorador (para los archivos de lenguaje del mondrian)
	//Y seteamos pais, para los separadores de miles y decimal
	String country = Configuration.COUNTRY;
	if (country!=null && !"".equals(country)){
		RequestContext.instance().setLocale(new Locale(lang,country));
	}else {
		RequestContext.instance().setLocale(new Locale(lang));
	}
	
	//RECUPERAMOS EL PARAMETRO BIDB_IMPLMENTATION DEFINIDO EN EL CONFIG.PROPERTIES
	if ("ORACLE".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
	}else if ("SQLSERVER".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
	}else if ("POSTGRES".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
	}else if ("MYSQL".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_MYSQL_DRIVER;
	}
	
	jdbcUrl = BIParameters.BIDB_URL;//RECUPERAMOS EL PARAMETRO BIDB_URL DEFINIDO EN EL CONFIG.PROPERTIES
	jdbcUser = BIParameters.BIDB_USR;//RECUPERAMOS EL PARAMETRO BIDB_USR DEFINIDO EN EL CONFIG.PROPERTIES
	jdbcPassword = BIParameters.BIDB_PWD;//RECUPERAMOS EL PARAMETRO BIDB_PWD DEFINIDO EN EL CONFIG.PROPERTIES
	
	mondrian.rolap.agg.AggregationManager.instance().getCacheControl(null).flushSchemaCache();//Limpia del cache todo --> Necesario dados unos errores reportados en los que se muestra siempre la vista anterior
	
	if (!schBean.isSchemaLoaded() || (request.getParameter("schemaId")!=null  && !schBean.getSchemaVo().getSchemaId().equals(request.getParameter("schemaId")))){
		uData.setStatusProgress(56); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		Thread.sleep(3 * 1000); //Esperamos se limpie la memoria cache
		uData.setStatusProgress(62); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		justLoaded=true;
		boolean error = true;
		int intentos = 1;//Intentamos cargar el cubo 5 veces aunque de error, ya que si el cubo es muy grande puede pasar que el cache demore mas en limpiarse y de error
		do {
			/////////// Recuperamos el schema de la base y lo cargamos en memoria //////////////
			if(request.getParameter("schemaId")!=null && !"null".equals(request.getParameter("schemaId"))){
				if (!schBean.loadSchemaVoById(new Integer(request.getParameter("schemaId")))){
					response.sendRedirect("errorBI.jsp?error=13"); //ERROR LOADING SCHEMA
					return;
				}
				//schBean.setJustLoaded(false);
			}else{
				return;
			}
				
			if (schBean.getSchemaVo() == null) {
				return;
			}
			schemaId = schBean.getSchemaVo().getSchemaId();
			hasRoles = schBean.schemaUseRoles(schemaId);
			hasRoles = false;//Se agrega esto como workaround por problema con roles 
			
			if(request.getSession().getAttribute("toolbar01")!=null){
				request.getSession().removeAttribute("toolbar01");
			}
			request.getSession().removeAttribute("toolbar01");
			uData.setStatusProgress(68); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			File schemaDef = new File(SchemaVo.SCHEMA_BI_TEMP_FULL_FILE_NAME);
			BufferedWriter writer;
			writer = new BufferedWriter(new FileWriter(schemaDef, false));
			writer.write(schBean.getXmlSchemaDef());
			writer.close();
			if (uData == null){
				uData = new UserData();
				uData.setLangId(Parameters.DEFAULT_LANG);
				uData.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
				//request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,uData);
			}
			String user = uData.getUserName();
			uData.setStatusProgress(74); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			//Vemos si nos pasaron el nombre del cubo por parametro, sino cargamos la vista de cualquier cubo del schema
			if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId")) ){
				cubeId = new Integer(request.getParameter("cubeId"));
				envName = schBean.getEnvName(cubeId); 
				CubeVo cubeVo = schBean.getCubeVo(cubeId);
				cubeName = cubeVo.getCubeName();
				if (cubeName.startsWith("mnuDw") || cubeName.startsWith("lblDw")){
					if (cubeName.indexOf("_")>0){
						cubeName = LabelManager.getName(labelSet, cubeName.substring(0, cubeName.indexOf("_"))) + cubeName.substring(cubeName.indexOf("_"), cubeName.length());
					}else if (!"".equals(envName)){
						cubeName = LabelManager.getName(labelSet, cubeName) + "_" + envName;
					}else {
						cubeName = LabelManager.getName(labelSet, cubeName);
					}
				}
				cubeTitle = cubeVo.getCubeTitle();
				if (cubeTitle.startsWith("mnuDw") || cubeTitle.startsWith("lblDw")){
					if (cubeTitle.indexOf(")") > 0){
						cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle.substring(0, cubeTitle.indexOf("(") - 1)) + " " + cubeTitle.substring(cubeTitle.indexOf("("), cubeTitle.length());							
					}else if (!"".equals(envName)){
						cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle) + " " + envName;
					}else{
						cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle);
					}
				}
				cubeDesc = cubeVo.getCubeDesc();
				if (cubeDesc != null){
					if (cubeDesc.startsWith("mnuDw") || cubeDesc.startsWith("lblDw")){
						if (cubeDesc.indexOf(")") > 0){	
							cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
						}else if (!"".equals(envName)){
							cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc)  + " " + envName;
						}else {
							cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc);
						}
					}
				}
			}
			schBean.setCubeIdLoaded(cubeId); //Almacenamos el id del cubo que se esta cargando en memoria
			/////////// Obtenemos la definicion de la vista //////////////
			cubeVwBean = new CubeViewBean();
			//Cargamos cualquier vista por defecto (si cubeId y viewId es null)
			
			if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
				viewId=new Integer(request.getParameter("viewId").toString());
			}else if(request.getAttribute("viewId")!=null && !"null".equals(request.getAttribute("viewId"))){
				viewId=new Integer(request.getAttribute("viewId").toString());
			}
			uData.setStatusProgress(80); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			schBean.setViewIdLoaded(viewId); //Almacenamos el id de la vista que se esta cargando en memoria
			if (uData.getEnvironmentId()==null) uData.setEnvironmentId(environmentId);
			cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);
			viewName = cubeVwBean.getCubeViewVo().getVwName();
			viewDesc = cubeVwBean.getCubeViewVo().getVwDesc();
			
			//Inicia log para apiaMonitor
			String apMonReference = Log.startTimer(IApiaEvtTypes.EXECUTE_BI_CUBE_VW, cubeTitle + " - Vista: '" + viewName + "'", uData.getUserName());
			
			if (cubeVwBean.getCubeViewVo().getVwId()!=null) {
				schBean.loadBtnAvailables(cubeVwBean.getCubeViewVo().getVwId());
			}else {
				schBean.setBtnAvailables("");
			}
			uData.setStatusProgress(86); //<--------------------------------------------------------------------PROGRESS BAR-----------------
	//		Definimos y configuramos acceso a Mondrian OLAP data source
			try{
				  if (schBean.getSchemaVo().getDbConId()!=null && schBean.getSchemaVo().getDbConId().intValue()!=0){ // --> Es un cubo definido por el usuario
					  if (schBean.getSchemaVo().getDbConId().intValue() == -1){ //Los datos se encuentra en la base de Apia
							jdbcUrl = Configuration.DB_URL;//RECUPERAMOS EL PARAMETRO DB_URL DEFINIDO EN EL CONFIG.PROPERTIES
							jdbcUser = Configuration.DB_USR;//RECUPERAMOS EL PARAMETRO DB_USR DEFINIDO EN EL CONFIG.PROPERTIES
							jdbcPassword = Configuration.DB_PWD;//RECUPERAMOS EL PARAMETRO DB_PWD DEFINIDO EN EL CONFIG.PROPERTIES
						
							if ("ORACLE".equals(Configuration.DB_IMPLEMENTATION)){
								jdbcDriver = Parameters.ORACLE_DRIVER;
							}else if ("SQLSERVER".equals(Configuration.DB_IMPLEMENTATION)){
								jdbcDriver = Parameters.SQLSERVER_DRIVER;
							}else if ("POSTGRES".equals(Configuration.DB_IMPLEMENTATION)){
								jdbcDriver = Parameters.POSTGRES_DRIVER;
							}
							
					  }else { //Los datos se encuentran en una base distinta a la utilizada por Apia
							DbConnectionVo dbConnVo = schBean.getDbConnForBI(schBean.getSchemaVo().getDbConId());
							jdbcUrl = dbConnVo.getDbConString();
							jdbcUser = dbConnVo.getDbConUser();
							jdbcPassword = dbConnVo.getDbConPassword();
							if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_ORACLE)) {
								jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
							} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_POSTGRE)) {
								jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
							} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_SQLSERVER)) {
								jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
							} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_MYSQL)) {
								jdbcDriver = BIParameters.BI_MYSQL_DRIVER;
							}
					  }
				}
				if (navigatorMode || !hasRoles){%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
				}else {%><jp:mondrianQuery id="query01" role="<%=usrProfiles%>" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
				}
				
				error = false;
			}catch (Throwable e){
				if (intentos < 5 && !e.getMessage().contains("Role")){// && !e.getMessage().contains("not found")) {
					System.out.println("--> ERROR LOADING CUBE, TRYING AGAIN.." + intentos + "/5");
					e.printStackTrace();
					mondrian.rolap.agg.AggregationManager.instance().getCacheControl(null).flushSchemaCache();//Limpia del cache todo
					if (e.getMessage().contains("not found")){
						Thread.sleep(2 * intentos * 1000);
					}else {
						Thread.sleep(5 * intentos * 1000);
					}
					
					intentos ++;
				}else {
					System.out.println("--> ERROR LOADING CUBE, TOO MANY INTENTS");
					Log.debug(e);
					String errMessage = e.getMessage();
					String errNumber = "14";
					if (errMessage.contains("Role")){
						errNumber = "20";
					}else if (e.getMessage().contains("not found")){
						errNumber = "60"; //En este momento no se pudo cargar la vista seleccionada. Intentelo nuevamente.
					}
					response.sendRedirect("errorBI.jsp?error=" + errNumber +"&errorMsg="+errMessage);
					uData.setStatusProgress(100);
					return;
				}
				
			}finally{
	//			Seteamos en false la variable de sincronizacion de despliegue de los cubos	
				  request.getSession().setAttribute("busy",new Boolean(false));
				  schemaDef.delete();
				  
				  //Finaliza log para ApiaMonitor
				  Log.stopTimer(IApiaEvtTypes.EXECUTE_BI_CUBE_VW, apMonReference);
			}
		} while (error);
		
		uData.setStatusProgress(92); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%
		uData.setStatusProgress(95); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		%><%}else	if(justLoaded ){	//cambio la vista
		cubeVwBean = new CubeViewBean();
		viewId=null;
		schemaId = schBean.getSchemaVo().getSchemaId();
		hasRoles = schBean.schemaUseRoles(schemaId);
		hasRoles = false;//Se agrega esto como workaround por problema con roles
		if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId")) ){
			cubeId = new Integer(request.getParameter("cubeId"));
		}
		envName = schBean.getEnvName(cubeId); 
		uData.setStatusProgress(60); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
			viewId=new Integer(request.getParameter("viewId").toString());
		}
		uData.setStatusProgress(70); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);
		viewName = cubeVwBean.getCubeViewVo().getVwName();
		viewDesc = cubeVwBean.getCubeViewVo().getVwDesc();
		if (cubeVwBean.getCubeViewVo().getVwId()!=null) {
			schBean.loadBtnAvailables(cubeVwBean.getCubeViewVo().getVwId());
		}else {
			schBean.setBtnAvailables("");
		}
		CubeVo cubeVo = schBean.getCubeVo(cubeVwBean.getCubeViewVo().getCubeId());
		cubeName = cubeVo.getCubeName();
		if (cubeName.startsWith("mnuDw") || cubeName.startsWith("lblDw")){
			if (cubeName.indexOf("_")>0){
				cubeName = LabelManager.getName(labelSet, cubeName.substring(0, cubeName.indexOf("_"))) + cubeName.substring(cubeName.indexOf("_"), cubeName.length());
			}else if (!"".equals(envName)){
				cubeName = LabelManager.getName(labelSet, cubeName) + "_" + envName;
			}else {
				cubeName = LabelManager.getName(labelSet, cubeName);
			}
		}
		cubeTitle = cubeVo.getCubeTitle();
		if (cubeTitle.startsWith("mnuDw") || cubeTitle.startsWith("lblDw")){
			if (cubeTitle.indexOf(")") > 0){
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle.substring(0, cubeTitle.indexOf("(") - 1)) + " " + cubeTitle.substring(cubeTitle.indexOf("("), cubeTitle.length());							
			}else if (!"".equals(envName)){
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle) + " " + envName;
			}else{
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle);
			}
		}
		cubeDesc = cubeVo.getCubeDesc();
		if (cubeDesc != null){
			if (cubeDesc.startsWith("mnuDw") || cubeDesc.startsWith("lblDw")){
				if (cubeDesc.indexOf(")") > 0){	
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
				}else if (!"".equals(envName)){
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc)  + " " + envName;
				}else {
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc);
				}
			}
		}
		
		File schemaDef = new File(SchemaVo.SCHEMA_BI_TEMP_FULL_FILE_NAME);
		BufferedWriter writer;
		writer = new BufferedWriter(new FileWriter(schemaDef, false));
		writer.write(schBean.getXmlSchemaDef());
		writer.close();
		if (uData == null){
			uData = new UserData();
			uData.setLangId(Parameters.DEFAULT_LANG);
			uData.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
			//request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,uData);
		}

//		Definimos y configuramos acceso a Mondrian OLAP data source 
		uData.setStatusProgress(80); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		try{
			if (schBean.getSchemaVo().getDbConId()!=null && schBean.getSchemaVo().getDbConId().intValue()!=0){ // --> Es un cubo definido por el usuario
				  if (schBean.getSchemaVo().getDbConId().intValue() == -1){ //Los datos se encuentra en la base de Apia
					jdbcUrl = Configuration.DB_URL;//RECUPERAMOS EL PARAMETRO BIDB_URL DEFINIDO EN EL CONFIG.PROPERTIES
					jdbcUser = Configuration.DB_USR;//RECUPERAMOS EL PARAMETRO BIDB_USR DEFINIDO EN EL CONFIG.PROPERTIES
					jdbcPassword = Configuration.DB_PWD;//RECUPERAMOS EL PARAMETRO BIDB_PWD DEFINIDO EN EL CONFIG.PROPERTIES
				
					if ("ORACLE".equals(Configuration.DB_IMPLEMENTATION)){
						jdbcDriver = Parameters.ORACLE_DRIVER;
					}else if ("SQLSERVER".equals(Configuration.DB_IMPLEMENTATION)){
						jdbcDriver = Parameters.SQLSERVER_DRIVER;
					}else if ("POSTGRES".equals(Configuration.DB_IMPLEMENTATION)){
						jdbcDriver = Parameters.POSTGRES_DRIVER;
					}
			 	 }else if (schBean.getSchemaVo().getDbConId()!=null){//Los datos se encuentran en una base distinta a la definida en el config.properties para el  bi
					DbConnectionVo dbConnVo = schBean.getDbConnForBI(schBean.getSchemaVo().getDbConId());
					jdbcUrl = dbConnVo.getDbConString();
					jdbcUser = dbConnVo.getDbConUser();
					jdbcPassword = dbConnVo.getDbConPassword();
					if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_ORACLE)) {
						jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
					} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_POSTGRE)) {
						jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
					} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_SQLSERVER)) {
						jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
					} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_MYSQL)) {
						jdbcDriver = BIParameters.BI_MYSQL_DRIVER;
					}
				}
			}
			if (navigatorMode || !hasRoles){%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
			}else {%><jp:mondrianQuery id="query01" role="<%=usrProfiles%>" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
			}

		}catch (Throwable e){
			Log.debug(e);
			response.sendRedirect("errorBI.jsp?error=14"+e.getMessage());
			uData.setStatusProgress(0);
			return;
		}finally{
//			Seteamos en false la variable de sincronizacion de despliegue de los cubos	
			  request.getSession().setAttribute("busy",new Boolean(false));
			  schemaDef.delete();
		}
		uData.setStatusProgress(95); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%}else{ //SCHEMA YA CARGADO
		schemaId = schBean.getSchemaVo().getSchemaId();
		hasRoles = schBean.schemaUseRoles(schemaId);
		hasRoles = false;//Se agrega esto como workaround por problema con roles
//		Vemos si el cubo pasado por parametro es el mismo que ya esta cargado en memoria
		cubeId = schBean.getCubeIdLoaded(); //cubeId que hay en memoria
		viewId = schBean.getViewIdLoaded(); //viewId que hay en memoria
		//Si me pasaron por parametro el nombre de un cubo, hayo su id para ver si es el que esta en memoria
		if(request.getParameter("schemaId")!=null && !"null".equals(request.getParameter("schemaId")) ){
			//sustituyo la variable schemaId por el que me pasaron por parametro
			schemaId = new Integer(request.getParameter("schemaId").toString()); //schemaId del cubo que me pasaron por parametro
			justLoaded=true;
		}
		if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId")) ){
			//sustituyo la variable cubeId por el que me pasaron por parametro
			cubeId = new Integer(request.getParameter("cubeId").toString()); //cubeId del cubo que me pasaron por parametro
			justLoaded=true;
		}

		if(cubeVwBean == null){
			cubeVwBean = new CubeViewBean();
			cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);
		}
		viewName = cubeVwBean.getCubeViewVo().getVwName();
		viewDesc = cubeVwBean.getCubeViewVo().getVwDesc();
		if (cubeVwBean.getCubeViewVo().getVwId()!=null) {
			schBean.loadBtnAvailables(cubeVwBean.getCubeViewVo().getVwId());
		}else {
			schBean.setBtnAvailables("");
		}
		envName = schBean.getEnvName(cubeId); 
		uData.setStatusProgress(60); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		CubeVo cubeVo = schBean.getCubeVo(cubeId);
		cubeName = cubeVo.getCubeName();
		if (cubeName.startsWith("mnuDw") || cubeName.startsWith("lblDw")){
			if (cubeName.indexOf("_")>0){
				cubeName = LabelManager.getName(labelSet, cubeName.substring(0, cubeName.indexOf("_"))) + cubeName.substring(cubeName.indexOf("_"), cubeName.length());
			}else if (!"".equals(envName)){
				cubeName = LabelManager.getName(labelSet, cubeName) + "_" + envName;
			}else {
				cubeName = LabelManager.getName(labelSet, cubeName);
			}
		}
		cubeTitle = cubeVo.getCubeTitle();
		if (cubeTitle.startsWith("mnuDw") || cubeTitle.startsWith("lblDw")){
			if (cubeTitle.indexOf(")") > 0){
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle.substring(0, cubeTitle.indexOf("(") - 1)) + " " + cubeTitle.substring(cubeTitle.indexOf("("), cubeTitle.length());							
			}else if (!"".equals(envName)){
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle) + " " + envName;
			}else{
				cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle);
			}
		}
		cubeDesc = cubeVo.getCubeDesc();
		if (cubeDesc != null){
			if (cubeDesc.startsWith("mnuDw") || cubeDesc.startsWith("lblDw")){
				if (cubeDesc.indexOf(")") > 0){	
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
				}else if (!"".equals(envName)){
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc)  + " " + envName;
				}else {
					cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc);
				}
			}
		}
					
		uData.setStatusProgress(70); //<--------------------------------------------------------------------PROGRESS BAR-----------------
		//Si el cubeId del que me pasaron por parametro es distinto del que tengo en la memoria
		if (cubeId != null && cubeId.intValue() != schBean.getCubeIdLoaded().intValue()){ //Se debe cargar en memoria otro cubo
			//Cargo los datos del que me pasaron por parametro
			newCube=true;
			schBean.setCubeIdLoaded(cubeId); //Almacenamos el id del nuevo cubo que se esta cargando en memoria
			cubeVo = schBean.getCubeVo(cubeId);
			cubeName = cubeVo.getCubeName();
			if (cubeName.startsWith("mnuDw") || cubeName.startsWith("lblDw")){
				if (cubeName.indexOf("_")>0){
					cubeName = LabelManager.getName(labelSet, cubeName.substring(0, cubeName.indexOf("_"))) + cubeName.substring(cubeName.indexOf("_"), cubeName.length());
				}else if (!"".equals(envName)){
					cubeName = LabelManager.getName(labelSet, cubeName) + "_" + envName;
				}else {
					cubeName = LabelManager.getName(labelSet, cubeName);
				}
			}
			cubeTitle = cubeVo.getCubeTitle();
			if (cubeTitle.startsWith("mnuDw") || cubeTitle.startsWith("lblDw")){
				if (cubeTitle.indexOf(")") > 0){
					cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle.substring(0, cubeTitle.indexOf("(") - 1)) + " " + cubeTitle.substring(cubeTitle.indexOf("("), cubeTitle.length());							
				}else if (!"".equals(envName)){
					cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle) + " " + envName;
				}else{
					cubeTitle = LabelManager.getToolTip(labelSet, cubeTitle);
				}
			}
			cubeDesc = cubeVo.getCubeDesc();
			if (cubeDesc != null){
				if (cubeDesc.startsWith("mnuDw") || cubeDesc.startsWith("lblDw")){
					if (cubeDesc.indexOf(")") > 0){	
						cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
					}else if (!"".equals(envName)){
						cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc)  + " " + envName;
					}else {
						cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc);
					}
				}
			}
			
			/////////// Obtenemos la definicion de la vista //////////////
			cubeVwBean = new CubeViewBean();
			//Cargamos cualquier vista por defecto (si cubeId y viewId es null)
			viewId=null;
			if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
				viewId=new Integer(request.getParameter("viewId").toString());
			}
			uData.setStatusProgress(80); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);
			%><c:set var="title01" scope="session">4 hierarchies on one axis</c:set><%
			uData.setStatusProgress(90); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			//Definimos y configuramos acceso a Mondrian OLAP data source
			
			try{
				if (schBean.getSchemaVo().getDbConId()!=null && schBean.getSchemaVo().getDbConId().intValue()!=0){ // --> Es un cubo definido por el usuario
					  if (schBean.getSchemaVo().getDbConId().intValue() == -1){ //Los datos se encuentra en la base de Apia
						jdbcUrl = Configuration.DB_URL;//RECUPERAMOS EL PARAMETRO BIDB_URL DEFINIDO EN EL CONFIG.PROPERTIES
						jdbcUser = Configuration.DB_USR;//RECUPERAMOS EL PARAMETRO BIDB_USR DEFINIDO EN EL CONFIG.PROPERTIES
						jdbcPassword = Configuration.DB_PWD;//RECUPERAMOS EL PARAMETRO BIDB_PWD DEFINIDO EN EL CONFIG.PROPERTIES
						
						if ("ORACLE".equals(Configuration.DB_IMPLEMENTATION)){
							jdbcDriver = Parameters.ORACLE_DRIVER;
						}else if ("SQLSERVER".equals(Configuration.DB_IMPLEMENTATION)){
							jdbcDriver = Parameters.SQLSERVER_DRIVER;
						}else if ("POSTGRES".equals(Configuration.DB_IMPLEMENTATION)){
							jdbcDriver = Parameters.POSTGRES_DRIVER;
						}
				  	}else if (schBean.getSchemaVo().getDbConId()!=null){//Los datos se encuentran en una base distinta a la definida en el config.properties para el  bi
						DbConnectionVo dbConnVo = schBean.getDbConnForBI(schBean.getSchemaVo().getDbConId());
						jdbcUrl = dbConnVo.getDbConString();
						jdbcUser = dbConnVo.getDbConUser();
						jdbcPassword = dbConnVo.getDbConPassword();
						if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_ORACLE)) {
							jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
						} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_POSTGRE)) {
							jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
						} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_SQLSERVER)) {
							jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
						} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_MYSQL)) {
							jdbcDriver = BIParameters.BI_MYSQL_DRIVER;
						}
					}
				}
				if (navigatorMode || !hasRoles){%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
				}else {%><jp:mondrianQuery role="<%=usrProfiles%>" id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
				}
//				Seteamos en false la variable de sincronizacion de despliegue de los cubos	
				request.getSession().setAttribute("busy",new Boolean(false));
			}catch (Throwable e){
				Log.debug(e);
				response.sendRedirect("errorBI.jsp?error=14"+e.getMessage());
				uData.setStatusProgress(100);
				return;
			}finally{
//				Seteamos en false la variable de sincronizacion de despliegue de los cubos	
				  request.getSession().setAttribute("busy",new Boolean(false));
			}
			uData.setStatusProgress(95); //<--------------------------------------------------------------------PROGRESS BAR-----------------
			%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%}
	}
uData.setStatusProgress(99); //<--------------------------------------------------------------------PROGRESS BAR-----------------
%><body class="jPivotBody" onload="setDimensions();setEditorSizer();setTabs();startsizeHeights();clickBlockerStart();blockerListener();"><div class="pageTop"></div><!-- NO ELIMINAR ESTE DIV SINO SE VEN MAL LOS TABS DE GRILLA Y GRAFICO --><form action="<%=Parameters.ROOT_PATH%>/jpivot/schemaLoader.jsp" method="post" id="frmMain" target="_self"><div id="divContent"><%//Cargamos el schema y la primer vista a desplegar en Mondrian en la memoria%><jp:table id="table01" query="#{query01}"/><jp:navigator id="navi01" query="#{query01}" visible="true"/><wcf:form id="mdxedit01" xmlUri="/jpivot/table/mdxedit.xml" model="#{query01}" visible="false"/><wcf:form id="sortform01" xmlUri="/jpivot/table/sortform.xml" model="#{table01}" visible="false"/><wcf:form id="savebrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="false" /><%if(justSaved || justLoaded){%><c:set target="${savebrowser01}" property="visible" value="false" /><%}%><wcf:form id="viewInfo01" xmlUri="/jpivot/info/viewInfo.xml" model="#{query01}" visible="false" /><%if(justClosedInfo || justLoaded){%><c:set target="${viewInfo01}" property="visible" value="false" /><%}%><jp:print id="print01"/><wcf:form id="printform01" xmlUri="/jpivot/print/printpropertiesform.xml" model="#{print01}" visible="false"/><jp:chart id="chart01" query="#{query01}" visible="false"/><wcf:form id="chartform01" xmlUri="/jpivot/chart/chartpropertiesform.xml" model="#{chart01}" visible="false"/><wcf:table id="query01.drillthroughtable" visible="false" selmode="none" editable="true"/><%if("navigator".equals(schBean.getLoaderType())){%><%@include file="navigatorInclude.jsp" %><%}else{%><%@include file="toolBarInclude.jsp"%><%}%><%if(justLoaded && !justSaved){
	cubeVwBean.loadControls(request);
}%><%-- render toolbar --%><wcf:render ref="toolbar01" xslUri="/jpivot/toolbar/htoolbar.xsl" xslCache="true"/><input type="hidden" id="path" name="path" value="<%=request.getParameter("path")!=null?request.getParameter("path"):""%>" /><p><input type="hidden" name="browserAction" id="browserAction" value="<c:if test="${savebrowser01.visible}">save</c:if>"/><%-- if there was an overflow, show error message --%><c:if test="${query01.result.overflowOccured}"><p><strong style="color:red">Resultset overflow occured</strong><p></c:if><%String tabSet1=(String) (  request.getAttribute("tabSet1")!=null?request.getAttribute("tabSet1"):request.getParameter("tabSet1") ); 
if( tabSet1==null ){%><c:if test="${chart01.visible}"><%tabSet1="1";%></c:if><c:if test="${navi01.visible}"><%tabSet1="0";%></c:if><%}%><table class="divTable"><tr><%if(schBean.olapButtonVisible()){%><c:if test="${navi01.visible}"><td class="navigatorTd" style="width:200px;vertical-align:top;"><div style="overflow:auto;"><%-- render navigator --%><wcf:render ref="navi01" xslUri="/jpivot/navi/navigator.xsl" xslCache="true"/><div></td></c:if><%}%><td style="vertical-align:top;/*width:100%*/"><c:if test="${table01.visible}"><div type="tabElement" tabElement="1" id="mainTabs" defaultTab="<%=tabSet1!=null?tabSet1:"0"%>" ontabswitch="document.getElementById('tabSet1').value=this.shownIndex;window.parent.tabSet1=this.shownIndex;"><div type="tab"  style="display:none;" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIGrid")%>" tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIGrid")%>"><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/></div></c:if><c:if test="${chart01.visible}"><div type="tab" align="center" style="display:none;background-color:rgb(<c:out value="${chart01.bgColorR}"/>,<c:out value="${chart01.bgColorG}"/>,<c:out value="${chart01.bgColorB}"/>)" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIChart")%>" tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIChart")%>"><wcf:render ref="chart01" xslUri="/jpivot/chart/chart.xsl" xslCache="true"/></div></c:if></td></tr></table><%String tabSet2=(String) (  request.getAttribute("tabSet2")!=null?request.getAttribute("tabSet2"):request.getParameter("tabSet2") ); 
if( tabSet2==null ){%><c:if test="${mdxedit01.visible}"><%tabSet2="0";%></c:if><c:if test="${sortform01.visible}"><%tabSet2="1";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="2";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="3";%></c:if><%}%><c:if test="${mdxedit01.visible || sortform01.visible || printform01.visible || chartform01.visible}"><div id="editorSizer" style="position:relative;"><div id="editors" type="tabElement" defaultTab="<%=(tabSet2!=null)?tabSet2:"0"%>"  ontabswitch="document.getElementById('tabSet2').value=this.shownIndex"><c:if test="${mdxedit01.visible}"><div type="tab" <%if(!"0".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIMdxQryEditor")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIMdxQryEditor")%>" style="display:none;"><%-- edit mdx --%><wcf:render ref="mdxedit01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${sortform01.visible}"><div type="tab" <%if(!"1".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" style="display:none;"><%-- sort properties --%><wcf:render ref="sortform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${chartform01.visible}"><div type="tab" <%if(!"2".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Chart" tabTitle="Chart Properties" style="display:none;"><!-- <div id="chartProps"> --><%-- chart properties --%><wcf:render ref="chartform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${printform01.visible}"><div type="tab" <%if(!"3".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Print" tabTitle="Print Properties" style="display:none;"><%-- print properties --%><wcf:render ref="printform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if></div></div></c:if><!-- render the table --><div <%if(!"1".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" style="display:none;"><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/></div><div id="srcData" style="min-height:200px;position:absolute;top:60px;left:90;background-color:white;overflow:auto;"><wcf:render ref="query01.drillthroughtable" xslUri="/wcf/wcf.xsl" xslCache="true"/></div><!-- <a href=".">back to index</a> --><%if(tabId!=null){ %><input type="hidden" id="tabId" name="tabId" value="<%=tabId%>"><%}%><%if(tokenId!=null){ %><input type="hidden" id="tokenId" name="tokenId" value="<%=tokenId%>"><%}%><input type="hidden" id="tabSet1" name="tabSet1" value="<%=tabSet1%>"><input type="hidden" id="tabSet2" name="tabSet2" value="<%=tabSet2%>"><input type="hidden" id="navigator" name="navigator" value="<c:if test="${navi01.visible}">true</c:if>"><input type="hidden" id="cubeName" name="cubeName" value="<%=request.getParameter("cubeName")%>"></div><wcf:render ref="savebrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><wcf:render ref="viewInfo01" xslUri="/jpivot/info/viewInfo.xsl" xslCache="false"/></form><%@include file="../page/modals/profiles.jsp" %><div class="pageBottom"></div><%
//uData.setStatusProgress(0); //<--------------------------------------------------------------------PROGRESS BAR-----------------
%><div id="divBlocker" style="display:none; position: fixed; width: 100%; height: 100%; background-color: black; top: 0px; z-index:2; opacity: 0.3; filter: alpha(opacity=30); -ms-filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=30);"></div></body></html><script language="javascript" defer="true">
	var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
	
	<%
	String windowId = "";
	if(request.getParameter("windowId")!=null){
		windowId        = "&windowId=" + request.getParameter("windowId");
	}else{
		windowId        = "";
	}
	%>
	var windowId        = "<%=windowId%>";
	
	function quit(){
		try{
			window.splash();
		}catch (e){
			try{
				window.parent.splash();
			}catch(e2){
			}
		}
	}
	
	function sizeMainTabsWidth(){
		var tabElement=document.getElementById("mainTabs");
		var width=getStageWidth()-20;
		var editorSizer=document.getElementById("editorSizer");
		var divTable=document.getElementById("divTable");
		if(editorSizer){
			editorSizer.style.width=(width+5)+"px";
		}
		if(divTable){
			divTable.style.width=(width+5)+"px";
		}
		if(document.getElementById("editors")){
		var tabs=document.getElementById("editors").tabs;
			if(tabs){
				for(var i=0;i<tabs.length;i++){
					tabs[i].style.width=(width-15)+"px";
				}
			}
		}
		if(getElementsByClassName("navigatorTd")[0]){
			width-=getElementsByClassName("navigatorTd")[0].offsetWidth;
		}
		tabElement.style.width=width+"px";
		/*if(MSIE){
			addListener(window,"resize",sizeMainTabsWidth);		
			sizeMainTabsWidth();
		}*/
	}
	function startsizeHeights(){
		//addListener(window,"resize",sizeHeights);
		addListener("resize", window, sizeHeights);
		sizeHeights();
	}
	function sizeHeights(){
		var width=getStageWidth();
		if(MSIE){
			/*document.body.style.padding="0px";
			document.body.style.margin="0px";
			document.body.style.marginLeft="10px";*/
			width+=5;
		}else{
			width+=20;
		}
		if(!MSIE6){
			if(getElementsByClassName("navigatorTd")[0] && document.getElementById("editors")){
				var height1=getElementsByClassName("navigatorTd")[0].offsetHeight-30;
				var height2=getStageHeight()-170;
				document.getElementById("mainTabs").style.height=height1+"px";
				height2=height2-height1;
				if(MSIE){
					height2-=20;
				}
				if(height2<150){height2=150;}
				document.getElementById("editors").style.height=height2+"px";
			}else if(document.getElementById("editors")){
				var height=getStageHeight()-(document.getElementById("mainTabs").offsetHeight+170);
				if(MSIE){
					height2-=20;
				}
				document.getElementById("editors").style.height=(height-10)+"px";
			}else{
				document.getElementById("mainTabs").style.height=(getStageHeight()-170)+"px";
				if(getElementsByClassName("navigatorTd")[0]){
					getElementsByClassName("navigatorTd")[0].style.height=(getStageHeight()-170)+"px";
				}
			}
		}
		
		document.getElementById("divContent").style.height=(getStageHeight()-(getElementsByClassName("pageTop")[0].offsetHeight+getElementsByClassName("pageBottom")[0].offsetHeight+8))+"px";
		if(Browser.ie){
			if (!Browser.ie9 && !Browser.ie11)  document.getElementById("divContent").style.marginTop="-18px";
			document.getElementById("divContent").style.marginBottom="-20px";
			document.body.style.display='none';
			document.body.style.display='block';
		}
		
		if(document.getElementById("browserBlock")){
			document.getElementById("browserBlock").style.zIndex=
			document.getElementById("browserBlock").style.height=(getStageHeight())+"px";
			document.getElementById("browserBlock").style.width=(width)+"px";
		}
		if (document.getElementById("srcData").innerHTML == ""){
			document.getElementById("srcData").style.visibility = "hidden";
		}else{
			var stageHeight = getStageHeight();
			if(stageHeight > 550)
				document.getElementById("srcData").style.height = (stageHeight-550)+"px";
			document.getElementById("srcData").style.width = (width - 170)+"px";
			document.getElementById("srcData").style.top = (getStageHeight()/2 - ((getStageHeight()-550)/2))+ "px";
			document.getElementById("srcData").style.left = (width/2 - ((width-170)/2))+ "px";
		}
	
	}
	
	function clickBlockerStart(){
		var inputs=document.getElementById("toolbar01").getElementsByTagName("INPUT");
		for(var i=0;i<inputs.length;i++){
			if(inputs[i].type=="image"){
				//addListener(inputs[i],"mouseup",function(evt){
				/*addListener("mouseup", inputs[i], function(evt){
					blockBrowser();
				});*/
				$(inputs[i]).addEvent("mouseup", blockBrowser);
			}
		}
		
		
		initPrfMdlPage();
	}
	
	function blockBrowser(){
		var div=document.createElement("DIV");
		div.id="browserBlock";
		div.style.position="absolute";
		div.className="block";
		div.style.width=getStageWidth()+"px";
		div.style.height=getStageHeight()+"px";
		div.style.backgroundColor="#FFFFFF";
		div.style.top="0px";
		div.style.left="0px";
		div.style.zIndex=SYS_PANELS.getNewZIndex();
		document.body.appendChild(div);
// 		window.parent.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
	}
	
	
	//window.parent.parent.hideResultFrame();
</script><script language="javascript">
	var URL_ROOT_PATH		 	="<%=Parameters.ROOT_PATH%>";
	//var URL_ROOT_PATH		 	= window.parent.URL_ROOT_PATH;
	var schemaId				="<%=schemaId%>";
	var cubeId					="<%=cubeId%>";
	var viewId					="<%=viewId%>";
	var userId					="<%=schBean.getUserData().getUserId()%>";
	var envId					="<%=schBean.getUserData().getEnvironmentId().toString()%>";
	var msgVwNamIsMandatory     ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgVwNaIsMandatory")%>";
	var msgAlrExVwName	        ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgAlrExVwName")%>";
	var msgMusSelVwFirst	    ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgMusSelVwFirst")%>";	
	var msgMusSelPrfFirst	    ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgMusSelPrfFirst")%>";		
	var msgCantDelVwFolder	    ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgCantDelVwFolder")%>";			
	var msgMusSelVwFolFirst     ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgMusSelVwFolFirst")%>";			
	var msgWrngPath			    ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWrngPath")%>";				
	var msgConfRewVw			="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgConfRewVw")%>";				
	var msgConfDelVw			="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgConfDelVw")%>";
	var msgErrDelMainView 		="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgErrDelMainView")%>";
  	var msgViewInUseByWidget    ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgVwInUseByWidget")%>";
  	var msgWrngView				="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgBIErrLoadingView")%>";
  	var MSG_WRNG_VW_NAME        ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWrngVwName")%>";
  	
  	var VIEW_NAME				="<%=viewName%>";
  	var VIEW_DESC				="<%=viewDesc%>";
  	
  	function setEditorSizer(){
  		var srcData=document.getElementById("srcData");
  		if(srcData){
  			srcData.style.top=((getStageHeight()-srcData.clientHeight)/2)+"px";
  			srcData.style.left=((getStageWidth()-srcData.clientWidth)/2)+"px";
  		}
  		getParentTab();
  	}
  	
  	function getParentTab(){
	  	var tabSet1=window.parent.tabSet1;
	  	if(tabSet1){
	  		document.getElementById("mainTabs").setAttribute("defaultTab",tabSet1);
	  	}
	  	sizeMainTabsWidth();
  	}
  	
  	
  	function blockerListener() {
  		//Espere un momento
  		$('frmMain').addEvent('submit', function() {
	  		blockBrowser();
	  	});
  		
  		//Correcion de Drill Through
  		var drillThroughData = $('query01');
  		if(drillThroughData) {
  			var header = drillThroughData.getElement('TR').childNodes[0].childNodes[0];
  			var srcMain = $('srcData');
  			srcMain.getParent().insertBefore(header, srcMain);
  			
			var tableHeight = srcMain.childNodes[0].clientHeight;
  			var maxHeight = document.body.clientHeight - 200;
  			if(maxHeight > tableHeight + 20)
  				maxHeight = tableHeight + 20;
  				
  			srcMain.setStyle('height', maxHeight);
  			srcMain.setStyle('top', (document.body.clientHeight - maxHeight) / 2);
  			srcMain.setStyle('z-index', 3);
  			
//   			var maxWidth = Number.from(srcMain.getStyle('width'));
//   			srcMain.setStyle('left', Number.floor((document.body.clientWidth - maxWidth) / 2));
//   			console.log("comela negro! " + Number.floor((document.body.clientWidth - maxWidth) / 2));
  			
  			
  			header.setStyle('position', 'absolute');
			header.setStyle('top', Number.from(srcMain.getStyle('top')) - 16);
  			
  			header.setStyle('left', srcMain.getStyle('left'));
  			header.setStyle('width', srcMain.getStyle('width'));
  			header.getElement('INPUT').setStyle('display', 'none');
  			
  			header.setStyle('z-index', 3);
  			
  			
  			$('divBlocker').setStyle('display', 'block');
  		}
  	}

</script><%
uData.setStatusProgress(100); //<--------------------------------------------------------------------PROGRESS BAR-----------------
%>