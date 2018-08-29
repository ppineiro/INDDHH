<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@ taglib uri="http://www.tonbeller.com/jpivot" prefix="jp" %><%@ taglib uri="http://www.tonbeller.com/wcf" prefix="wcf" %><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@page import="java.io.BufferedReader"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.bean.administration.SchemaBean"%><%@ page session="true" contentType="text/html; charset=UTF-8" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.UserData"%><%@page import="java.io.File"%><%@page import="java.io.BufferedWriter"%><%@page import="java.io.FileWriter"%><%@page import="com.dogma.bean.administration.CubeViewBean"%><%@page import="com.tonbeller.wcf.controller.RequestContext" %><%@page import="com.st.util.log.Log"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.administration.DashboardBean"%><%SchemaBean dBean = new SchemaBean();%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.st.util.log.Log"%><%@page import="mondrian.rolap.CacheControlImpl"%><%@page import="com.dogma.Configuration"%><html><head><%
//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");

String styleDirectory = "default";
Integer environmentId = null;

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%><title>JPivot Test Page</title><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"></meta><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/table/mdxtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/navi/mdxnavi.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/form/xform.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/table/xtable.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/wcf/tree/xtree.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/tabs.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/jpivot/jpivot.css"><link rel="stylesheet" type="text/css" href="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/css/workArea.css"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/tabs.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/common.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/list.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/dimensions.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/viewBrowser.js" defer="true"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/jpivot/viewInfo.js" defer="true"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js" defer="true"></script><%@include file="jPivotScriptVars.jsp" %><style><c:if test="${navi01.visible}">
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
	String viewName="";
	String viewDesc="";
	boolean newCube=false;
	boolean justLoaded=( (request.getParameter("justLoaded")!=null && "true".equals(request.getParameter("justLoaded").toString()))  || (request.getAttribute("justLoaded")!=null && "true".equals(request.getAttribute("justLoaded").toString())) );
	boolean justSaved=( (request.getParameter("justSaved")!=null && "true".equals(request.getParameter("justSaved").toString()))  || (request.getAttribute("justSaved")!=null && "true".equals(request.getAttribute("justSaved").toString())) );
	boolean justClosedInfo =( (request.getParameter("justClosedInfo")!=null && "true".equals(request.getParameter("justClosedInfo").toString()))  || (request.getAttribute("justClosedInfo")!=null && "true".equals(request.getAttribute("justClosedInfo").toString())) ); 
	boolean hasRoles = false;
	String usrProfiles = dBean.getUsrProfiles();//perfiles del usuario actual

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
	
	///////////////////////// 1 - Recuperamos los parametros

	//1.1 - schemaId
	if(request.getParameter("schemaId")!=null && !"null".equals(request.getParameter("schemaId"))){
		schemaId = new Integer(request.getParameter("schemaId"));
	}else{
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun schemaId"));
		return;
	}
		
	//1.2 - cubeId
	if(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId"))){
		cubeId = new Integer(request.getParameter("cubeId"));
	}else{
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun cubeId"));
		return;
	}
	
	//1.3 - viewId
	if(request.getParameter("viewId")!=null && !"null".equals(request.getParameter("viewId"))){
		viewId=new Integer(request.getParameter("viewId").toString());
	}else if(request.getAttribute("viewId")!=null && !"null".equals(request.getAttribute("viewId"))){
		viewId=new Integer(request.getAttribute("viewId").toString());
	}else{
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se especifico ningun viewId"));
		return;
	}
	
	hasRoles = dBean.schemaUseRoles(schemaId);
	
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
	
	//mondrian.rolap.RolapSchema.clearCache(); //Limpia del cache todo
	CacheControlImpl cche = new CacheControlImpl();
	cche.flushSchemaCache();
	Thread.sleep(3 * 1000); //Le damos tiempo a que limpie el cache sino puede dar error.

	/////////// Cargamos el schema en memoria //////////////
	if (!dBean.loadSchemaVoById(schemaId)){
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?error=13"); //ERROR LOADING SCHEMA
		return;
	}
		
	if (dBean.getSchemaVo() == null) {
		request.getSession().setAttribute("busy",new Boolean(false)); //Seteamos la variable de sincronizacion de carga de cubos en false
		response.sendRedirect(Parameters.ROOT_PATH+"/programs/biExecution/widgets/errorWidget.jsp?errorMsg=" + StringUtil.escapeScriptStr("No se encontro el schemaId en la base de datos del bi"));
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
	writer.write(dBean.getXmlSchemaDef());
	writer.close();
	
	//Recuperamos la información del cubo 
	CubeVo cubeVo = dBean.getCubeVo(cubeId);
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
	
	dBean.setCubeIdLoaded(cubeId); //Almacenamos el id del cubo que se esta cargando en memoria
	
	/////////// Obtenemos la definicion de la vista //////////////
	cubeVwBean = new CubeViewBean();
	//Cargamos cualquier vista por defecto (si cubeId y viewId es null)
	cubeVwBean.loadSchCubeViewVo(schemaId, cubeId, viewId, uData);
	viewName = cubeVwBean.getCubeViewVo().getVwName();
	viewDesc = cubeVwBean.getCubeViewVo().getVwDesc();
	//Definimos y configuramos acceso a Mondrian OLAP data source
  
	try{
			if (dBean.getSchemaVo().getDbConId()!=null && dBean.getSchemaVo().getDbConId().intValue()!=0){ // --> Es un cubo definido por el usuario
				  if (dBean.getSchemaVo().getDbConId().intValue() == -1){ //Los datos se encuentra en la base de Apia
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
						} else if (dbConnVo.getDbConType().equals(DbConnectionVo.TYPE_MYSQL)) {
							jdbcDriver = BIParameters.BI_MYSQL_DRIVER;
						}
				  }
			}
			if (!hasRoles){%><jp:mondrianQuery id="query01" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=catalogUri%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
			}else{%><jp:mondrianQuery id="query01" role="<%=usrProfiles%>" jdbcDriver="<%=jdbcDriver%>"	jdbcUrl="<%=jdbcUrl%>" jdbcUser="<%=jdbcUser%>" jdbcPassword="<%=jdbcPassword%>" catalogUri="<%=catalogUri%>"><%=cubeVwBean.getMdxQuery()%></jp:mondrianQuery><%
			}
		}catch (Throwable e){
			Log.debug(e);
			response.sendRedirect("errorBI.jsp?error=14&errorMsg="+e.getMessage());
			uData.setStatusProgress(0);
			return;
		}finally{
//			Seteamos en false la variable de sincronizacion de despliegue de los cubos	
	  		request.getSession().setAttribute("busy",new Boolean(false));
  			schemaDef.delete();
		}
		
		%><c:if test="${query01 == null}"><jsp:forward page="."/></c:if><body class="jPivotBody" onload="setDimensions();setTabs();setEditorSizer();startsizeHeights();clickBlockerStart();"><div class="pageTop"><table><tr><td width="0px" style="white-space:nowrap;"><%=LabelManager.getName(labelSet, "lblVis") + ": " + viewName%></td></tr></table></div><form action="<%=Parameters.ROOT_PATH%>/jpivot/schemaLoader.jsp" method="post" id="frmMain" target="_self"><div id="divContent"><%//Cargamos el schema y la primer vista a desplegar en Mondrian en la memoria%><jp:table id="table01" query="#{query01}"/><jp:navigator id="navi01" query="#{query01}" visible="true"/><wcf:form id="mdxedit01" xmlUri="/jpivot/table/mdxedit.xml" model="#{query01}" visible="false"/><wcf:form id="sortform01" xmlUri="/jpivot/table/sortform.xml" model="#{table01}" visible="false"/><wcf:form id="savebrowser01" xmlUri="/jpivot/views/viewBrowser.xml" model="#{query01}" visible="false" /><%if(justSaved || justLoaded){%><c:set target="${savebrowser01}" property="visible" value="false" /><%}%><wcf:form id="viewInfo01" xmlUri="/jpivot/info/viewInfo.xml" model="#{query01}" visible="false" /><%if(justClosedInfo || justLoaded){%><c:set target="${viewInfo01}" property="visible" value="false" /><%}%><jp:print id="print01"/><wcf:form id="printform01" xmlUri="/jpivot/print/printpropertiesform.xml" model="#{print01}" visible="false"/><jp:chart id="chart01" query="#{query01}" visible="false"/><wcf:form id="chartform01" xmlUri="/jpivot/chart/chartpropertiesform.xml" model="#{chart01}" visible="false"/><wcf:table id="query01.drillthroughtable" visible="false" selmode="none" editable="true"/><%-- define a toolbar for Widget Viewer mode --%><wcf:toolbar id="toolbar01" bundle="com.tonbeller.jpivot.toolbar.resources"><wcf:imgbutton id="printpdf" tooltip="toolb.print" img="print" href="../Print?cube=01&type=1"/><wcf:imgbutton id="printxls" tooltip="toolb.excel" img="excel" href="../Print?cube=01&type=0"/><wcf:separator/><wcf:scriptbutton id="viewInfoButton01" tooltip="toolb.viewInfo" img="infoBtn" model="#{viewInfo01.visible}"/><wcf:separator/></wcf:toolbar><%//if(justLoaded && !justSaved){
	cubeVwBean.loadControls(request);
//}%><%-- render toolbar --%><wcf:render ref="toolbar01" xslUri="/jpivot/toolbar/htoolbar.xsl" xslCache="true"/><input type="hidden" id="path" name="path" value="<%=request.getParameter("path")!=null?request.getParameter("path"):""%>" /><p><input type="hidden" name="browserAction" id="browserAction" value="<c:if test="${savebrowser01.visible}">save</c:if>"/><%-- if there was an overflow, show error message --%><c:if test="${query01.result.overflowOccured}"><p><strong style="color:red">Resultset overflow occured</strong><p></c:if><%String tabSet1=(String) (  request.getAttribute("tabSet1")!=null?request.getAttribute("tabSet1"):request.getParameter("tabSet1") ); 
if( tabSet1==null ){%><c:if test="${navi01.visible}"><%tabSet1="0";%></c:if><c:if test="${chart01.visible}"><%tabSet1="1";%></c:if><%}%><table class="divTable"><tr><td style="vertical-align:top;/*width:100%*/"><c:if test="${table01.visible}"><div type="tabElement" tabElement="1" id="mainTabs" defaultTab="<%=tabSet1!=null?tabSet1:"0"%>" ontabswitch="document.getElementById('tabSet1').value=this.shownIndex"><div type="tab"  style="display:none;" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIGrid")%>" tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIGrid")%>"><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/></div></c:if><c:if test="${chart01.visible}"><div type="tab" align="center" style="display:none;background-color:rgb(<c:out value="${chart01.bgColorR}"/>,<c:out value="${chart01.bgColorG}"/>,<c:out value="${chart01.bgColorB}"/>)" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIChart")%>" tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIChart")%>"><wcf:render ref="chart01" xslUri="/jpivot/chart/chart.xsl" xslCache="true"/></div></c:if></td></tr></table><%String tabSet2=(String) (  request.getAttribute("tabSet2")!=null?request.getAttribute("tabSet2"):request.getParameter("tabSet2") ); 
if( tabSet2==null ){%><c:if test="${mdxedit01.visible}"><%tabSet2="0";%></c:if><c:if test="${sortform01.visible}"><%tabSet2="1";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="2";%></c:if><c:if test="${chartform01.visible}"><%tabSet2="3";%></c:if><%}%><c:if test="${mdxedit01.visible || sortform01.visible || printform01.visible || chartform01.visible}"><div id="editorSizer" style="position:relative;"><div id="editors" type="tabElement" defaultTab="<%=(tabSet2!=null)?tabSet2:"0"%>"  ontabswitch="document.getElementById('tabSet2').value=this.shownIndex"><c:if test="${mdxedit01.visible}"><div type="tab" <%if(!"0".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBIMdxQryEditor")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBIMdxQryEditor")%>" style="display:none;"><%-- edit mdx --%><wcf:render ref="mdxedit01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${sortform01.visible}"><div type="tab" <%if(!"1".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" style="display:none;"><%-- sort properties --%><wcf:render ref="sortform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${chartform01.visible}"><div type="tab" <%if(!"2".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Chart" tabTitle="Chart Properties" style="display:none;"><!-- <div id="chartProps"> --><%-- chart properties --%><wcf:render ref="chartform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if><c:if test="${printform01.visible}"><div type="tab" <%if(!"3".equals(tabSet2)){%>style="display:none;" <%}%>tabText="Print" tabTitle="Print Properties" style="display:none;"><%-- print properties --%><wcf:render ref="printform01" xslUri="/wcf/wcf.xsl" xslCache="true"/></div></c:if></div></div></c:if><!-- render the table --><div <%if(!"1".equals(tabSet2)){%>style="display:none;" <%}%>tabText="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" tabTitle="<%=LabelManager.getToolTip(uData.getLabelSetId(),uData.getLangId(),"lblBISort")%>" style="display:none;"><wcf:render ref="table01" xslUri="/jpivot/table/mdxtable.xsl" xslCache="true"/></div><div id="srcData" style="position :absolute;top:60px;left:90;background-color:white"><!-- drill through table --><wcf:render ref="query01.drillthroughtable" xslUri="/wcf/wcf.xsl" xslCache="true"/></div><!-- <a href=".">back to index</a> --><input type="hidden" id="tabSet1" name="tabSet1" value="<%=tabSet1%>"><input type="hidden" id="tabSet2" name="tabSet2" value="<%=tabSet2%>"><input type="hidden" id="navigator" name="navigator" value="<c:if test="${navi01.visible}">true</c:if>"><input type="hidden" id="cubeName" name="cubeName" value="<%=request.getParameter("cubeName")%>"></div><wcf:render ref="savebrowser01" xslUri="/jpivot/views/viewBrowser.xsl" xslCache="false"/><wcf:render ref="viewInfo01" xslUri="/jpivot/info/viewInfo.xsl" xslCache="false"/></form><div class="pageBottom"><table><tr><td width="100%"></td><td width="0px"><button type="button" onclick="window.close()">Salir</button></td></tr></table></div><%
uData.setStatusProgress(0); //<--------------------------------------------------------------------PROGRESS BAR-----------------
%></body></html><script language="javascript" defer="true">
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
	
	function sizeMainTabsWidth(){
		var tabElement=document.getElementById("mainTabs");
		var width=getStageWidth()-20;
		var editorSizer=document.getElementById("editorSizer");
		if(editorSizer){
			editorSizer.style.width=(width+5)+"px";
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
		if(MSIE){
			addListener(window,"resize",sizeMainTabsWidth);		
			sizeMainTabsWidth();
		}
	}
	function startsizeHeights(){
		addListener(window,"resize",sizeHeights);
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
				document.getElementById("editors").style.height=height+"px";
			}else{
				document.getElementById("mainTabs").style.height=(getStageHeight()-170)+"px";
				if(getElementsByClassName("navigatorTd")[0]){
					getElementsByClassName("navigatorTd")[0].style.height=(getStageHeight()-170)+"px";
				}
			}
		}
		
		document.getElementById("divContent").style.height=(getStageHeight()-(getElementsByClassName("pageTop")[0].offsetHeight+getElementsByClassName("pageBottom")[0].offsetHeight+8))+"px";
		if(MSIE){
			document.getElementById("divContent").style.marginTop="-18px";
			document.getElementById("divContent").style.marginBottom="-20px";
		}
		
		if(document.getElementById("browserBlock")){
			document.getElementById("browserBlock").style.height=(getStageHeight())+"px";
			document.getElementById("browserBlock").style.width=(width)+"px";
		}
	}
	
	function clickBlockerStart(){
		var inputs=document.getElementById("toolbar01").getElementsByTagName("INPUT");
		for(var i=0;i<inputs.length;i++){
			if(inputs[i].type=="image"){
				addListener(inputs[i],"mouseup",function(evt){
					blockBrowser();
				});
			}
		}
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
		div.style.zIndex=999999;
		document.body.appendChild(div);
		window.parent.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
	}
	
	window.parent.parent.hideResultFrame();
	
	//Fix para algunas instalaciones en donde la tabla se muestra vacia hasta hacer click en ella
	document.getElementById('table01').style.display = 'none';
	setTimeout(function() {
		document.getElementById('table01').style.display = '';
	}, 200);
	
</script><script language="javascript">
	var URL_ROOT_PATH		 	="<%=Parameters.ROOT_PATH%>";
	//var URL_ROOT_PATH		 	= window.parent.URL_ROOT_PATH;
	var schemaId				="<%=schemaId%>";
	var cubeId					="<%=cubeId%>";
	var viewId					="<%=viewId%>";
	var userId					="<%=dBean.getUserData(request).getUserId()%>";
	var envId					="<%=dBean.getUserData(request).getEnvironmentId().toString()%>";
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
  	var MSG_WRNG_VW_NAME        ="<%=LabelManager.getName(uData.getLabelSetId(),uData.getLangId(),"msgWrngVwName")%>";
  	var VIEW_NAME				="<%=viewName%>";
  	var VIEW_DESC				="<%=viewDesc%>";
  	
  	function setEditorSizer(){
  		var srcData=document.getElementById("srcData");
  		if(srcData){
  			srcData.style.top=((getStageHeight()-srcData.clientHeight)/2)+"px";
  			srcData.style.left=((getStageWidth()-srcData.clientWidth)/2)+"px";
  		}
  	
  	}
</script>

