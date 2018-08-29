<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ClasificationBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCla")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
				Collection col = dBean.getDependencies();
				if (col!=null && col.size()>0) {
					Iterator it = col.iterator();
					boolean blnFirst = true;
					boolean blnSec = true;
					boolean finShowPro = false;
					boolean finShowCla = false;
					int countShownPro = 1;
					int countShownCla = 1;
					
					while (it.hasNext() && (!finShowPro || !finShowCla)) {
						Object obj = it.next();
						if (obj instanceof ProcessVo) {
							if (countShownPro > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPro) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowPro = true;
							} else if (!finShowPro){
								if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
									blnFirst = false;
								}
		 						out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProcessVo) obj).getProId().toString() + "," + ((ProcessVo) obj).getProVerId().toString() + ")\"> " + ((ProcessVo) obj).getProName() + "</p>");
		 						countShownPro++;
							}
						}else if (obj instanceof ClaTreeVo) {
							if (countShownCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowCla) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowCla = true;
							} else if (!finShowCla){
								if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConCla")%></DIV><%
									blnSec = false;
								}
								out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('ClaTreeVo'," + ((ClaTreeVo) obj).getClaTreId().toString() + ")\"> " + ((ClaTreeVo) obj).getClaTreName() + "</p>");
								countShownCla++;
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
	document.getElementById("frmMain").action = "administration.ClasificationsAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.ClasificationsAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>