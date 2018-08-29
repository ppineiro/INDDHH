<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.LabelBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEti")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true;
				boolean finShowEnvironment = false; boolean finShowParameters = false;
				int countShownEnvironment = 1; int countShownParameters = 1;

				while (it.hasNext() && (!finShowEnvironment || !finShowParameters)) {
					Object obj = it.next();
					if (obj instanceof EnvironmentVo) {
						if (countShownEnvironment > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvironment) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowEnvironment = true;
						} else if (!finShowEnvironment){
							if (blnFirst) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepEnv")%></DIV><%						blnFirst = false;
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((EnvironmentVo) obj).getEnvName());
							countShownEnvironment ++;
						}
					} else if (obj instanceof ParametersVo) {
						if (countShownParameters > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowParameters) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowParameters = true;
						} else if (!finShowParameters){
							if (blnSec) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepParDefLbl")%></DIV><%
								blnSec = false;
  							}
 							out.print("<LI class=\"liDep\">" + LabelManager.getName(labelSet,"lblDepParDefLbl"));
 							countShownParameters ++;
						} 
					}
				}
			}else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));	
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.LabelsAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>
