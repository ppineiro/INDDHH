<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupBean"></jsp:useBean><%Collection colDeps = dBean.getDependencies();
  Iterator itDeps = colDeps.iterator();

  while (itDeps.hasNext()){
	  Object obj = itDeps.next();
		if (obj instanceof GruDepProInstVo){
			GruDepProInstVo gruDepProInstVo = (GruDepProInstVo) obj;
			if (gruDepProInstVo.getProInstId().intValue() == (new Integer(request.getParameter("proInstId"))).intValue() &&
					gruDepProInstVo.getTskId().intValue() == (new Integer(request.getParameter("tskId"))).intValue()){
			%><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"lblTask")%></td><td></td></tr></table><div id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDat")%></div></td></tr><tr><td colspan=4 align=left><table><%if (gruDepProInstVo.getProInstPrjName() != null){ %><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"titPrj")%>: <%=dBean.fmtStr(gruDepProInstVo.getProInstPrjName())%></LI></td></tr><%} %><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblAmb")%>: <%=dBean.fmtStr(gruDepProInstVo.getProInstEnvName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblPro")%>: <%=dBean.fmtStr(gruDepProInstVo.getProInstProName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblProInst")%>: <%=dBean.fmtStr(gruDepProInstVo.getIdentification())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTask")%>: <%=dBean.fmtStr(gruDepProInstVo.getTskName())%></LI></td></tr></table></td></tr><% if (gruDepProInstVo.getProInstRoles().size() > 0){%><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"titRol")%></div></td></tr><tr><td colspan=4 align=left><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><tr><td><%Collection colRoles = gruDepProInstVo.getProInstRoles();
							   	  Iterator itRoles = colRoles.iterator();
							      while (itRoles.hasNext()){ %><LI class="liDep"><%=((RoleVo)itRoles.next()).getRolName()%></LI><%}%></td></tr></tbody></table></td></tr><%}%></table></form></div><%}
		}
  }%><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

