<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.DogmaAbstractBean"></jsp:useBean><% 
com.dogma.bean.administration.ReportBean auxBean = new com.dogma.bean.administration.ReportBean();
auxBean.initEnv(request);
ReportVo objVo = auxBean.getReportInfo(request); 
%><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"titReport")%></td><td></td></tr></table><div id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDat")%></div><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td><%=dBean.fmtStr(objVo.getRepName())%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%>:</td><td><%=dBean.fmtStr(objVo.getRepDesc())%></td></tr></table></form></div><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

