<%@page import="com.dogma.DogmaException"%>
<%@page import="com.apia.core.CoreFacade"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@page import="biz.statum.apia.web.action.execution.EntInstanceListAction"%>
<%@page import="biz.statum.apia.web.bean.execution.EntInstanceListBean"%>
<%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%>
<%@page import="biz.statum.apia.web.action.BasicAction"%>
<%@page import="com.dogma.vo.BusEntInstanceVo"%>
<%@page import="com.dogma.vo.BusEntityVo"%>
<%@page import="biz.statum.apia.web.bean.BeanUtils"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.st.util.translator.TranslationManager"%>
<%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%>
<%@page import="com.dogma.vo.BusEntStatusVo"%>
<%@page import="java.util.Collection"%>
<%@page import="biz.statum.apia.web.bean.execution.TaskBean"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.st.util.labels.LabelManager" %>
<%@page import="com.dogma.vo.LanguageVo"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<% 
request.setAttribute("isTask","false");

EntInstanceListBean listBean = EntInstanceListAction.getBean(request,response);

EntInstanceBean dBean = listBean.getEntInstanceBean();

BusEntInstanceVo beInstVo = dBean.getEntity();
BusEntityVo beVo = dBean.getEntityType();
//Collection beRelCol = dBean.getEntityRelations();

EntInstanceBean entityBean = dBean;
String template;
if("true".equals(request.getParameter("kb"))) {
	template = "/page/templates/entityKB.jsp";
} else {
	template = beVo.getBusEntExeTemplate();
	if (template == null || "".equals(template)) {
		template = "/page/templates/entityDefault.jsp";
	}	
}


com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

boolean commentsMarked = false;

Collection<LanguageVo> tskTradLang = null;
try {
	tskTradLang = CoreFacade.getInstance().getAllLanguages();
	
	request.setAttribute("tskTradLang", tskTradLang);
} catch(DogmaException e) {}



%>
	<region:render template='<%=template%>'>
	
		<region:put section='entityMain'><%@include file="../includes/entityMain.jsp" %></region:put>
		<region:put section='entityForms' content="/page/execution/includes/forms.jsp?frmParent=E"/>
		<region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/>
		<region:put section='entityCategories' content="/page/execution/includes/entityCategories.jsp"/>
		<region:put section='entityVisibilities' content="/page/execution/includes/entityVisibilities.jsp"/>
		<region:put section='entityComments'><%@include file="../includes/entityComments.jsp" %></region:put>
		<region:put section='entityAsociations'><%@include file="../includes/entityAsociations.jsp" %></region:put>
		<region:put section='title'>
		<%
			beVo.setLanguage(BasicBeanStatic.getUserDataStatic(request).getLangId());
			TranslationManager.setTranslationByNumber(beVo);
			%>
			<span id="titleSpan"><%=BeanUtils.fmtHTML(beVo.getBusEntTitle())%></span>
		</region:put>
		<region:put section='buttons'>
			<div id="divAdminActEdit" class="fncPanel buttons">
				<div class="title"><system:label show="text" label="titActions"/></div>
				<div class="content">
				<% if("true".equals(request.getParameter("fromEntQuery"))) { %>
					<div id="btnClose" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div>
				<%} else {%>
					<div id="btnConf" class="button suggestedAction submit validate['submit']" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div>
				<%} %>
				<% if(!uData.isExternalMode() && !"true".equals(request.getParameter("fromEntQuery"))) { %>
					<div id="btnBackToList" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div>
				<%} %>
				
				</div>
			</div>
		</region:put>
		
		<region:put section="helpDocuments">
			<div class="title"><system:label show="text" label="mnuOpc"/></div>
			<div class="content">
				<div id="btnViewDocs" class="button" title="<system:label show="tooltip" label="sbtEjeDoc" />"><system:label show="text" label="sbtEjeDoc" /></div>
				<div id="btnPrintFrm" class="button" title="<system:label show="tooltip" label="btnStaPri" />"><system:label show="text" label="btnStaPri" /></div>
			</div>
				
		</region:put>	
		
		<region:put section='scripts_include'>
			<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/monitor.css" rel="stylesheet" type="text/css">
		
			<script type="text/javascript" src="<system:util show="context" />/page/execution/entities/edit.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script>
			<!-- documents -->
			<script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script>
			
			<!--  categories -->
			<script type="text/javascript" src="<system:util show="context" />/page/generic/categories.js"></script>
			
			<!--  asociations -->
			<script type="text/javascript" src="<system:util show="context" />/page/generic/asociations.js"></script>
			
			<!--  visibilities -->
			<script type="text/javascript" src="<system:util show="context" />/page/generic/visibilities.js"></script>
				
			<!-- modals  -->
			<script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/modals/entityInstances.js"></script>
			
			<script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script>
	
			<script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script>
			
			<!-- JS Objects -->
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/js/print.js"></script>
			
			<!-- API JS -->
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script>
			
			
			<%if("".equals(com.dogma.Configuration.CUSTOM_TINYMCE_PATH)){ %>
				<script language="javascript" type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script>
			<%} else { %>
				<script language="javascript" type="text/javascript" src="<system:util show="context" /><%=com.dogma.Configuration.CUSTOM_TINYMCE_PATH%>"></script>
			<%} %>
			
			<script language="javascript" type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.execution.EntInstanceListAction.run';	
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				var signedOK = "false";
				var currentTab = <%=request.getParameter("currentTab")!=null?request.getParameter("currentTab"):"-1"%>;
				var currentStep = 1;
				var MSG_REQ_SIGNATURE_FORM = '<system:label show="text" label="lblReqSigForm" forScript="true" />';
				var EXTERNAL_ACCESS = "<%=(uData.isExternalMode() || uData.isFromMinisite())%>";
				var IN_MONITOR = false;
				var BTN_FILE_UPLOAD_LBL = '<system:label show="text" label="prpUpload" forHtml="true" forScript="true" />';
				var BTN_FILE_DOWNLOAD_LBL = '<system:label show="text" label="prpDownload" forHtml="true" forScript="true" />';
				var BTN_FILE_INFO_LBL = '<system:label show="text" label="lblInfo" forHtml="true" forScript="true" />';
				var BTN_FILE_LOCK_LBL = '<system:label show="text" label="prpLock" forHtml="true" forScript="true" />';
				var BTN_FILE_SIGN_LBL = '<system:label show="text" label="prpSign" forHtml="true" forScript="true" />';
				var BTN_FILE_VERIFY_LBL = '<system:label show="text" label="prpVerify" forHtml="true" forScript="true" />';
				var BTN_FILE_TRADUC_LBL = '<system:label show="text" label="lblTranslations" forHtml="true" forScript="true" />';
				var BTN_FILE_ERASE_LBL = '<system:label show="text" label="prpErase" forHtml="true" forScript="true" />';
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				var TIT_SING_DOCS_MODAL_LBL = "<system:label show='text' label='titDocsToSign' forHtml='true'/>";
				
				var ERR_EXEC_BUS_CLASS 	= "<system:label show='text' label='errExecBusClass' forHtml='true'/>";
				var LBL_ERROR 			= "<system:label show='text' label='lblError' forHtml='true'/>";
				var MSG_VAL_NOT_FOUND 	= "<system:label show='text' label='msgValNotFound' forHtml='true'/>";
				var ERR_EXEC_BINDING 	= "<system:label show='text' label='errExecBinding' forHtml='true'/>";
				
				var TIT_TRANSLTATION = "<system:label show='text' label='titTra' forHtml='true'/>";
				
				var MSG_DEL_FILE_TRANS = "<system:label show='text' label='msgDelFileTrans' forHtml='true'/>";
				var TIT_DEL_FILE = "<system:label show='text' label='titDelFile' forHtml='true'/>";
				
				var commentsMarked 	= <%=commentsMarked%>;
				
				<%if(!"true".equals(request.getAttribute("isMonitor")) && !"true".equals(request.getParameter("isMonitor"))){ %>
					var isMonitor = false;
				<%} else {%>
					var isMonitor = true;
					var forceDocOnlyInformation = true;
				<%}%>
				
				var IS_READONLY = <%="true".equals(request.getParameter("fromEntQuery")) || "true".equals(request.getParameter("kb"))%> || isMonitor;
				var kb = <%="true".equals(request.getParameter("kb"))%>;
				var currentContentTab = null;
				
				var docTypePerEntId = <%=dBean.getEntity().getBusEntId()%>;
				
				tinymce.init({
					<%
						if(LanguageVo.LANG_EN == uData.getLangId().intValue()) {
							//No colocamos el lenguaje, toma ingles por defecto
						} else if(LanguageVo.LANG_SP == uData.getLangId().intValue()) {
							out.write("language: 'es',");
						} else if(LanguageVo.LANG_PT == uData.getLangId().intValue()) {
							out.write("language: 'pt_BR', ");
						}
					%>
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
				    spellchecker_rpc_url: "<%=Parameters.ROOT_PATH%>/spellchecker/jmyspell-spellchecker",
				    spellchecker_language: "es_UY",
				    spellchecker_languages: '<system:label show="text" label="lblIdiIng" forHtml="true" forScript="true" />=en_US,<system:label show="text" label="lblIdiEsp" forHtml="true" forScript="true" />=es_UY,<system:label show="text" label="lblIdiPor" forHtml="true" forScript="true" />=pt_PT'
				});
				
				
				var appletBlocker;
				
				function showAppletModal() {
					signedOK = "false";
					appletBlocker = $$('div.modalBlocker')[0]
					if(!appletBlocker)
						appletBlocker = createBlockerDiv();
					$("divDigitalSign").setStyles({
						display: 'block',
						zIndex: Number.from(appletBlocker.getStyle('z-index')) + 1
					}).position();;
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
				}
				
				function hideAppletModal() {
					if(appletBlocker)
						appletBlocker.destroy();
					appletBlocker = null;
					$('divDigitalSign').setStyle('display', 'none');
				}
				
				if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
					window.addEvent('domready', function() {
						document.body.addClass('modal-content');
					});
				}
				
				
				<%
					if (beVo.getFlagValue(BusEntityVo.FLAG_USER_ENTITY)){
				%>		
						function processUsersModalReturnForLDAP(ret){
							var rowContent = ret[0].getRowContent();
							var login = rowContent[0];
							var name = rowContent[1];
							var email = rowContent[2];
							
							var retrieveField = function(frm_src, fld_name) {
								for(var i = 0; i < frm_src.fields.length; i++) {
									var current_name = frm_src.fields[i].options[IProperty.PROPERTY_NAME];
									if(current_name && current_name.toUpperCase() == fld_name.toUpperCase()) {
										return frm_src.fields[i];
									}
								}
							};
							
							var myForm;
							for(var i = 0; i < executionEntForms.length; i++) {
								if(executionEntForms[i].frmName == "USERCREATION")
									myForm = executionEntForms[i];
							}
							var fLogin = retrieveField(myForm, "login");
							fLogin.content.set(SynchronizeFields.SYNC_FAILED, 'true');
							fLogin.apijs_setFieldValue(login);
							var fName = retrieveField(myForm, "name");
							fName.content.set(SynchronizeFields.SYNC_FAILED, 'true');
							fName.apijs_setFieldValue(name);
							var fEmail = retrieveField(myForm, "email");
							fEmail.content.set(SynchronizeFields.SYNC_FAILED, 'true');
							fEmail.apijs_setFieldValue(email);
							var fPass = retrieveField(myForm, "password");
							fPass.content.set(SynchronizeFields.SYNC_FAILED, 'true');
							fPass.apijs_setFieldValue("password");
							var fRewpass = retrieveField(myForm, "rewpassword");
							fRewpass.content.set(SynchronizeFields.SYNC_FAILED, 'true');
							fRewpass.apijs_setFieldValue("password");
						}
				<%
					}
				%>
					
				<%if("true".equals(request.getParameter("fromEntQuery"))) {%>
					var fromEntQuery = true;
				<%}%>
				
			</script>
			
		</region:put>
	
		<region:put section="entImage">
			<%if(beVo.getImgPath()!=null){%>
			<img src="<system:util show="context" />/images/uploaded/<%=beVo.getImgPath()%>" style="height: 64px; width: 64px;">
			<%} else {%>
				<img src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/functionalities/Entidades.gif" style="height: 64px; width: 64px;">
			<%} %>
		</region:put>
		
		<region:put section="entDescription">
			<%=BeanUtils.fmtHTML(beVo.getBusEntDesc()) %>
		</region:put>
	</region:render>
	
	<div class="divDelApplet" id='divDigitalSign'>
		<iframe id="ifrApplet" frameborder="0" style="width: 430px;height: 210px">		
		</iframe>
	</div>
	
	

	
<%
String strScript = (String)request.getAttribute("FRM_SCRIPT");
if(strScript!=null){
	out.println(strScript);
}
%>