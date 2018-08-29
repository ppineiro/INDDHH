<%@page import="biz.statum.apia.web.bean.BasicBean"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.apia.web.action.monitor.BusinessAction"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="biz.statum.apia.web.action.execution.EntInstanceListAction"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceListBean"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%><%@page import="com.dogma.vo.BusEntStatusVo"%><%@page import="java.util.Collection"%><%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager" %><%@page import="com.dogma.vo.LanguageVo"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><% 
request.setAttribute("isTask","false");
request.setAttribute("isMonitor", "true");
request.setAttribute("readOnly", "true");

BusinessBean monBusMonitorBean = BusinessAction.getBean(request, response);
EntInstanceBean dBean = monBusMonitorBean.getEntInstanceBean(); 

BusEntInstanceVo beInstVo = dBean.getEntity();
BusEntityVo beVo = dBean.getEntityType();
//Collection beRelCol = dBean.getEntityRelations();

EntInstanceBean entityBean = dBean;
String template = "/page/templates/entityDefault.jsp";

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

boolean commentsMarked = false;

BasicBean businessEntBean = BasicAction.staticRetrieveBean(request, response, BasicAction.BEAN_ADMIN_NAME);

biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;

if(businessEntBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)businessEntBean).getEntInstanceBean();
	
} else if (businessEntBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	biz.statum.apia.web.bean.execution.TaskBean taskBean = (biz.statum.apia.web.bean.execution.TaskBean)businessEntBean;
	aBean = taskBean;
	
} else if (businessEntBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)businessEntBean;
} else if (businessEntBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean){
	aBean = (biz.statum.apia.web.bean.monitor.BusinessBean)businessEntBean;
}

aBean.processForm(request, response, EntInstanceBean.BEAN_TYPE_ENTITY, "");

%><region:render template='<%=template%>'><region:put section='entityMain'><%@include file="/page/execution/includes/entityMain.jsp" %></region:put><region:put section='entityForms'><div class="tabContent"><%
				String strFormsHTML_E = (String)request.getAttribute("FRM_HTML_E");
				if(strFormsHTML_E!=null){
					out.println(strFormsHTML_E);
				}
			%></div></region:put><region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/><region:put section='entityCategories' content="/page/execution/includes/entityCategories.jsp"/><region:put section='entityVisibilities' content="/page/execution/includes/entityVisibilities.jsp"/><region:put section='entityComments'><%@include file="/page/execution/includes/entityComments.jsp" %></region:put><region:put section='entityAsociations'><%@include file="/page/execution/includes/entityAsociations.jsp" %></region:put><region:put section='title'><%
			beVo.setLanguage(BasicBeanStatic.getUserDataStatic(request).getLangId());
			TranslationManager.setTranslationByNumber(beVo);
			%><span id="titleSpan"><%=BeanUtils.fmtHTML(beVo.getBusEntTitle())%></span></region:put><region:put section="helpDocuments"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="btnViewDocs" class="button" title="<system:label show="tooltip" label="sbtEjeDoc" />"><system:label show="text" label="sbtEjeDoc" /></div><div id="btnPrintFrm" class="button" title="<system:label show="tooltip" label="btnStaPri" />"><system:label show="text" label="btnStaPri" /></div></div></region:put><region:put section='scripts_include'><script type="text/javascript" src="<system:util show="context" />/page/execution/entities/edit.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script><!-- documents --><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><!--  categories --><script type="text/javascript" src="<system:util show="context" />/page/generic/categories.js"></script><!--  asociations --><script type="text/javascript" src="<system:util show="context" />/page/generic/asociations.js"></script><!--  visibilities --><script type="text/javascript" src="<system:util show="context" />/page/generic/visibilities.js"></script><!-- modals  --><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/entityInstances.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script><script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script><!-- JS Objects --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/captcha.js"></script><script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script><script type="text/javascript" src="<system:util show="context" />/js/print.js"></script><!-- API JS --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script><%@include file="/page/includes/tinymce.editor.jsp" %><script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.monitor.BusinessAction.run';
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
				var BTN_FILE_ERASE_LBL = '<system:label show="text" label="prpErase" forHtml="true" forScript="true" />';
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				
				var LBL_FROM = "<system:label show='text' label='lblFrom' forHtml='true'/>";
				
				var commentsMarked 	= <%=commentsMarked%>;
				
				<%if(!"true".equals(request.getAttribute("isMonitor"))){ %>
					var isMonitor = false;
				<%} else {%>
					var isMonitor = true;
				<%}%>
				
				var IS_READONLY = <%="true".equals(request.getParameter("fromEntQuery"))%> || isMonitor;
				
				var currentContentTab = null;
				
				var docTypePerEntId = <%=dBean.getEntity().getBusEntId()%>;
											
				function showAppletModal(){
					signedOK = "false";
					$("divDigitalSign").style.display='block';
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
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
					
				window.addEvent('load', function() {
					$('panelPinHidde').fireEvent('click');
				});
			</script><%
			String strScript = (String)request.getAttribute("FRM_SCRIPT");
			if(strScript!=null){
				out.println(strScript);
			}
			%></region:put><region:put section="entImage"><%if(beVo.getImgPath()!=null){%><img src="<system:util show="context" />/images/uploaded/<%=beVo.getImgPath()%>" style="height: 64px; width: 64px;"><%} else {%><img src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/functionalities/Entidades.gif" style="height: 64px; width: 64px;"><%} %></region:put><region:put section="entDescription"><%=BeanUtils.fmtHTML(beVo.getBusEntDesc()) %>&nbsp;
		</region:put><region:put section="signature"><div class="divDelApplet" id='divDigitalSign'><iframe id="ifrApplet" title="<system:label show="text" label="lblAppletTitle" />" <%= request.getHeader("user-agent").contains("MSIE 8.0") ? "frameBorder=0" : ""%> style="width: 430px;height: 210px;border: 0px;"></iframe></div></region:put></region:render>