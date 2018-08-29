<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.EnvironmentsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titAmb")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection colDeps = dBean.getDependencies();
					  if (colDeps!=null && colDeps.size()>0){%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%
			  Iterator itDeps = null;
			  boolean blnFirst = true; boolean blnSec = true; 
			  boolean finShowProInst = false; boolean finShowBusEntInst = false;
			  int countShownProInst = 1; int countShownBusEntInst = 1; 
				
			  if (colDeps!=null && colDeps.size()>0){
				itDeps = colDeps.iterator();
									
				while (itDeps != null && itDeps.hasNext() && (!finShowProInst || !finShowBusEntInst)) {
					Object objDeps = itDeps.next();
					//Dependencias
					if (objDeps instanceof ProInstanceVo) {
						if (countShownProInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInst) {
							%><tr><td style="height:10px;width:600px"><%	
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInst = true;
							%></td></tr><%
						} else if (!finShowProInst){
							%><tr><td style="height:10px;width:600px"><%	
							if (blnFirst) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProInstanceVo) objDeps).getEntityIdentification(((ProInstanceVo) objDeps).getProInstNamePre(),((ProInstanceVo) objDeps).getProInstNameNum(),((ProInstanceVo) objDeps).getProInstNamePos()) + " (" + ((ProInstanceVo) objDeps).getProName() + ")" );
							countShownProInst++;
							%></td></tr><%
						}
					} else 	if (objDeps instanceof BusEntInstanceVo) {
						if (countShownBusEntInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInst) {
							%><tr><td style="height:10px;width:600px"><%	
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInst = true;
							%></td></tr><%
						} else if (!finShowBusEntInst){
							%><tr><td style="height:10px;width:600px"><%	
							if (blnSec) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsEnt")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntInstanceVo) objDeps).getEntityIdentification() + " (" + ((BusEntInstanceVo)objDeps).getBusEntName() + ")");
							countShownBusEntInst++;
							%></td></tr><%
						}
					}
				}//FIN WHILE
			}else{%><tr><td style="height:10px;width:600px"><%
					out.print(LabelManager.getName(labelSet,"lblNoDep"));
					%></td></tr><%
			}%></tbody></table></TD><%Collection colAdInf = dBean.getAdiInformation();
			 if (colAdInf!=null && colAdInf.size()>0){%><TD valign="top"><table><thead><tr><th style="width:50%; title="<%=LabelManager.getToolTip(labelSet,"lblRels")%>"><%=LabelManager.getName(labelSet,"lblRels")%></th></tr></thead><tbody><%
				  Iterator itAdInf = null;
				  boolean blnUser =true; boolean blnPool = true; boolean blnLbls =true; boolean blnLang =true;  boolean blnProf =true;
			  	  boolean finShowPool = false; boolean finShowUser = false; boolean finShowLbls=false; boolean finShowLang=false;
			      boolean finShowProf=false;
				  int countShownPool = 1; int countShownUser = 1; int countShownLbls =1; int countShownLang =1; int countShownProf =1;
				 
					itAdInf = colAdInf.iterator();
//					Informacion adicional 				  				
					while (itAdInf != null && itAdInf.hasNext() && (!finShowUser || !finShowPool || !finShowLbls || !finShowLang)) {
						%><tr><td style="height:10px;width:600px"><%	
						Object objAdInf = itAdInf.next();
							
						if (objAdInf instanceof UserVo) {
							if (countShownUser > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowUser) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowUser = true;
							} else if (!finShowUser){
								if (blnUser) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelUsu")%></DIV><%
									blnUser = false;
								}
								out.print("<LI class=\"liDep\">" + ((UserVo) objAdInf).getUsrLogin());
								countShownUser++;
							}	
						}else if (objAdInf instanceof PoolVo){
							if (countShownPool > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPool) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowPool = true;
							} else if (!finShowPool){
								if (blnPool) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelPoo")%></DIV><%
									blnPool = false;
								}
								out.print("<LI class=\"liDep\">" + ((PoolVo) objAdInf).getPoolName());
								countShownPool++;
							}
						}else if (objAdInf instanceof LblSetVo){
							if (countShownLbls > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowLbls) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowLbls = true;
							} else if (!finShowLbls){
								if (blnLbls) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelLbl")%></DIV><%
									blnLbls = false;
								}
								out.print("<LI class=\"liDep\">" + ((LblSetVo) objAdInf).getLblSetName());
								countShownLbls++;
							}
						}else if (objAdInf instanceof LanguageVo){
							if (countShownLang > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowLang) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowLang = true;
							} else if (!finShowLang){
								if (blnLang) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelLan")%></DIV><%
									blnLang = false;
								}
								out.print("<LI class=\"liDep\">" + ((LanguageVo) objAdInf).getLangName());
								countShownLang++;
							}
						}else if (objAdInf instanceof ProfileVo){
							if (countShownProf > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProf) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowProf = true;
							} else if (!finShowProf){
								if (blnProf) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelPro")%></DIV><%
									blnProf = false;
								}
								out.print("<LI class=\"liDep\">" + ((ProfileVo) objAdInf).getPrfName());
								countShownProf++;
							}
						}
						%></td></tr><%
					}//Fin While
				  }%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (colDeps.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "security.EnvironmentsAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "security.EnvironmentsAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>