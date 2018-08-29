<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.LanguageBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titLen")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirstEnv = true; boolean blnFirstLbl = true;
				boolean finShowEnvironment = false; boolean finShowLblSet = false;
				int countShownEnvironment = 0; int countShownLblSet = 0;
								
				while (it.hasNext() && (!finShowEnvironment || !finShowLblSet)) {
					Object obj = it.next();
					if (obj instanceof EnvironmentVo) {
						if (countShownEnvironment > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvironment) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowEnvironment = true;
						} else if (!finShowEnvironment){
							if (blnFirstEnv){%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepEnv")%></DIV><%
 								blnFirstEnv = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((EnvironmentVo) obj).getEnvName());
 							countShownEnvironment ++;
						}
					}else if (obj instanceof LblSetVo) {
						if (countShownLblSet > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowLblSet) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowLblSet = true;
						} else if (!finShowLblSet){
							if (blnFirstLbl) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepLbl")%></DIV><%
								blnFirstLbl = false;
							}
							out.print("<LI class=\"liDep\">" + ((LblSetVo) obj).getLblSetName());
							countShownLblSet ++;
						}
					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.LanguageAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.LanguageAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>