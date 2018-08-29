<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><iframe name=ifrMain id=ifrMain style="height:100%;width:100%" FRAMEBORDER=0 src="<%=Parameters.ROOT_PATH%>/ViewEntityFormsAction.do?action=populateGrid&frmName=<%=request.getParameter("frmName")%>&inModal=true&rowIndex=<%=request.getParameter("rowIndex")%>&frmId=<%=request.getParameter("frmId")%>&pagedGrid=<%=request.getParameter("pagedGrid")%>&frmParent=<%=request.getParameter("frmParent")%>&parent=<%=request.getParameter("parent")%>&modalReadOnly=<%=request.getParameter("modalReadOnly")%>&fldId=<%=request.getParameter("fldId")%>"></iframe><iframe style="display:none" name="ifrTarget" id="ifrTarget" src="" ></iframe><%@include file="../../components/scripts/server/endInc.jsp" %><script>

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