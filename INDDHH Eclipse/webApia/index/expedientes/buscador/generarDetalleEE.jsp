<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="st.access.conf.Conf"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1);
	ArrayList<Busqueda> arr = new ArrayList<Busqueda>();
	BusquedaDao BDao = new BusquedaDao();
	String nroEE = request.getParameter("nroEE").toString();
	String path = BDao.getCaratula(nroEE);

	int environmentId = 1001;
	int currentLanguage = 1;
	String usuario = "";
	UserData uData = ThreadData.getUserData();	
	if (uData!=null) {
		usuario = uData.getUserId() + "";		
	}

	arr = BDao.busquedaOpcion1(nroEE, usuario, environmentId);								
	Busqueda t = arr.get(0);	
%>	
<%
	String tokenId = "";
	if (request.getParameter("tokenId")!=null){
		tokenId = request.getParameter("tokenId").toString();
	}
	String  tabId = "";
	if (request.getParameter("tabId")!=null){
		tabId = request.getParameter("tabId").toString();
	}
	String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;
%>
<html>

<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><!--meta http-equiv="X-UA-Compatible" content="IE=7"-->
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/spinner.css" rel="stylesheet" type="text/css">
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/messages.css" rel="stylesheet" type="text/css">
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/modal.css" rel="stylesheet" type="text/css">
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/tabs.css" rel="stylesheet" type="text/css">	
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modernizr.custom.js"></script>
	<!-- MOOTOOLS --><!--script type="text/javascript" src=getUrlApp() + "/js/mootools-1.2.5-core.js"></script><script type="text/javascript" src=getUrlApp() + "/js/mootools-1.2.5.1-more.js"></script-->	
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script><!-- MOBILE -->
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mobile/swipe.js"></script><!-- FORMCHECK PARA VALIDAR FORMS-->
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/formcheck/lang/es.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/formcheck/formcheck.js"></script><!-- CONTROLADOR DE MODALS -->
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modalController.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/scroller.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/tabs.js">
	</script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/numeric.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/tabs.js"></script>
	<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/css/documentum/tabs.css" type="text/css" media="screen">
	<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen">
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/datepicker/datepicker.js"></script>
	<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/css/documentum/datepicker/datepicker.css" type="text/css" media="screen">
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/tooltips/js/sexy-tooltips.v1.2.mootools.js">
	</script><link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme">
	<link rel="shortcut icon" href="<%=Parameters.ROOT_PATH%>/css/documentum/favicon.ico"><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/colorpicker/mooRainbow.js"></script>
	<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/js/colorpicker/mooRainbow.css" type="text/css" media="all">
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/campaigns.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/externalAccess/postmessage.js"></script>
	<script type="text/javascript">		
	
		var TAB_ID_REQUEST = "<%=TAB_ID_REQUEST%>";
		var CURRENT_ENVIRONMENT		= "<%=environmentId%>";
		var	sp;		
		var CONTEXT					= "<%=com.dogma.Parameters.ROOT_PATH%>";
		var STYLE					= "documentum";
		var WAIT_A_SECOND			= 'Espere un momento';
		var GNR_TIT_WARNING 		= 'Advertencia';
		var GNR_CHK_ONLY_ONE 		= 'Debe seleccionar solo un registro.';
		var GNR_CHK_AT_LEAST_ONE 	= 'Debe seleccionar un registro.';
		var GNR_MORE_RECORDS		= 'No hay registros para la consulta realizada';
		var GNR_TOT_RECORDS			= 'Total de registros';
		var GNR_TOT_RECORDS_REACHED	= 'Se ha llegado a la cantidad máxima de registros. Utilice un filtro para obtener otros registros.';
		
		var GNR_NAV_FIRST			= 'Ir al primero';
		var GNR_NAV_PREV			= 'Ir al anterior';
		var GNR_NAV_NEXT			= 'Ir al siguiente';
		var GNR_NAV_LAST			= 'Ir al último';
		var GNR_NAV_REFRESH			= 'Actualizar';
		 
		
		var GNR_NAV_ADM_CEATE		= 'Crear';
		var GNR_NAV_ADM_UPDATE		= 'Modificar';
		var GNR_NAV_ADM_CLONE		= 'Clonar';
		var GNR_NAV_ADM_DELETE		= 'Eliminar';
		var GNR_NAV_ADM_DEPENDENCIES= 'Dependencias';
		var GNR_NAV_ADM_CLOSE		= 'Cerrar';
		
		var BTN_CONFIRM				= 'Confirmar';
		var BTN_CANCEL				= 'Cancelar';
		
		var BTN_CLOSE				= 'Cerrar';
		
		var GRID_BTN_UP				= 'Subir';
		var GRID_BTN_DOWN			= 'Bajar';
		var GRID_BTN_ADD			= 'Agregar';
		var GRID_BTN_DELETE			= 'Eliminar';
		var GRID_MSG_SEL_ROW		= 'Debe seleccionar al menos una fila.';
		
		var GNR_INVALID_NAME 		= 'El nombre sólo puede contener letras, números y \'_\'.';
		
		var MSG_FEC_FIN_MAY_FEC_INI	= 'La fecha de finalización debe ser mayor que la fecha de inicio.';
		var MSG_FEC_INI_MEN_TODAY	= '\"Fecha desde\" no puede ser anterior a hoy.';
		var MSG_FEC_FIN_MEN_TODAY	= '\"Fecha hasta\" no puede ser anterior a hoy.';
		
		var GNR_ORDER_BY			= "Ordenar por:";
		var GNR_TITILE_MESSAGES		= "Messages";
		var GNR_TITILE_EXCEPTIONS	= "Exceptions";
		
		var CONFIRM_ELEMENT_DELETE	= 'Borrar el registro seleccionado';
		var CONFIRM_ELEMENT_INIT	= '¿Desea inicializar el/los registro/s?';
		var CONFIRM_FNC_DELETE		= '¿Desea eliminar la carpeta y todas sus subcarpetas?';
		
		var MSG_ELE_ONLY_READ		= 'Usted posee permisos de sólo lectura sobre el elemento seleccionado. ¿Desea acceder sin la posibilidad de guardar los cambios?';
		
		var COMPLETE_OK				= 'Operación completa.';
		
		var DOWNLOADING				= 'Descargando el archivo';
		
		var BTN_MARK_FRM_TO_SIGN	= 'Marcar para firmar';
		var BTN_VERIFY_FRM_SIGN		= 'Verificar firmas';
		
		var MSG_PERMISSIONS_ERROR 	= 'Al menos un usuario debe tener acceso de escritura.';
		var MSG_USE_PROY_PERMS 		= '¿Desea utilizar los permisos del proyecto y perder los permisos definidos?';
		var MSG_PERM_WILL_BE_LOST	= 'Se perderán los permisos de lectura y modificación definidos. ¿Desea continuar?';
		
		var MSG_DOC_LOCKED_BY_USR	= 'El documento ya se encuentra bloqueado por otro usuario.';
		var MSG_DOC_MUST_BE_LOCKED	= 'El documento debe estar bloqueado por el usuario actual para permitir modificaciones.';
		
		var MSG_LOADING				= 'Cargando...';
			
		var BTN_PRINT				= 'Imprimir';			
		
		//var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
		var MSIE	= window.navigator.userAgent.indexOf("MSIE") >= 0;
		var OPERA	= window.navigator.userAgent.indexOf("Opera") >= 0;
		var FIREFOX	= window.navigator.userAgent.indexOf("Firefox") >= 0;
		var CHROME	= window.navigator.userAgent.indexOf("Chrome") >= 0;
		var SAFARI	= window.navigator.userAgent.indexOf("Safari") >= 0 && !CHROME;
		
		var ADMIN_SPINNER = null;
		
		var GNR_NUMERIC				= 'El campo \"<TOK>\" debe ser numérico.';
		
		var LBL_CAN_UPDATE			= 'puede actualizar';
		
		
		
		var DATE_FORMAT = 'd/M/Y';
		var HOUR_SEPARATOR = ':';
		if	(HOUR_SEPARATOR == null || HOUR_SEPARATOR.length != 1){ HOUR_SEPARATOR = ":"; }
		
		var charThousSeparator	= '.';
		var charDecimalSeparator = ',';
		var addThousandSeparator = true;
		var amountDecimalSeparator = '2';
		var amountDecimalZeros = '0';
		
		/*
		var charThousSeparator	= '.';
		var charDecimalSeparator = ',';
		var addThousandSeparator = true;
		var amountDecimalSeparator = '2';
		var amountDecimalZeros = '0';
		var strDateFormat = "dd/MM/yyyy";
		
		
		//var objNumRegExp 			=  /^-?\d{1,3}(,\d{3})*\.\d{1,3}$|^-?\d{1,3}(,\d{3})*$|^-?\d{1,}\.\d{1,3}$|^-?\d{1,}$/;
		var objNumRegExp;
		if(addThousandSeparator) {
			objNumRegExp =  /^-?\d{1,3}(\.\d{3})*\,\d{1,2}$|^-?\d{1,3}(\.\d{3})*$/;
		} else {
			objNumRegExp =	/^-?\d{1,}\,\d{1,2}$|^-?\d{1,}$/;
		}
		*/
		
		var objNumRegExp = /^-?\d{1,3}(\.\d{3})*,\d{1,2}$|^-?\d{1,3}(\.\d{3})*$/;
		
		window.addEvent('load', function() {
			
			document.addEvent('keyup', Generic.showSearch);
			document.addEvent('keydown', Generic.preventBackNavigation);
			
			initTabs();
			
			//llama al init page de cada jsp... todos deben tener uno, aunque no se haga nada en el
			if(initPage)
				initPage();
			else if(console.log)
				console.log('initPage no definido en el frame actual');
			
			//Setear datepicker
			$$("input.datePicker").each(setAdmDatePicker);			
			
			//Setear datepicker
			$$("div.button").each(Generic.setButton);
			
			//Setear numeric
			$$('input.numeric').each(Numeric.setNumeric);
			
			//Setear botones de grillas
			$$("div.navButton").each(Generic.setAdmGridBtnWidth);
			
			$$('div.tabComponent').each(function(container) {
				container.setStyle("padding-top", container.getPrevious().getHeight());
			});
			
			window.addEvent("resize", function() {
				$$('div.tabComponent').each(function(container) {
					container.setStyle("padding-top", container.getPrevious().getHeight());
				});
			})
			
			var execBlocker = $('exec-blocker');
			if(execBlocker) {
				var fx = new Fx.Morph(execBlocker, {
					duration: 1000,
					transition: Fx.Transitions.Quart.easeOut
				});
				fx.start({
					opacity: 0
				}).chain(function() {
					execBlocker.destroy();
				});
			}
		});
	</script><style type="text/css">
		/***Requieren full path***/
		.no-cssgradients .exec_field button.genericBtn {
			background-image: none;
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='/Apia/css/documentum/img/button/back_button_normal.gif', sizingMethod='scale');
		}
		.no-cssgradients .exec_field button.genericBtn:hover {
			background-image: none;
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='/Apia/css/documentum/img/button/back_button_hover.gif', sizingMethod='scale');
		}
	</style>
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/modal.css" rel="stylesheet" type="text/css">
	
			<link href="<%=Parameters.ROOT_PATH%>/css/documentum/monitor.css" rel="stylesheet" type="text/css">
			
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/tasks/task.js"></script>
			
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/synchronize-fields.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/masked-input.js"></script>
			
			<!-- JS Objects -->
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/form.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/field.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/input.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/select.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/area.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/button.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/check.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/editor.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/grid.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/hidden.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/href.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/image.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/label.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/multiple.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/password.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/radio.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/title.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/fileinput.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/classes/fieldTypes/tree.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/contextmenu.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/print.js"></script>
			
			<!-- API JS -->
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/API/apiaFunctions.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/execution/scripts/API/apiaField.js"></script>
			
			<!-- documents -->
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/modals/documents.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/generic/documents.js"></script>
			
			<!-- modals  -->
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/modals/pools.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/modals/users.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/modals/calendarsView.js"></script>
			
		
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/navButtons.js"></script>
			
			<!-- social -->
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/social/taskReadPanel.js"></script>			
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/social/socialShareMdl.js"></script>
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/social/socialReadChannelMdl.js"></script>
			
			
				<script type="text/javascript" type="text/javascript" src="<%=Parameters.ROOT_PATH%>/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script>
			
			
			<script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.execution.TaskAction.run';	
			
				var commentsMarked 	= false;
				var currentTab 		= -1;
				
				var currentStep		= 1;
				var stepQty 		= 1;
				var CURRENT_TASK_NAME = "REALIZAR ACTUACION";
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = "Existen formularios firmables que no fueron firmados";
				
				var TSK_TITLE = "Realizar actuación";
				var TAB_ID	= "1439843425542";

				var IN_MONITOR = false;
				var IN_MONITOR_PROCESS = false;
				var IN_MONITOR_TASK	   = false;
				var EXTERNAL_ACCESS = "false";
				var IS_MINISITE		= "false";
				var onFinish 		= "null";
				
				var BTN_FILE_UPLOAD_LBL = "Subir archivo";
				var BTN_FILE_DOWNLOAD_LBL = "Descargar archivo";
				var BTN_FILE_INFO_LBL = "Información";
				var BTN_FILE_LOCK_LBL = "Bloquear/Desbloquear";
				var BTN_FILE_ERASE_LBL = "Eliminar";
				var BTN_FILE_SIGN_LBL = "Firmar archivo";
				var BTN_FILE_VERIFY_LBL = "Verificar firma";
				
				var TIT_SING_MODAL_LBL = "Formularios a firmar";
				var TIT_SING_DOCS_MODAL_LBL = "LBL_NOT_FOUND : titDocsToSign";
				
				
					var isMonitor = false;
				
				
				//Social
				APIA_SOCIAL_ACTIVE			= toBoolean('false');
				
				
				var idNumWrite = false;
				
				var currentContentTab = null;
				
				var MSG_NO_GUA = "Tarea no guardada. ¿Continuar?";
				
				IN_EXECUTION = true;
				docTypePerEntId = 1023;
				docTypePerProId = 1367;
				
				
				tinymce.init({
					language: 'es',
				    theme: "modern",
				    mode : "exact",
					height : "350",
					width : "600",
				    plugins: [
						"advlist autolink lists charmap print preview hr spellchecker",
						"searchreplace visualblocks code fullscreen",
						"insertdatetime table contextmenu paste textcolor"
				    ],
				    toolbar1: "bold italic underline | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | spellchecker ",
				    templates: [
				        {title: 'Test template 1', content: 'Test 1'},
				        {title: 'Test template 2', content: 'Test 2'}
				    ],
				    setup: function(ed) {
				    	ed.on('blur', function(e) {
							if(e.target.isDirty())
 								e.target.save();
							
							e.target.getElement().fireEvent('change');
			          	});	
				    },
				    spellchecker_rpc_url: getUrlApp() + "/spellchecker/jmyspell-spellchecker",
				    spellchecker_language: "es_UY",
				    spellchecker_languages: 'Inglés=en_US,Español=es_UY,Portugués=pt_PT'
				});
				
				function showAppletModal(){
					signedOK = "false";
					appletBlocker = $$('div.modalBlocker')[0]
					if(!appletBlocker)
						appletBlocker = createBlockerDiv();
					$("divDigitalSign").setStyles({
						display: 'block',
						zIndex: Number.from(appletBlocker.getStyle('z-index')) + 1
					}).position();
					$("ifrApplet").src =  getUrlApp() + "/digitalSignatureApplet/applet.jsp?tokenId=1439842758557";
				}
				
				function hideAppletModal() {
					appletBlocker.destroy();
					appletBlocker = null;
					$('divDigitalSign').setStyle('display', 'none');
				}
				
				<!-- Agendas  -->
				
				var TSK_DAY_MON = 'Lun.';
				var TSK_DAY_TUE = 'Mar.';
				var TSK_DAY_WED = 'Mi&#233;.';
				var TSK_DAY_THU = 'Jue.';
				var TSK_DAY_FRI = 'Vie.';
				var TSK_DAY_SAT = 'S&#225;b.';
				var TSK_DAY_SUN = 'Dom.';
				
				var TSK_MONT_JAN = 'Enero';
				var TSK_MONT_FEB = 'Febrero';
				var TSK_MONT_MAR = 'Marzo';
				var TSK_MONT_APR = 'Abril';
				var TSK_MONT_MAY = 'Mayo';
				var TSK_MONT_JUN = 'Junio';
				var TSK_MONT_JUL = 'Julio';
				var TSK_MONT_AUG = 'Agosto';
				var TSK_MONT_SEP = 'Setiembre';
				var TSK_MONT_OCT = 'Octubre';
				var TSK_MONT_NOV = 'Noviembre';
				var TSK_MONT_DEC = 'Diciembre';
				
				var LBL_TODAY = 'Hoy';
				var LBL_SCHED_FORM_TITLE = 'Agenda';
				
				var LBL_SCHED_OF = 'de';
				var LBL_SCHED_WEEK_NOT_CONFIGURED = 'No es posible agendar tareas en la semana seleccionada.';
				
			</script>
			<link href="<%=Parameters.ROOT_PATH%>/css/documentum/tskSchedulerExec.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/tskSchedulerExecution.js"></script>
			
		
	<script type="text/javascript">
		currentTab = 3;
	</script>
<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/scripts/tinymce/jscripts/tinymce_4.1.5/skins/lightgray/skin.min.css"></head>

</head>
<body>

<table border="0" width="100%" align="center" height="100%">
<tr>	
	<td width="2%">&nbsp;</td>
	<td width="40%" align="center" valign="top">
	
		<table border="0" width="100%" align="center" valign="top">
		<tr>	
			<td>	
				<div id="E_1042" class="formContainer fieldGroup">
					<div class="collapseForm"></div>
					<div class="title form-title">Carátula</div>
					<table id="tblE_1042" style="table-layout: fixed; width: 600px;"><tbody>
					<tr>
						<td id="E_1042_gr_0_0">
							<div id="E_1042_23" class="field exec_field"><label>Dependencia:</label><span class="input-as-text"><%=t.getDependencia()%></span></div>
						</td>
						<td id="E_1042_gr_0_1"></td>
						<td id="E_1042_gr_0_2">
							<div id="E_1042_24" class="field exec_field"><label>Área:</label><span class="input-as-text"><%=t.getArea()%></span></div>
						</td>
						<td id="E_1042_gr_0_3"></td>
					</tr>
					<tr>
						<td id="E_1042_gr_1_0">
							<div id="E_1042_11" class="field exec_field required AJAXfield"><label title="">Oficina origen:</label>
								<span class="input-as-text"><%=BDao.getGrupo(t.getOficinaActual())%></span>
							</div>
						</td>
						<td id="E_1042_gr_1_1">
						</td>
						<td id="E_1042_gr_1_2">
							<div id="E_1042_15" class="field exec_field"><label>Número de expediente:</label><span class="input-as-text"><%=request.getParameter("nroEE")%></span></div>
						</td>
						<td id="E_1042_gr_1_3"></td>
					</tr>
					<tr>
						<td id="E_1042_gr_2_0"><div id="E_1042_57" class="field exec_field"><label>Fecha valor:</label><span class="input-as-text"><%=t.getFechaValor()%></span></div>
					</td>
						<td id="E_1042_gr_2_1"></td>
						<td id="E_1042_gr_2_2">
							<div id="E_1042_120" class="field exec_field"></div>
						</td>
						<td id="E_1042_gr_2_3"></td>
					</tr>
					<tr>
						<td id="E_1042_gr_3_0">
							<div id="E_1042_66" class="field exec_field"><label title="">Forma documental:</label>
								<span class="input-as-text"><%=t.getFormaDoc()%></span>
							</div>
						</td>
						<td id="E_1042_gr_3_1"></td>
						<td id="E_1042_gr_3_2">
							<div id="E_1042_7" class="field exec_field required">
								<label>Fecha de creación:</label>
								<span class="input-as-text"><%=t.getFechaCreacion()%></span>
							</div>
						</td>
						<td id="E_1042_gr_3_3"></td>
					</tr>
					<tr>
						<td id="E_1042_gr_4_0">
							<div id="E_1042_4" class="field exec_field required">
								<label>Tipo de expediente:</label>
								<span class="input-as-text"><%=BDao.getTipoExpedientes(t.getTipoExpediente())%></span>
							</div>
						</td>
						<td id="E_1042_gr_4_1"></td>
						<td id="E_1042_gr_4_2"></td>
						<td id="E_1042_gr_4_3"></td>
					</tr>					
					<tr></tr>
					<tr></tr>
					<tr>
						<td id="E_1042_gr_8_0" rowspan="3" colspan="4">
						<div id="E_1042_9" class="field exec_field required AJAXfield">
							<label title="">Asunto:</label>
							<textarea id="E_1042_9" readonly class="readonly validate[&quot;required&quot;]" rows="5" style="width: 98%; resize:none;"><%=t.getAsunto()%></textarea>							
						</div>
						</td>
					</tr>
					<tr></tr>
					<tr></tr>
					<tr>
						<td id="E_1042_gr_11_0">
							<div id="E_1042_12" class="field exec_field required">
								<label title="">Acceso restringido:</label>
									<span class="input-as-text"><%=t.getConfidencialidad()%></span>																		
							</div>
						</td>
						<td id="E_1042_gr_11_1"></td>
						<td id="E_1042_gr_11_2">
							<div id="E_1042_5" class="field exec_field required">
								<label title="">Prioridad:</label>
									<span class="input-as-text"><%=BDao.getPrioridad(t.getPrioridad())%></span>																			
							</div>
						</td>
						<td id="E_1042_gr_11_3"></td>
					</tr>
					<tr>
						<td id="E_1042_gr_12_0">
							<div id="E_1042_27" class="field exec_field">
								<label title="">¿Tiene elemento físico?:</label>
									<span class="input-as-text"><%=t.getDocFisica()%></span>																								
							</div>
						</td>
						<td id="E_1042_gr_12_1"></td>
						<td id="E_1042_gr_12_2">
						<div id="E_1042_81" class="field exec_field">
							<label title="">Clasificación:</label>
							<select id="E_1042_81">
							<option value="1">Público</option>
							<option value="2">Reservado</option>
							<option value="3">Confidencial</option>
							<option value="4">Secreto</option>
							</select>
						</div>
						</td>
						<td id="E_1042_gr_12_3"></td>
					</tr>
					
					<tr>
						<td id="E_1042_gr_12_0" colspan="4">&nbsp;</td>																	
					</tr>
					
					<tr>
						<td id="E_1042_gr_12_0" colspan="3">
							<div>
								&nbsp;<img src="<%=Parameters.ROOT_PATH%>/expedientes/iconos/pdf.gif">&nbsp;&nbsp;
								<b>Expediente <%=request.getParameter("nroEE")%>.pdf</b>&nbsp;&nbsp;
								<a href="javascript:verFoliado('<%=new Base64().encode(request.getParameter("nroEE"))%>','TSKOtra')">Descargar</a>									
							</div>
						</td>											
						<td id="E_1042_gr_12_3"></td>
					</tr>
					
					<tr>
						<td id="E_1042_gr_12_0" colspan="4">&nbsp;</td>																	
					</tr>				
					
					<tr>
						<td id="E_1042_gr_12_0" colspan="4" align="center">
							<button type="button" class="genericBtn" onclick="window.history.back();"><span>Volver</span></button>
						</td>																	
					</tr>


										
					</table>
				</div>	
			</td>
		</tr>
		</table>
	
	</td>
	<td width="58%" align="center" valign="top">
	
		<iframe 
			frameborder="0" 
			class="tabContent" 
			name="IFrameArbol123" 
			src="<%=Parameters.ROOT_PATH%>/expedientes/arbolDelExpediente/arbolDelExpediente.jsp?ee=<%=request.getParameter("nroEE")%><%=TAB_ID_REQUEST%>" 						
			style="width: 100%; height: 100%;">
			</iframe>
			
	</td>
</tr>

<!--
<table border="0" width="50%">

<tr>	
	<td width="20%">nroEE</td>
	<td width="30%"></td>
	<td width="50%" rowspan="8"><a href='<%=path%>'><img src='<%=path%>' width="100%"></a></td>
</tr>
<tr>	
	<td>Asunto</td>	
	<td><%=t.getAsunto()%></td>
</tr>
<tr>	
	<td>Estado</td>
	<td><%=BDao.getEstados(t.getEstado())%></td>
</tr>

<tr>
	<td>Oficina creadora</td>
	<td><%=t.getOficinaCreadora()%></td>
</tr>

<tr>	
	<td>Fecha de creacion</td>
	<td><%=t.getFechaCreacion()%></td>
</tr>

<tr>		
	<td>Oficina Actual</td>
	<td><%=BDao.getGrupo(t.getOficinaActual())%></td>
</tr>

<tr>
	<td>Fecha ultimo pase</td>
	<td><%=t.getFechaPase()%></td>
</tr>

</table>
	-->
	
</body>
