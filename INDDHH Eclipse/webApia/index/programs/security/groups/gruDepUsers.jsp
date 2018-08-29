<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupBean"></jsp:useBean><%Collection colDeps = dBean.getDependencies();
  Iterator itDeps = colDeps.iterator();
  String usrLogin = request.getParameter("usrLogin"); 
  while (itDeps.hasNext()){
	  Object obj = itDeps.next();
		if (obj instanceof GruDepUsersVo){
			GruDepUsersVo gruDepUsrVo = (GruDepUsersVo) obj;
			if (gruDepUsrVo.getUsrLogin().equals(usrLogin)){
			%><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"titUsu")%></td><td></td></tr></table><div id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDat")%></div></td></tr><tr><td colspan=4 align=left><table><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblLog")%>: <%=dBean.fmtStr(gruDepUsrVo.getUsrLogin())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblNom")%>: <%=dBean.fmtStr(gruDepUsrVo.getUsrName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblEma")%>: <%=dBean.fmtStr(gruDepUsrVo.getUsrEmail())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblCom")%>: <%=dBean.fmtStr(gruDepUsrVo.getUsrComments())%></LI></td></tr></table></td></tr><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblEnvs")%></div></td></tr><tr><td colspan=4 align=left><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><tr><td><%Collection colEnvs = gruDepUsrVo.getUsrEnvs();
							   	  Iterator itEnvs = colEnvs.iterator();
							      while (itEnvs.hasNext()){%><LI class="liDep"><%=((EnvironmentVo)itEnvs.next()).getEnvName()%></LI><%}%></td></tr></tbody></table></td></tr></table></form></div><%}
		}
  }%><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

