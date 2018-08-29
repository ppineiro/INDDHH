<%@page import="com.dogma.*"%><%@page import="com.dogma.security.util.DateUtil"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.*"%><%@page import="java.util.Date"%><%@page import="java.util.GregorianCalendar"%><%@page import="java.util.Calendar"%><%@page import="java.util.*"%><%@page import="java.io.*"%><%@page import="com.st.util.log.Log"%><%@page import="chat.commands.conversation.NewMessage"%><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><%
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
if (request.getParameter("hidLangId") != null && !"null".equals(request.getParameter("hidLangId"))) {
	langId = new Integer(request.getParameter("hidLangId"));
}
String defer=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"true\"":"";
%><title> - APIADESK - </title><script language="javascript">
var currStyle="classic";

var DESK_WIN_TITLE	= " - APIADESK - ";

var URL_ROOT_PATH	= "<%=Parameters.ROOT_PATH%>";

var CHAT_URL		= "<%=Parameters.APIACHAT_URL%>";

var CHAT_PROXY_URL	= "apiaCommunicator/htmlProxy.jsp?reqUrl=";

var CHAT_REFRESH_TIME = <%=Parameters.APIACHAT_FREQUENCY_CALLBACK%>;

var GNR_JANUARY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_JANUARY))%>";
var GNR_FEBRUARY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_FEBRUARY))%>";
var GNR_MARCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_MARCH))%>";
var GNR_APRIL		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_APRIL))%>";
var GNR_MAY			= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_MAY))%>";
var GNR_JUNE		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_JUNE))%>";
var GNR_JULY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_JULY))%>";
var GNR_AUGUST		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_AUGUST))%>";
var GNR_SEPTEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_SEPTEMBER))%>";
var GNR_OCTOBER		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_OCTOBER))%>";
var GNR_NOVEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_NOVEMBER))%>";
var GNR_DECEMBER	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_DECEMBER))%>";
var GNR_MONDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblLunes"))%>";
var GNR_TUESDAY  	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblMartes"))%>";
var GNR_WEDNESDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblMiercoles"))%>";
var GNR_THURSDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblJueves"))%>";
var GNR_FRIDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblViernes"))%>";
var GNR_SATURDAY	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblSabado"))%>";
var GNR_SUNDAY		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,"lblDomingo"))%>";


var GNR_FOR_FCH		= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_FOR_FCH))%>";

var LOGGED_USER_NAME= "<%=bLogin.getUserName(request)%>";

var LOGGED_USER		= "<%=bLogin.getUserId(request)%>";

var LOGGED_SESSION	= "<%=request.getSession().getId()%>";

var licenceInfo = "<%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%>";

var logoutLabel = "<%=LabelManager.getToolTip(labelSet,langId,"lblTocCloApp")%>";
<%
String groups="";
Iterator it=bLogin.getUserGroups(request).iterator();
while(it.hasNext()){
	groups+="\""+it.next().toString()+"\"";
	if(it.hasNext()){
		groups+=",";
	}
}
%>
var USER_GROUPS		=[<%=groups%>];

var ENVIRONMENT		= "<%=bLogin.fmtHTML(bLogin.getUserData(request).getEnvironmentName())%>";

var lblMyTasks		= "<%=LabelManager.getName(labelSet,langId,"titEjeMisTar")%>";
var lblFreeTasks	= "<%=LabelManager.getName(labelSet,langId,"titEjeTarLib")%>";

var msgAquireTask	= "<%=LabelManager.getName(labelSet,langId,"msgAquireTask")%>";
var msgFreeTask		= "<%=LabelManager.getName(labelSet,langId,"msgFreeTask")%>";

var lblNewPostit	= "<%=LabelManager.getName(labelSet,langId,"lblNewPostit")%>";
var lblHidePostits	= "<%=LabelManager.getName(labelSet,langId,"lblHidePostits")%>";
var lblShowPostits	= "<%=LabelManager.getName(labelSet,langId,"lblShowPostits")%>";
var lblPostitsToBack	= "<%=LabelManager.getName(labelSet,langId,"lblPostitsToBack")%>";

var lblNewFolder		= "<%=LabelManager.getName(labelSet,langId,"lblNewFolder")%>";

var lblSort			= "<%=LabelManager.getName(labelSet,langId,"lblSort")%>";
var lblSortCascade	= "<%=LabelManager.getName(labelSet,langId,"lblSortCascade")%>";
var lblSortHorizontal	= "<%=LabelManager.getName(labelSet,langId,"lblSortHorizontal")%>";
var lblSortByName	= "<%=LabelManager.getName(labelSet,langId,"lblSortByName")%>";
var lblSortByType	= "<%=LabelManager.getName(labelSet,langId,"lblSortByType")%>";
var lblMinimizeAll	= "<%=LabelManager.getName(labelSet,langId,"lblMinimizeAll")%>";

var lblSaveDesk		= "<%=LabelManager.getName(labelSet,langId,"lblSaveDesk")%>";

var lblDeleteElement= "<%=LabelManager.getName(labelSet,langId,"lblDeleteElement")%>";
var lblChangeName	= "<%=LabelManager.getName(labelSet,langId,"lblChangeName")%>";

var lblPending		= "<%=LabelManager.getName(labelSet,langId,"lblPending")%>";

var lblCloseWindow	= "<%=LabelManager.getName(labelSet,langId,"lblCloseWindow")%>";
var lblMaximizeWindow	= "<%=LabelManager.getName(labelSet,langId,"lblMaximizeWindow")%>";
var lblRestoreWindow	= "<%=LabelManager.getName(labelSet,langId,"lblRestoreWindow")%>";
var lblMinimizeWindow	= "<%=LabelManager.getName(labelSet,langId,"lblMinimizeWindow")%>";

var lblRefresh			= "<%=LabelManager.getName(labelSet,langId,"lblRefresh")%>";
var lblGroupBy			= "<%=LabelManager.getName(labelSet,langId,"lblGroupBy")%>";
var lblUnGroup			= "<%=LabelManager.getName(labelSet,langId,"lblUnGroup")%>";

var btnMonHis			= "<%=LabelManager.getName(labelSet,langId,"btnMonHis")%>";
var lblTit				= "<%=LabelManager.getName(labelSet,langId,"lblTit")%>";
var lblEjeFchDes		= "<%=LabelManager.getName(labelSet,langId,"lblEjeFchDes")%>";
var lblEjeFchHas		= "<%=LabelManager.getName(labelSet,langId,"lblEjeFchHas")%>";
var lblFilUsrNom		= "<%=LabelManager.getName(labelSet,langId,"lblFilUsrNom")%>";

var lblPool		= "<%=LabelManager.getName(labelSet,langId,"lblPool")%>";
	
<% if (Parameters.APIACHAT_MODE_CLIENT) { %>
var MSG_TYPE_NA 					= '<%= NewMessage.TYPE_NA %>';
var MSG_TYPE_NEW_USER				= '<%= NewMessage.TYPE_NEW_USER %>';
var MSG_TYPE_EXIT_USER				= '<%= NewMessage.TYPE_EXIT_USER %>';

var MSG_TYPE_NEW_FILE_TRANFER		= '<%= NewMessage.TYPE_NEW_FILE_TRANFER %>';
var MSG_TYPE_ACCEPT_FILE_TRANFER	= '<%= NewMessage.TYPE_ACCEPT_FILE_TRANFER %>';
var MSG_TYPE_CANCEL_FILE_TRANFER	= '<%= NewMessage.TYPE_CANCEL_FILE_TRANFER %>';
var MSG_TYPE_COMPLET_FILE_TRANFER	= '<%= NewMessage.TYPE_COMPLET_FILE_TRANFER %>';
var MSG_TYPE_SENDING_FILE_TRANFER	= '<%= NewMessage.TYPE_SENDING_FILE_TRANFER %>';
var MSG_TYPE_ERROR_FILE_TRANFER		= '<%= NewMessage.TYPE_ERROR_FILE_TRANFER %>';
<%}%>

var LANG_ID			= "<%=langId%>";

function setWindowTitle(tit){
	document.title=tit;
}

</script><%@include file="jsps/scriptaculousInclude.jsp" %><script language="javascript" src="apiaCommunicator/commandHandlers.js"></script><script language="javascript" src="apiaCommunicator/messageHandlers.js"></script><script language="javascript" src="apiaCommunicator/chatWindow.js"></script><script language="javascript" src="apiaCommunicator/HistoryManager.js"></script><script language="javascript" src="apiaCommunicator/groupWindow.js"></script><script language="javascript" src="apiaCommunicator/chatClient.js"></script><script language="javascript" src="common.js"></script><script language="javascript" src="xmlUtils.js"></script><script language="javascript" src="winCommon.js"></script><script language="javascript" src="interface.js"></script><script language="javascript" src="windowManager.js"></script><script language="javascript" src="desktopManager.js"></script><script language="javascript" src="model.js"></script><script language="javascript" src="menuBar.js"></script><script language="javascript" src="widgets.js"></script><script language="javascript" src="dock.js"></script><script language="javascript" src="desktopModel.js"></script><script language="javascript" src="postIts.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/feedBackFrame.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/modalController.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/val.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/calendar.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/maskedInput.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/tjmlib.js"></script><script language="javascript" src="TaskList.js"></script><script language="javascript" src="gridView.js"></script><script language="javascript" src="iconView.js"></script><script language="javascript" src="list.js"></script><script language="javascript"><%Date d=new Date();
GregorianCalendar cal = new GregorianCalendar();
cal.setTime(d);%>
var serverDate=<%=((DateUtil.getDay(d).charAt(0)!='0')?(DateUtil.getDay(d)):(DateUtil.getDay(d).charAt(1)+""))%>;
var serverMonth=<%=((DateUtil.getMonth(d).charAt(0)!='0')?(DateUtil.getMonth(d)):(DateUtil.getMonth(d).charAt(1)+""))%>;
var serverYear=<%=DateUtil.getYear(d)%>;
var serverHour=<%=cal.get(Calendar.HOUR)%>;
var serverMinute=<%=cal.get(Calendar.MINUTE)%>;
<%if(!"yyyy/MM/dd".equals(EnvParameters.getEnvParameter(bLogin.getEnvId(request),EnvParameters.FMT_DATE))){%>
var DATE_MASK 		= "<%="__" + Parameters.DATE_SEPARATOR + "__" + Parameters.DATE_SEPARATOR + "____"%>";
<%} else {%>
var DATE_MASK 		= "<%="____" + Parameters.DATE_SEPARATOR + "__" + Parameters.DATE_SEPARATOR + "__"%>";
<%}%>

var strDateFormat 			= "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(bLogin.getEnvId(request),EnvParameters.FMT_DATE))%>";
var GNR_DATE_SEPARATOR		= "<%=Parameters.DATE_SEPARATOR%>";

var URL_STYLE_PATH			= "<%=Parameters.ROOT_PATH%>/styles/default";

var xmlLoaderListener=new Object();

var elWins=new Object();

function init(){

	<%if(Parameters.CUSTOM_JSP.length()>0){
		File f = new File(Parameters.APP_PATH + Parameters.CUSTOM_JSP);
		if(f.exists()){%>
			sendVars("<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JSP%>","")
		<%}else{
			Log.debug("The jsp file setted in the parameter CUSTOM JSP with value: " + Parameters.CUSTOM_JSP + " was not found");
		}
	}%>

	PreloadImages();
	initTaskList();
	xmlLoaderListener.onload=function(model){
		postIts=new Array();
		initInterFace();
		for(var i=0;i<model.length;i++){
			var elementData=model[i];
			if(elementData.type=="window"){
				if(elementData.elementId){
					elWins[elementData.elementId]=elementData;
				}else if(elementData.taskList!=null){
					openTaskListWindow(elementData);
				}else{
					openModelWindow(elementData);
				}
			}else if(elementData.type=="postit"){
				var postit=addPostit(elementData.text);
				postit.style.left=elementData.left+"px";
				postit.style.top=elementData.top+"px";
				postit.x=elementData.left;
				postit.y=elementData.top;
			}else{
				var anElement;
				if(elementData.elements || elementData.type=="folder"){
					anElement=new folder(elementData).getIconElement();
				}else{
					anElement=new element(elementData).getIconElement();
				}
				deskTop.addElement(anElement);
				if(elementData.windowId && elWins[elementData.windowId]){
					var winEl=elWins[elementData.windowId];
					var win=anElement.openWindow();
					win.setSize(winEl.width,winEl.height);
					win.setPosition(winEl.x,winEl.y);
					if(winEl.minimized=="true"){
						win.minimize();
					}
				}
			}
		}
		setPostitsVisibility(postitsInitState);
		hideResultFrame();
		addListener(window,"unload",killSession);
		//postitsToBack();
		//try{window.parent.hideResultFrame();}catch(e){};
	}
	loadModel("ApiaDeskAction.do?action=loadModel");
	makeUnselectable(document.body);
	//startModelCookie();
}

function allReady(){
	if(deskTop && deskTop.ready && menuBar && menuBar.ready){
		topArea.fadeOut();
	}
}

function PreloadImages() {
  var aImages = ['images/helpTipBL.png','images/helpTipBR.png','images/helpTipTL.png','images/helpTipTR.png'];
  for(var i=0; i < aImages.length; i++) {
    var img = new Image();
    img.src = aImages[i];
  }
}


// to do fix esto	
function hideResultFrame() {
	var win=window;
	while(!win.document.getElementById("iframeMessages") && (win!=win.parent) ){
		win=win.parent;
	}
	if(win.document.getElementById("iframeMessages") && win.document.getElementById("iframeResult")){
		win.document.getElementById("iframeMessages").hideResultFrame();
		win.document.getElementById("iframeResult").hideResultFrame();
	}
}

function killSession(){
	sendVars("security.LoginAction.do?action=logout","");
}

</script><link href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/styles/classic/css/desktop.css" rel="stylesheet" type="text/css"><link href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/styles/classic/css/menu.css" rel="stylesheet" type="text/css"><link href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/styles/classic/css/window.css" rel="stylesheet" type="text/css"><link href="<%=Parameters.ROOT_PATH%>/styles/default/css/dtPicker.css" rel="stylesheet" type="text/css"><style>
.feedBackFrame{
	POSITION: absolute;
	DISPLAY:none;
	WIDTH:350px;
	HEIGHT:200px;
	OVERFLOW:hidden;
}

.modalWin{
	BORDER:#416D94 1px solid;
    BACKGROUND-COLOR:#92C0E2;
}
</style></head><body onLoad="init()" style="padding:0px; margin:0px;overflow:hidden;width:100%;" scroll=no>
&nbsp;
<iframe style="z-index:9999990;" name="iframeResult" id="iframeResult" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe><iframe style="z-index:99999999;" name="iframeMessages" id="iframeMessages" class="feedBackFrame" frameborder="no" style="" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" ></iframe></body></html>

