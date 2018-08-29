<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.SchemaBean"%><%@ page session="true" contentType="text/html; charset=UTF-8" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><%@page import="com.tonbeller.wcf.controller.RequestContext" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.SchemaBean"><%dBean.setLoaderType("navigator");%></jsp:useBean><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="mondrian.rolap.CacheControlImpl"%><html><head><%
String styleDirectory = "default";
Integer environmentId = null;

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%><style><c:if test="${navi01.visible}">
	.navigatorTd{
		vertical-align:top;
		width:200px;
		padding-top:0px;
		background-color:FEFEFE;
	}
	#navi01{
		width:200px;
	}
</c:if></style></head><%
	CubeViewBean cubeVwBean=null;
	Integer schemaId = null;
	Integer cubeId = null;
	Integer viewId=null;
	String cubeName="";
	String cubeDesc="";
	String jdbcDriver = null;
	String jdbcUrl = null;
	String jdbcUser = null;
	String jdbcPassword = null;

//	RECUPERAMOS EL PARAMETRO BIDB_IMPLMENTATION DEFINIDO EN EL CONFIG.PROPERTIES
	if ("ORACLE".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
	}else if ("SQLSERVER".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
	}else if ("POSTGRES".equals(BIParameters.BIDB_IMPLEMENTATION)){
		jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
	}
	
	jdbcUrl = BIParameters.BIDB_URL;//RECUPERAMOS EL PARAMETRO BIDB_URL DEFINIDO EN EL CONFIG.PROPERTIES
	jdbcUser = BIParameters.BIDB_USR;//RECUPERAMOS EL PARAMETRO BIDB_USR DEFINIDO EN EL CONFIG.PROPERTIES
	jdbcPassword = BIParameters.BIDB_PWD;//RECUPERAMOS EL PARAMETRO BIDB_PWD DEFINIDO EN EL CONFIG.PROPERTIES
	
	if (!dBean.isSchemaLoaded()){
		CacheControlImpl cche = new CacheControlImpl();
		cche.flushSchemaCache();
		//Thread.sleep(3 * 1000); //Le damos tiempo a que limpie el cache sino puede dar error.
		/////////// Recuperamos el schema de la base y lo cargamos en memoria //////////////
		if(request.getParameter("schemaId")!=null && !"null".equals(request.getParameter("schemaId"))){
			if (!dBean.loadSchemaVoById(new Integer(request.getParameter("schemaId")))){
				//System.out.println("------BI ERROR: Error cargando schema");
				return;
			}
		}else{
			//System.out.println("------ERROR: NO SE ESPECIFICO NINGUN Id DE SCHEMA PARA CARGAR-----------");
			return;
		}
			
		if (dBean.getSchemaVo() == null) {
			//System.out.println("------ERROR: NO SE ENCONTRO EL SCHEMA CON ID: " + request.getParameter("schemaId") + "-----------");
			return;
		}
		schemaId = dBean.getSchemaVo().getSchemaId();
	
		if(request.getSession().getAttribute("toolbar01")!=null){
			request.getSession().removeAttribute("toolbar01");
		}
		request.getSession().removeAttribute("toolbar01");
		//File schemaDef = new File(Parameters.APP_PATH+"/jpivot/schemaDefinitionXML.xml");
		File schemaDef = new File(SchemaVo.SCHEMA_BI_TEMP_FULL_FILE_NAME);
		BufferedWriter writer;
		writer = new BufferedWriter(new FileWriter(schemaDef, false));
		writer.write(dBean.getXmlSchemaDef());
		writer.close();
		
		cubeId = new Integer(request.getParameter("cubeId"));
		CubeVo cubeVo = dBean.getCubeVo(cubeId);
		cubeName = cubeVo.getCubeName();
		cubeDesc = cubeVo.getCubeDesc();
		
		dBean.setCubeIdLoaded(cubeId); //Almacenamos el id del cubo que se esta cargando en memoria
		/////////// Obtenemos la definicion de la vista //////////////
		cubeVwBean = new CubeViewBean();
		//Cargamos cualquier vista por defecto (si cubeId y viewId es null)
		
		if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
			viewId=new Integer(request.getParameter("viewId").toString());
		}else if(request.getAttribute("viewId")!=null && !"null".equals(request.getAttribute("viewId"))){
			viewId=new Integer(request.getAttribute("viewId").toString());
		}
		cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId);
		//System.out.println(""); 
		///System.out.println("");
		//System.out.println("---------------------LOADING SCHEMA OF BI IN MEMORY----------------------");
		//System.out.println(" -> Schema Name: "+ dBean.getSchemaVo().getSchemaName());
		//if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId")) ){
		//	System.out.println(" -> Cube Id Loaded: "+ request.getParameter("cubeId"));
		//}else{
		//	System.out.println(" -> Cube Loaded By Default: "+ cubeVwBean.getCubeViewVo().getCubeId());
		//}
		//System.out.println(" -> View Name: "+ cubeVwBean.getCubeViewVo().getVwName());
		//System.out.println(" -> MDX: "+ cubeVwBean.getMdxQuery());
		//Definimos y configuramos acceso a Mondrian OLAP data source
		try{
			if (dBean.getSchemaVo().getDbConId()!=null){//Los datos se encuentran en una base distinta a la definida en el config.properties para el  bi
				DbConnectionVo dbConnVo = dBean.getDbConnForBI(dBean.getSchemaVo().getDbConId());
				jdbcUrl = dbConnVo.getDbConString();
				jdbcUser = dbConnVo.getDbConUser();
				jdbcPassword = dbConnVo.getDbConPassword();
				if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_ORACLE)) {
					jdbcDriver = BIParameters.BI_ORACLE_DRIVER;
				} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_POSTGRE)) {
					jdbcDriver = BIParameters.BI_POSTGRES_DRIVER;
				} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_SQLSERVER)) {
					jdbcDriver = BIParameters.BI_SQLSERVER_DRIVER;
				}
			}
			%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=SchemaVo.SCHEMA_BI_TEMP_CATALOG_FULL_URI%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
		}catch (Throwable e){
			return;
		}
		%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><%
		%><%}%><body><%//Cargamos el schema y la primer vista a desplegar en Mondrian en la memoria%><jp:table id="table01" query="#{query01}"/></body></html><script language="javascript">
	var schemaId = "<%=schemaId%>";
	var cubeId	 = "<%=cubeId%>";
	var viewId	 = "<%=viewId%>";
</script><%//System.out.println("-----------------FINISH LOADING SCHEMA OF BI IN MEMORY--------------------------");
//System.out.println("");
//System.out.println("");%>