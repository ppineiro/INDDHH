<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.vo.custom.GruDepProcessVo"%><%@page import="com.dogma.vo.custom.GruDepUsersVo"%><%@page import="com.dogma.vo.custom.GruDepTasksVo"%><%@page import="com.dogma.vo.custom.GruDepProInstVo"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.scheduler.SchedulerBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSch")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection colDeps = dBean.getDependencies();
						if (colDeps!=null && colDeps.size()>0) {%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%
				if (colDeps!=null && colDeps.size()>0) {
					Iterator itDeps = colDeps.iterator();
	
					boolean blnFirstScheduler = true;

					boolean finScheduler = false;

					int countScheduler = 1;
			
					while (itDeps.hasNext() && (! finScheduler)) {

						Object objDeps = itDeps.next();
						//Dependencias
						if (objDeps instanceof SchBusClaActivityVo) {
							if (countScheduler > Parameters.MAX_DEPENDENCIES_SHOWN && !finScheduler) {
								%><tr><td style="height:10px;width:600px"><%
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finScheduler = true;
								%></td></tr><%
							} else if (!finScheduler) {
								%><tr><td style="height:10px;width:600px"><%
								if (blnFirstScheduler) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepScheduler")%></DIV><%
									blnFirstScheduler = false;
								}
								out.print("<LI class=\"liDep\">" + ((SchBusClaActivityVo) objDeps).getSchName() + "</li>");
								countScheduler ++;
								%></td></tr><%
							}
						}
					}//FIN WHILE
			} else {%><tr><td style="height:10px;width:600px"><%
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
				%></td></tr><%
			}%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (colDeps.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>