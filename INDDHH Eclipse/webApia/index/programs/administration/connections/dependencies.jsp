<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ConnectionsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCon")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirstBusCla = true; boolean blnFirstQuery = true;
				boolean blnFirstReport = true; boolean blnFirstCube = true;
				boolean finShowBusCla = false; boolean finShowQuery = false;
				boolean finShowReport = false; boolean finShowCube = false;
				int countShownBusCla = 1; int countShownQuery = 1;
				int countShownReport = 1; int countShownCube = 1;
				
				while (it.hasNext() && (!finShowBusCla || !finShowQuery || !finShowReport || !finShowCube)) {
					Object obj = it.next();
					if (obj instanceof BusClassVo) {
						if (countShownBusCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusCla) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusCla = true;
						} else if (!finShowBusCla){
							if (blnFirstBusCla) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusCla")%></DIV><%
								blnFirstBusCla = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('BusClassVo'," + ((BusClassVo) obj).getBusClaId().toString() + ")\"> " + ((BusClassVo) obj).getBusClaName() + "</p>");
							countShownBusCla++;
						}
					}else if (obj instanceof QueryVo) {
						if (countShownQuery > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuery) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowQuery = true;
						} else if (!finShowQuery){
							if (blnFirstQuery) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepQue")%></DIV><%
								blnFirstQuery = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('QueryVo'," + ((QueryVo) obj).getQryId().toString() + ")\"> " + ((QueryVo) obj).getQryName() + "</p>");
							countShownQuery++;
						}
 					}else if (obj instanceof ReportVo) {
						if (countShownReport > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowReport) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowReport = true;
						} else if (!finShowReport){
							if (blnFirstReport) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepRep")%></DIV><%
								blnFirstReport = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('ReportVo'," + ((ReportVo) obj).getRepId().toString() + ")\"> " + ((ReportVo) obj).getRepName() + "</p>");
							countShownReport++;
						}
 					}else if (obj instanceof CubeVo) {
						if (countShownCube > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowCube) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowCube = true;
						} else if (!finShowCube){
							if (blnFirstCube) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepCubes")%></DIV><%
								blnFirstCube = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('CubeVo'," + ((CubeVo) obj).getCubeId().toString() + ")\"> " + ((CubeVo) obj).getCubeName() + "</p>");
							countShownCube++;
						}
 					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%//@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.ConnectionsAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.ConnectionsAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>
