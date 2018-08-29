<%@page import="biz.statum.apia.web.bean.BasicBean"%>
<%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%>
<%@page import="com.dogma.Configuration"%>
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
<%@page import="java.util.ArrayList"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<% 
request.setAttribute("isTask","false");

EntInstanceListBean listBean = EntInstanceListAction.getBean(request,response);

EntInstanceBean dBean = listBean.getEntInstanceBean();

BusEntInstanceVo beInstVo = dBean.getEntity();
BusEntityVo beVo = dBean.getEntityType();

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


BasicBean entBasicBean = BasicAction.staticRetrieveBean(request, response, BasicAction.BEAN_ADMIN_NAME);

ExecutionBean aBean = null;

if(entBasicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)entBasicBean).getEntInstanceBean();
	
} else if (entBasicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	aBean = (biz.statum.apia.web.bean.execution.TaskBean)entBasicBean;
	
} else if (entBasicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)entBasicBean;
} else if (entBasicBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean){
	aBean = (biz.statum.apia.web.bean.monitor.BusinessBean)entBasicBean;
}

aBean.processForm(request, response, EntInstanceBean.BEAN_TYPE_ENTITY, "");

%>
	<region:render template='<%=template%>'>
	
		<region:put section='entityMain'><%@include file="../includes/entityMain.jsp" %></region:put>
		<region:put section='entityForms'>
			<div class="tabContent">
			<%
				String strFormsHTML_E = (String)request.getAttribute("FRM_HTML_E");
				if(strFormsHTML_E!=null){
					out.println(strFormsHTML_E);
				}
			%>
			</div>
		</region:put>
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
				<% if("true".equals(request.getParameter("viewMode"))) { %>
					<div id="btnCloseMdl" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div>
				<%} else if("true".equals(request.getParameter("fromEntQuery"))) { %> 
					<div id="btnClose" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div>
				<%} else {%>
					<div id="btnConf" class="button suggestedAction submit validate['submit']" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div>
				<%} %>
				
				<%if("true".equals(request.getParameter("fromWorkEntity"))) { %> 
					<div id="btnClose" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div>
				<%} %>
				
				
				
				<% if(!uData.isExternalMode() && !"true".equals(request.getParameter("fromEntQuery")) &&  !"true".equals(request.getParameter("fromWorkEntity")) && !"true".equals(request.getParameter("viewMode"))) { %>
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
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/captcha.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/js/print.js"></script>
			
			<!-- WEBDAV JS Client -->
			<script type="text/javascript" src="<system:util show="context" />/js/ITHitWebDav/ITHitWebDAVClient.js"></script>
			
			<!-- API JS -->
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script>

			<%@include file="/page/includes/tinymce.editor.jsp" %>
			
			<script type="text/javascript">
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
				var MSG_CONFIG_DELETE_DOCUMENT_FILE_INPUT        = '<system:label show="text" label="msgConfDelDoc" forScript="true" />';
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				var TIT_SING_DOCS_MODAL_LBL = "<system:label show='text' label='titDocsToSign' forHtml='true'/>";
				
				var ERR_EXEC_BUS_CLASS 	= "<system:label show='text' label='errExecBusClass' forHtml='true'/>";
				var LBL_ERROR 			= "<system:label show='text' label='lblError' forHtml='true'/>";
				var MSG_VAL_NOT_FOUND 	= "<system:label show='text' label='msgValNotFound' forHtml='true'/>";
				var ERR_EXEC_BINDING 	= "<system:label show='text' label='errExecBinding' forHtml='true'/>";
				
				var TIT_TRANSLTATION = "<system:label show='text' label='titTra' forHtml='true'/>";
				
				var MSG_DEL_FILE_TRANS = "<system:label show='text' label='msgDelFileTrans' forHtml='true'/>";
				var TIT_DEL_FILE = "<system:label show='text' label='titDelFile' forHtml='true'/>";
				
				var LBL_OTHER_DOCS	= "<system:label show='text' label='sbtOtherDocs' forHtml='true'/>";
				
				var LBL_FROM = "<system:label show='text' label='lblFrom' forHtml='true'/>";
				var LBL_EDIT = '<system:label show="text" label="lblEdit" forScript="true" forHtml="true"/>';
				
				var commentsMarked 	= <%=commentsMarked%>;
				
				var ENT_TITLE = "<%=BeanUtils.fmtHTML(beVo.getBusEntTitle())%>";
				
				var fromWorkEntity = '<%=request.getParameter("fromWorkEntity")%>';
				
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
								
				var appletBlocker;
				
				function showAppletModal() {
					signedOK = "false";
					appletBlocker = $$('div.modalBlocker')[0]
					if(!appletBlocker)
						appletBlocker = createBlockerDiv();
					var divDigitalSign = $("divDigitalSign").setStyles({
						display: 'block',
						zIndex: Number.from(appletBlocker.getStyle('z-index')) + 1
					});
					
					<% 
						boolean hasCustomBrowser = false;
						if(!"".equals(Configuration.SIGNATURE_PAGE_CHROME)) { 
							hasCustomBrowser = true;
					%>
							if(Browser.Platform.name.contains("win") && Browser.chrome && Browser.version >= 42) {
								divDigitalSign.position();
								var ifrApplet = $("ifrApplet");
								ifrApplet.setStyle("height", 150);
								ifrApplet.setStyle("width", 500);
								divDigitalSign.position();
								divDigitalSign.addClass("chromeApplet");
								$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_CHROME%>?<system:util show="tabIdRequest" />";
								divDigitalSign.focus();
							} else 
					<% 	}
						if(!"".equals(Configuration.SIGNATURE_PAGE_FIREFOX)) { 
							hasCustomBrowser = true;
					%>
							if(Browser.firefox && Browser.version >= 50) {
								divDigitalSign.position();
								var ifrApplet = $("ifrApplet");
								ifrApplet.setStyle("height", 150);
								ifrApplet.setStyle("width", 500);
								divDigitalSign.position();
								divDigitalSign.addClass("firefoxApplet");
								$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_FIREFOX%>?<system:util show="tabIdRequest" />";
								divDigitalSign.focus();
							} else 
					<% 	}
						if(!"".equals(Configuration.SIGNATURE_PAGE_IE)) { 
							hasCustomBrowser = true;
					%>
							if(Browser.ie) {
								divDigitalSign.position();
								$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_IE%>?<system:util show="tabIdRequest" />";
							} else 
					<% 	}
						if(!"".equals(Configuration.SIGNATURE_PAGE_OPERA)) { 
							hasCustomBrowser = true;
					%>
							if(Browser.opera) {
								divDigitalSign.position();
								$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_OPERA%>?<system:util show="tabIdRequest" />";
							} else 
					<% 	}
						if(!"".equals(Configuration.SIGNATURE_PAGE_SAFARI)) { 
							hasCustomBrowser = true;
					%>
							if(Browser.safari) {
								divDigitalSign.position();
								$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_SAFARI%>?<system:util show="tabIdRequest" />";
							} else 
					<% 	}
						
						if(hasCustomBrowser) { %>
						{
					<% } %>
						divDigitalSign.position();
						$("ifrApplet").src =  "<system:util show="context" />/<%=Configuration.SIGNATURE_PAGE_DEFAULT%>?<system:util show="tabIdRequest" />";
					<% if(hasCustomBrowser) { %>
						}
					<% } %>
				}
				
				function hideAppletModal() {
					if(!appletBlocker) {
						appletBlocker = $$('div.modalBlocker')[0];
					}
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
				
				var WEBDAV_PROTOCOL_INSTALLER = ITHit.WebDAV.Client.DocManager.GetInstallFileName();
				<%
				out.write("var MSG_NO_DOC_EDIT_PROTOCOL	= '");	
				Collection<String> toks = new ArrayList<String>();
				toks.add("<a href=\"plugins/webdav/'+WEBDAV_PROTOCOL_INSTALLER+'\" download>");
				toks.add("</a>");
				out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgNoDocEdiProto"), toks) + "';");
				%>
				
			</script>
			
			<%
				String strScript = (String)request.getAttribute("FRM_SCRIPT");
				if(strScript!=null){
					out.println(strScript);
				}
			%>
		</region:put>
	
		<region:put section="entImage">
			 
			
			<%if(beVo.getImgPath()!=null){%>
			<div class="fncDescriptionImgUsers" style="background-image: url('images/uploaded/<%=beVo.getImgPath()%>');"></div>
			<%} else {%>
			<div class="fncDescriptionImgUsers" style="background-image: url('css/base/img/functionalities/Tareas.gif');"></div>
			<%} %>
			
		</region:put>
		
		<region:put section="entDescription">
			<%=BeanUtils.fmtHTML(beVo.getBusEntDesc()) %>
		</region:put>
		
		<region:put section="signature">
			<div class="divDelApplet" id='divDigitalSign'>
				<iframe title="<system:label show="text" label="lblAppletTitl" />" id="ifrApplet" <%= request.getHeader("user-agent").contains("MSIE 8.0") ? "frameBorder=0" : ""%> style="width: 430px;height: 210px">
				</iframe>
			</div>
		</region:put>
	</region:render>