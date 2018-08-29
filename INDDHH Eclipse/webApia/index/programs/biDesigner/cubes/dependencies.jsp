<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCubes")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnViews = true;
				boolean blnWid = true;
				
				boolean finShowViews = false; 
				boolean finShowWid=false;

				int countShownViews = 1;
				int countShownWids = 1;
				
				while (it.hasNext() && (!finShowViews)) {
					Object obj = it.next();
					if (obj instanceof CubeViewVo) { //VISTAS
						if (countShownViews > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowViews) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowViews = true;
						} else if (!finShowViews){
							if (blnViews) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepView")%></DIV><%
								blnViews = false;
							}
							out.print("<LI class=\"liDep\">" + ((CubeViewVo) obj).getVwName());
							countShownViews ++;
						}
					}
					if (obj instanceof WidgetVo) { //WIDGETS
						if (countShownWids > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowWid) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowWid = true;
						} else if (!finShowViews){
							if (blnWid) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepWidgets")%></DIV><%
								blnWid = false;
							}
							out.print("<LI class=\"liDep\">" + ((WidgetVo) obj).getWidName());
							countShownWids ++;
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
	document.getElementById("frmMain").action = "biDesigner.CubeAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "biDesigner.CubeAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>