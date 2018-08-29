<%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="biz.statum.apia.web.action.execution.TaskAction"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceListBean"%><%@page import="biz.statum.apia.web.action.execution.EntInstanceListAction"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">

<head>
<script type="text/javascript" src="/Apia/portal/js/tel2.js"></script>
<link href="/Apia/portal/css/tel.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/execution.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/administration.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/common.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/portal.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/reset.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/typography.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/layout.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/login.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/mobile.css" rel="stylesheet" type="text/css">
<link href="/Apia/css/base/login-mobile.css" rel="stylesheet" type="text/css">

<%@include file="../../includes/headInclude.jsp" %><!-- documents --><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script><script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/captcha.js"></script><script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script><script type="text/javascript">
	
	var executionEntForms = new Array();
	var executionProForms = new Array();
	
	var currentClassE = "";
	var currentClassP = "";
	
	var editionMode = true;
	
	function initPage() {
		
		$('frmData').formChecker = new FormCheck(
			'frmData', {
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: -12,
					tipsOffsetX: -10
				}
			}
		);
		
		//disparar el cargado de los formularios
		$$('div.formContainer').each(function (frm) {
			
			//parse each form...
			var form = new Form(frm);
			
			 //Se agregan antes de ser procesados para que lo encuentre la API
			if(form.frmType == "E")
				executionEntForms.push(form);
			else
				executionProForms.push(form);
					
			form.parseXML(null);
		});
		
		checkErrors();
		
		<% if("E".equals(request.getParameter("frmParent"))) { %>
			try {
				frmOnloadE();
			} catch (e) {
				if(currentClassE != "") {
// 					showMessage("Error in business class '" + currentClassE + "', contact system administrator");
					showMessage(Generic.formatMsg(ERR_EXEC_BUS_CLASS, currentClassE));
				}
			}
		<% } else { %>
			try{
				frmOnloadP();
			} catch(e){
				if(currentClassP!=""){
// 					showMessage("Error in business class " + currentClassP + "', contact system administrator");
					showMessage(Generic.formatMsg(ERR_EXEC_BUS_CLASS, currentClassP));
				}
			}
		<% } %>
		
		$('frmData').addEvent('submit', function(e) {
			$(window.frameElement).set('scrollTo', window.scrollY);
			this.submit();
		});
		
		initDocumentMdlPage();
	}
	
	function getModalReturnValue() {
		if($('frmData').formChecker.isFormValid())
			return true;
		
		return;
	}
	
	function checkErrors() {
		
		var xmlDoc;
		var execErrors = $('execErrors');
		if (window.DOMParser) {
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(new String(execErrors.value),"text/xml");
		} else {
			// Internet Explorer
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML(new String(execErrors.value)); 
		}
		
		var xml;
		if(Browser.ie) {
			for(var iter_e = xmlDoc.childNodes.length - 1; iter_e >= 0; iter_e--) {
				if(xmlDoc.childNodes[iter_e].nodeType != 3) {
					xml = xmlDoc.childNodes[iter_e];
					break;
				}
			}
		} else {
			xml = xmlDoc.childNodes[0];
		}
		
		var hasErrors = false;
		
		if(xml && xml.childNodes) {
			for(var i = 0; i < xml.childNodes.length; i++) {
				if (xml.childNodes[i].tagName == "sysExceptions") {
					processXmlExceptions(xml.childNodes[i], true);
					hasErrors = true;
				}
				
				if (xml.childNodes[i].tagName == "sysMessages") {
					processXmlMessages(xml.childNodes[i], true);
					hasErrors = true;
				}
			}
		}
		
		execErrors.value  = "<?xml version='1.0' encoding='iso-8859-1'?><data onClose='' />";
		
		return hasErrors;
	}
	
	<% if("true".equals(request.getParameter("isTask"))) { %>
		var URL_REQUEST_AJAX = '/apia.execution.TaskAction.run';
	<% } else { %>
		var URL_REQUEST_AJAX = '/apia.execution.EntInstanceListAction.run';
	<% } %>
	
	var ADDITIONAL_INFO_IN_TABLE_DATA = false;
	var signedOK = "false";
	var currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "-1"%>;
	var currentStep = 1;
	var MSG_REQ_SIGNATURE_FORM = '<system:label show="text" label="lblReqSigForm" forScript="true" />';
	var EXTERNAL_ACCESS = "<%=(uData.isExternalMode() || uData.isFromMinisite())%>";
	
	var BTN_FILE_UPLOAD_LBL = '<system:label show="text" label="prpUpload" forHtml="true" forScript="true" />';
	var BTN_FILE_DOWNLOAD_LBL = '<system:label show="text" label="prpDownload" forHtml="true" forScript="true" />';
	var BTN_FILE_INFO_LBL = '<system:label show="text" label="lblInfo" forHtml="true" forScript="true" />';
	var BTN_FILE_LOCK_LBL = '<system:label show="text" label="prpLock" forHtml="true" forScript="true" />';
	var BTN_FILE_SIGN_LBL = '<system:label show="text" label="prpSign" forHtml="true" forScript="true" />';
	var BTN_FILE_VERIFY_LBL = '<system:label show="text" label="prpVerify" forHtml="true" forScript="true" />';
	var BTN_FILE_ERASE_LBL = '<system:label show="text" label="prpErase" forHtml="true" forScript="true" />';
	
	var TIT_SING_MODAL_LBL = '<system:label show="text" label="titFormsToSign" forHtml="true"/>';
	
	var ERR_EXEC_BUS_CLASS 	= "<system:label show='text' label='errExecBusClass' forHtml='true'/>";
	var LBL_ERROR 			= "<system:label show='text' label='lblError' forHtml='true'/>";
	var MSG_VAL_NOT_FOUND 	= "<system:label show='text' label='msgValNotFound' forHtml='true'/>";
	var ERR_EXEC_BINDING 	= "<system:label show='text' label='errExecBinding' forHtml='true'/>";
	
	<% if (!"true".equals(request.getAttribute("isMonitor"))) { %>
		var isMonitor = false;
		var IN_MONITOR = false;
	<% } else { %>
		var isMonitor = true;
		var IN_MONITOR = true;
	<% } %></script><%
	String strScriptLoad = "";
	
	biz.statum.apia.web.bean.BasicBean bBean = null;
	boolean isTaskMode = "true".equals(request.getParameter("isTask"));
	if(!isTaskMode) {
		bBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
	}else{
		bBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
	}

	biz.statum.apia.web.bean.execution.ExecutionBean exeBean = null;

	if(bBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
		exeBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)bBean).getEntInstanceBean();
	} else if (bBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
		exeBean = (biz.statum.apia.web.bean.execution.TaskBean)bBean;
	}

	biz.statum.apia.web.bean.execution.FormBean fBean = exeBean.getCurrentEditionBean();

	String divId = request.getParameter("frmParent") + "_" + fBean.getFormDefinition().getFrmId();
	String xml = fBean.getFullXMLforModal(request,response,Integer.parseInt(request.getParameter("index")));
	
	
	if(fBean.hasOnload && fBean.firstLoad)
		strScriptLoad +=  fBean.getOnLoadName() + ";\n";
	
	if(fBean.hasOnReload && !fBean.firstLoad)
		strScriptLoad +=  fBean.getOnReloadName() + ";\n";	
	
	fBean.firstLoad = false;
	
	String strScript = fBean.getScript();

	if(strScript == null)
		strScript="";
	
	StringBuffer strBuf = new StringBuffer(strScript);

	strBuf.append("\n<script language=\"javascript\" DEFER>\n");
	strBuf.append("\nvar saving = false;\n");
	if("E".equals(request.getParameter("frmParent"))) {
		strBuf.append("function frmOnloadE(){\n");
	} else {
		strBuf.append("function frmOnloadP(){\n");
	}
	strBuf.append(strScriptLoad);
	strBuf.append("}\n");
	strBuf.append("</script>\n");

	String strScriptEdit = strBuf.toString();
	if(strScriptEdit != null) {
		out.println(strScriptEdit);
	}
	%></head><body><div class="body" id="bodyDiv"><form id="frmData" action="" method="post"><div id="<%=divId%>" class="formContainer" data-xml="<%out.print(xml);%>"></div></form></div><div class="footer"></div><%@include file="../../modals/documents.jsp" %><%@include file="endInclude.jsp" %></body></html>