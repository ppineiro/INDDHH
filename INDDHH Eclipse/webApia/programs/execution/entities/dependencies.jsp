<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.EntInstanceBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeEnt")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true;
				boolean finShowBusEntInst = false; boolean finShowProInst = false;
				int countShownBusEntInst = 1; int countShownProInst = 1;
				
				while (it.hasNext() && (!finShowBusEntInst || !finShowProInst)) {
					Object obj = it.next();
					if (obj instanceof BusEntInstanceVo) {
						if (countShownBusEntInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInst) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInst = true;
						} else if(!finShowBusEntInst){
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepEntInstAtt")%></DIV><%
 								blnFirst = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((BusEntInstanceVo) obj).getEntityIdentification() + " (" + ((BusEntInstanceVo) obj).getEntityType().getBusEntName() + ")");
 							countShownBusEntInst ++;
						}
					} else if (obj instanceof ProInstanceVo) {
						if (countShownProInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInst) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInst = true;
						} else if(!finShowProInst){
							if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepProInstAtt")%></DIV><%
 								blnSec = false;
 							}
 							if (((ProInstanceVo) obj).getAttName() == null) {
	 							out.print("<LI class=\"liDep\">" + ((ProInstanceVo) obj).getIdentification());
	 						} else {
 								out.print("<LI class=\"liDep\">" + ((ProInstanceVo) obj).getIdentification() + " - " + ((ProInstanceVo) obj).getAttName());
 							}
 							countShownProInst ++;
						}
					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
var QUERY_ADMIN = <%= dBean.isQueryAdministration() %>;
</SCRIPT><script language="javascript">
function btnExit_click(){
	splash();
}

function btnBack_click(){
	if (QUERY_ADMIN) {
		document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=backToList";
	} else {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
	}
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>