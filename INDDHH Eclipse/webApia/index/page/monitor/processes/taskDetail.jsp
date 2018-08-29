<%@page import="com.dogma.vo.TskLanguagesVo"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="com.dogma.vo.LanguageVo"%><%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="biz.statum.apia.web.bean.execution.ProInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceBean"%><%@page import="biz.statum.apia.web.bean.execution.TaskBean"%><%@page import="biz.statum.apia.web.bean.execution.ExecutionBean"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.BusEntStatusVo"%><%@page import="com.dogma.vo.BusEntInstanceVo"%><%@page import="com.dogma.vo.CalendarVo"%><%@page import="com.dogma.vo.ProInstCommentVo"%><%@page import="biz.statum.apia.web.bean.execution.InitTaskBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.Iterator"%><%@page import="java.util.Collection"%><%@page import="com.st.util.labels.LabelManager" %><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%

request.setAttribute("isTask","false"); 
request.setAttribute("readOnly","true");

boolean fromProcess = "true".equals(request.getParameter("proDetails"));

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);

ProcessesBean dBean = ProcessesAction.staticRetrieveBean(http);
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

com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);

boolean commentsMarked = false;
request.setAttribute("isMonitor","true");

// TaskVo taskVo = tBean.getTaskVo();
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
%><region:render template='<%=template%>'><region:put section='title'><%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){ %><img title="<system:label show="text" label="lblEjeTitPriPro1"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority1.gif" alt=""><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){ %><img title="<system:label show="text" label="lblEjeTitPriPro3"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority3.gif" alt=""><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){%><img title="<system:label show="text" label="lblEjeTitPriPro4"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority4.gif" alt=""><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority2.gif" alt=""><%}else {%><img title="<system:label show="text" label="lblEjeTitPriPro2"/>" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/priority2.gif" alt=""><%}%><span id="titleSpan"><%= fromProcess ? dBean.getProNameDetails() : BeanUtils.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId())) %></span></region:put><region:put section="tskDescription"><%=fromProcess ? dBean.getProInstanceBean().getProcess().getProDesc() : BeanUtils.fmtHTML(TranslationManager.getTaskDescription(dBean.getTaskVo().getTskName(), dBean.getTaskVo().getTskDesc(), uData.getEnvironmentId(), uData.getLangId())) %>
		&nbsp;</region:put><region:put section="taskImage"><%if(fromProcess) {%><%if(dBean.getProInstanceBean().getProcess().getImgPath() != null){%><img src="<system:util show="context" />/images/uploaded/<%=dBean.getProInstanceBean().getProcess().getImgPath()%>" style="height: 64px; width: 64px;"><%} else {%><img src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/functionalities/Procesos.gif" style="height: 64px; width: 64px;"><%} %><%} else { %><%if(dBean.getTaskVo().getImgPath()!=null){%><img src="<system:util show="context" />/images/uploaded/<%=dBean.getTaskVo().getImgPath()%>" style="height: 64px; width: 64px;"><%} else {%><img src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/functionalities/Tareas.gif" style="height: 64px; width: 64px;"><%} %><%} %></region:put><region:put section='entityMain'><%@include file="/page/execution/includes/entityMain.jsp" %></region:put><region:put section='entityDocuments' content="/page/execution/includes/documents.jsp?frmParent=E"/><region:put section='processMain'><%@include file="/page/execution/includes/processMain.jsp" %></region:put><region:put section='processDocuments' content="/page/execution/includes/documents.jsp?frmParent=P"/><region:put section='entityForms' content="/page/monitor/processes/taskDetailForms.jsp?frmParent=E"/><region:put section='processForms' content="/page/monitor/processes/taskDetailForms.jsp?frmParent=P"/><region:put section='taskComments'><%@include file="/page/execution/includes/taskComments.jsp" %></region:put><region:put section='scripts_include'><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/monitor.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<system:util show="context" />/page/execution/tasks/task.js" <%=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"defer\"":"" %>></script><script type="text/javascript" src="<system:util show="context" />/page/monitor/processes/taskDetail.js"></script><script type="text/javascript" src="<system:util show="context" />/js/synchronize-fields.js"></script><script type="text/javascript" src="<system:util show="context" />/js/masked-input.js"></script><!-- JS Objects --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/form.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/field.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/input.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/select.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/area.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/button.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/check.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/editor.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/grid.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/hidden.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/href.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/image.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/label.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/multiple.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/password.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/radio.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/title.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/fileinput.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/classes/fieldTypes/tree.js"></script><script type="text/javascript" src="<system:util show="context" />/js/contextmenu.js"></script><script type="text/javascript" src="<system:util show="context" />/js/print.js"></script><!-- API JS --><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaFunctions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/execution/scripts/API/apiaField.js"></script><!-- documents --><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><!-- modals  --><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><%if("".equals(com.dogma.Configuration.CUSTOM_TINYMCE_PATH)){ %><script language="javascript" type="text/javascript" src="<system:util show="context" />/scripts/tinymce/jscripts/tinymce_4.1.5/tinymce.min.js"></script><%} else { %><script language="javascript" type="text/javascript" src="<system:util show="context" /><%=com.dogma.Configuration.CUSTOM_TINYMCE_PATH%>"></script><%} %><script type="text/javascript">
				var URL_REQUEST_AJAX = '/apia.monitor.ProcessesAction.run';	
			
				var commentsMarked 	= <%=commentsMarked%>;
				var currentTab 		= <%=request.getParameter("currentTab")!=null?request.getParameter("currentTab"):"-1"%>;
				
				var CURRENT_TASK_NAME = "<%=taskVo != null ? taskVo.getTskName() : ""%>";
				
				var ADDITIONAL_INFO_IN_TABLE_DATA = false;
				
				var signedOK = "false";
				var MSG_REQ_SIGNATURE_FORM = '<system:label show="text" label="lblReqSigForm" forScript="true" />';
				
				<%if(!"true".equals(request.getAttribute("isMonitor"))){ %>
					var isMonitor = false;
				<%} else {%>
					var isMonitor = true;
				<%}%>
				
				var TSK_TITLE = null; //Evita el cambio de nombre del tab
				var IN_MONITOR = true;
				var IN_MONITOR_PROCESS = true;
				var IN_MONITOR_TASK	   = false;
				
				var EXTERNAL_ACCESS = "<%=uData.isExternalMode()%>";
				var FROM_TASKS_MONITOR = toBoolean('<system:edit show="value" from="theBean" field="fromTaskMonitor"/>');
				var LAST_ID = '<system:edit show="value" from="theBean" field="lastId"/>';
				
				var BTN_FILE_UPLOAD_LBL = '<system:label show="text" label="prpUpload" forHtml="true" forScript="true" />';
				var BTN_FILE_DOWNLOAD_LBL = '<system:label show="text" label="prpDownload" forHtml="true" forScript="true" />';
				var BTN_FILE_INFO_LBL = '<system:label show="text" label="lblInfo" forHtml="true" forScript="true" />';
				var BTN_FILE_LOCK_LBL = '<system:label show="text" label="prpLock" forHtml="true" forScript="true" />';
				var BTN_FILE_SIGN_LBL = '<system:label show="text" label="prpSign" forHtml="true" forScript="true" />';
				var BTN_FILE_VERIFY_LBL = '<system:label show="text" label="prpVerify" forHtml="true" forScript="true" />';
				var BTN_FILE_ERASE_LBL = '<system:label show="text" label="prpErase" forHtml="true" forScript="true" />';
				
				var TIT_SING_MODAL_LBL = "<system:label show='text' label='titFormsToSign' forHtml='true'/>";
				
				window.addEvent('load', function() { initDetailsPage(); } );
				
				<%if(ProcessVo.IDENTIFIER_NUM_WRITE.equals(proVo.getProIdeNum())) {%>
				var idNumWrite = true;
				<%} else {%>
				var idNumWrite = false;<%}%>
				
				var currentContentTab = null;
				
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
					$("divDigitalSign").style.display='block';
					$("ifrApplet").src =  "<system:util show="context" />/digitalSignatureApplet/applet.jsp?tokenId=<system:util show="tokenId" />";
				}
			</script></region:put><region:put section='buttons'><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnPrint" class="button extendedSize" title="<system:label show="tooltip" label="btnPrint"/>"><system:label show="tooltip" label="btnPrint"/></div><div id="btnBack" class="button extendedSize" title="<system:label show="tooltip" label="btnVol"/>"><system:label show="tooltip" label="btnVol"/></div></div></div>&nbsp;
		</region:put><region:put section="helpDocuments"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="btnViewDocs" class="button extendedSize" title="<system:label show="tooltip" label="sbtEjeDoc" />"><system:label show="text" label="sbtEjeDoc" /></div></div></region:put></region:render><div class="divDelApplet" id='divDigitalSign'><iframe id="ifrApplet" frameborder="0" style="width: 430px;height: 210px"></iframe></div><%
String strScript = (String)request.getAttribute("FRM_SCRIPT");
if(strScript!=null){
	out.println(strScript);
}
%>