<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.vo.custom.ProEleBusEntFormDepVo"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titTskSchedulers")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnProEleDep = true;
				boolean finShowProEleDep = false;
				int countShownProEleDep = 1;
				
				while (it.hasNext() && !finShowProEleDep) {
					Object obj = it.next();
					if (obj instanceof ProEleBusEntFormDepVo) {
						if (countShownProEleDep > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProEleDep) {
							%><tr><td style="height:10px;width:600px"><%									
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProEleDep = true;
							%></td></tr><%
						} else if (!finShowProEleDep){
							%><tr><td style="height:10px;width:600px"><%							
							if (blnProEleDep) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepProEleFor")%></DIV><%
								blnProEleDep = false;
							}
							//out.print("<LI class=\"liDep\">LabelManager.getName(labelSet,"lblPro") + ": " + ((ProEleBusEntFormDepVo) obj).getProcessName() + " (" + ((ProEleBusEntFormDepVo) obj).getProVerId() + ") - " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProEleBusEntFormDepVo) obj).getTaskName() + "</a>");
							out.print("<LI class=\"liDep\">" + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProEleBusEntFormDepVo) obj).getProcessName() + " - " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProEleBusEntFormDepVo) obj).getTaskName());
							countShownProEleDep ++;
							%></td></tr><%
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
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>