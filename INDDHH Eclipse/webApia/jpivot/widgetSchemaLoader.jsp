<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="biz.statum.apia.web.bean.administration.SchemasBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.SchemaBean"%><%@ page session="true" contentType="text/html; charset=UTF-8" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><%@page import="com.tonbeller.wcf.controller.RequestContext" %><%@page import="com.st.util.log.Log"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.administration.DashboardBean"%><%

try{
	
HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
SchemasBean schBean= (SchemasBean) BasicAction.staticRetrieveBean(http, BasicAction.BEAN_ADMIN_NAME);
String tabId = request.getParameter("tabId");
request.getSession().setAttribute("forWidget", new Boolean(true));

if (schBean==null) schBean = new SchemasBean(null);
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="mondrian.rolap.CacheControlImpl"%><%@page import="com.dogma.Configuration"%><html><head><%

//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");

String styleDirectory = "default";
Integer environmentId = null;

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%><title>JPivot Test Page</title><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"></meta><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/table/mdxtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/navi/mdxnavi.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/form/xform.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/table/xtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/tree/xtree.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/tabs.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/jpivot.css"><%@include file="jPivotScriptVars.jsp" %><script type="text/javascript">
		function hideProcessingMsg() {
			var wid_id = <%=request.getParameter("widId")%>;
			//this.parent.document.getElementById('blocker_' + wid_id).style.display = 'none';
		}
	</script><style>
		input {
			display: none;
		}
	</style></head><%
	CubeViewBean cubeVwBean=null;
	Integer schemaId = null;
	Integer cubeId = null;
	Integer widId = null;
	Integer dshId = null;
	Integer dshChildId=null;
	boolean viewBtnComments = false; //valor por defecto
	boolean viewBtnInfo = false; //valor por defecto
	boolean viewBtnRefresh = false; //valor por defecto
	boolean viewWidName = "true".equals(request.getParameter("viewWidName"));
	boolean hasChilds = "true".equals(request.getParameter("hasChilds"));
	Integer cantInformation = Integer.valueOf(0);
	if (request.getParameter("cantInformation")!=null && !"".equals(request.getParameter("cantInformation"))) cantInformation = Integer.valueOf(request.getParameter("cantInformation"));
	String widName = request.getParameter("widName");
	String widTitle = request.getParameter("widTitle");
	String widDesc = request.getParameter("widDesc");
	String viewMode = request.getParameter("viewMode");
	Double widgetWidth = Double.valueOf(350); //ancho del widget
	Double widgetHeight = Double.valueOf(300); //largo del widget
	boolean viewChart = "chart".equals(viewMode);
	boolean hasRoles = false;
	String usrProfiles = (schBean!=null)?schBean.getUsrProfiles():null;//perfiles del usuario actual

	Integer viewId=null;
	String cubeName="";
	String cubeDesc="";
	boolean newCube=false;
	
	if (request.getParameter("biError")!=null) {
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?error=" + request.getParameter("biError"));
		return;
	}
	
	if (request.getParameter("dshChildId")!=null && !"null".equals(request.getParameter("dshChildId"))){
		dshChildId = new Integer(request.getParameter("dshChildId"));
	}
	
	if (request.getParameter("viewBtnComments")!=null && "true".equals(request.getParameter("viewBtnComments"))){
		viewBtnComments = true;
	}
	if (request.getParameter("viewBtnInfo")!=null && "true".equals(request.getParameter("viewBtnInfo"))){
		viewBtnInfo = true;
	}
	if (request.getParameter("viewBtnRefresh")!=null && "true".equals(request.getParameter("viewBtnRefresh"))){
		viewBtnRefresh = true;
	}
	
	//Parametros de la base donde se encuentran los datos de los cubos
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
	
	///////////////////////// 1 - Recuperamos los parametros

	//1.1 - schemaId
	if(request.getParameter("schemaId")!=null && !"null".equals(request.getParameter("schemaId"))){
		schemaId = new Integer(request.getParameter("schemaId"));
	}else{
		if (schBean.getSchemaVo()!=null && schBean.getSchemaVo().getSchemaId()!=null){
			schemaId = schBean.getSchemaVo().getSchemaId();
		}else {
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			if (widId!=null){
				response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?msgError=" + StringUtil.escapeScriptStr("No se especifico ningun schemaId") + "&widId="+widId.intValue());
			}else{
				response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?msgError=" + StringUtil.escapeScriptStr("No se especifico ningun schemaId"));
			}
			return;
		}
	}
	
	//1.2 - dshId
	if(request.getParameter("dshId")!=null && !"null".equals(request.getParameter("dshId")) && !"".equals(request.getParameter("dshId"))){
		dshId = new Integer(request.getParameter("dshId"));
	}
	
	//1.3 - widId
	if(request.getParameter("widId")!=null && !"null".equals(request.getParameter("widId"))){
		widId = new Integer(request.getParameter("widId"));
	}else{
		if (schBean.getSchemaVo()!=null && schBean.getWidId()!=null){
			widId = schBean.getWidId();
		}else {
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun widId"));
			return;
		}
	}

	//1.4 - cubeId
	if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId"))){
		cubeId = new Integer(request.getParameter("cubeId"));
	}else{
		if (schBean.getCubeId()!=null){
			cubeId = schBean.getCubeId();
		}else{
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun cubeId") + "&widId="+widId.intValue());
			return;
		}
	}
	
	//1.5 - viewId
	if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
		viewId=new Integer(request.getParameter("viewId").toString());
	}else if(request.getAttribute("viewId")!=null && !"null".equals(request.getAttribute("viewId"))){
		viewId=new Integer(request.getAttribute("viewId").toString());
	}else{
		if (schBean.getVwId()!=null){
			viewId = schBean.getVwId();
		}else{
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun viewId") + "&widId="+widId.intValue());
			return;
		}
	}
	
	//1.6 - widgetWidth
	if(request.getParameter("widWidth")!=null && !"null".equals(request.getParameter("widWidth"))){
		widgetWidth= Double.valueOf(request.getParameter("widWidth").toString());
	}else if(request.getAttribute("widWidth")!=null && !"null".equals(request.getAttribute("widWidth"))){
		widgetWidth=Double.valueOf(request.getAttribute("widWidth").toString());
	}
	
	//1.7 - widgetHeight
		if(request.getParameter("widHeight")!=null && !"null".equals(request.getParameter("widHeight"))){
			widgetHeight= Double.valueOf(request.getParameter("widHeight").toString());
		}else if(request.getAttribute("widHeight")!=null && !"null".equals(request.getAttribute("widHeight"))){
			widgetHeight=Double.valueOf(request.getAttribute("widHeight").toString());
		}
	
	if (widName==null){
		widName = schBean.getWidName();
	}
	
	schBean.loadWidgetSchemaVoById(schemaId, widId, widName, cubeId, viewId);
	schBean.setViewIdLoaded(viewId);

	hasRoles = schBean.schemaUseRoles(schemaId);
	
	double nameSize = widName.length();
	int maxTitleSize = Double.valueOf(widgetWidth / 7.5).intValue(); //Se estima 10 pixeles por letra
	String showWidName = widName.length()>maxTitleSize?widName.substring(0,maxTitleSize)+"..":widName;
	String showWidTitle = widTitle;
	if (widTitle!=null) showWidTitle = widTitle.length()>maxTitleSize?widTitle.substring(0,maxTitleSize)+"..":widTitle;
	boolean hasDesc = widDesc!=null && !"".equals(widDesc) && !"null".equals(widDesc);
	 	
	//////////////////////////////
	
	//Seteamos lenguaje del explorador (para los archivos de lenguaje del mondrian)
	//Y seteamos pais, para los separadores de miles y decimal
	String country = Configuration.COUNTRY;
	if (country!=null && !"".equals(country)){
		RequestContext.instance().setLocale(new Locale(lang,country));
	}else {
		RequestContext.instance().setLocale(new Locale(lang));
	}
	
	// Recuperamos informacion del usuario actual: lenguaje, nombre
	if (uData == null){
		uData = new UserData();
		uData.setLangId(Parameters.DEFAULT_LANG);
		uData.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
		//request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,uData);
	}
	String user = uData.getUserName();
	
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
	
//	mondrian.rolap.RolapSchema.clearCache(); //Limpia del cache todo
	CacheControlImpl cche = new CacheControlImpl();
	cche.flushSchemaCache();
	Thread.sleep(3 * 1000); //Le damos tiempo a que limpie el cache sino puede dar error.

	/////////// Cargamos el schema en memoria //////////////
	if (!schBean.loadSchemaVoById(schemaId)){
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?error=13" + "&widId="+widId.intValue()); //ERROR LOADING SCHEMA
		return;
	}
		
	if (schBean.getSchemaVo() == null) {
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se encontro el schemaId en la base de datos del bi") + "&widId="+widId.intValue());
		return;
	}
	
	if(request.getSession().getAttribute("toolbar01")!=null){
		request.getSession().removeAttribute("toolbar01");
	}
	
	request.getSession().removeAttribute("toolbar01");
	
	//Escribimos la definicion del esquema en un archivo para que mondrian pueda leerlo
	//File schemaDef = new File(SchemaVo.SCHEMA_BI_TEMP_FULL_FILE_NAME);
	String schemaFile = SchemaVo.SCHEMA_WIDGET_TEMP_FILE_NAME + new Date().getTime() + ".xml";
	String schemaFileDir = SchemaVo.SCHEMA_BI_TEMP_DIR_NAME + File.separator + schemaFile;
	String catalogUri = "/jpivot/"+schemaFile;
	
	File schemaDef = new File(schemaFileDir);
	BufferedWriter writer;
	writer = new BufferedWriter(new FileWriter(schemaDef, false));
	writer.write(schBean.getXmlSchemaDef());
	writer.close();
	
	Date nowDate = new Date();
	//Recuperamos la información del cubo 
	CubeVo cubeVo = schBean.getCubeVo(cubeId);
	cubeName = cubeVo.getCubeName();
	if (cubeName.startsWith("mnuDw")){
		cubeName = LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),cubeName);
	}
	cubeDesc = cubeVo.getCubeDesc();
	if (cubeDesc!=null){
		if (cubeDesc.startsWith("mnuDw")){
			cubeDesc = LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),cubeDesc);
		}else if (cubeDesc.startsWith("lblDw")){ //Versiones nuevas de apia
			if (cubeDesc.indexOf(")") > 0){
				//Es un cubo autogenerado
				cubeName = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
				cubeDesc = null;
			}
		}
	}
	
	schBean.setCubeIdLoaded(cubeId); //Almacenamos el id del cubo que se esta cargando en memoria
	
	/////////// Obtenemos la definicion de la vista //////////////
	cubeVwBean = new CubeViewBean();
	//Cargamos cualquier vista por defecto (si cubeId y viewId es null)
	cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);

	//Definimos y configuramos acceso a Mondrian OLAP data source
  
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
		if (!hasRoles){%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>" jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=catalogUri%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
		}else {%><jp:mondrianQuery id="query01" role="<%=usrProfiles%>" jdbcDriver="<%=jdbcDriver%>" jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=catalogUri%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
		}
	}catch (Throwable e){		
		if (e.getMessage().contains("Mondrian Error:Syntax error")){
			Log.debug("---------------------------------------------------------------------------");
			Log.debug("Error loading widget of type cube:");
			Log.debug(e);
			Log.debug("---------------------------------------------------------------------------");
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?error=18&errorMsg="+e.getMessage()+"&schemaId=" + schemaId + "&widId="+widId.intValue());
		}else {
			Log.debug("---------------------------------------------------------------------------");
			Log.debug("Error loading widget of type cube:");
			Log.debug(e);
			Log.debug("---------------------------------------------------------------------------");
			request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
			response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?error=19&errorMsg="+e.getMessage()+"&schemaId=" + schemaId + "&widId="+widId.intValue());
		}
			
		return;
		
	}finally{
		request.getSession().setAttribute("busy",new Boolean(false));	
		schemaDef.delete();
	}
	%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><body id="body" class="jPivotBody" style="background:transparent;" onload="setEditorSizer();document.body.style.overflow='auto';hideProcessingMsg();"><form action="<%=Parameters.ROOT_PATH%>/jpivot/schemaLoader.jsp" method="post" id="frmMain" target="_self"><%//Cargamos el schema y la primer vista a desplegar en Mondrian en la memoria%><jp:table id="table01" query="#{query01}"/><jp:navigator id="navi01" query="#{query01}" visible="true"/><wcf:form id="mdxedit01" xmlUri="/jpivot/table/mdxedit.xml" model="#{query01}" visible="false"/><wcf:form id="sortform01" xmlUri="/jpivot/table/sortform.xml" model="#{table01}" visible="false"/><wcf:form id="savebrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="false" /><jp:print id="print01"/><wcf:form id="printform01" xmlUri="/jpivot/print/printpropertiesform.xml" model="#{print01}" visible="false"/><jp:chart id="chart01" query="#{query01}" visible="false"/><wcf:form id="chartform01" xmlUri="/jpivot/chart/chartpropertiesform.xml" model="#{chart01}" visible="false"/><wcf:table id="query01.drillthroughtable" visible="false" selmode="none" editable="true"/><wcf:toolbar id="toolbar01" bundle="com.tonbeller.jpivot.toolbar.resources"></wcf:toolbar><%cubeVwBean.loadControls(request);%><input type="hidden" id="txtLastUpdate" value="<%=schBean.fmtHTMLTime(environmentId, nowDate)%>" /><table class="divTable"><tr><td style="vertical-align:top;/*width:100%*/"><%if(viewChart){%><wcf:render ref="chart01" xslUri="/jpivot/chart/chart.xsl" xslCache="true"/><%} else { %><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/><%} %></td></tr></table></form></body></html><script language="javascript" defer="true">
	//window.parent.parent.hideResultFrame();
</script><script language="javascript">
	var URL_ROOT_PATH		 	="<%=Parameters.ROOT_PATH%>";
	//var URL_ROOT_PATH		 	= window.parent.URL_ROOT_PATH;
	var schemaId				="<%=schemaId%>";
	var cubeId					="<%=cubeId%>";
	var viewId					="<%=viewId%>";
	var userId					="<%=uData.getUserId()%>";
	var envId					="<%=(uData.getEnvironmentId()!=null)?uData.getEnvironmentId().toString():null%>";
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
  	function setEditorSizer(){
  		var srcData=document.getElementById("srcData");
  		if(srcData){
  			srcData.style.top=((getStageHeight()-srcData.clientHeight)/2)+"px";
  			srcData.style.left=((getStageWidth()-srcData.clientWidth)/2)+"px";
  		}
  	
  	}

</script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><%
}finally{
  //Seteamos en false la variable de sincronizacion de despliegue de los cubos	
  request.getSession().setAttribute("busy",new Boolean(false));
}
%>
