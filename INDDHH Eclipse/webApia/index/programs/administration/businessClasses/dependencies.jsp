<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BusinessClassesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titClaNeg")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirstPro = true; boolean blnFirstFrm = true; boolean blnFirstFld = true;
				boolean blnFirstEle = true;	boolean blnFirstSch = true; boolean blnFristEnt = true;
				boolean blnFirstQry = true; boolean blnFirstWid = true; boolean blnProEleEvtBusClass = true;
				
				boolean finShowProcess = false; boolean finShowFrmFldEvtBusCla = false; boolean finShowForm = false;
				boolean finShowProEleEvtBusCla = false; boolean finShowSchBusClaAct = false;
				boolean finShowBusEntEvtBusCla = false; boolean finShowQuery = false; boolean finShowWidgets = false;
				
				int countShownProcess = 1; int countShownFrmFldEvtBusCla = 1; int countShownForm = 1;
				int countShownProEleEvtBusCla = 1; int countShownSchBusClaAct = 1;
				int countShownBusEntEvtBusCla = 1; int countShownQuery = 1; int countShownWidgets = 1;
				
 				while (it.hasNext() && (!finShowProcess || !finShowFrmFldEvtBusCla || !finShowForm || !finShowProEleEvtBusCla || !finShowSchBusClaAct || !finShowBusEntEvtBusCla || !finShowQuery || !finShowWidgets)) {
 					Object obj = it.next();
					if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnFirstPro) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepPro")%></DIV><%
 								blnFirstPro = false;
 							}
 							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProcessVo) obj).getProId().toString() + "," + ((ProcessVo) obj).getProVerId().toString() + ")\"> " + ((ProcessVo) obj).getProName() + "</a>");
 							countShownProcess ++;
						}
					} else if (obj instanceof FrmFldEvtBusClassVo) {
						if (countShownFrmFldEvtBusCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFrmFldEvtBusCla) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowFrmFldEvtBusCla = true;
						} else if (!finShowFrmFldEvtBusCla){
 							if (blnFirstFld) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepFrmFld")%></DIV><%
								blnFirstFld = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((FrmFldEvtBusClassVo) obj).getFormName() + " - " + ((FrmFldEvtBusClassVo) obj).getFrmFldLabel());
 							countShownFrmFldEvtBusCla ++;
						}
 					} else if (obj instanceof FormVo) {
 						if (countShownForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowForm) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowForm = true;
						} else if (!finShowForm){
	 						if (blnFirstFrm) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepFrm")%></DIV><%
								blnFirstFrm = false;
 							}
 							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('FormVo'," + ((FormVo) obj).getFrmId().toString() + ")\"> " + ((FormVo) obj).getFrmName() + "</a>");
 							countShownForm++;
						}
 					} else if (obj instanceof ProEleEvtBusClassVo) {
 						if (countShownProEleEvtBusCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProEleEvtBusCla) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
 							finShowProEleEvtBusCla = true;
 						} else if (!finShowProEleEvtBusCla){
 							if (blnProEleEvtBusClass) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepProEle")%></DIV><%
								blnProEleEvtBusClass = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((ProEleEvtBusClassVo) obj).getProName() + " - " + ((ProEleEvtBusClassVo) obj).getTskName());
 							countShownProEleEvtBusCla ++;
 						}
 					} else if (obj instanceof SchBusClaActivityVo) {
 						if (countShownSchBusClaAct > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowSchBusClaAct) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
 							finShowSchBusClaAct = true;
 						} else if (!finShowSchBusClaAct){
 							if (blnFirstSch) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepSch")%></DIV><%
 								blnFirstSch = false;
							}
 							out.print("<LI class=\"liDep\">" + ((SchBusClaActivityVo) obj).getSchName() + " - "  + SchedulerBean.getPeriodicityName(request,((SchBusClaActivityVo) obj).getPeriodicity()) + " - " + dBean.fmtDate(((SchBusClaActivityVo) obj).getFirstExecution()));
 							countShownSchBusClaAct ++;
 						}
 					} else if (obj instanceof BusEntEvtBusClassVo) {
 						if (countShownBusEntEvtBusCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntEvtBusCla) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
 							finShowBusEntEvtBusCla = true;
 						} else if (!finShowBusEntEvtBusCla){
	 						if (blnFirstFld) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusEnt")%></DIV><%
								blnFirstFld = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((BusEntEvtBusClassVo) obj).getBusEntName());
 							countShownBusEntEvtBusCla ++;
 						}
 					} else if (obj instanceof QueryVo) {
 						if (countShownQuery > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuery) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
 							finShowQuery = true;
 						} else if (!finShowQuery){
	 						if (blnFirstQry) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepQue")%></DIV><%
								blnFirstQry = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((QueryVo) obj).getQryName());
 							countShownQuery ++;
 						}
 					} else if (obj instanceof WidgetVo) {
 						if (countShownWidgets > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowWidgets) {
 							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
 							finShowWidgets = true;
 						} else if (!finShowQuery){
	 						if (blnFirstWid) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepWidgets")%></DIV><%
 								blnFirstWid = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((WidgetVo) obj).getWidName());
 							countShownWidgets ++;
 						}
 					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (((col!=null) && (col.size()==0))||(col==null)){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>