<%@page import="com.dogma.vo.TskLanguagesVo"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="biz.statum.apia.web.action.monitor.TasksAction"%><%@page import="com.dogma.vo.LanguageVo"%><%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="biz.statum.apia.web.bean.execution.ProInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.BusEntStatusVo"%><%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="com.dogma.vo.CalendarVo"%><%@page import="com.dogma.vo.ProInstCommentVo"%><%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.st.util.labels.LabelManager" %><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%

request.setAttribute("isMonitorTask","true"); 

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);

TasksBean dBean = TasksAction.staticRetrieveBean(http);
boolean isFirstTask = false;

EntInstanceBean entityBean = dBean.getEntInstanceBean();
ProInstanceBean processBean = dBean.getProInstanceBean();

BusEntInstanceVo beInstVo = entityBean.getEntity();
BusEntityVo beVo = entityBean.getEntityType();
//Collection beRelCol = entityBean.getEntityRelations();

TaskVo taskVo = dBean.getTaskVo();
ProcessVo proVo =  processBean.getProcess();
ProInstanceVo proInstVo = processBean.getProcInstance();

String template = "/page/templates/taskDefault.jsp";
if (proVo.getProExeTemplate() != null && !proVo.getProExeTemplate().equals("")) {
	template = proVo.getProExeTemplate();
}
if (dBean.getTaskVo().getTskExeTemplate() != null && !dBean.getTaskVo().getTskExeTemplate().equals("")) {
	template = dBean.getTaskVo().getTskExeTemplate();
}

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

boolean commentsMarked = false;
request.setAttribute("isMonitor","true");

//TaskVo taskVo = tBean.getTaskVo();
Collection<LanguageVo> tskTradLang = null;
if(taskVo != null && taskVo.getTskLanguages() != null) {
	tskTradLang = new ArrayList<LanguageVo>();
	for(TskLanguagesVo lang : taskVo.getTskLanguages()) {
		LanguageVo langVo = new LanguageVo();
		langVo.setLangId(lang.getLangId());
		langVo.setLangName(lang.getLangName());
		tskTradLang.add(langVo);
	}
}

request.setAttribute("tskTradLang", tskTradLang);

TasksBean taskMonitorBean = TasksAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));

taskMonitorBean.processForm(request, response, EntInstanceBean.BEAN_TYPE_ENTITY);
taskMonitorBean.processForm(request, response, ProInstanceBean.BEAN_TYPE_PROCESS);

out.clear();

%><system:edit show="saveAValue" saveOn="beanName" value="monitorTask" /><region:render template='<%=template%>'><region:put section='title'><div class="titImage"><%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){ %><img title="<system:label show="text" label="lblEjeTitPriPro1"/>" src="<system:util show="context" />/css/base/img/priority1.gif" alt="<system:label show="text" label="lblEjeTitPriPro1"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){ %><img title="<system:label show="text" label="lblEjeTitPriPro3"/>" src="<system:util show="context" />/css/base/img/priority3.gif" alt="<system:label show="text" label="lblEjeTitPriPro3"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){%><img title="<system:label show="text" label="lblEjeTitPriPro4"/>" src="<system:util show="context" />/css/base/img/priority4.gif" alt="<system:label show="text" label="lblEjeTitPriPro4"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/base/img/priority2.gif" alt="<system:label show="text" label="lblEjeTitPriPro2"/>"><%}else {%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/base/img/priority2.gif" alt="<system:label show="text" label="lblEjeTitPriPro2"/>"><%}%></div><system:label show="text" label="titEjeTar" /> : <span id="titleSpan"><%=BeanUtils.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId()))%></span></region:put><region:put section="tskDescription"><%=BeanUtils.fmtHTML(TranslationManager.getTaskDescription(dBean.getTaskVo().getTskName(), dBean.getTaskVo().getTskDesc(), uData.getEnvironmentId(), uData.getLangId())) %>&nbsp;
		</region:put><region:put section="taskImage"><%if(dBean.getTaskVo().getImgPath()!=null){%><img src="<system:util show="context" />/images/uploaded/<%=dBean.getTaskVo().getImgPath()%>" style="height: 64px; width: 64px;"><%} else {%><img src="<system:util show="context" />/css/base/img/functionalities/Tareas.gif" style="height: 64px; width: 64px;"><%} %></region:put><region:put section='entityMain'><%@include file="/page/execution/includes/entityMain.jsp" %></region:put><region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/><region:put section='processMain'><%@include file="/page/execution/includes/processMain.jsp" %></region:put><region:put section='processDocuments' content="/page/execution/includes/documents.jsp?frmParent=P"/><region:put section='entityForms'><div class="tabContent"><%
					String strFormsHTML_E = (String)request.getAttribute("FRM_HTML_E");
					if(strFormsHTML_E != null) {
						out.println(strFormsHTML_E);
					}
				%></div></region:put><region:put section='processForms'><div class="tabContent"><%
					String strFormsHTML_P = (String)request.getAttribute("FRM_HTML_P");
					if(strFormsHTML_P != null) {
						out.println(strFormsHTML_P);
					}
				%></div></region:put><region:put section='taskComments'><%@include file="/page/execution/includes/taskComments.jsp" %></region:put><region:put section='scripts_include'><script type="text/javascript" src="<system:util show="context" />/page/execution/tasks/task.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script><script type="text/javascript" src="<system:util show="context" />/page/monitor/tasks/details.js"></script><script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script><script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script><!-- JS Objects --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/captcha.js"></script><script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script><script type="text/javascript" src="<system:util show="context" />/js/print.js"></script><!-- API JS --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script><!-- documents --><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><!-- modals  --><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><%@include file="/page/includes/tinymce.editor.jsp" %><script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.monitor.TasksAction.run';
				
				var commentsMarked 	= <%=commentsMarked%>;
				var currentTab 		= <%=request.getParameter("currentTab")!=null?request.getParameter("currentTab"):"-1"%>;
				
				var CURRENT_TASK_NAME = "<%=taskVo.getTskName()%>";
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = '<system:label show="text" label="lblReqSigForm" forScript="true" />';
				
				var DISABLED = toBoolean('<system:edit show="value" from="theBean" field="modeDisabled" />');				
				
				var TSK_TITLE = "<%= BeanUtils.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId())) %>";
				var TAB_ID	= "<system:util show="tabId"  />";
				
				var LBL_FROM = "<system:label show='text' label='lblFrom' forHtml='true'/>";
				var APIA_SOCIAL_ACTIVE = false;
			<%if(!"true".equals(request.getAttribute("isMonitor"))){ %>
				var isMonitor = false;
			<%} else {%>
				var isMonitor = true;
			<%}%>
				
				var BTN_FILE_UPLOAD_LBL = '<system:label show="text" label="prpUpload" forHtml="true" forScript="true" />';
				var BTN_FILE_DOWNLOAD_LBL = '<system:label show="text" label="prpDownload" forHtml="true" forScript="true" />';
				var BTN_FILE_INFO_LBL = '<system:label show="text" label="lblInfo" forHtml="true" forScript="true" />';
				var BTN_FILE_LOCK_LBL = '<system:label show="text" label="prpLock" forHtml="true" forScript="true" />';
				var BTN_FILE_SIGN_LBL = '<system:label show="text" label="prpSign" forHtml="true" forScript="true" />';
				var BTN_FILE_VERIFY_LBL = '<system:label show="text" label="prpVerify" forHtml="true" forScript="true" />';
				var BTN_FILE_ERASE_LBL = '<system:label show="text" label="prpErase" forHtml="true" forScript="true" />';
				var LBL_EDIT = '<system:label show="text" label="lblEdit" forScript="true" forHtml="true"/>';
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				
				window.addEvent('load', function() { 
					initDetailsPage(); 
				} );
				
				<%if(ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())) {%>
				var idNumWrite = true;
				<%} else {%>
				var idNumWrite = false;<%}%>
				
				var currentContentTab = null;
				
				var fromAlterProcess = false;
				var fromCancelProcess = false;
				
				function showAppletModal(){
					signedOK = "false";
					$("divDigitalSign").style.display='block';
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
				}
			</script><%
				String strScript = (String)request.getAttribute("FRM_SCRIPT");
				if(strScript != null) {
					out.println(strScript);
				}
			%><% if (proVo.getCustomCSSPath() != null){ %><!-- custom process style  --><link href="<system:util show="context" />/<%=proVo.getCustomCSSPath()%>" rel="stylesheet" type="text/css" ><% } %><% if (taskVo.getCustomCSSPath() != null){ %><!-- custom task style  --><link href="<system:util show="context" />/<%=taskVo.getCustomCSSPath()%>" rel="stylesheet" type="text/css" ><% } %></region:put><region:put section='buttons'><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnPrint" class="button" title="<system:label show="tooltip" label="btnPrint"/>"><system:label show="text" label="btnPrint"/></div><system:edit show="ifValue" from="theBean" field="fromQuery" value="true"><div id="btnCloseTab" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div></system:edit><system:edit show="ifNotValue" from="theBean" field="fromQuery" value="true"><div id="btnBack" class="button" title="<system:label show="tooltip" label="btnVol"/>"><system:label show="text" label="btnVol"/></div></system:edit></div></div></region:put><region:put section="signature"><div class="divDelApplet" id='divDigitalSign'><iframe id="ifrApplet" frameborder="0" style="width: 430px;height: 210px"></iframe></div></region:put></region:render>
