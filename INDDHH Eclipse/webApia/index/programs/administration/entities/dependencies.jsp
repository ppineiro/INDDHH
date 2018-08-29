<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEntNeg")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			Collection col = dBean.getDependencies();
			if (col!=null && col.size()>=1) {
				Iterator it = col.iterator();
				boolean blnFirst = true; 
				boolean blnSec = true; 
				boolean blnThr = true;
				boolean blnQry = true; 
				boolean blnFrmFld = true; 
				boolean blnInst = true; 
				boolean blnBnd = true; 
				boolean blnWid = true;
				boolean blnQryCol = true;
				boolean blnCbe = true;
				boolean blnMonBus=true;

				boolean finShowProcess = false; 
				boolean finShowProfile = false; 
				boolean finShowForm = false;
				boolean finShowQuery = false; 
				boolean finShowFrmFldProperty = false; 
				boolean finShowBusEntInstance = false;
				boolean finShowBind = false; 
				boolean finShowWid = false;
				boolean finQryCol = false;
				boolean finShowCbe=false;
				boolean finShowMonBus = false;
				
				int countShownProcess = 1; 
				int countShownProfile = 1; 
				int countShownForm = 1;
				int countShownQuery = 1; 
				int countShownFrmFldProperty = 1; 
				int countShownBusEntInstance = 1;
				int countShownBind = 1; 
				int countShownWid = 1;
				int countShowQryCol = 1;
				int countShownCbe = 1;
				int countShownMonBus = 1;
				
				while (it.hasNext() && (!finShowProcess || !finShowProfile ||! finShowForm || !finShowQuery || !finShowFrmFldProperty || !finShowBusEntInstance || !finShowWid || !finQryCol || !finShowCbe)) {
					Object obj = it.next();
					if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProVerId().toString() + " (" + ((ProcessVo) obj).getProName() + ")</a>");
							countShownProcess++;
						}
					} else if (obj instanceof ProfileVo) {
						if (countShownProfile > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProfile) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProfile = true;
						} else if (!finShowProfile){
							if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepPrf")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProfileVo) obj).getPrfName());
							countShownProfile++;
						}
					} else if (obj instanceof FormVo) {
						if (countShownForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowForm) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowForm = true;
						} else if (!finShowForm){
							if (blnThr) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConAtt")%></DIV><%
 								blnThr = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((FormVo) obj).getFrmName() + " - " + ((FormVo) obj).getAttName());
 							countShownForm++;
						}
					} else if (obj instanceof FrmFldEntBindingVo) {
						if (countShownBind > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBind) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBind = true;
						} else if (!finShowBind){
							if (blnBnd) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConBnd")%></DIV><%
 								blnBnd = false;
 							}
 							out.print("<LI class=\"liDep\">" + ((FrmFldEntBindingVo) obj).getAttName());
 							countShownBind++;
						}
					} else if (obj instanceof QueryVo) {
						if (countShownQuery > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuery) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowQuery = true;
						} else if (!finShowQuery){
							if (blnQry) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConQry")%></DIV><%
								blnQry = false;
							}
 							out.print("<LI class=\"liDep\">" + ((QueryVo) obj).getQryName());
 							countShownQuery++;
						}
					} else if (obj instanceof FrmFldPropertyVo) {
						if (countShownFrmFldProperty > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFrmFldProperty) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowFrmFldProperty = true;
						} else if (!finShowFrmFldProperty){
							if (blnFrmFld) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConAtt")%></DIV><%
								blnFrmFld = false;
							}
							if (((FrmFldPropertyVo) obj).getFrmFieldVo() != null) {
								out.print("<LI class=\"liDep\">" + ((FrmFldPropertyVo) obj).getFormVo().getFrmTitle() + " - " + ((FrmFldPropertyVo) obj).getFrmFieldVo().getLabel());
							} else {
								out.print("<LI class=\"liDep\">" + ((FrmFldPropertyVo) obj).getFormVo().getFrmTitle());
							}
							countShownFrmFldProperty++;
						}
					} else if (obj instanceof BusEntInstanceVo) {
						if (countShownBusEntInstance > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInstance) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInstance = true;
						} else if (!finShowBusEntInstance){
							if (blnInst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblBusEntInstDep")%></DIV><%
								blnInst = false;
 							}
	 						out.print("<LI class=\"liDep\">" + ((BusEntInstanceVo) obj).getEntityIdentification() + " (" + ((BusEntInstanceVo) obj).getEntityType().getBusEntName() + ")");
	 						countShownBusEntInstance ++;
 						}
 					}else if (obj instanceof WidgetVo) {
						if (countShownWid > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowWid) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowWid = true;
						} else if (!finShowWid){
							if (blnWid) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepWidgets")%></DIV><%
 								blnWid = false;
 							}
	 						out.print("<LI class=\"liDep\">" + ((WidgetVo) obj).getWidName());
	 						countShownWid ++;
 						}
 					}else if (obj instanceof QryColumnVo) {
						if (countShowQryCol > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowWid) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finQryCol = true;
						} else if (!finShowWid){
							if (blnWid) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConQryCol")%></DIV><%
 								blnWid = false;
 							}
	 						out.print("<LI class=\"liDep\">" + ((QryColumnVo) obj).getQryName() + " - " + ((QryColumnVo) obj).getQryColName());
	 						countShownWid ++;
 						}
 					}else if (obj instanceof CubeVo) {
						if (countShownCbe > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowCbe) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowCbe = true;
						} else if (!finShowCbe){
							if (blnCbe) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepCubes")%></DIV><%
 								blnCbe = false;
 							}
	 						out.print("<LI class=\"liDep\">" + ((CubeVo) obj).getCubeName());
	 						countShownCbe ++;
 						}
 					}else if (obj instanceof MonBusinessVo) { //MON_BUSINESS
						if (countShownMonBus > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowMonBus) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowMonBus = true;
						} else if (!finShowMonBus){
							if (blnMonBus) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepMonBus")%></DIV><%
								blnMonBus = false;
							}
							out.print("<LI class=\"liDep\">" + ((MonBusinessVo) obj).getMonBusName());
							countShownMonBus ++;
						}
 					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col==null || col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>