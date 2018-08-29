<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titUsu":"titUsuEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection colDeps = dBean.getDependencies();
						if (colDeps!=null && colDeps.size()>0) {%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%	
			
			if (colDeps!=null && colDeps.size()>0) {
				Iterator itDeps = colDeps.iterator();
				boolean blnFirst = true; 
				boolean blnFirstInst = true; 
				boolean blnFirstInstEnt = true;
				boolean blnSec = true; 
				boolean blnMess = true; 
				boolean blnFirstEle = true;
				boolean blnNotPool = true;
				boolean blnTskNotPool = true;
				boolean blnFirstScheduler = true;
				boolean blnFirstSubs = true;
				boolean blnWss = true;
				
				boolean finShowProEleInst = false; 
				boolean finShowProElementDep = false; 
				boolean finShowDocument = false;
				boolean finShowUser = false; 
				boolean finShowProInstance = false;
				boolean finShowBusEntInst = false;
				boolean finShoMess = false;
				boolean finNotPool = false;
				boolean finTskNotPool = false;
				boolean finShowSubs = false;
				boolean finScheduler = false;
				boolean finWss = false;
				
				int countShownProEleInst = 1; 
				int countShownProElementDep = 1; 
				int countShownDocument = 1;
				int countShownUser = 1; 
				int countShownProInstance = 1; 
				int countShownBusEntInst = 1;
				int countShownMess = 1;
				int countNotPool = 1;
				int countTskNotPool = 1;
				int countShowSubs = 1;
				int countScheduler = 1;
				int countWss = 1;
				
				while (itDeps.hasNext() && (!finShowProEleInst || !finShowProElementDep || !finShowDocument || !finShowUser|| !finShowProInstance|| !finShowBusEntInst || !finWss)) {
					Object objDeps = itDeps.next();
					//Dependencias
					if (objDeps instanceof UsersSubstitutesVo) {
						if (countShowSubs > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowSubs) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowSubs = true;
							%></td></tr><%
						} else if (!finShowSubs) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnFirstSubs) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepSubst")%></DIV><%
								blnFirstSubs = false;
							}
							out.print("<LI class=\"liDep\">" +  ((UsersSubstitutesVo)objDeps).getUsrLogin() + " : "  + dBean.fmtDate(((UsersSubstitutesVo)objDeps).getStartDate()) + " - "  + dBean.fmtDate(((UsersSubstitutesVo)objDeps).getStartDate()));
							countShowSubs ++;
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
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((SchBusClaActivityVo) objDeps).getSchName() + "</li>");
							countScheduler ++;
							%></td></tr><%
						}
						
					} else if (objDeps instanceof ProEleInstanceDepVo) {
						if (countShownProEleInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProEleInst) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProEleInst = true;
							%></td></tr><%
						} else if (!finShowProEleInst) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsTar")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openInformation2('ProcessVo'," + ((ProEleInstanceDepVo) objDeps).getProId().toString() + "," + ((ProEleInstanceDepVo) objDeps).getProVerId().toString() + ")\"> " + ((ProEleInstanceDepVo) objDeps).getEnvName() + " - " + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProEleInstanceDepVo) objDeps).getProName() + " ( " + ProInstanceVo.getEntityIdentification(((ProEleInstanceDepVo) objDeps).getProNamePre(),new Integer(((ProEleInstanceDepVo) objDeps).getProNameNum()),((ProEleInstanceDepVo) objDeps).getProNamePos()) + " ) " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProEleInstanceDepVo) objDeps).getTskName()+ "</a>");
							countShownProEleInst ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof ProElementDepVo){
						
						if (countShownProElementDep > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProElementDep) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProElementDep = true;
							%></td></tr><%
						} else if (!finShowProElementDep) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnFirstEle) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
								blnFirstEle = false;
							}
							out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openInformation2('ProcessVo'," + ((ProElementDepVo) objDeps).getProId().toString() + "," + ((ProElementDepVo) objDeps).getProVerId().toString() + ")\"> " + ((ProElementDepVo) objDeps).getEnvName() + " - " + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProElementDepVo) objDeps).getProName() + " - " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProElementDepVo) objDeps).getTskName()+ "</a>");
							countShownProElementDep ++;
							%></td></tr><%
						}

					} else if (objDeps instanceof DocumentVo) {
						if (countShownDocument > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowDocument) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowDocument = true;
							%></td></tr><%
						} else if (!finShowDocument) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepDoc")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((DocumentVo) objDeps).getEnvName() + " - " + ((DocumentVo) objDeps).getDocName());
							countShownDocument ++;		
							%></td></tr><%
						}
					} else if (objDeps instanceof UserVo) {
						
					} else if (objDeps instanceof ProInstanceVo) {
						if (countShownProInstance > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInstance) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInstance = true;
							%></td></tr><%
						} else if (!finShowProInstance) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnFirstInst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnFirstInst = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProInstanceVo) objDeps).getIdentification()  + " (" + ((ProInstanceVo)objDeps).getProName() + ")");
							countShownProInstance ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof BusEntInstanceVo) {
						if (countShownBusEntInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInst) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInst = true;
							%></td></tr><%
						} else if (!finShowBusEntInst) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnFirstInstEnt) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsBusEnt")%></DIV><%
								blnFirstInstEnt = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntInstanceVo) objDeps).getEntityIdentification()  + " (" + ((BusEntInstanceVo)objDeps).getBusEntName() + ")");
							countShownBusEntInst ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof EnvMsgPoolVo) {
						if (countShownMess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShoMess) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShoMess = true;
							%></td></tr><%
						} else if (!finShoMess) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnMess) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepMenAmb")%></DIV><%
								blnMess = false;
							}
							out.print("<LI class=\"liDep\">" + ((EnvMsgPoolVo) objDeps).getEnvName());
							countShownMess ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof ProNotPoolDepVo) {
						if (countNotPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finNotPool) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finNotPool = true;
							%></td></tr><%
						} else if (!finNotPool) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnNotPool) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepNotPro")%></DIV><%
								blnNotPool = false;
							}
							out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openInformation2('ProcessVo'," + ((ProNotPoolDepVo) objDeps).getProId().toString() + "," + ((ProNotPoolDepVo) objDeps).getProVerId().toString() + ")\"> " + ((ProNotPoolDepVo) objDeps).getEnvName() + " - " + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProNotPoolDepVo) objDeps).getProName() + "</a>");
							
							countNotPool ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof TskNotPoolDepVo) {
						if (countTskNotPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finTskNotPool) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finTskNotPool = true;
							%></td></tr><%
						} else if (!finTskNotPool) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnTskNotPool) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepNotTsk")%></DIV><%
								blnTskNotPool = false;
							}
							out.print("<LI class=\"liDep\"><a href=\"#\" style=\"text-decoration:underline\" title=\"" + LabelManager.getName(labelSet,"msgCliAdiInf") + "\" onClick=\"openInformation('TaskVo'," + ((TskNotPoolDepVo) objDeps).getTskId().toString()+ ")\"> " + ((TskNotPoolDepVo) objDeps).getEnvName() + " - " + LabelManager.getName(labelSet,"lblTask") + ": " + ((TskNotPoolDepVo) objDeps).getTskName() + "</a>");
							
							countNotPool ++;
							%></td></tr><%
						}
					} else if (objDeps instanceof WsPublicationVo) {
						if (countWss > Parameters.MAX_DEPENDENCIES_SHOWN && !finWss) {
							%><tr><td style="height:10px;width:600px"><%
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finWss = true;
							%></td></tr><%
						} else if (!finWss) {
							%><tr><td style="height:10px;width:600px"><%
							if (blnWss) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepWss")%></DIV><%
								blnWss = false;
							}
							out.print("<LI class=\"liDep\"> " + ((WsPublicationVo) objDeps).getEnvName() + " - " + LabelManager.getName(labelSet,"lblTask") + ": " + ((WsPublicationVo) objDeps).getWsName() + "</li>");
							
							countNotPool ++;
							%></td></tr><%
						}
					}
				}//FIN WHILE
			} else {%><tr><td style="height:10px;width:600px"><%
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
				%></td></tr><%
			}%></tbody></table></TD><%Collection colAdInf = dBean.getAdInformation();
			  if (colAdInf!=null && colAdInf.size()>0){ %><TD valign="top"><table><thead><tr><th style="width:50%; title="<%=LabelManager.getToolTip(labelSet,"lblRels")%>"><%=LabelManager.getName(labelSet,"lblRels")%></th></tr></thead><tbody><%
				 Iterator itAdInf = null;
				 boolean blnEnvs =true; boolean blnPool = true;
			  	 boolean finShowEnvs = false; boolean finShowPools= false;
				 int countShownEnvs = 1; int countShownPools = 1;
				 
				itAdInf = colAdInf.iterator();
//				Informacion adicional 				  				
					while (itAdInf != null && itAdInf.hasNext() && (!finShowEnvs)) {
						Object objAdInf = itAdInf.next();
						if (objAdInf instanceof PoolVo) {
							if (countShownPools > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPools) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowEnvs = true;
								%></td></tr><%
							} else if (!finShowPools){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnPool) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelPoo")%></DIV><%
									blnPool = false;
								}
								out.print("<LI class=\"liDep\">" + ((PoolVo) objAdInf).getPoolName());
								countShownPools++;
								%></td></tr><%
							}	
						}else if (objAdInf instanceof EnvironmentVo) {
							if (countShownEnvs > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvs) {
								%><tr><td style="height:10px;width:600px"><%	
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowEnvs = true;
								%></td></tr><%
							} else if (!finShowEnvs){
								%><tr><td style="height:10px;width:600px"><%	
								if (blnEnvs) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelEnv")%></DIV><%
									blnEnvs = false;
								}
								out.print("<LI class=\"liDep\">" + ((EnvironmentVo) objAdInf).getEnvName());
								countShownEnvs++;
								%></td></tr><%
							}	
						}
					}//Fin While
				  }%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (colDeps!=null && colDeps.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.UserAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.UserAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>	
