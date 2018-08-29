<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><form id="frmMain" name="frmMain" method="POST"><jsp:useBean id="bean" scope="session" class="com.dogma.bean.execution.TestForm"></jsp:useBean><%

//com.dogma.bean.execution.TestForm bean = new com.dogma.bean.execution.TestForm();
bean.init(request);
out.print(bean.getForm());
%></form><button type="button" onclick="btnSub()">submitear</button></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script>
function btnSub() {
	document.getElementById("frmMain").action="testForm2.jsp";
	frmMain.submit();
}
</script>