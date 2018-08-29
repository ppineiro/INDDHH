<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.FunctionalityBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titFun":"titFunEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><%Collection colDeps = dBean.getDependencies();
			  Iterator itDeps = null;
			  boolean blnQuerys = true; boolean blnProfiles = true;  boolean blnBusEnt = true;
			  boolean finShowQuerys = false; boolean finShowProfiles = false; boolean finShowBusEnt = false;
			  int countShownQuerys = 1; int countShownProfiles = 1; int countShownBusEnt = 1; 
				
			  if (colDeps!=null && colDeps.size()>0){
				itDeps = colDeps.iterator();
									
				while (itDeps != null && itDeps.hasNext() && (!finShowQuerys || !finShowProfiles || !finShowBusEnt)) {
					Object objDeps = itDeps.next();
					//Dependencias
					if (objDeps instanceof QueryVo) {
						if (countShownQuerys > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuerys) {
							%><tr><td style="height:10px;width:600px"><%	
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowQuerys = true;
							%></td></tr><%
						} else if (!finShowQuerys){
							%><tr><td style="height:10px;width:600px"><%	
							if (blnQuerys) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConQry")%></DIV><%
								blnQuerys = false;
							}
							out.print("<LI class=\"liDep\">" + ((QueryVo) objDeps).getQryName());
							countShownQuerys++;
							%></td></tr><%
						}
					} else if (objDeps instanceof ProfileVo) {
						if (countShownProfiles > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProfiles) {
							%><tr><td style="height:10px;width:600px"><%	
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProfiles = true;
							%></td></tr><%
						} else if (!finShowProfiles){
							%><tr><td style="height:10px;width:600px"><%	
							if (blnProfiles) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPrf")%></DIV><%
								blnProfiles = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProfileVo) objDeps).getPrfName());
							countShownProfiles++;
							%></td></tr><%
						}
					}else if (objDeps instanceof BusEntityVo) {
						if (countShownBusEnt > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEnt) {
							%><tr><td style="height:10px;width:600px"><%	
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEnt = true;
							%></td></tr><%
						} else if (!finShowBusEnt){
							%><tr><td style="height:10px;width:600px"><%	
							if (blnBusEnt) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusEnt")%></DIV><%
								blnBusEnt = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntityVo) objDeps).getBusEntName());
							countShownBusEnt++;
							%></td></tr><%
						}
					}

				}//FIN WHILE
			}else{%><tr><td><%
					out.print(LabelManager.getName(labelSet,"lblNoDep"));
					%></td></tr><%
			}%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (colDeps.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>