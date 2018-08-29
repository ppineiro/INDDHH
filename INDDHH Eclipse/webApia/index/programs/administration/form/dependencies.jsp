<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.FormBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titFor")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE><TR><TD valign="top"><table><thead><tr><%Collection col = dBean.getDependencies();
 							if (col!=null && col.size()>0) {%><th style="width:50%" title="<%=LabelManager.getToolTip(labelSet,"sbtDep")%>"><%=LabelManager.getName(labelSet,"sbtDep")%></th><%} %></tr></thead><tbody><%			
					if (col!=null && col.size()>0) {
						Iterator it = col.iterator();
						boolean blnProEleDep = true; 
						boolean blnBusEntForm = true; 
						boolean blnForm = true;
						boolean blnFFP = true;
						boolean finShowProEleDep = false; 
						boolean finShowBusEntForm = false; 
						boolean finShowForm = false;
						boolean finShowFFP = false;
						boolean blnProEleBusEntForm=true;
						int countShownProEleDep = 1; 
						int countShownBusEntForm = 1; 
						int countShownForm = 1;
						int countShownFFP = 1;
						while (it.hasNext()  && (!finShowProEleDep || !finShowProEleDep)) {
							Object obj = it.next();
							if (obj instanceof ProEleFormDepVo) {
								if (countShownProEleDep > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProEleDep) {
									%><tr><td style="height:10px;width:600px"><%									
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowProEleDep = true;
									%></td></tr><%
								} else if (!finShowProEleDep){
									%><tr><td style="height:10px;width:600px"><%							
									if (blnProEleDep) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepProEleFor")%></DIV><%
										blnProEleDep = false;
									}
									out.print("<LI class=\"liDep\"><a style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProEleFormDepVo) obj).getProId().toString() + "," + ((ProEleFormDepVo) obj).getProVerId().toString() + ")\"> " + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProEleFormDepVo) obj).getProcessName() + " (" + ((ProEleFormDepVo) obj).getProVerId() + ") - " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProEleFormDepVo) obj).getTaskName()+ "</p>");
									
									countShownProEleDep ++;
									%></td></tr><%
								}
							}else if (obj instanceof BusEntFormVo) {
								if (countShownBusEntForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntForm) {
									%><tr><td style="height:10px;width:600px"><%
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowBusEntForm = true;
									%></td></tr><%
								} else if (!finShowBusEntForm){
									%><tr><td style="height:10px;width:600px"><%
									if (blnBusEntForm) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusEntFor")%></DIV><%
										blnBusEntForm = false;
									}
									out.print("<LI class=\"liDep\"><a style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('BusEntityVo'," + ((BusEntFormVo) obj).getBusEntId().toString() + ")\"> " + ((BusEntFormVo) obj).getBusEntName() + " (" + ((BusEntFormVo) obj).getBusEntId().toString()+ ") </p>");
									countShownBusEntForm++;
									%></td></tr><%
								}
							}else if (obj instanceof ProEleBusEntFormVo) {
								if (countShownBusEntForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntForm) {
									%><tr><td style="height:10px;width:600px"><%
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowBusEntForm = true;
									%></td></tr><%
								} else if (!finShowBusEntForm){
									%><tr><td style="height:10px;width:600px"><%
									if (blnProEleBusEntForm) { %><DIV class="subTit"><%= LabelManager.getName(labelSet,"sbtDepProEleBusEntFor")%></DIV><%
										blnProEleBusEntForm = false;
									}
									out.print("<LI class=\"liDep\"><a style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProEleBusEntFormVo) obj).getProId().toString() + "," + ((ProEleBusEntFormVo) obj).getProVerId().toString() + ")\"> " + LabelManager.getName(labelSet,"lblPro") + ": " + ((ProEleBusEntFormDepVo) obj).getProcessName() + " (" + ((ProEleBusEntFormDepVo) obj).getProVerId() + ") - " + LabelManager.getName(labelSet,"lblEjeTar") + ": " + ((ProEleBusEntFormDepVo) obj).getTaskName()+ " - " + LabelManager.getName(labelSet,"lblEjeEnt") + ": " + ((ProEleBusEntFormDepVo) obj).getBusEntName()+ " </a>");
									countShownBusEntForm++;
									%></td></tr><%
								}
							}else if (obj instanceof FormVo){
								if (countShownForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowForm) {
									%><tr><td style="height:10px;width:600px"><%
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowForm = true;
									%></td></tr><%
								} else if (!finShowForm){
									%><tr><td style="height:10px;width:600px"><%
									if (blnForm) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepForView")%></DIV><%
										blnForm = false;
									}
									out.print("<LI class=\"liDep\">" + ((FormVo) obj).getFrmName());
									countShownForm++;
									%></td></tr><%
								}
							}else if (obj instanceof FrmFldPropertyVo){
								if (countShownFFP > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFFP) {
									%><tr><td style="height:10px;width:600px"><%
									out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
									finShowFFP = true;
									%></td></tr><%
								} else if (!finShowFFP){
									%><tr><td style="height:10px;width:600px"><%
									if (blnFFP) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepForProp")%></DIV><%
										blnFFP = false;
									}
									out.print("<LI class=\"liDep\">" + ((FrmFldPropertyVo) obj).getFrmName());
									countShownFFP++;
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
				  boolean blnFrms =true; 
			  	  boolean finShowFrms = false;
				  int countShownFrms = 1;
				 
					itAdInf = colAdInf.iterator();
//					Informacion adicional 				  				
					while (itAdInf != null && itAdInf.hasNext() && (!finShowFrms)) {
						%><tr><td style="height:10px;width:600px"><%	
						Object objAdInf = itAdInf.next();
							
						if (objAdInf instanceof FormVo) {
							if (countShownFrms > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFrms) {
								out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
								finShowFrms = true;
							} else if (!finShowFrms){
								if (blnFrms) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRelFrm")%></DIV><%
									blnFrms = false;
								}
								out.print("<LI class=\"liDep\">" + ((FormVo) objAdInf).getFrmName());
								countShownFrms++;
							}	
						}
						%></td></tr><%
					}//Fin While
				  }%></tbody></table></TD></TR></TABLE></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col!=null && col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%//@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.FormAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.FormAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>