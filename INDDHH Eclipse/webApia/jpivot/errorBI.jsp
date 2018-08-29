<%@include file="../page/includes/startInc.jsp" %><%@page import="com.dogma.bi.BIConstants"%><%@page import="com.dogma.bi.BIEngine"%><%@page import="java.util.Collection"%><jsp:useBean id="cBean" scope="session" class="com.dogma.bean.administration.CubeViewBean"></jsp:useBean><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.CubeViewVo"%><HTML><head><%@include file="../page/includes/headInclude.jsp" %><script language="javascript">	
	var MSG_BI_IMPL_NOT_FOUND = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_BI_IMPL_NOT_FOUND"/>';
	var MSG_BI_WRNG_IMPLEMENTATION = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_BI_WRNG_IMPLEMENTATION" />';
	var MSG_BI_URL_NOT_FOUND = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_BI_URL_NOT_FOUND" />';
	var MSG_BI_PWD_NOT_FOUND = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_BI_PWD_NOT_FOUND" />';
	var MSG_BI_USR_NOT_FOUND = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_BI_USR_NOT_FOUND" />'; //BIDB_USR
	var MSG_ERR_LOADING_SCHEMA = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_LOADING_SCHEMA" />'; //LOADING SCHEMA
	var MSG_ERR_LOADING_VIEW = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_LOADING_VIEW" />'; //LOADING VIEW
	var MSG_ERR_EMPTY_FACT_TABLES = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_EMPTY_FACT_TABLES" />'; //EMPTING FACT TABLES
	var MSG_NO_SPECIFIED_ERROR = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_NO_SPECIFIED_ERROR" />';
	var MSG_NO_EXIST_ENTITY_TABLE = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_NO_EXIST_ENTITY_TABLE" />';
	var MSG_EMPTY_ENTITY_TABLE = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_EMPTY_ENTITY_TABLE" />';
	var MSG_NO_EXIST_PROCESS_TABLE = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_NO_EXIST_PROCESS_TABLE" />';
	var MSG_EMPTY_PROCESS_TABLE = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_EMPTY_PROCESS_TABLE" />';
	var MSG_ERR_SCHEMA_OR_VIEW = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_SCHEMA_OR_VIEW" />';
	var MSG_URL_NOT_CORRESPOND_WITH_IMPLEMENTATION = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_URL_NOT_CORRESPOND_WITH_IMPLEMENTATION" />';
	var MSG_ERR_SCHEMA_NOT_EXIST = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_SCHEMA_NOT_EXIST" />';
	var MSG_ERR_CUBE_NOT_EXIST = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_CUBE_NOT_EXIST" />';
	var MSG_ERR_DASH_NOT_EXIST = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_DASH_NOT_EXIST" />';
	var MSG_ERR_VIEW_NOT_EXIST = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_VIEW_NOT_EXIST" />';
	var MSG_ERR_WRNG_CONF = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_WRNG_CONF" />';
	var MSG_ERR_CONNECTING_BIDB = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_CONNECTING_BI_DB" />';
	var MSG_ERR_ROLE_PERMISSION = '<system:label show="textFromConstant" label="com.dogma.bi.BIConstants.MSG_ERR_VIEW_NO_ACCESS" />';
	var TIT_BI_DEF_VIEW_ERROR = '<system:label show="text" label="titBIDefViewError" />'; 
	var MSG_BI_ALL_VIEW_ERROR = '<system:label show="text" label="msgBIAllViewError" />'; 
	var LBL_BI_VIEWS_WITH_ERROR = '<system:label show="text" label="lblBIViewsWithError" />';
	var MSG_BI_ERR_TRY_LOAD_VIEW = '<system:label show="text" label="msgBIErrTryLoadView" />'; 
	var MSG_BI_ERR_LOADING_VIEW = '<system:label show="text" label="msgBIErrLoadingView" />'; 
	var TIT_BI_ERR_LOADING_VIEW = '<system:label show="text" label="titBIErrLoadingView" />'; 
	var MSG_BI_BUS_ENT_NOT_EXIST = '<system:label show="text" label="msgBIBusEntNotExist" />'; 
	var MSG_BI_PRO_NOT_EXIST = '<system:label show="text" label="msgBIProNotExist" />'; 
	var MSG_BI_ERR_CON_BI_SERV_PORT = '<system:label show="text" label="msgBIErrConBIServPort" />'; 
	var MSG_BI_ERR_CON_BI_SERV_APP_NAME = '<system:label show="text" label="msgBIErrConBIServAppName" />'; 
	var MSG_BI_ERR_CON_BI_SERV = '<system:label show="text" label="msgBIErrConBIServ" />'; 
	var MSG_BI_ERR_SCH_CBE_ID_NOT_FOUND = '<system:label show="text" label="msgBIErrSchCbeIdNotFound" />';
	var MSG_BI_ERR_ENV_ID_NOT_FOUND = '<system:label show="text" label="msgBIErrEnvIdNotFound" />';
	var MSG_BI_ERR_TIME_OUT_LOADING_VIEW = '<system:label show="text" label="msgMaxWaitTimeExceeded" />';
	var MSG_BI_SEL_OTHER_VIEW = '<system:label show="text" label="msgBIErrSelOthView" />';
	var MSG_BI_ERR_CANT_LOAD_SEL_VIEW_TRY_AGAIN = '<system:label show="text" label="msgBIErrCntLoaSelVwTryAgain" />';
	
	var ERROR = "<%=request.getParameter("error")%>";
	var ERRORMSG = "<%=request.getParameter("errorMsg")%>";
	
	function showMessageAndCloseTab(text, title) {
		var panel = SYS_PANELS.newPanel([]);
		if(title) panel.header.innerHTML = title; //title
		panel.content.innerHTML = text; //msg
		SYS_PANELS.addClose(panel, false, function() {
			window.parent.getTabContainerController().removeActiveTab();
		});
		SYS_PANELS.adjustVisual();
	}
	
	function initPage(){ 
		if (ERROR == "1"){//BIDB_IMPLMENTATION
			showMessageAndCloseTab(MSG_BI_IMPL_NOT_FOUND);
		}else if (ERROR == "2"){//BIDB_IMPLMENTATION not oracle, postgres or sqlserver
			showMessageAndCloseTab(MSG_BI_WRNG_IMPLEMENTATION);
		}else if (ERROR == "3"){//BIDB_URL
			showMessageAndCloseTab(MSG_BI_URL_NOT_FOUND);
		}else if (ERROR == "4"){//BIDB_PWD
			showMessageAndCloseTab(MSG_BI_PWD_NOT_FOUND);
		}else if (ERROR == "5"){//BIDB_USR
			showMessageAndCloseTab(MSG_BI_USR_NOT_FOUND);
		}else if (ERROR == "6"){//SCHEMA_id or CUbe_id is null
			showMessageAndCloseTab(MSG_BI_ERR_SCH_CBE_ID_NOT_FOUND);
		}else if (ERROR == "7"){//FACT TABLES EMPTY
			showMessageAndCloseTab(MSG_ERR_EMPTY_FACT_TABLES);
		}else if (ERROR == "8"){//ENV ID IS NULL
			showMessageAndCloseTab(MSG_BI_ERR_ENV_ID_NOT_FOUND);
		}else if (ERROR == "9"){//ENTITY TABLE NOT EXIST
			showMessageAndCloseTab(MSG_NO_EXIST_ENTITY_TABLE);
		}else if (ERROR == "10"){//ENTITY TABLE IS EMPTY
			showMessageAndCloseTab(MSG_EMPTY_ENTITY_TABLE);
		}else if (ERROR == "11"){//PROCESS TABLE NOT EXIST
			showMessageAndCloseTab(MSG_NO_EXIST_PROCESS_TABLE);
		}else if (ERROR == "12"){//PROCESS TABLE IS EMPTY
			showMessageAndCloseTab(MSG_EMPTY_PROCESS_TABLE);
		}else if (ERROR == "13"){//ERROR LOADING SCHEMA (No modificar el numero de este error pq es usado en schema loader)
			showMessageAndCloseTab(MSG_ERR_LOADING_SCHEMA);
		}else if (ERROR == "14"){ //No modificar el numero de este error pq es usado en schema loader
			showMessageAndCloseTab(MSG_ERR_SCHEMA_OR_VIEW + ":[" + ERRORMSG +"]");
		}else if (ERROR == "15") { //URL NOT CORRESPOND WITH IMPLEMENTATION
			showMessageAndCloseTab(MSG_URL_NOT_CORRESPOND_WITH_IMPLEMENTATION);
		}else if (ERROR == "16") { //SCHEMA NOT EXIST
			showMessageAndCloseTab(MSG_ERR_SCHEMA_NOT_EXIST);
		}else if (ERROR == "17") { //CUBE NOT EXIST
			showMessageAndCloseTab(MSG_ERR_CUBE_NOT_EXIST);
		}else if (ERROR == "18") { //VIEW NOT EXIST
			showMessageAndCloseTab(MSG_ERR_VIEW_NOT_EXIST);
		}else if (ERROR == "19") { //VIEW NOT EXIST
			var msg = MSG_ERR_CONNECTING_BIDB + ": [" + <%=BIEngine.checkBIConnection()%> + "]";
			showMessageAndCloseTab(msg);
		}else if (ERROR == "20"){//ACTUAL ROLE DONT HAVE PERMISSIONS ON THIS VIEW
			showMessageAndCloseTab(MSG_ERR_ROLE_PERMISSION);
		}else if (ERROR == "21"){//ERROR LOADING VIEW
			<%if("navigator".equals(request.getParameter("mode"))) {%> //Si estamos en modo navegador => tiene que poder seleccionar otra o crear una nueva
				var panel = SYS_PANELS.newPanel([]);
				panel.header.innerHTML = TIT_BI_DEF_VIEW_ERROR;
				
				SYS_PANELS.addClose(panel, false, function() {
					window.parent.getTabContainerController().removeActiveTab();
				});
				
				var content;
				<%
				boolean showConfirm = true;
				Collection<CubeViewVo> allCbeVws = cBean.getAllCubeViews((request.getParameter("cubeId")!=null)?new Integer(request.getParameter("cubeId")):null);
				if (allCbeVws != null && allCbeVws.size() > 1) {%>
					content = MSG_ERR_LOADING_VIEW; //msg
					content += '<br/><br/><select id="selView">';
					<% for (CubeViewVo cbeVwVo : allCbeVws) {
						if (cbeVwVo.getInitialView() == null || cbeVwVo.getInitialView().intValue()!= 1){%> //Si no es la vista por defecto (pq ya sabemos que no anda)
							content += '<option value="<%=cbeVwVo.getVwId()%>"><%=cbeVwVo.getVwName().toString()%></option>';
						<%}
					}%>
					content += '</select>';
					panel.content.innerHTML = content;
				<%} else {//No hay otras vistas para ingresar al cubo => Se debe poder dar la oportunidad de generar una nueva
					showConfirm = false;%> 
					
					panel.content.innerHTML = MSG_BI_ALL_VIEW_ERROR;
						
					new Element('div.close', {
						html: '<system:label show="text" label="btnGenView" />',
						title: '<system:label show="tooltip" label="btnGenView" />'
					}).inject(panel.footer).addEvent('click', function() {
						genNewDefVw();
					})
				<%}%><%if(showConfirm) {%>
				new Element('div.close').setStyles({
						'font-weight': 'bold',
						'float': 'left',
						'margin-left': '5px'
					}).set('html', BTN_CONFIRM).inject(panel.footer).addEvent('click', function() {
						loadView($('selView').get('value'), window.parent.getTabContainerController().activeTab.getElement('span').get('html'));
					});
				<%}%>
				
				SYS_PANELS.adjustVisual();
				
			<%} else {%> //Estamos en modo visualizador => Le avisamos del error y listo
				showMessageAndCloseTab(MSG_BI_ERR_TRY_LOAD_VIEW, TIT_BI_ERR_LOADING_VIEW);
			<%}%>
		}else if (ERROR == "22"){//ENTITY ASOC TO CUBE NOT EXIST
			showMessageAndCloseTab(MSG_BI_BUS_ENT_NOT_EXIST);
		}else if (ERROR == "23"){//PROCESS ASOC TO CUBE NOT EXIST
			showMessageAndCloseTab(MSG_BI_PRO_NOT_EXIST);
		}else if (ERROR == "24"){//TIME OUT LOADING CUBE IN MODE NAVIGATOR
			<%if("navigator".equals(request.getParameter("mode"))) { //Si estamos en modo navegador => tiene que poder seleccionar otra o crear una nueva
				%>
				var panel = SYS_PANELS.newPanel([]);
				panel.header.innerHTML = TIT_BI_DEF_VIEW_ERROR;
				
				SYS_PANELS.addClose(panel, false, function() {
					window.parent.getTabContainerController().removeActiveTab();
				});
				
				var content;
				
				<%
				boolean showConfirm = true;
				Collection<CubeViewVo> allCbeVws = cBean.getAllCubeViews((request.getParameter("cubeId")!=null)?new Integer(request.getParameter("cubeId")):null);
				if (allCbeVws != null && allCbeVws.size() > 1) {%>
					content = MSG_BI_ERR_TIME_OUT_LOADING_VIEW + " " + MSG_BI_SEL_OTHER_VIEW; //msg
					content += '<br/><br/><select id="selView">';
					<% for (CubeViewVo cbeVwVo : allCbeVws) {
						if (cbeVwVo.getInitialView() == null || cbeVwVo.getInitialView().intValue()!= 1){%> //Si no es la vista por defecto (pq ya sabemos que no anda)
							content += '<option value="<%=cbeVwVo.getVwId()%>"><%=cbeVwVo.getVwName().toString()%></option>';
						<%}
					}%>
					content += '</select>';
					panel.content.innerHTML = content;
				<%} else {//No hay otras vistas para ingresar al cubo => Se debe poder dar la oportunidad de generar una nueva
					showConfirm = false;%> 
					panel.content.innerHTML = MSG_BI_ERR_TIME_OUT_LOADING_VIEW;
						
					new Element('div.close', {
						html: '<system:label show="text" label="btnGenView" />',
						title: '<system:label show="tooltip" label="btnGenView" />'
					}).inject(panel.footer).addEvent('click', function() {
						genNewDefVw();
					})
				<%}%><%if(showConfirm) {%>
					new Element('div.close').setStyles({
							'font-weight': 'bold',
							'float': 'left',
							'margin-left': '5px'
						}).set('html', BTN_CONFIRM).inject(panel.footer).addEvent('click', function() {
							loadView($('selView').get('value'), window.parent.getTabContainerController().activeTab.getElement('span').get('html'));
					});
				<%}%>
				SYS_PANELS.adjustVisual();
				
			<%} else {%> //Estamos en modo visualizador => Le avisamos del error y listo
				showMessageAndCloseTab(MSG_BI_ERR_TIME_OUT_LOADING_VIEW, TIT_BI_ERR_LOADING_VIEW);
			<%}%>
		}else if (ERROR == "30") { //ERROR CONNECTING TO SERVER (in general is wrong port)
			showMessageAndCloseTab(MSG_BI_ERR_CON_BI_SERV_PORT);	
		}else if (ERROR == "31") { //ERROR CONNECTING TO SERVER (in genreal is wrong application name)
			showMessageAndCloseTab(MSG_BI_ERR_CON_BI_SERV_APP_NAME);		
		}else if (ERROR == "32") { //ERROR CONNECTING TO SERVER
			showMessageAndCloseTab(MSG_BI_ERR_CON_BI_SERV + ERRORMSG);		
		}else if (ERROR == "50") { //DASHBOARD NOT EXIST
			showMessageAndCloseTab(MSG_ERR_DASH_NOT_EXIST);
		}else if (ERROR == "60") { //TRY AGAIN : En este momento no se pudo cargar la vista seleccionada, intentelo nuevamente.
			showMessageAndCloseTab(MSG_BI_ERR_CANT_LOAD_SEL_VIEW_TRY_AGAIN);
		}else{
			showMessageAndCloseTab(MSG_NO_SPECIFIED_ERROR + ":[" + ERRORMSG +"]");		
		}
	}
	
	function loadView(viewId, viewName) {
		
		var mode = '<%=request.getParameter("mode")%>';
		
		var url = CONTEXT + '/apia.administration.BIAction.run?action=' + (mode == 'navigator' ? 'openNavigator' : 'openViewer') + '&isAjax=true' + 
			'&forceOpen=true' + 
			'&schemaId=<%=request.getParameter("schemaId")%>' +
			'&cubeId=<%=request.getParameter("cubeId")%>' +
			'&entityCube=<%=request.getParameter("entityCube")%>' +
			'&processCube=<%=request.getParameter("processCube")%>' +
			'&viewId=' + viewId +
			'&envId=<%=request.getParameter("envId")%>' +
			'&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>' +
			'&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
			
		var tabContainer = window.parent.getTabContainerController();
		
		tabContainer.removeActiveTab();
		tabContainer.addNewTab(viewName, url, null, null);
	}
	
	function genNewDefVw() {
		var url = CONTEXT + '/apia.administration.BIAction.run?action=generateViewAndLoad&mode=<%=request.getParameter("mode")%>&schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&entityCube=<%=request.getParameter("entityCube")%>&processCube=<%=request.getParameter("processCube")%>&envId=<%=request.getParameter("envId")%>&envApiaGenCube=<%=request.getParameter("envApiaGenCube")%>&allEnvApiaGenCube=<%=request.getParameter("allEnvApiaGenCube")%>';
		var tabContainer = window.parent.getTabContainerController();
		var tabTitle = window.parent.getTabContainerController().activeTab.getElement('span').get('html');
		tabContainer.removeActiveTab();
		tabContainer.addNewTab(tabTitle, url, null, null);
	}
	
</script></head><body><div class="dataContainer cube"></div><%@include file="../page/includes/footer.jsp" %></body></html><%uData.setStatusProgress(100);%>