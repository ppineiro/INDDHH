<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title></title><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"><!--meta http-equiv="X-UA-Compatible" content="IE=7"-->
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/spinner.css" rel="stylesheet" type="text/css">
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/messages.css" rel="stylesheet" type="text/css">
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/modal.css" rel="stylesheet" type="text/css">
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/tabs.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/modernizr.custom.js"></script><!-- MOOTOOLS -->
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/mootools-more-1.4.0.1-compat.js"></script><!-- MOBILE -->
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/mobile/swipe.js"></script><!-- FORMCHECK PARA VALIDAR FORMS-->
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/formcheck/lang/es.js"></script>
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/formcheck/formcheck.js"></script><!-- CONTROLADOR DE MODALS --><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/modalController.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/scroller.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/tabs.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/modal.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/generics.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/numeric.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/tabs.js"></script><link rel="stylesheet" href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/tabs.css" type="text/css" media="screen"><link rel="stylesheet" href="<%=Configuration.ROOT_PATH %>/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen"><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/datepicker/datepicker.js"></script><link rel="stylesheet" href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/datepicker/datepicker.css" type="text/css" media="screen"><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script><link rel="stylesheet" href="<%=Configuration.ROOT_PATH %>/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme"><link rel="shortcut icon" href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/favicon.ico"><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/colorpicker/mooRainbow.js"></script><link rel="stylesheet" href="<%=Configuration.ROOT_PATH %>/js/colorpicker/mooRainbow.css" type="text/css" media="all"><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/includes/campaigns.js"></script><script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/externalAccess/postmessage.js"></script><script type="text/javascript">
				
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
			
			
				$(window.document.html).addClass("req-after");
			
			
			var execBlocker = $('exec-blocker');
			if(execBlocker) {
				var fx = new Fx.Morph(execBlocker, {
					duration: 400
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
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/img/button/back_button_normal.gif', sizingMethod='scale');
		}
		.no-cssgradients .exec_field button.genericBtn:hover {
			background-image: none;
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/img/button/back_button_hover.gif', sizingMethod='scale');
		}
	</style>
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/modal.css" rel="stylesheet" type="text/css">
	
			<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/monitor.css" rel="stylesheet" type="text/css">
			
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/tasks/task.js" ></script>
			
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/synchronize-fields.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/masked-input.js"></script>
			
			<!-- JS Objects -->
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/form.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/field.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/input.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/select.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/area.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/button.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/check.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/editor.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/grid.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/hidden.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/href.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/image.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/label.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/multiple.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/password.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/radio.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/title.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/fileinput.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/classes/fieldTypes/tree.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/contextmenu.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/js/print.js"></script>
			
			<!-- API JS -->
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/API/apiaFunctions.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/execution/scripts/API/apiaField.js"></script>
			
			<!-- documents -->
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/modals/documents.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/generic/documents.js"></script>
			
			<!-- modals  -->
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/modals/pools.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/modals/users.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/modals/calendarsView.js"></script>
			
		
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/includes/navButtons.js"></script>
			
			<!-- social -->
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/social/taskReadPanel.js"></script>			
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/social/socialShareMdl.js"></script>
			<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/social/socialReadChannelMdl.js"></script>
			
			
				<script language="javascript" type="text/javascript" src="<%=Configuration.ROOT_PATH %>/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script>
			
			
			<script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.execution.TaskAction.run';	
			
				var commentsMarked 	= false;
				var currentTab 		= -1;
				
				var currentStep		= 1;
				var stepQty 		= 1;
				var CURRENT_TASK_NAME = "INICIO_TRAMITE";
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = "Existen formularios firmables que no fueron firmados";
				
				var TSK_TITLE = "Inicio_Tramite";
				var TAB_ID	= "1435868782471";

				var IN_MONITOR = false;
				var IN_MONITOR_PROCESS = false;
				var IN_MONITOR_TASK	   = false;
				var EXTERNAL_ACCESS = "true";
				var IS_MINISITE		= "false";
				var onFinish 		= "1";
				
				var BTN_FILE_UPLOAD_LBL = "Subir archivo";
				var BTN_FILE_DOWNLOAD_LBL = "Descargar archivo";
				var BTN_FILE_INFO_LBL = "Información";
				var BTN_FILE_LOCK_LBL = "Bloquear/Desbloquear";
				var BTN_FILE_ERASE_LBL = "Eliminar";
				var BTN_FILE_SIGN_LBL = "Firmar archivo";
				var BTN_FILE_VERIFY_LBL = "Verificar firma";
				var BTN_FILE_TRADUC_LBL = 'Traducciones';
				
				var TIT_SING_MODAL_LBL = "Formularios a firmar";
				var TIT_SING_MODAL_PREV_LBL = "Formularios para firmar de pasos anteriores";
				var TIT_SING_DOCS_MODAL_LBL = "Documentos para firmar";
				
				var ERR_EXEC_BUS_CLASS = "Error en la clase de negocio, comuníquese con el administrador.";
				var LBL_ERROR 		= "Error";
				var MSG_VAL_NOT_FOUND 	= "No se encontró el valor.";
				var ERR_EXEC_BINDING 	= "Ocurrió un error al realizar el binding de atributos.";
				
				var TIT_TRANSLTATION = "Traducción de contenidos";
				
				var MSG_DEL_FILE_TRANS = "Al eliminar un documento se perderán sus traducciones. ¿Desea continuar?";
				var TIT_DEL_FILE = "Eliminar documento";
				
				
					var isMonitor = false;
				
				
				//Social
				APIA_SOCIAL_ACTIVE			= toBoolean('false');
				
				
				var idNumWrite = false;
				
				var currentContentTab = null;
				
				var MSG_NO_GUA = "Tarea no guardada. ¿Continuar?";
				
				IN_EXECUTION = true;
				docTypePerEntId = 1006;
				docTypePerProId = 1006;
				
				
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
				    spellchecker_rpc_url: "<%=Configuration.ROOT_PATH %>/spellchecker/jmyspell-spellchecker",
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
					$("ifrApplet").src =  "<%=Configuration.ROOT_PATH %>/digitalSignatureApplet/applet.jsp?tokenId=1435868762493";
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
			<link href="<%=Configuration.ROOT_PATH %>/css/estilo_tramites_en_linea/tskSchedulerExec.css" rel="stylesheet" type="text/css" >
			<script language="javascript" type="text/javascript" src="<%=Configuration.ROOT_PATH %>/page/includes/tskSchedulerExecution.js"></script>
			
		
	
	<style type="text/css">
		.tabHolder, #panelPinShow, .theFooter {
			display: none !important;
		}
		
		#frmData {
			display: block;
		}
		div.body {
			height: auto;
		}
		
		div.dataContainer {
			position: relative;
		}
		
		.actions .title {
			display: none;
		}
		
		.actions .button {
			display: block !important;
			width: 95px;
			margin: auto !important;
		}
		div.fncPanel div.stepsGraph {
			float: none !important;
			margin: auto !important;
			display: table;
		}
		div.fncPanel div.stepsGraph > div {
/* 			float: none; */
		}
	</style>
	<script type="text/javascript">
		window.addEvent('load', function() {		
			var frmData = $('frmData');
			
			frmData.addClass('autoHideActions');
			frmData.getElement('div.dataContainer').addClass('max-size');
			window.fireEvent('resize');
		})
	</script>
</head>

<body>
<br>
<div align="center">

	<table width="300px" cellpadding="0" cellspacing="0" style="width: 300px">
		
		<tr style="font-weight: bold; height: 15px; color: #727272">
			<td style="border-width: 0px" colspan="2">
				<b>Moneda</b>
			</td>
			<td style="border-width: 0px; text-align: right;">
				<b>Promedio</b>
			</td>
		</tr>

		
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/us.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						US$ Bill
					</td>
					<td style="border-width: 0px; text-align: right;">
						27,189
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/us.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						US$ Fdo
					</td>
					<td style="border-width: 0px; text-align: right;">
						27,142
					</td>
				</tr>
			
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/euro.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Euro
					</td>
					<td style="border-width: 0px; text-align: right;">
						29,9987
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/arg.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Peso
					</td>
					<td style="border-width: 0px; text-align: right;">
						2,175
					</td>
				</tr>
			
				<tr style="background-color: #f3f3f4; height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/bra.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
						Real
					</td>
					<td style="border-width: 0px; text-align: right;">
						8,55
					</td>
				</tr>
			
				<tr style="height: 20px; color: #727272;">
					<td style="border-width: 0px; margin-right: 5px;">
						<img src='<%=Configuration.ROOT_PATH %>/portal/img/ui.png' />&nbsp;
					</td>
					<td style="border-width: 0px; font-weight: bold;">
					   &nbsp
					</td>
					<td style="border-width: 0px; text-align: right;">
						3,0988
					</td>
				</tr>
			
		<tr style="height: 20px; color: #727272;">
			<td style="border-width: 0px; margin-right: 5px; text-align: center" 
				colspan="3">
				<%					
				Date curDate = new Date();
				SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
				String DateToStr = format.format(curDate);
				%>
				<span id="ctl00_ctl24_g_aedc6d69_2228_47a8_a410_a7c7f4ed87ef_ctl00_lblInfo">Cierre del <%=DateToStr%></span>
			</td>
		</tr>
	</table>    
</div>

</body>
</html>