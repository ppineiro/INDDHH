<%@page import="com.dogma.vo.TskLanguagesVo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="biz.statum.sdk.util.BooleanUtils"%>
<%@page import="biz.statum.apia.web.action.execution.TaskAction"%>
<%@page import="com.dogma.vo.LanguageVo"%>
<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@page import="biz.statum.apia.web.bean.execution.ProInstanceBean"%>
<%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%>
<%@page import="biz.statum.apia.web.bean.execution.TaskBean"%>
<%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%>
<%@page import="com.dogma.vo.ProInstanceVo"%>
<%@page import="com.dogma.vo.ProcessVo"%>
<%@page import="com.dogma.vo.TaskVo"%>
<%@page import="com.dogma.vo.BusEntityVo"%>
<%@page import="com.dogma.vo.BusEntStatusVo"%>
<%@page import="com.dogma.vo.BusEntInstanceVo"%>
<%@page import="com.dogma.vo.CalendarVo"%>
<%@page import="com.dogma.vo.ProInstCommentVo"%>
<%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%>
<%@page import="biz.statum.apia.web.action.BasicAction"%>
<%@page import="biz.statum.apia.web.bean.execution.TaskBean"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="biz.statum.apia.web.bean.BeanUtils"%>
<%@page import="com.st.util.translator.TranslationManager"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Collection"%>
<%@page import="com.st.util.labels.LabelManager" %>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%

request.setAttribute("isTask","true"); 

TaskBean dBean = TaskAction.getBean(request,response); //(TaskBean) session.getAttribute(BasicAction.BEAN_EXEC_NAME);
boolean isFirstTask = dBean instanceof InitTaskBean;

int stepCount = dBean.getStepQty();
int currentStepNumber = dBean.getCurrentStep();


BusEntInstanceVo beInstVo = dBean.getEntInstanceBean().getEntity();
BusEntityVo beVo = dBean.getEntInstanceBean().getEntityType();
//Collection beRelCol = dBean.getEntInstanceBean().getEntityRelations();

TaskVo taskVo = dBean.getTaskVo();
ProcessVo proVo =  dBean.getProInstanceBean().getProcess();
ProInstanceVo proInstVo = dBean.getProInstanceBean().getProcInstance();

EntInstanceBean entityBean = dBean.getEntInstanceBean();
ProInstanceBean processBean = dBean.getProInstanceBean();

String template = "/page/templates/taskDefault.jsp";
if (proVo.getProExeTemplate() != null && !proVo.getProExeTemplate().equals("")) {
	template = proVo.getProExeTemplate();
}
if (dBean.getTaskVo().getTskExeTemplate() != null && !dBean.getTaskVo().getTskExeTemplate().equals("")) {
	template = dBean.getTaskVo().getTskExeTemplate();
}

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

//--si se accede desde el minisitio... colocar el template de minisitio
if(uData.isFromMinisite()){
	template = "/page/templates/taskDefaultMinisite.jsp";
}

boolean commentsMarked = false;

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

out.clear();
%>
<region:render template='<%=template%>'>
		<region:put section='title'>
			<div class="titImage">
			<%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){ %>
				<img title="<system:label show="text" label="lblEjeTitPriPro1"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority1.gif" alt="">
			<%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){ %>
				<img title="<system:label show="text" label="lblEjeTitPriPro3"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority3.gif" alt="">
			<%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){%>
				<img title="<system:label show="text" label="lblEjeTitPriPro4"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority4.gif" alt="">
			<%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){%>
				<img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority2.gif" alt="">
			<%}else {%>
				<img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority2.gif" alt="">
			<%}%>
			</div>
			<%= "<div class='proTitle'>"+BeanUtils.fmtHTML(TranslationManager.getProcTitle(proVo.getProName(), proVo.getProTitle(), uData.getEnvironmentId(), uData.getLangId())) + " > " + "</div>"+  "<div class='taskTitle'>" + BeanUtils.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId())) + "</div>"%>
			
		</region:put>
		
		<region:put section="tskDescription">
			<%//=BeanUtils.fmtHTML(dBean.getTaskVo().getTskDesc())%>
			<%=BeanUtils.fmtHTML(TranslationManager.getTaskDescription(dBean.getTaskVo().getTskName(), dBean.getTaskVo().getTskDesc(), uData.getEnvironmentId(), uData.getLangId())) %>
		</region:put>
		
		<region:put section="taskImage">
			<%if(dBean.getTaskVo().getImgPath()!=null){%>
			<img src="<system:util show="context" />/images/uploaded/<%=dBean.getTaskVo().getImgPath()%>" style="height: 64px; width: 64px;">
			<%} else {%>
				<img src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/functionalities/Tareas.gif" style="height: 64px; width: 64px;">
			<%} %>
		</region:put>
	
		<region:put section="apiaSocial">
			<system:edit show="ifParameter" field="APIASOCIAL_ACTIVE" value="true">
				<%@include file="../../social/taskReadPanel.jsp" %>				
			</system:edit>
		</region:put>
	
		<region:put section='entityMain'><%@include file="../includes/entityMain.jsp" %></region:put>
		<region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/>
		<region:put section='processMain'><%@include file="../includes/processMain.jsp" %></region:put>
		<region:put section='processDocuments' content="/page/execution/includes/documents.jsp?frmParent=P"/>
		<region:put section='entityForms' content="/page/execution/includes/forms.jsp?frmParent=E"/>
		<region:put section='processForms' content="/page/execution/includes/forms.jsp?frmParent=P"/>
		<region:put section='taskComments'><%@include file="../includes/taskComments.jsp" %></region:put>
		<region:put section='taskMonitor'><%@include file="../includes/taskMonitor.jsp" %></region:put>
		
		<region:put section='scripts_include'>
			<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/monitor.css" rel="stylesheet" type="text/css">
			
			<script type="text/javascript" src="<system:util show="context" />/page/execution/tasks/task.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script>
			
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
			
			<!-- documents -->
			<script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script>
			
			<!-- modals  -->
			<script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/modals/calendarsView.js"></script>
			
		
			<script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script>
			
			<!-- social -->
			<script type="text/javascript" src="<system:util show="context" />/page/social/taskReadPanel.js"></script>			
			<script type="text/javascript" src="<system:util show="context" />/page/social/socialShareMdl.js"></script>
			<script type="text/javascript" src="<system:util show="context" />/page/social/socialReadChannelMdl.js"></script>
			
			<%if("".equals(com.dogma.Configuration.CUSTOM_TINYMCE_PATH)){ %>
				<script language="javascript" type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script>
			<%} else { %>
				<script language="javascript" type="text/javascript" src="<system:util show="context" /><%=com.dogma.Configuration.CUSTOM_TINYMCE_PATH%>"></script>
			<%} %>
			
			<script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.execution.TaskAction.run';	
			
				var commentsMarked 	= <%=commentsMarked%>;
				var currentTab 		= <%=request.getParameter("currentTab")!=null?request.getParameter("currentTab"):"-1"%>;
				
				var currentStep		= <%=dBean.getCurrentStep().intValue()%>;
				var stepQty 		= <%=dBean.getStepQty().intValue()%>;
				var CURRENT_TASK_NAME = "<%=taskVo.getTskName()%>";
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = "<system:label show='text' label='lblReqSigForm'/>";
				
				var TSK_TITLE = "<%= BeanUtils.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId())) %>";
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
				var BTN_FILE_TRADUC_LBL = "<system:label show='text' label='lblTranslations' forHtml='true'/>";
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				var TIT_SING_MODAL_PREV_LBL = "<system:label show='text' label='titPrevFormsToSign' forHtml='true'/>";
				var TIT_SING_DOCS_MODAL_LBL = "<system:label show='text' label='titDocsToSign' forHtml='true'/>";
				
				var ERR_EXEC_BUS_CLASS = "<system:label show='text' label='errExecBusClass' forHtml='true'/>";
				var LBL_ERROR 		= "<system:label show='text' label='lblError' forHtml='true'/>";
				var MSG_VAL_NOT_FOUND 	= "<system:label show='text' label='msgValNotFound' forHtml='true'/>";
				var ERR_EXEC_BINDING 	= "<system:label show='text' label='errExecBinding' forHtml='true'/>";
				
				var TIT_TRANSLTATION = "<system:label show='text' label='titTra' forHtml='true'/>";
				
				var MSG_DEL_FILE_TRANS = "<system:label show='text' label='msgDelFileTrans' forHtml='true'/>";
				var TIT_DEL_FILE = "<system:label show='text' label='titDelFile' forHtml='true'/>";
				
				var appletBlocker;
				
				<%if(!"true".equals(request.getAttribute("isMonitor"))){ %>
					var isMonitor = false;
				<%} else {%>
					var isMonitor = true;
				<%}%>
				
				//Social
				APIA_SOCIAL_ACTIVE			= toBoolean('<system:edit show="constant" from="com.dogma.Parameters" field="APIASOCIAL_ACTIVE"/>');
				
				<%if(ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())) {%>
				var idNumWrite = true;
				<%} else {%>
				var idNumWrite = false;<%}%>
				
				var currentContentTab = null;
				
				var MSG_NO_GUA = "<system:label show='text' label='msgNoGua' forHtml='true'/>";
				
				IN_EXECUTION = true;
				docTypePerEntId = <%=dBean.getEntInstanceBean().getEntity().getBusEntId()%>;
				docTypePerProId = <%=dBean.getProInstanceBean().getProcess().getProId()%>;
				
				
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
				
				function showAppletModal(){
					signedOK = "false";
					appletBlocker = $$('div.modalBlocker')[0]
					if(!appletBlocker)
						appletBlocker = createBlockerDiv();
					$("divDigitalSign").setStyles({
						display: 'block',
						zIndex: Number.from(appletBlocker.getStyle('z-index')) + 1
					}).position();
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
				}
				
				function hideAppletModal() {
					if(appletBlocker)
						appletBlocker.destroy();
					appletBlocker = null;
					$('divDigitalSign').setStyle('display', 'none');
				}
				
				<!-- Agendas  -->
				
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
				
			</script>
			<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/tskSchedulerExec.css" rel="stylesheet" type="text/css" >
			<script language="javascript" type="text/javascript" src="<system:util show="context" />/page/includes/tskSchedulerExecution.js"></script>
			
		</region:put>
		<region:put section='buttons'>
			

			<div id="divAdminActEdit" class="fncPanel buttons">
				<div class="title"><system:label show='text' label='titActions'/></div>
				<div class="content">
				
				
					<%if(currentStepNumber==stepCount){ %>
					<div id="btnConf"  <%if (dBean.getStepQty().intValue() == dBean.getCurrentStep().intValue()) {%>class="button submit suggestedAction" <%}else{%>class="button btnDisabled" btnDisabled="true" <%}%> title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div>
					<%} %>
					<%if(currentStepNumber < stepCount){ %>
					<div id="btnNext" <%if (dBean.getStepQty().intValue() > dBean.getCurrentStep().intValue()) {%>class="button suggestedAction" <%}else{%>class="button btnDisabled" btnDisabled="true" <%}%> title="<system:label show="tooltip" label="btnSig"/>"><system:label show="text" label="btnSig"/></div>					
					<%} %>
					<%if(currentStepNumber>1){ %>
					<div id="btnLast" <%if (dBean.getCurrentStep().intValue() > 1) {%>class="button" <%} else {%>class="button btnDisabled" btnDisabled="true" <%}%>title="<system:label show="tooltip" label="btnAnt"/>"><system:label show="text" label="btnAnt"/></div>
					<%} %>
					<%if (!isFirstTask) {%>
						<div id="btnSave" class="button" title="<system:label show="tooltip" label="btnGua"/>"><system:label show="tooltip" label="btnGua"/></div>
						<div class="button" id="btnFree"   title="<system:label show="tooltip" label="btnEjeLib"/>"><system:label show="text" label="btnEjeLib"/></div>
						<%if (taskVo.getFlagValue(TaskVo.POS_FLAG_DELEGATE) && proVo.getFlagValue(ProcessVo.FLAG_DELEGATE) && "true".equals(EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_USES_HIERARCHY))) {%>
						<div id="btnDelegate" class="button" title="<system:label show="tooltip" label="lblExeDelegar"/>"><system:label show="text" label="lblExeDelegar"/></div>
						<%}%>
					<%} %>
					
					<%if (BooleanUtils.isTrue(Parameters.APIASOCIAL_ACTIVE)) {%>
						<div id="btnSocialShare" class="button" title="<system:label show="tooltip" label="lblShareMsg" />"><system:label show="text" label="lblShareMsg" /></div>
					<%}%>			
					
					<%if(uData.isFromMinisite()){ %>
					<div id="btnBackToMinisite" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div>
					<%} %>
				</div>
			</div>
			
			<%if(stepCount>1){ %>
			<div id="divAdminActSteps" class="fncPanel buttons clear">
				<div class="title"><system:label show='text' label='titSteps'/></div>
				<div id="stepsGraph" class="stepsGraph"></div>
			</div>
			<%} %>
			
		</region:put>		
		
		<region:put section="helpDocuments">
			<div class="title"><system:label show="text" label="mnuOpc"/></div>
			<div class="content">
				<div id="btnViewDocs" class="button" title="<system:label show="tooltip" label="sbtEjeDoc" />"><system:label show="text" label="sbtEjeDoc" /></div>
				<div id="btnPrintFrm" class="button" title="<system:label show="tooltip" label="btnStaPri" />"><system:label show="text" label="btnStaPri" /></div>
			</div>
				
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