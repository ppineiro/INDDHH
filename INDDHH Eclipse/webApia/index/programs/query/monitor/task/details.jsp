<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.query.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><% 

	MonitorTasksBean dBean = (MonitorTasksBean) session.getAttribute("dBean");
	BusEntInstanceVo beInstVo = dBean.getEntInstanceBean().getEntity();
	BusEntityVo beVo = dBean.getEntInstanceBean().getEntityType();
	Collection beRelCol = dBean.getEntInstanceBean().getEntityRelations();
	
	ProcessVo proVo =  dBean.getProInstanceBean().getProcess();
	ProInstanceVo proInstVo = dBean.getProInstanceBean().getProcInstance();
	
	com.dogma.bean.execution.EntInstanceBean entityBean = dBean.getEntInstanceBean();
	ProInstanceBean processBean = dBean.getProInstanceBean();
	
	String template = "/templates/taskDefault.jsp";
	if (proVo.getProExeTemplate() != null) {
		template = proVo.getProExeTemplate();
	}
	
%><region:render template='<%=template%>'><region:put section='title'><%=LabelManager.getName(labelSet,"titPro")%></region:put><region:put section='entityMain'><%@include file="../../../execution/includes/entityMain.jsp" %></region:put><region:put section='entityRelations'><%@include file="../../../execution/includes/entityRelations.jsp" %></region:put><region:put section='entityDocuments' content="/programs/documents/documents.jsp?docBean=entity"/><region:put section='processMain'><%@include file="../../../execution/includes/processMain.jsp"%></region:put><region:put section='processHistory'><%@include file="../../../execution/includes/entityProHistory.jsp"%></region:put><region:put section='processDocuments' content="/programs/documents/documents.jsp?docBean=process&readOnly=true"/><region:put section='entityForms' content="/programs/query/monitor/task/detailsForms.jsp?frmParent=E"/><region:put section='processForms' content="/programs/query/monitor/task/detailsForms.jsp?frmParent=P"/><region:put section='taskComments'><%@include file="../../../execution/includes/taskComments.jsp"%></region:put><region:put section='buttons'><button type="button" id="btnPrint" onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><form style="display:none" id="printForm" name="printForm" method="post" action="<%=Parameters.ROOT_PATH%>/frames/print.jsp" target="_blank"><input type="hidden" name="body" id="body"></form></region:put><form id="frmMain2" name="frmMain2" method="POST" style="display:none;"></form></region:render><%@include file="../../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/apiaFunctions.js"></script><script src="<%=Parameters.ROOT_PATH%>/programs/execution/tasks/task.js"></script><SCRIPT>
function tabSwitch(){
}

function btnBack_click() {
  if (<%= dBean.isFromHistory() %>) {
	document.getElementById("frmMain2").action = "query.MonitorTasksAction.do?action=backToHistory";
  } else if (<%= dBean.isQueryGoBack() %>) {
  	document.getElementById("frmMain2").action = "query.QueryAction.do?action=returnAction";
  } else if (<%= dBean.isFromQueryTaskMonitor() %>) {
  	document.getElementById("frmMain2").action = "query.TaskMonitorAction.do?action=backList";
  } else if (<%= dBean.isFromList() %>) {
  	document.getElementById("frmMain2").action = "query.MonitorTasksAction.do?action=backToList";  
  	//antes: action=backList
  } else {
  	document.getElementById("frmMain2").action = "query.MonitorTasksAction.do?action=search";
  }
  submitForm(document.getElementById("frmMain2"));
}

//***********************************************************//
//     NO CAMBIAR EL ORDEN EN QUE SE ESTABLECEN LOS DATOS    //
//***********************************************************//
function btnPrint_click() {
	var docFrame=document.getElementById("docFrame")
	if(docFrame){
		docFrame.src="";
	}
	try {
			if (!beforePrintFormsData_E()) {
				return;
			}
		} catch (e){}
		try {
			if (!beforePrintFormsData_P()) {
				return;
			}
		} catch (e){}
		
	
	
		var modal=openModal("/frames/blank.jsp", 680,400);
		function submitPrint(){
			document.getElementById("printForm").submit();
		    document.getElementById("printForm").body.value = "";
	    }
	    modal.onload=function(){
	    	submitPrint();
	    }
		var selectedTab = null;
		var divContentHeight = document.getElementById("divContent").style.height;
		//document.getElementById("divContent").style.height = "";
		document.getElementById("printForm").body.value = "";
		document.getElementById("printForm").body.value = processBodyToPrint();
	   //document.getElementById("divContent").style.height = divContentHeight;
	
	    //styleWin.focus();
		document.getElementById("printForm").target=modal.content.name;//"Print";
		
			
		try {
			if (!afterPrintFormsData_E()) {
				return;
			}
		} catch (e){}
		try {
			if (!afterPrintFormsData_P()) {
				return;
			}
		} catch (e){}
}

</SCRIPT><% 
/*
String strScript = (String)request.getAttribute("FORM_SCRIPTS");
if(strScript!=null){
	out.println(strScript);
}
*/
%>