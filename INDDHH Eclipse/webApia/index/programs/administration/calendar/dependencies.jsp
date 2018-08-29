<%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.vo.TaskSchedulerVo"%><%@page import="com.dogma.vo.PoolVo"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CalendarBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCal")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		 	Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnPro = true; boolean blnTskSch = true; boolean blnPool = true;
				boolean finShowPro = false; boolean finShowTskSch = false; boolean finShowPool = false;
				int countShownPro = 1; int countShownTskSch = 1; int countShownPool = 1;
				
				while (it.hasNext() && !finShowPro && !finShowTskSch) {
					Object obj = it.next();
					if (obj instanceof ProcessVo) {
						if (countShownPro > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPro) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowPro = true;
						} else if (!finShowPro){
							if (blnPro) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
								blnPro = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProName());
							countShownPro++;
						}
					}else if (obj instanceof TaskSchedulerVo) {
						if (countShownTskSch > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowTskSch) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowTskSch = true;
						} else if (!finShowTskSch){
							if (blnTskSch) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConTskSch")%></DIV><%
								blnTskSch = false;
							}
							out.print("<LI class=\"liDep\">" + ((TaskSchedulerVo) obj).getTskSchName());
							countShownTskSch++;
						}
					}else if (obj instanceof PoolVo) {
						if (countShownPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPool) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowPool = true;
						} else if (!finShowPool){
							if (blnPool) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPool")%></DIV><%
								blnPool = false;
							}
							out.print("<LI class=\"liDep\">" + ((PoolVo) obj).getPoolName());
							countShownTskSch++;
						}
					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%//@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.CalendarAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.CalendarAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>
