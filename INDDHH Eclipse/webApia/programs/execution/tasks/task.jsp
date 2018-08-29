<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.*"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@page import="com.st.util.translator.TranslationManager"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% 
	TaskBean dBean = (TaskBean) session.getAttribute("dBean");
	boolean isFirstTask = dBean instanceof InitTaskBean;
	BusEntInstanceVo beInstVo = dBean.getEntInstanceBean().getEntity();
	BusEntityVo beVo = dBean.getEntInstanceBean().getEntityType();
	Collection beRelCol = dBean.getEntInstanceBean().getEntityRelations();
	
	TaskVo taskVo = dBean.getTaskVo();
	ProcessVo proVo =  dBean.getProInstanceBean().getProcess();
	ProInstanceVo proInstVo = dBean.getProInstanceBean().getProcInstance();
	
	EntInstanceBean entityBean = dBean.getEntInstanceBean();
	ProInstanceBean processBean = dBean.getProInstanceBean();
	
	String divContentHeight = tl_div_height;
	String divType = DogmaConstants.SESSION_TL_HEIGHT;
	if (isFirstTask) {
		divContentHeight = cmp_div_height;
		divType = DogmaConstants.SESSION_CMP_HEIGHT;
	}
	
	String template = "/templates/taskDefault.jsp";
	if (proVo.getProExeTemplate() != null && !proVo.getProExeTemplate().equals("")) {
		//template = proVo.getProExeTemplate();
		if (proVo.getProExeTemplate().startsWith("/")){
			template = proVo.getProExeTemplate();
		} else{
			template = "../../modals/"+proVo.getProExeTemplate();
		}
	}
	if (dBean.getTaskVo().getTskExeTemplate() != null && !dBean.getTaskVo().getTskExeTemplate().equals("")) {
		template = dBean.getTaskVo().getTskExeTemplate();
	}
	
	boolean fromUrl = false;
	if(request.getParameter("fromUrl")!=null){
		fromUrl = true;
	}
	
	dBean.setHasFormsInStep(false);
	
	
	request.getSession().setAttribute("MCE","false");
	
	
	if(dBean.isPageWithTinyMCE()){
		request.getSession().setAttribute("MCE","true");
	}
	
	
%><%@page import="sun.misc.BASE64Encoder"%><region:render template='<%=template%>'><region:put section='title'><%=LabelManager.getName(labelSet,"titEjeTar")%> : <%=dBean.fmtHTML(TranslationManager.getTaskTitle(dBean.getCurrentElement(), uData.getEnvironmentId(), uData.getLangId()))%><%if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_LOW){ %><img title="<%=LabelManager.getName(labelSet,"lblEjeTitPriPro1")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/priority1.gif"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_HIGH){ %><img title="<%=LabelManager.getName(labelSet,"lblEjeTitPriPro3")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/priority3.gif"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_URGENT){%><img title="<%=LabelManager.getName(labelSet,"lblEjeTitPriPro4")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/priority4.gif"><%}else if(proInstVo.getProPriority() != null && proInstVo.getProPriority().intValue() == com.dogma.vo.ProInstanceVo.PRO_PRIORITY_NORMAL){%><img title="<%=LabelManager.getName(labelSet,"lblEjeTitPriPro2")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/priority2.gif"><%}else {%><img title="<%=LabelManager.getName(labelSet,"lblEjeTitPriPro2")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/priority2.gif"><%}%></region:put><region:put section='divHeight'><%=divContentHeight%></region:put><region:put section='entityMain'><%@include file="../includes/entityMain.jsp" %></region:put><region:put section='entityRelations'><%@include file="../includes/entityRelations.jsp" %></region:put><region:put section='entityDocuments' content="/programs/documents/documents.jsp?docBean=entity"/><region:put section='processMain'><%@include file="../includes/processMain.jsp"%></region:put><region:put section='processHistory'><%@include file="../includes/entityProHistory.jsp"%></region:put><region:put section='processDocuments' content="/programs/documents/documents.jsp?docBean=process"/><region:put section='entityForms' content="/programs/execution/includes/forms.jsp?frmParent=E"/><region:put section='processForms' content="/programs/execution/includes/forms.jsp?frmParent=P"/><region:put section='taskComments'><%@include file="../includes/taskComments.jsp"%></region:put><%Collection colActions=dBean.getUserData(request).getActionsAllow(); 
		boolean allow = false;
		Iterator iterator = colActions.iterator();
		while (iterator.hasNext() && !allow) {
			String classNameAllow = (String) iterator.next();
			allow = classNameAllow.equals("query.MonitorProcessesAction");
		}

		if (allow) {
		%><region:put section='taskMonitor'><%@include file="../includes/taskMonitor.jsp"%></region:put><%} %><region:put section='buttons'><%if (!isFirstTask) {%><td align=left width=100%><% if (dBean.isFromQuery()) { %><button type="button" id="btnFree" disabled onclick="btnFreeQuery_click(<%=proInstVo.getProInstId()%>,<%=dBean.getCurrentElement().getProEleInstId()%>)" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeLib")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeLib")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeLib")%></button><% } else { %><button type="button" id="btnFree" disabled onclick="btnFree_click(<%=proInstVo.getProInstId()%>,<%=dBean.getCurrentElement().getProEleInstId()%>)" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeLib")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeLib")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeLib")%></button><% } %><%if (taskVo.getFlagValue(TaskVo.POS_FLAG_DELEGATE) && proVo.getFlagValue(ProcessVo.FLAG_DELEGATE) && "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request),EnvParameters.ENV_USES_HIERARCHY))) {%><button id="btnDelegate" disabled onclick="btnDelegate_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblExeDelegar")%>" title="<%=LabelManager.getToolTip(labelSet,"lblExeDelegar")%>"><%=LabelManager.getNameWAccess(labelSet,"lblExeDelegar")%></button><%}%></td><td><button id="btnSave" disabled onclick="btnSave_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGua")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGua")%>"><%=LabelManager.getNameWAccess(labelSet,"btnGua")%></button><%}%><%if (dBean.isQueryGoBack() && (dBean.getCurrentStep()==null || (dBean.getCurrentStep()!=null && dBean.getCurrentStep().intValue()==1))  ) {%><button id="btnAnt" onclick="btnAnt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><% } %><%if (dBean.getCurrentStep().intValue() > 1) {%><button id="btnLast" disabled onclick="btnLast_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><%}%><%if (dBean.getStepQty().intValue() > dBean.getCurrentStep().intValue()) {%><button id="btnNext" disabled onclick="btnNext_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnPro")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><%} else {%><%if(Parameters.DIGITAL_SIGN_IN_CLIENT && dBean.hasSignableForms()){%><button id="btnSign" onclick="btnSignData_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSign")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSign")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSign")%></button><%}%><button id="btnConf" disabled onclick="btnConf<%=(!(dBean instanceof InitTaskBean))?"Dirty":""%>_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%}%><button id="btnPrint" disabled onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><%if (isFirstTask && !dBean.isQueryGoBack()  && ! dBean.isFromMenu()) {%><button id="btnVolver" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><%}%><button id="btnExit" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button><form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form></region:put></region:render><iframe id="ifrAutoSave" name="ifrAutoSave" style="display:none"></iframe><iframe id="iframeAjax" name="iframeAjax" style="display:none"></iframe><%if("true".equals(request.getParameter("signApplet"))){%><DIV style='display:none;background-color:white;color:black;position:absolute;top:100px;left:200px;z-index:99;border:solid 1px black' id='divDigitalSign'><iframe id="ifrApplet" frameborder="0" style="width: 430px;height: 210px"></iframe></DIV><%}%><%@include file="../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/execution/tasks/task.js" DEFER></script><script src="<%=Parameters.ROOT_PATH%>/scripts/grid/grids.js" DEFER></script><SCRIPT>
var QUERY_GO_BACK = <%= entityBean.isQueryGoBack() %>;
var QUERY_ADMIN = <%= entityBean.isQueryAdministration() %>;
var SPECIFIC_ADMIN = <%=entityBean.isGlobalAdministration()%>; 
var QUERY_CANCEL = <%=entityBean.isQryProCancel()%>;
var QUERY_ALTER = <%=entityBean.isQryProAlter()%>;
var ALTER_ENTITY = <%=dBean.isAlterEntity()%>;
var CANCEL_PROCESS = <%=dBean.isCancelProcess()%>;
var CANCEL_BACK_URL = "<%=dBean.getCancelBackURL()%>";
var ALTER_PROCESS = <%=dBean.isAlterProcess()%>;
var ALTER_BACK_URL = "<%=dBean.getAlterBackURL()%>";
var BTN_SAVE_EXIT = "<%= "true".equalsIgnoreCase(EnvParameters.getEnvParameter(dBean.getEnvId(request),EnvParameters.ENV_BTN_SAVE_EXIT)) %>";
var CURRENT_TASK_NAME = "<%=taskVo.getTskName()%>";
function tabSwitch(){
}
 
<%if (!isFirstTask) {%>
	function btnConfDirty_click() {
		if (window.frameElement.name != "workArea") {
			try{
				window.parent.document.getElementById("dirtyFreeTasks").value = "true";
			}
			catch(e){}
		}
		btnConf_click();
	}
<%}%>
internalDivType = "<%=divType%>";
</SCRIPT><%
String strScript = (String)request.getAttribute("FORM_SCRIPTS");
if(strScript!=null){
	out.println(strScript);
}
%><%

String strOnCng = dBean.getOnStepChangeScripts(request);
out.println(strOnCng);
%><SCRIPT DEFER>

var firedByStepBack = false;
var firedByStepNext = false;
var firedByConfirm = false;

var signedOK = "true";

var currentClassE = "";
var currentClassP = "";
mesNoSave = "<%=LabelManager.getName(labelSet,"msgNoGua")%>";

var MSG_REQ_SIGNATURE_FORM = "<%=LabelManager.getName(labelSet,"lblReqSigForm")%>";

apiaCurrentStep = "<%=dBean.getCurrentStep()==null?"":dBean.getCurrentStep().toString()%>";
window.onload=function(){

<%
long ss  = com.dogma.security.configuration.Configuration.SRV_SESSION_TIMEOUT/1000;
long ses = request.getSession().getMaxInactiveInterval();

long res = 0;
if(ss < ses){
	res = ss;
}else{
	res = ses;
}

if(Parameters.AUTOSAVE_TASKS){%>
	setTimeout ('btnExit_click_noConfirm()', <%=(res*1000)-20000%>); 
<%}%>
		processButtons(false);
		
		try{
			frmOnloadE();
		} catch(e){
			if(currentClassE!=""){
				alert("Error in business class '" + currentClassE + "', contact system administrator");
			}
		}
		try{
			frmOnloadP();
		} catch(e){
			if(currentClassP!=""){
				alert("Error in business class " + currentClassP + "', contact system administrator");
			}
		}
	
		<%if("true".equals(request.getParameter("ajax"))){%>
		window.parent.reload("<%=request.getParameter("frmName")%>");
		<%
		//modificacion realizada por mleiva para arreglar error del tester en cam_2026
		} else if (buffer.length() > 0) {
		out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}else{window.document.onreadystatechange=fnStartDocInit;}");
		%>function fnStartDocInit(){
			if (document.readyState=='complete' || (!MSIE)){
				try {  
					var win=window;
					while(!win.document.getElementById('iframeMessages') && win!=win.parent){
						win=win.parent;
					}
 					if (win.document.getElementById('iframeMessages')) {
						win.document.getElementById('iframeMessages').showMessage(document.getElementById("errorText").value, document.body);
					}else{
						str = document.getElementById("errorText").value;
						if (str.indexOf("</PRE>") != null) {
							str = str.substring(5,str.indexOf("</PRE>"));
						}
						alert(str);
					}
				} catch (e) {
					str = document.getElementById("errorText").value;
					if (str.indexOf("</PRE>") != null) {
						str = str.substring(5,str.indexOf("</PRE>"));
					}
					alert(str);
				}
			}
		}<%}	%><%if(dBean.getStepQty().intValue() > dBean.getCurrentStep().intValue() && !dBean.isHasFormsInStep()){%>
	try{
		btnNext_click();
	}catch(e){}
	<%}	%><%if("true".equals(request.getParameter("signApplet"))){%>
		showAppletModal(); 
		signedOK = "false";
	<%}%>
}

var FROM_URL = <%=fromUrl%>;
var AUTOSAVE = <%=Parameters.AUTOSAVE_TASKS%>;
var AUTOSAVE_CONF = <%=Parameters.AUTOSAVE_TASKS_CONFIRM%>;
var AUTOSAVE_CONF_MSG = "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,"msgConfAutoSave"))%>";

<%if("true".equals(request.getParameter("signApplet"))){%>
function showAppletModal(){
	document.getElementById("divDigitalSign").style.display='block';
	document.getElementById("ifrApplet").src =  "<%=Parameters.ROOT_PATH%>/digitalSignatureApplet/applet.jsp";
}
<%}%>


function appletConfirmer(result){
	signedOK = result;
	document.getElementById("btnConf").click();
}

function appletCloser(result){
	signedOK = result;
	document.getElementById("divDigitalSign").style.display = "none";
}


var txtBusEntId = "<%=dBean.getEntInstanceBean().getEntityType().getBusEntId()%>";
var txtBusEntAdm = "<%=dBean.getEntInstanceBean().getEntityType().getBusEntAdminType()%>";
var currentLanguage = "<%=currentLanguage%>";
</SCRIPT><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/digitalSignature.js"></script><script><%if(dBean.getFirstFocus() != null) {%>
	DONT_SET_FOCUS = <%=!dBean.getFirstFocus()%>;
	<%} else {%>
	DONT_SET_FOCUS = <%=!Parameters.DO_SCROLL%>;
	<%}%></script><%dBean.resetTinyMCEDrawn();%>
