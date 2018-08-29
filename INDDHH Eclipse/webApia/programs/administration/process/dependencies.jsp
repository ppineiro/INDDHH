<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProcessBean"></jsp:useBean><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPro")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			Collection col = dBean.getProcDependencies(request);
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true; boolean blnThr = true; boolean blnWid = true; boolean blnCbe = true; boolean blnMonBus=true; boolean blnPrf = true; boolean blnFun = true;
				boolean finShowProcess = false; boolean finShowProInstance = false;
				boolean finShowBusEntPro = false; boolean finShowWid = false; boolean finShowCbe = false; boolean finShowMonBus = false; boolean finShowPrf = false; boolean finShowFun = false;
				int countShownProcess = 1; int countShownProInstance = 1; int countShownBusEntPro = 1;
				int countShownWid = 1; int countShownCbe = 1; int countShownMonBus = 1; int countShownPrf = 1; int countShownFun = 1;
				
				while (it.hasNext() && (!finShowProcess || !finShowProInstance || !finShowBusEntPro || !finShowWid || !finShowCbe || !finShowPrf || !finShowFun)) {
					Object obj = it.next();
					if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
								blnFirst = false;
							}
	 						out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProcessVo) obj).getProId().toString() + "," + ((ProcessVo) obj).getProVerId().toString() + ")\"> " + ((ProcessVo) obj).getProName() + " (" + ((ProcessVo) obj).getProVerId().toString() + ")</a>");
	 						countShownProcess ++;
						}
	 				}else if (obj instanceof ProInstanceVo) {
	 					if (countShownProInstance > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInstance) {
	 						out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInstance = true;
						} else if (!finShowProInstance){
		 					if (blnSec) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProInstanceVo) obj).getIdentification() + " (" + ((ProInstanceVo) obj).getProcess().getProName() + ")") ;
							countShownProInstance++;
						}
	 				}else if (obj instanceof BusEntProcessVo) { 
	 					if (countShownBusEntPro > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntPro) {
	 						out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntPro = true;
						} else if (!finShowBusEntPro){
							if (blnThr) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblEntAso")%></DIV><%
								blnThr = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('BusEntityVo'," + ((BusEntProcessVo) obj).getBusEntId() + ")\"> " + ((BusEntProcessVo) obj).getEntName() + "</a>");
							countShownBusEntPro++;
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
 					}else if (obj instanceof ProfileVo) { //Profiles-Fnc
						if (countShownPrf > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowPrf) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowPrf = true;
						} else if (!finShowPrf){
							if (blnPrf) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepPrf")%></DIV><%
								blnPrf = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProfileVo) obj).getPrfName());
							countShownPrf ++;
						}
 					} else if (obj instanceof FunctionalityVo) { //Functionality
						if (countShownFun > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFun) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowFun = true;
						} else if (!finShowFun){
							if (blnFun) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepFun")%></DIV><%
								blnFun = false;
							}
							out.print("<LI class=\"liDep\">" + ((FunctionalityVo) obj).getFncTitle() + " (" + ((FunctionalityVo) obj).getFncName() + ")");
							countShownFun ++;
						}
 					}
				}
			} else {
				out.print(LabelManager.getName(labelSet,"lblNoDep"));
			}
		%></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col == null || col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/administration/process/process.js"></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/information/information.js'></script><script language="javascript">
var dependencies=true;
</script>

