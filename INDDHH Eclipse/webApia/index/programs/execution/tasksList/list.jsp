<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><SCRIPT DEFER=true>
function tabSwitch(){
	var index=document.getElementById("samplesTab").getSelectedTabIndex();
	if(index==0){
		if (document.getElementById("dirtyMyTasks").value == "true") {
			setTimeout('try{window.frames["frameContent0"].refresh()}catch(e){}',200);
			document.getElementById("dirtyMyTasks").value = "false";
		}
	}
	if(index==1){
		if (document.getElementById("dirtyFreeTasks").value == "true") {
			setTimeout('try{window.frames["frameContent1"].refresh()}catch(e){}',200);
			document.getElementById("dirtyFreeTasks").value = "false";
		}
	}
		
	if(!MSIE){
		window.frames["frameContent"+index].emulateLoaded();
	}
}

var theDif=0;

function init(){
//	sizeMe();
	document.getElementById("frameContent0").src="<%=Parameters.ROOT_PATH%>/programs/execution/tasksList/clientList.jsp?listType=<%=com.dogma.bean.execution.ListTaskBean.WORKING_MODE_INPROCESS%>"+windowId;
	document.getElementById("frameContent1").src="<%=Parameters.ROOT_PATH%>/programs/execution/tasksList/clientList.jsp?listType=<%=com.dogma.bean.execution.ListTaskBean.WORKING_MODE_READY%>"+windowId;
/*	window.onresize=function(){
		if(navigator.userAgent.indexOf("MSIE")>0){
			window.event.cancelBubble = true;
		}
		sizeMe();
	}*/
	<%
	if(Parameters.READY_TASKS_FIRST){
		%>document.getElementById("dirtyMyTasks").value = "true";<%
	}
	
	%>
	
}

</SCRIPT></head><body onLoad="init()" class="listBody"><DIV id="divContent" style="overflow:hidden;"><div type="tabElement" id="samplesTab" x="2" ontabswitch="tabSwitch()"<%if( "R".equals(request.getParameter("workMode")) || (Parameters.READY_TASKS_FIRST && (request.getParameter("preFilter")==null || "null".equals(request.getParameter("preFilter")) ))){%> defaultTab="1"<%}%>><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,Parameters.SHOW_MY_TASKS?"tabEjeMisTar":"tabEjeTarAdq")%>" tabText="<%=LabelManager.getName(labelSet,Parameters.SHOW_MY_TASKS?"tabEjeMisTar":"tabEjeTarAdq")%>"><iframe id="frameContent0" name="frameContent0" border="0" scrolling="no" frameborder="0" width="100%" height="100%"></iframe></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeTarLib")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeTarLib")%>"><iframe id="frameContent1" name="frameContent1" border="0" scrolling="no" frameborder="0" width="100%" height="100%"></iframe></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabEjeTraTar")%>" tabText="<%=LabelManager.getName(labelSet,"tabEjeTraTar")%>"><iframe id="frameContent2" name="frameContent2" border="0" scrolling="no" frameborder="0" width="100%" height="100%" src="<%=Parameters.ROOT_PATH%>/frames/blank.jsp"></iframe></div></div><input type="hidden" id="dirtyMyTasks" value="false"><input type="hidden" id="dirtyFreeTasks" value="true"></DIV></body><script src="<%=Parameters.ROOT_PATH%>/programs/execution/tasksList/list.js" DEFER="true"></script><%@include file="../../../components/scripts/server/endInc.jsp" %></HTML>