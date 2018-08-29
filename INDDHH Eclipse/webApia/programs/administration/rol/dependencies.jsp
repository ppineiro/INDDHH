<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.RolBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titRol")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		 	Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true;
				boolean finShowProcess = false; boolean finShowProInstance = false;
				int countShownProcess = 1; int countShownProInstance = 1;
				
				while (it.hasNext() && (!finShowProcess || !finShowProInstance)) {
					Object obj = it.next();
					if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepProTsk")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProName() + "(" + ((ProcessVo) obj).getProVerId() +")" + " - " + ((ProcessVo) obj).getTaskName()) ;
							countShownProcess ++;
						}
					}else if (obj instanceof ProInstanceVo) {
						if (countShownProInstance > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInstance) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInstance = true;
						} else if (!finShowProInstance){
							if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProInstanceVo) obj).getIdentification() + " (" + ((ProInstanceVo) obj).getProName() + ")" );
							countShownProInstance ++;
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
	document.getElementById("frmMain").action = "administration.RolAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.RolAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>
