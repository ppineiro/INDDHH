<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.ProfileBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titPer":"titPerEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection col = dBean.getDependencies();
 							if (col!=null && col.size()>0) {%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%
					if (col!=null && col.size()>0) {
						Iterator it = col.iterator();
						boolean blnFirst = true; boolean blnFirstSubst = true;
						boolean finShowUsrProfile = false; boolean finShowSubst = false;
						int countShownUsrProfile = 1; int countShowSubst=1;
				
						while (it.hasNext() && !finShowUsrProfile) {
							Object objDeps = it.next();
//							Dependencias
							if(objDeps instanceof UsrSubstituteProfileVo){
								
								if (countShowSubst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowSubst) {
									%><tr><td style="height:10px;width:600px"><%	
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowSubst = true;
									%></td></tr><%
								} else if (!finShowSubst){
									%><tr><td style="height:10px;width:600px"><%	
									if (blnFirstSubst) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepSubst")%></DIV><%
										blnFirstSubst = false;
									}
									UsrSubstituteProfileVo subDeps = (UsrSubstituteProfileVo)objDeps;
									out.print("<LI class=\"liDep\">" + subDeps.getUsrLogin() );
									countShowSubst ++;	
									%></td></tr><%
								}
								
								
								
							}else if (objDeps instanceof UsrProfileVo) {
								if (countShownUsrProfile > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowUsrProfile) {
									%><tr><td style="height:10px;width:600px"><%
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowUsrProfile = true;
									%></td></tr><%
								} else if (!finShowUsrProfile){
									%><tr><td style="height:10px;width:600px"><%
									if (blnFirst) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepUsu")%></DIV><%
										blnFirst = false;
									}
									out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('UserVo','" + ((UsrProfileVo) objDeps).getUsrLogin() + "')\"> " + ((UsrProfileVo) objDeps).getUsrLogin() + "</a>");
									countShownUsrProfile ++;
									%></td></tr><%
								}
							}
						}//FIN WHILE
			} else {%><tr><td style="height:10px;width:600px"><%
					out.print(LabelManager.getName(labelSet,"lblNoDep"));
					%></td></tr><%
			}%></tbody></table></TD><%Collection colAdInf = dBean.getAdInformation();
			 if (colAdInf!=null && colAdInf.size()>0){%><TD valign="top"><table><thead><tr><th style="width:50%; title="<%=LabelManager.getToolTip(labelSet,"lblRels")%>"><%=LabelManager.getName(labelSet,"lblRels")%></th></tr></thead><tbody><%
				  Iterator itAdInf = null;
				  boolean blnEnvs =true; 
			  	  boolean finShowEnvs = false;
				  int countShownEnvs = 1;
				 
					itAdInf = colAdInf.iterator();
//					Informacion adicional 				  				
					while (itAdInf != null && itAdInf.hasNext() && (!finShowEnvs)) {
						%><tr><td style="height:10px;width:600px"><%	
						Object objAdInf = itAdInf.next();
							
						if (objAdInf instanceof EnvironmentVo) {
							if (countShownEnvs > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvs) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowEnvs = true;
							} else if (!finShowEnvs){
								if (blnEnvs) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelEnv")%></DIV><%
									blnEnvs = false;
								}
								out.print("<LI class=\"liDep\">" + ((EnvironmentVo) objAdInf).getEnvName());
								countShownEnvs++;
							}	
						}
						%></td></tr><%
					}//Fin While
				  }%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.ProfilesAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.ProfilesAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>