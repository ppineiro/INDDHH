<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.DogmaAbstractBean"></jsp:useBean><% BusClassVo busClassVo = com.dogma.bean.administration.BusinessClassesBean.getBusinessClassInfo(request); %><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"titClaNeg")%></td><td></td></tr></table><div id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDat")%></div><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td><%=dBean.fmtStr(busClassVo.getBusClaName())%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblTipCla")%>"><%=LabelManager.getName(labelSet,"lblTipCla")%>:</td><td><%
						if(BusClassVo.TYPE_WEB_SERVICE.equals(busClassVo.getBusClaType())){
							out.print(LabelManager.getName(labelSet,"lblTipClaWS"));
						} else if(BusClassVo.TYPE_DATA_BASE.equals(busClassVo.getBusClaType())){
							out.print(LabelManager.getName(labelSet,"lblTipClaDB"));
						} else if(BusClassVo.TYPE_JSCPT_PROGRAMMING.equals(busClassVo.getBusClaType())){
							out.print(LabelManager.getName(labelSet,"lblTipClaScr"));
						} else if(BusClassVo.TYPE_JAVA_PROGRAMMING.equals(busClassVo.getBusClaType())){
							out.print(LabelManager.getName(labelSet,"lblTipClaJav"));
						}
					%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%>:</td><td colspan=3><%=dBean.fmtStr(busClassVo.getBusClaDesc())%></td></tr></table></form></div><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

