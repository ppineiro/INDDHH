<%@ page import="com.dogma.Parameters"%><%@ page import="com.dogma.vo.*"%><%@ page import="com.dogma.bean.execution.*"%><%@ page import="com.st.util.StringUtil"%><%@ page import="com.st.util.labels.LabelManager"%><%@ page import="java.util.*"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><% TaskBean dBean = (TaskBean) session.getAttribute("dBean"); %><%@include file="../../../components/scripts/server/frmTargetStart.jsp" %><div id="divMsg" style="height:197px;"><!--     - RESULT MESSAGE          --><table class="tblTitulo"><tr><td><%=LabelManager.getName(labelSet,langId,"lblMen")%></td></tr></table><div class="divContent" id="divContent"><form id="frmMain" name="frmMain" method="POST"><table><tr><td id="preMsg"></td></tr></table></form></div><table id="btnsBar" class="btnsBar" width="100%"><tr><td></td><td align="right" width="100%"><button type="button" id="btnCloseWin" onclick="btnConf_click()" style="visiblility:hidden" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCer")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCer")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCer")%></button> &nbsp;
			</td></tr></table></div></body></html><script language="javascript">

if (document.addEventListener) {
	document.addEventListener('DOMContentLoaded', function(){init();}, false);
}else{
	window.document.attachEvent("onreadystatechange",function(){
		if (document.readyState=='complete'){
			init();
		}
	});
}

function initMsg(){
var oBody;
<% 	
	//- Special messages ---
	boolean cerrarVentana = false;
	boolean mustShow=false;

	if (dBean.getHasException()) {
		mustShow=true;
		if (dBean.getDogmaException() != null &&
			dBean.getDogmaException().getDirectMessage() != null) {
		%>
		document.getElementById("preMsg").innerHTML = "<%= dBean.fmtScriptStr((dBean.getDogmaException().getDirectMessage() != null)? dBean.getDogmaException().getDirectMessage():
		 (dBean.getDogmaException().getNativeException() != null) ? dBean.getDogmaException().getNativeException().getMessage():
		  dBean.getDogmaException().getMessage() ).replaceAll("\n"," ").replaceAll("\r"," ")
		%>";<%
		//dBean.clearMessages();
		}
	} else 
	if (dBean.getMessageType() != null) {

	//		if (dBean instanceof com.dogma.bean.execution.InitTaskBean) {
			ArrayList arr = new ArrayList();
			String message = "";
			switch (dBean.getMessageType().intValue()) {
				case TaskBean.MESSAGE_PROCESS_CREATE :
					mustShow=true;
					ProcessVo proc = dBean.getProInstanceBean().getProcess();
					if (proc.getProAction().equals(ProcessVo.PROCESS_ACTION_CREATION)) {
						boolean showMsgEnt = false;
						if (proc.isFlagNull(proc.getProFlags(),ProcessVo.FLAG_MSG_ENTITY_CREATED)) {
							showMsgEnt = true;
						} else {
							if (proc.getFlagValue(ProcessVo.FLAG_MSG_ENTITY_CREATED)){
								showMsgEnt = true;
							}
						}
						if (showMsgEnt){
							ArrayList arr2 = new ArrayList();
							arr2.add(dBean.getEntInstanceBean().getCompleteEntity().getEntityVo().getBusEntTitle());
							arr2.add(dBean.getEntInstanceBean().getCompleteEntity().getEntInstanceVo().getEntityIdentification());
							message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_ENTITY_CREATED),arr2) + "<BR><BR>";
						}
					}
					boolean showMsgProc = false;
					if (proc.isFlagNull(proc.getProFlags(),ProcessVo.FLAG_MSG_PROCESS_CREATED)) {
						showMsgProc = true;
					} else {
						if (proc.getFlagValue(ProcessVo.FLAG_MSG_PROCESS_CREATED)){
							showMsgProc = true;
						}
					}
					if (showMsgProc){
						arr.add(proc.getProName());
						arr.add(dBean.getProInstanceBean().getCompleteProcess().getProcInstance().getIdentification());
						message += StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_PROCESS_CREATED),arr) + "<BR><BR>";
					}
					boolean showMsgCustom = false;
					if (proc.getFlagValue(ProcessVo.FLAG_MSG_CUSTOM_CREATED) && (proc.getCustomMsg() != null) && (proc.getCustomMsg().length() > 0)) {
						showMsgCustom = true;
					}
					if (showMsgCustom) {
						message += proc.getCustomMsg();
					}

					//-------AGREGADO MENSAJES
					message += "<BR>";
					if(dBean.getUserMessages(request)!=null){
						Iterator it = dBean.getUserMessages(request).iterator();
						while(it.hasNext()){
							message += "<BR>" + (String)it.next();
						}
					}
					dBean.clearUserMessages(request);
					//--------FIN AGREGADO MENSAJES

					%>document.getElementById("preMsg").innerHTML = "<%=dBean.fmtScriptStr(message)%>";<%
					cerrarVentana = true;
					break;
				case TaskBean.MESSAGE_TASK_COMPLETED :
					arr.add(dBean.getCurrentElement().getTskTitle());
					message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_TASK_COMPLETED),arr);

					//-------AGREGADO MENSAJES
					message += "<BR>";
					if(dBean.getUserMessages(request)!=null){
						mustShow=true;
						Iterator it = dBean.getUserMessages(request).iterator();
						while(it.hasNext()){
							message += "<BR>" + (String)it.next();
						}
					}
					dBean.clearUserMessages(request);
					//--------FIN AGREGADO MENSAJES
					if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM){message="";}
					%>
					document.getElementById("preMsg").innerHTML = "<%=dBean.fmtScriptStr(message)%>";<%
					cerrarVentana = true;
					break;
				case TaskBean.MESSAGE_TASK_SAVED :
					arr.add(dBean.getCurrentElement().getTskTitle());
					message = StringUtil.parseMessage(LabelManager.getName(labelSet,langId, DogmaException.EXE_TASK_SAVED),arr);
					if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM){message="";}
					%>document.getElementById("preMsg").innerHTML = "<%=dBean.fmtScriptStr(message)%>";<%
					cerrarVentana = true;
					break;
				case TaskBean.MESSAGE_TASK_ELE_OR_DEL :
					message = LabelManager.getName(labelSet,langId, DogmaException.EXE_TSK_DELEGATED);
					if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM){message="";}
					%>document.getElementById("preMsg").innerHTML = "<%=dBean.fmtScriptStr(message)%>";<%
					cerrarVentana = true;
					break;					
			}
			
			dBean.clearMessages();			
	}
%>
}
function btnConf_click(){
//RESULT MESSAGE
	window.parent.document.getElementById("iframeMessages").hideResultFrame();
 	var doc=window.parent.document.getElementById("iframeResult").submitterDoc;
	try{
		doc.getElementById("btnLast").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnNext").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnConf").disabled = false;
	} catch(e){}
	 try{
		doc.getElementById("btnSave").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnFree").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnPrint").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnDelegate").disabled = false;
	} catch(e){}
	try{
		doc.getElementById("btnElevate").disabled = false;
	} catch(e){}
	window.parent.document.getElementById("iframeResult").hideResultFrame(null,null);
	<% if (cerrarVentana) {
		if (dBean.getNextTaskVo() == null) {%>
			window.parent.document.getElementById("iframeMessages").getBody().parentNode.parentNode.location.href="<%=Parameters.ROOT_PATH%>/frames/splash.jsp";
			window.parent.document.getElementById("iframeResult").getBody().parentNode.parentNode.location.href="<%=Parameters.ROOT_PATH%>/FramesAction.do?action=splash"+windowId;
		<%} else {%>
			window.parent.document.getElementById("iframeMessages").showResultFrame(window.parent.document.getElementById("iframeResult").getBody());
			window.parent.document.getElementById("iframeResult").getBody().parentNode.parentNode.location.href="<%=Parameters.ROOT_PATH%>/execution.TaskAction.do?action=getTask&fromWizzard=<%=dBean.getNextTaskVo().isFromWizzard()%>&proInstId=<%=dBean.getNextTaskVo().getProInstId()%>&proEleInstId=<%=dBean.getNextTaskVo().getProEleInstId()%>"+windowId;
		<%}%><%}%>
	
	try{
		<%if("true".equals(request.getParameter("error"))){%>
			var win=window.parent.document.getElementById(window.name).submitWindow;
			win.document.getElementById("frmMain").action = "execution.TaskAction.do?action=reload";
			win.document.getElementById("frmMain").target = "_self";
			try{
				win.document.getElementById("frmMain").action=win.document.getElementById("frmMain").action+"&selTab="+win.document.getElementById("samplesTab").getSelectedTabIndex()+windowId;
			} catch (e) {}
			win.document.getElementById("frmMain").submit();
		<%}%>
	} catch(e){}
	try{
		<%if("true".equals(request.getParameter("error"))){%>
			win.frames['tab2'].document.getElementById("frmMain").action = "execution.TaskAction.do?action=reload";
			win.frames['tab2'].document.getElementById("frmMain").target = "_self";
			try{
				win.frames['tab2'].document.getElementById("frmMain").action=win.frames['tab2'].document.getElementById("frmMain").action+"&selTab="+win.frames['tab2'].document.getElementById("frmMain").getSelectedTabIndex()+windowId;
			} catch (e) {}
			win.frames['tab2'].document.getElementById("frmMain").submit();
		<%}%>
	} catch(e){}
}

</script><script language="javascript">
function initFrame(){
	if(element.readyState=="complete"){
/*		FRAME_WIDTH = parseInt(element.currentStyle.width);
		FRAME_HEIGHT = parseInt(element.currentStyle.height);*/
		doCenterFrame();
	}
}

function doCenterFrame(){
	updatePosExpr();
	var leftExprStr = "document.getElementById('" + element.name + "').getWinCenterWidth()"
	var topExprStr = "document.getElementById('" + element.name + "').getWinCenterHeight()"
	element.style.setExpression("left",leftExprStr);
	element.style.setExpression("top",topExprStr);
}

function updatePosExpr(){
	iFeedBackFr =window.parent.document.getElementById(window.name);
	var x=window.parent.innerWidth;
	if(navigator.userAgent.indexOf("MSIE")>0){
		x=window.parent.document.documentElement.clientWidth;
	}
	var y=window.parent.innerHeight;
	if(navigator.userAgent.indexOf("MSIE")>0){
		y=window.parent.document.documentElement.clientHeight;
	}
	var width=window.innerWidth;
	if(navigator.userAgent.indexOf("MSIE")>0){
		width=iFeedBackFr.clientWidth;
	}
	var height=window.innerHeight;
	if(navigator.userAgent.indexOf("MSIE")>0){
		height=iFeedBackFr.clientHeight;
	}
	iFeedBackFr.style.left=((x-width)/2)+"px";
	iFeedBackFr.style.top=((y-height)/2)+"px";

}

function getWinCenterWidth(){
	return expr_frame_left;
}

function getWinCenterHeight(){
	return expr_frame_top;
}

function showResultFrame(body){
	//updatePosExpr();
	//document.getElementById("divMsg").style.display="none";
	oBody = body;
//	disableUi(true, body);
/*	iFeedBackFr =	window.parent.document.getElementById(window.name);
	iFeedBackFr.style.display="block";
	updatePosExpr();*/
}

function showMessage(str, body){ 
<%if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM){%>
	return;
<%}%>
	updatePosExpr();
	//iFeedBackFr = window.document.frames(element.name);
	document.getElementById("preMsg").innerHTML = str;
	document.getElementById("divMsg").style.display="block";
	document.getElementById("divContent").style.display="block";
	document.getElementById("btnsBar").style.display="block";
	document.getElementById("divWait").style.display="none";
	oBody = body;
	//disableUi(true, body);
	window.parent.document.getElementById(window.name).style.display="block";
}

function hideResultFrame(eventToFire, body){
	/*if (oNewSpan != "") {
	//	disableUi("false", oBody);
	}*/
	var iFeedBackFr =	window.parent.document.getElementById(window.name);
	iFeedBackFr.hideResultFrame();
}

function getBody(){
	return window.parent.document.getElementById(window.name).oBody;
//	return oBody;
}

function resizeFrame(iWidth){
	iWidth=iWidth + "px"
	element.style.width=iWidth;
}

function disableUi(bStatus, divContent){
	var oTab,cmbColl;
	var oTabEl = divContent.getElementsByTagName("tabElement");
	
	if (oTabEl[0]!=null){
		 oTab  = oTabEl[0].getSelectedTab();
		 cmbColl = oTab.getElementsByTagName("SELECT");
	}else{
		 cmbColl = divContent.getElementsByTagName("SELECT");
	}
	var colLen = cmbColl.length;
		if(bStatus==true){
				for(var s=0;s<colLen;s++){
					if(cmbColl[s].disabled == false){
						cmbColl[s].disabled = true;
					}else{
						cmbColl[s].setAttribute("attStayDisabled",true);
					}
				}
				var oDisabledSpan = document.createElement("DIV");
					oDisabledSpan.style.width = "100%";
					oDisabledSpan.style.height = "100%";
					oDisabledSpan.style.filter="alpha(opacity:40)";
					oDisabledSpan.style.backgroundColor="#DFDFDF";
					oDisabledSpan.style.position ="absolute";
					oDisabledSpan.style.left = "0px";
					oDisabledSpan.style.top = "0px";
					oDisabledSpan.style.zIndex = "998";
					oDisabledSpan.onclick="alert('hola')";
					oNewSpan = divContent.insertAdjacentElement("afterEnd", oDisabledSpan);
					//oNewSpan.attachEvent("onclick",divContent_onClick);
					
		}else{
					for(var s=0;s<colLen;s++){
						if(cmbColl[s].attStayDisabled != true){
							cmbColl[s].disabled = false;
						}else{
							cmbColl[s].removeAttribute("attStayDisabled");
						}
					}
					//oNewSpan.detachEvent("onclick",divContent_onClick);
					oNewSpan.removeNode(true);
					oNewSpan = "";
		}
}

function divContent_onClick(){
	window.event.cancelBubble=true; 
	window.event.returnValue=false;
}

function disableButtonBar(bStatus){
	var win=window.parent.document.getElementById(window.name).submitWindow;
	btnsBar = win.document.getElementById("divContent");
	var btnsColl = btnsBar.getElementsByTagName("BUTTON");
	var btnsCollLen = btnsColl.length;
		if (bStatus==true){
			for(var x=0;x<btnsCollLen;x++){
				if(btnsColl[x].disabled==false){
					btnsColl[x].disabled = true;
				}else{
					btnsColl[x].setAttribute("attStayDisabled",true);
				}
			}
		}else{
			for(var x=0;x<btnsCollLen;x++){
				if(btnsColl[x].attStayDisabled != true){
					btnsColl[x].disabled = false;
				}else{
					btnsColl[x].removeAttribute("attStayDisabled");
				}
			}
		}
}

function hideResultFrame(eventToFire, body){
	/*if (oNewSpan != "") {
//		disableUi("false", oBody);
	}*/
	window.parent.document.getElementById(window.name).style.display="none";
}

function init(){
	
	
	<%if(!mustShow && Parameters.AUTOCLOSE_TASK_CONFIRM){%>
		window.parent.document.getElementById("iframeResult").style.display="none";
		window.parent.document.getElementById("iframeMessages").style.display="none";
		btnConf_click();
	<%} else {%>
		initMsg();
		document.getElementById("divContent").style.display="block";
		document.getElementById("divMsg").style.display="block";
		document.getElementById("preMsg").style.display="block";
		var oBtnBar=document.getElementById("btnsBar");
		if(window.navigator.appVersion.indexOf("MSIE")>0){
			oBtnBar.style.display="block";
		}else{
			oBtnBar.style.display="table";
		} 
		document.getElementById("btnCloseWin").style.visibility="visible";
		try{
		document.getElementById("btnCloseWin").focus();
		}catch(e){}
	//	updatePosExpr();
	//	window.parent.document.getElementById("iframeResult").style.display="block";
	//	window.parent.document.getElementById("iframeMessages").style.display="none";
	<%}%>
} 	

</script><%@include file="../../../components/scripts/server/frmTargetEnd.jsp" %>