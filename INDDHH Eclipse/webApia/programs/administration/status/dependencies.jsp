<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesStatusBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSta")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
		 	Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true; boolean blnPro = true;
				boolean finShowBusEntity = false; boolean finShowBusEntInstance = false; boolean finShowProcess = false;
				int countShownBusEntity = 1; int countShownBusEntInstance = 1; int countShownProcess = 1;
 
				
				while (it.hasNext() && (!finShowBusEntity || !finShowBusEntInstance || !finShowProcess)) {
					Object obj = it.next();
					if (obj instanceof BusEntityVo) {
						if (countShownBusEntity > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntity) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntity = true;
						} else if (!finShowBusEntity) {
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusEnt")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntityVo) obj).getBusEntName());
							countShownBusEntity++;
						}
					} else if (obj instanceof BusEntInstanceVo) {
						if (countShownBusEntInstance > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInstance) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInstance = true;
						} else if (!finShowBusEntInstance) {
							if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsEnt")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntInstanceVo) obj).getEntityIdentification());
							countShownBusEntInstance++;
						}
					}else if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess) {
							if (blnPro) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
								blnPro = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProName());
							countShownProcess ++;
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
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>
