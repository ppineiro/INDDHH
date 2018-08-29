<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupBean"></jsp:useBean><%Collection colDeps = dBean.getDependencies();
  Iterator itDeps = colDeps.iterator();

  while (itDeps.hasNext()){
	  Object obj = itDeps.next();
		if (obj instanceof GruDepTasksVo){
			GruDepTasksVo gruDepTskVo = (GruDepTasksVo) obj;
			if (gruDepTskVo.getTskId().intValue() == (new Integer(request.getParameter("tskId"))).intValue()){
			%><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"titTar")%></td><td></td></tr></table><div id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDat")%></div></td></tr><tr><td colspan=4 align=left><table><%if (gruDepTskVo.getTskProName() != null){ %><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"titPrj")%>: <%=dBean.fmtStr(gruDepTskVo.getTskProName())%></LI></td></tr><%} %><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblAmb")%>: <%=dBean.fmtStr(gruDepTskVo.getTskEnvName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblNom")%>: <%=dBean.fmtStr(gruDepTskVo.getTskName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"lblDes")%>: <%=dBean.fmtStr(gruDepTskVo.getTskDesc())%></LI></td></tr></table></td></tr><% if (gruDepTskVo.isTskReasign()){%><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblAccUtil")%></div></td></tr><tr><td colspan=4 align=left><table><tr><td><LI class="liDep"><%=LabelManager.getToolTip(labelSet,"lblReaTskGru")%></LI></td></tr></table></td></tr><%}%><% if (gruDepTskVo.getTskNotType().size() > 0){%><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblNotUtil")%></div></td></tr><tr><td colspan=4 align=left><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><tr><td><%Collection notPool = gruDepTskVo.getTskNotType();
							   	  Iterator itNotPool = notPool.iterator();
							      while (itNotPool.hasNext()){
									 String event = (String)itNotPool.next();
								   	 if (TskNotPoolVo.NOTIFICATION_EVENT_ACQUIRED.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskAcq")%></LI><%}
  							  	     if (TskNotPoolVo.NOTIFICATION_EVENT_ALERT.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskAle")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_ASIGN.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskAsi")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_COMPLEAT.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskCom")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_DELEGATE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskDele")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_ELEVATE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskEle")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_OVERDUE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskOver")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_REASIGN.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskRea")%></LI><%}
								     if (TskNotPoolVo.NOTIFICATION_EVENT_RELEASE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblTskRel")%></LI><%}
						      	   }%></td></tr></tbody></table></td></tr><%}%></table></form></div><%}
		}
  }%><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

