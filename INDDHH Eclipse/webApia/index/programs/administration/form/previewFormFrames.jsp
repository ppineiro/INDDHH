<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><iframe id=ifrMain style="height:100%;width:100%;" FRAMEBORDER=0 src="<%=Parameters.ROOT_PATH%>/ViewEntityFormsAction.do?action=previewForm&frmId=<%=request.getParameter("frmId")%>&modalReadOnly=true&inModal=true"></iframe><iframe name="iframeMessages" id="iframeMessage" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" class="feedBackFrame" frameborder="no" style="display:none" ></iframe><iframe style="display:none" name=ifrTarget id=ifrTarget src="" ></iframe><%@include file="../../../components/scripts/server/endInc.jsp" %><script>

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
</script>