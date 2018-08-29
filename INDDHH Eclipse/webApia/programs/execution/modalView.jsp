<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><script language="javascript">

window.returnValue="";

function submitError() {
	alert("error");
}

function submitOK() {
	alert("OK");
}

function closeWindow(x) {
	window.returnValue=x;
	window.close();
}
</script></head><body><iframe id=ifrMain style="height:100%;width:100%" FRAMEBORDER=0 src="<%=Parameters.ROOT_PATH%>/execution.EntInstanceAction.do?action=inModal&txtBusEntAdm=<%=request.getParameter("entName")%>&<%=request.getParameter("busEntId")!=null? "txtBusEntInstNum0=" + request.getParameter("busEntId")+"&":""%><%=request.getParameter("params")!=null? "params=" + request.getParameter("params")+"&":""%><%=request.getParameter("formNames")!=null? "formNames=" + request.getParameter("formNames")+"&":""%><%=request.getParameter("readonly")!=null? "readOnly=" + request.getParameter("readonly")+"&":""%><%=request.getParameter("showPrint")!=null? "showPrint=" + request.getParameter("showPrint")+"&":""%>inModal=true&chkSel0=on&readOnly=<%= request.getParameter("readOnly") %><%=(request.getParameter("windowId")!=null)?("&windowId="+request.getParameter("windowId").toString()):""%>"></iframe><!--<iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe> --><iframe style="display:none" name=ifrTarget id=ifrTarget src="" ></iframe></body><%@include file="../../components/scripts/server/endInc.jsp" %></HTML>

