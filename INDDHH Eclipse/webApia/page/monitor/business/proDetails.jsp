<%@page import="biz.statum.apia.web.bean.BasicBean"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@page import="biz.statum.apia.web.action.monitor.BusinessAction"%><%@page import="biz.statum.sdk.util.BooleanUtils"%><%@page import="biz.statum.apia.web.action.execution.TaskAction"%><%@page import="com.dogma.vo.LanguageVo"%><%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="biz.statum.apia.web.bean.execution.ProInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.BusEntStatusVo"%><%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="com.dogma.vo.CalendarVo"%><%@page import="com.dogma.vo.ProInstCommentVo"%><%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.st.util.labels.LabelManager" %><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%

request.setAttribute("isTask","false"); 
request.setAttribute("isMonitor", "true");
request.setAttribute("readOnly", "true");

//MonitorBusinessBean monBusMonitorBean = (MonitorBusinessBean) session.getAttribute("dBean");
BusinessBean monBusMonitorBean = BusinessAction.getBean(request, response);
ProcessesBean dBean = monBusMonitorBean.getMonitorProcessesBean(); 
//TaskBean dBean = TaskAction.getBean(request,response); //(TaskBean) session.getAttribute(BasicAction.BEAN_EXEC_NAME);
// boolean isFirstTask = dBean instanceof InitTaskBean;

// int stepCount = dBean.getStepQty();
// int currentStepNumber = dBean.getCurrentStep();


BusEntInstanceVo beInstVo = dBean.getEntInstanceBean().getEntity();
BusEntityVo beVo = dBean.getEntInstanceBean().getEntityType();
//Collection beRelCol = dBean.getEntInstanceBean().getEntityRelations();

TaskVo taskVo = dBean.getTaskVo();
ProcessVo proVo =  dBean.getProInstanceBean().getProcess();
ProInstanceVo proInstVo = dBean.getProInstanceBean().getProcInstance();

EntInstanceBean entityBean = dBean.getEntInstanceBean();
ProInstanceBean processBean = dBean.getProInstanceBean();

String template = "/page/templates/taskDefault.jsp";
// if (proVo.getProExeTemplate() != null && !proVo.getProExeTemplate().equals("")) {
// 	template = proVo.getProExeTemplate();
// }


com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

//--si se accede desde el minisitio... colocar el template de minisitio

boolean commentsMarked = false;


BasicBean businessProcessBean = BasicAction.staticRetrieveBean(request, response, BasicAction.BEAN_ADMIN_NAME);

ExecutionBean aBean = null;

if(businessProcessBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)businessProcessBean).getEntInstanceBean();
	
} else if (businessProcessBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	aBean = (biz.statum.apia.web.bean.execution.TaskBean)businessProcessBean;
	
} else if (businessProcessBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)businessProcessBean;
} else if (businessProcessBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean){
	aBean = (biz.statum.apia.web.bean.monitor.BusinessBean)businessProcessBean;
}

aBean.processForm(request, response, EntInstanceBean.BEAN_TYPE_ENTITY, "");
aBean.processForm(request, response, ProInstanceBean.BEAN_TYPE_PROCESS, "");


out.clear();
%><region:render template='<%=template%>'><region:put section='title'><div class="titImage"><%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){ %><img title="<system:label show="text" label="lblEjeTitPriPro1"/>" src="<system:util show="context" />/css/base/img/priority1.gif" alt="<system:label show="text" label="lblEjeTitPriPro1"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){ %><img title="<system:label show="text" label="lblEjeTitPriPro3"/>" src="<system:util show="context" />/css/base/img/priority3.gif" alt="<system:label show="text" label="lblEjeTitPriPro3"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){%><img title="<system:label show="text" label="lblEjeTitPriPro4"/>" src="<system:util show="context" />/css/base/img/priority4.gif" alt="<system:label show="text" label="lblEjeTitPriPro4"/>"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/base/img/priority2.gif" alt="<system:label show="text" label="lblEjeTitPriPro2"/>"><%}else {%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/base/img/priority2.gif" alt="<system:label show="text" label="lblEjeTitPriPro2"/>"><%}%></div><%= "<span class='proTitle'>"+BeanUtils.fmtHTML(TranslationManager.getProcTitle(proVo.getProName(), proVo.getProTitle(), uData.getEnvironmentId(), uData.getLangId())) + "</span><span class='execTitleSeparator'>&gt;</span><span class='taskTitle'></span>"%></region:put><region:put section="tskDescription">
			&nbsp;			
		</region:put><region:put section="taskImage">
			&nbsp;			
		</region:put><region:put section="apiaSocial">
			&nbsp;			
		</region:put><region:put section='entityMain'><%@include file="/page/execution/includes/entityMain.jsp" %></region:put><region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/><region:put section='processMain'><%@include file="/page/execution//includes/processMain.jsp" %></region:put><region:put section='processDocuments' content="/page/execution/includes/documents.jsp?frmParent=P"/><region:put section='entityForms'><div class="tabContent"><%
				String strFormsHTML_E = (String)request.getAttribute("FRM_HTML_E");
				if(strFormsHTML_E!=null){
					out.println(strFormsHTML_E);
				}
			%></div></region:put><region:put section='processForms'><div class="tabContent"><%
				String strFormsHTML_P = (String)request.getAttribute("FRM_HTML_P");
				if(strFormsHTML_P!=null){
					out.println(strFormsHTML_P);
				}
			%></div></region:put><region:put section='taskComments'><%@include file="/page/execution/includes/taskComments.jsp" %></region:put><region:put section='taskMonitor'><%@include file="/page/execution/includes/taskMonitor.jsp" %></region:put><region:put section='scripts_include'><script type="text/javascript" src="<system:util show="context" />/page/execution/tasks/task.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script><script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script><script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script><!-- JS Objects --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/captcha.js"></script><script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script><script type="text/javascript" src="<system:util show="context" />/js/print.js"></script><!-- API JS --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script><!-- documents --><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><!-- modals  --><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/calendarsView.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><%@include file="/page/includes/tinymce.editor.jsp" %><!-- social --><script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.monitor.BusinessAction.run';	
			
				var commentsMarked 	= <%=commentsMarked%>;
				var currentTab 		= <%=request.getParameter("currentTab")!=null?request.getParameter("currentTab"):"-1"%>;
				
				var currentStep		= 1;
				var stepQty 		= 1;
				var CURRENT_TASK_NAME = "";
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = "<system:label show='text' label='lblReqSigForm'/>";
				
				var TSK_TITLE = "";
				var TAB_ID	= "<system:util show="tabId"  />";

				var IN_MONITOR = false;
				var IN_MONITOR_PROCESS = false;
				var IN_MONITOR_TASK	   = false;
				var EXTERNAL_ACCESS = "<%=(uData.isExternalMode() || uData.isFromMinisite())%>";
				var IS_MINISITE		= "<%=uData.isFromMinisite()%>";
				var onFinish 		= "<%=(uData.getOnFinish())%>";
				
				var BTN_FILE_UPLOAD_LBL = "<system:label show='text' label='prpUpload' forHtml='true'/>";
				var BTN_FILE_DOWNLOAD_LBL = "<system:label show='text' label='prpDownload' forHtml='true'/>";
				var BTN_FILE_INFO_LBL = "<system:label show='text' label='lblInfo' forHtml='true'/>";
				var BTN_FILE_LOCK_LBL = "<system:label show='text' label='prpLock' forHtml='true'/>";
				var BTN_FILE_ERASE_LBL = "<system:label show='text' label='prpErase' forHtml='true'/>";
				var BTN_FILE_SIGN_LBL = "<system:label show='text' label='prpSign' forHtml='true'/>";
				var BTN_FILE_VERIFY_LBL = "<system:label show='text' label='prpVerify' forHtml='true'/>";
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				
				var LBL_FROM = "<system:label show='text' label='lblFrom' forHtml='true'/>";
				
				<%if(!"true".equals(request.getAttribute("isMonitor"))){ %>
					var isMonitor = false;
				<%} else {%>
					var isMonitor = true;
				<%}%>
				
				var IS_READONLY = <%="true".equals(request.getParameter("fromEntQuery"))%> || isMonitor;
				
				//Social
				APIA_SOCIAL_ACTIVE			= false;
				
				<%if(ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())) {%>
				var idNumWrite = true;
				<%} else {%>
				var idNumWrite = false;<%}%>
				
				var currentContentTab = null;
										
				function showAppletModal(){
					signedOK = "false";
					$("divDigitalSign").style.display='block';
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
				}
				
				window.addEvent('load', function() {
					$('panelPinHidde').fireEvent('click');
				});
			</script><!-- Agendas  --><script type="text/javascript">
				var TSK_DAY_MON = '<system:label show="text" label="lblTskDayMon"/>';
				var TSK_DAY_TUE = '<system:label show="text" label="lblTskDayTue"/>';
				var TSK_DAY_WED = '<system:label show="text" label="lblTskDayWed"/>';
				var TSK_DAY_THU = '<system:label show="text" label="lblTskDayThu"/>';
				var TSK_DAY_FRI = '<system:label show="text" label="lblTskDayFri"/>';
				var TSK_DAY_SAT = '<system:label show="text" label="lblTskDaySat"/>';
				var TSK_DAY_SUN = '<system:label show="text" label="lblTskDaySun"/>';
				
				var TSK_MONT_JAN = '<system:label show="text" label="lblEnero"/>';
				var TSK_MONT_FEB = '<system:label show="text" label="lblFebrero"/>';
				var TSK_MONT_MAR = '<system:label show="text" label="lblMarzo"/>';
				var TSK_MONT_APR = '<system:label show="text" label="lblAbril"/>';
				var TSK_MONT_MAY = '<system:label show="text" label="lblMayo"/>';
				var TSK_MONT_JUN = '<system:label show="text" label="lblJunio"/>';
				var TSK_MONT_JUL = '<system:label show="text" label="lblJulio"/>';
				var TSK_MONT_AUG = '<system:label show="text" label="lblAgosto"/>';
				var TSK_MONT_SEP = '<system:label show="text" label="lblSetiembre"/>';
				var TSK_MONT_OCT = '<system:label show="text" label="lblOctubre"/>';
				var TSK_MONT_NOV = '<system:label show="text" label="lblNoviembre"/>';
				var TSK_MONT_DEC = '<system:label show="text" label="lblDiciembre"/>';
				
				var LBL_TODAY = '<system:label show="text" label="lblToday"/>';
				var LBL_SCHED_FORM_TITLE = '<system:label show="text" label="titTabSchTask"/>';
				
				var LBL_SCHED_OF = '<system:label show="text" label="lblTskSchedOf"/>';
				var LBL_SCHED_WEEK_NOT_CONFIGURED = '<system:label show="text" label="msgTskSchWeekNotConfig"/>';
				
			</script><link href="<system:util show="context" />/css/base/modules/schedulerExec.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/includes/tskSchedulerExecution.js"></script><%
			String strScript = (String)request.getAttribute("FRM_SCRIPT");
			if(strScript!=null){
				out.println(strScript);
			}
			%></region:put><region:put section='buttons'>
			&nbsp;
		</region:put><region:put section="helpDocuments"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="btnViewDocs" class="button" title="<system:label show="tooltip" label="sbtEjeDoc" />"><system:label show="text" label="sbtEjeDoc" /></div><div id="btnPrintFrm" class="button" title="<system:label show="tooltip" label="btnStaPri" />"><system:label show="text" label="btnStaPri" /></div></div></region:put><region:put section="signature"><div class="divDelApplet" id='divDigitalSign'><iframe id="ifrApplet" title="<system:label show="text" label="lblAppletTitle" />" <%= request.getHeader("user-agent").contains("MSIE 8.0") ? "frameBorder=0" : ""%> style="width: 430px;height: 210px;border: 0px;"></iframe></div></region:put></region:render>