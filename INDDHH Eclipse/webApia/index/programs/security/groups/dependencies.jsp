<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.vo.custom.GruDepProcessVo"%><%@page import="com.dogma.vo.custom.GruDepUsersVo"%><%@page import="com.dogma.vo.custom.GruDepTasksVo"%><%@page import="com.dogma.vo.custom.GruDepProInstVo"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titGru":"titGruEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection colDeps = dBean.getDependencies();
						if (colDeps!=null && colDeps.size()>0) {%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%
				if (colDeps!=null && colDeps.size()>0) {
					Iterator itDeps = colDeps.iterator();
	
					boolean blnFirstInst = true; boolean blnFirstDoc = true; boolean blnFirstDef = true;
					boolean blnFirstUsu = true; boolean blnFirstMsg = true; boolean blnFristTsk = true;
					boolean blnFirstPool = true; boolean blnFirstSubst = true;
					boolean blnFirstScheduler = true;

					boolean finShowProInst = false; boolean finShowDocument = false; boolean finShowProcess = false;
					boolean finShowUsrPool = false; boolean finShowTask = false; boolean finShowEnvMsgPool = false;
					boolean finShowPool = false; boolean finShowSubst = false;
					boolean finScheduler = false;

					int countShownProInst = 1; int countShownDocument = 1; int countShownProcess = 1;
					int countShownUsrPool = 1; int countShownTask = 1; int countShownEnvMsgPool = 1;
					int countShownPool = 1;	int countShowSubst = 1;
					int countScheduler = 1;
					
					Collection<Integer> process = new ArrayList<Integer>();
			
					while (itDeps.hasNext() && (!finShowProInst || !finShowDocument || !finShowProcess || !finShowUsrPool || !finShowTask || !finShowEnvMsgPool || !finScheduler)) {

						Object objDeps = itDeps.next();
						//Dependencias
						if(objDeps instanceof UsrSubstitutePoolVo){
						
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
								UsrSubstitutePoolVo subDeps = (UsrSubstitutePoolVo)objDeps;
								out.print("<LI class=\"liDep\">" + subDeps.getUsrSubstituteLogin() );
								countShowSubst ++;	
								%></td></tr><%
							}
							
						} else if (objDeps instanceof SchBusClaActivityVo) {
							if (countScheduler > Parameters.MAX_DEPENDENCIES_SHOWN && !finScheduler) {
								%><tr><td style="height:10px;width:600px"><%
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finScheduler = true;
								%></td></tr><%
							} else if (!finScheduler) {
								%><tr><td style="height:10px;width:600px"><%
								if (blnFirstScheduler) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepScheduler")%></DIV><%
									blnFirstScheduler = false;
								}
								out.print("<LI class=\"liDep\">" + ((SchBusClaActivityVo) objDeps).getSchName() + "</li>");
								countScheduler ++;
								%></td></tr><%
							}
							
						}else if (objDeps instanceof GruDepProInstVo) {
							if (countShownProInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInst) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowProInst = true;
								%></td></tr><%
							} else if (!finShowProInst){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFirstInst) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
									blnFirstInst = false;
								}
								GruDepProInstVo gruDeps = (GruDepProInstVo)objDeps;
								out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openProInstInformation(" + ((GruDepProInstVo) objDeps).getProInstId() + ", " + ((GruDepProInstVo) objDeps).getTskId() + ")\"> " + gruDeps.getIdentification() + " (" + gruDeps.getProInstProName()+ " - " + ((GruDepProInstVo) objDeps).getTskName() + ")</a>");
								countShownProInst ++;	
								%></td></tr><%
							}
						} else if (objDeps instanceof DocumentVo) {
							if (countShownDocument > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowDocument) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowDocument = true;
								%></td></tr><%
							} else if (!finShowDocument){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFirstDoc) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepDoc")%></DIV><%
									blnFirstDoc = false;
								}
								out.print("<LI class=\"liDep\">" + ((DocumentVo) objDeps).getDocName());
								countShownDocument ++;	
								%></td></tr><%
							}
						} else if (objDeps instanceof GruDepProcessVo) {
							if(!process.contains(((GruDepProcessVo) objDeps).getProId())) {
								process.add(((GruDepProcessVo) objDeps).getProId());
							
								if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
									%><tr><td style="height:10px;width:600px"><%	
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowProcess = true;
									%></td></tr><%
								} else if (!finShowProcess){
									%><tr><td style="height:10px;width:600px"><%	
									if (blnFirstDef) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepPro")%></DIV><%
										blnFirstDef = false;
									}
									out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openGroupInformation(" + ((GruDepProcessVo) objDeps).getProId() + ")\"> " + ((GruDepProcessVo) objDeps).getProName() + "</a>");
									countShownProcess++;
									%></td></tr><%
								}
							}
						} else if (objDeps instanceof GruDepUsersVo) {
							if (countShownUsrPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowUsrPool) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowUsrPool = true;
								%></td></tr><%
							} else if (!finShowUsrPool){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFirstUsu) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepUsu")%></DIV><%
									blnFirstUsu = false;
								}
								out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openUserInformation('" + ((GruDepUsersVo) objDeps).getUsrLogin() + "')\"> " + ((GruDepUsersVo) objDeps).getUsrLogin() + "</a>");
								countShownUsrPool++;
								%></td></tr><%
							}
						} else 	if (objDeps instanceof GruDepTasksVo) {
							if (countShownTask > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowTask) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowTask = true;
								%></td></tr><%
							} else if (!finShowTask){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFristTsk) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepTsk")%></DIV><%
									blnFristTsk = false;
								}
								out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openTaskInformation('" + ((GruDepTasksVo) objDeps).getTskId() + "')\"> " + ((GruDepTasksVo) objDeps).getTskName() + " (" + ((GruDepTasksVo) objDeps).getTskEnvName() + ")" + "</a>");
								countShownTask ++;
								%></td></tr><%
							}
						} else if (objDeps instanceof EnvMsgPoolVo) {
							if (countShownEnvMsgPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvMsgPool) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowEnvMsgPool = true;
								%></td></tr><%
							} else if (!finShowEnvMsgPool){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFirstMsg) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepMenAmb")%></DIV><%
									blnFirstMsg = false;
								}
								out.print("<LI class=\"liDep\">" + ((EnvMsgPoolVo) objDeps).getEnvName() + (dBean.isModeGlobal()?": '"+((EnvMsgPoolVo) objDeps).getMessage()+".'":""));
								countShownEnvMsgPool++;
								%></td></tr><%
							}
						} else if (objDeps instanceof PoolHierarchyVo) {
							if (countShownPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPool) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowPool = true;
								%></td></tr><%
							} else if (!finShowPool){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnFirstPool) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepEstJer")%></DIV><%
									blnFirstPool = false;
								}
								out.print("<LI class=\"liDep\">" + LabelManager.getName(labelSet,"lblEstJer" + (dBean.isModeGlobal()?"":"Env")));
								countShownPool++;
								%></td></tr><%
							}
						}
					}//FIN WHILE
			} else {%><tr><td style="height:10px;width:600px"><%
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
				%></td></tr><%
			}%></tbody></table></TD><%Collection colAdInf = dBean.getAdiInformation();
			  if (colAdInf!=null && colAdInf.size()>0){ %><TD valign="top"><table><thead><tr><th style="width:50%; title="<%=LabelManager.getToolTip(labelSet,"lblRels")%>"><%=LabelManager.getName(labelSet,"lblRels")%></th></tr></thead><tbody><%
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
				  }%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (colDeps.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.GroupsAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.GroupsAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
function openGroupInformation(proId){
	openModal("/programs/security/groups/gruDepProcess.jsp?proId=" + proId,510,350);
}
function openUserInformation(usrLogin){
	openModal("/programs/security/groups/gruDepUsers.jsp?usrLogin=" + usrLogin,510,350);
}
function openTaskInformation(tskId){
	openModal("/programs/security/groups/gruDepTasks.jsp?tskId=" + tskId,510,350);
}
function openProInstInformation(proInstId, tskId){
	openModal("/programs/security/groups/gruDepProInst.jsp?proInstId=" + proInstId + "&tskId=" + tskId,510,350);
}
</script>