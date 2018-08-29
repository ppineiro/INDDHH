<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DataDictionaryBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDicDat")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true; boolean blnThird = true;
				boolean blnFour = true;	boolean blnFive = true; boolean blnDW = true;
				boolean blnForm	= true; boolean blnParBnd=true; boolean blnFirstWS=true; 
				
				boolean finShowProInstAtt = false; boolean finShowBusEntInst = false;
				boolean finShowQuery = false; boolean finShowBusEntity = false; 
				boolean finShowProcess = false;boolean finShowEnvDwAtt = false; 
				boolean finShowForm = false; boolean finShowBusClaParBin = false;boolean finShowWS = false;

				int countShownProInstAtt = 1; int countShownBusEntInst = 1; int countShownQuery = 1;
				int countShownBusEntity = 1; int countShownProcess = 1; int countShownEnvDwAtt = 1; 
				int countShownForm = 1; int countShownBusClaParBin = 1; int countShownWS = 1;
				
				while (it.hasNext() && (!finShowProInstAtt || !finShowBusEntInst || !finShowQuery || !finShowBusEntity || !finShowEnvDwAtt || !finShowForm || !finShowBusClaParBin)) {
					Object obj = it.next();
					if (obj instanceof ProInstAttributeDataDicDepVo) {
						if (countShownProInstAtt > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProInstAtt) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProInstAtt = true;
						} else if (!finShowProInstAtt){
							if (blnFirst) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsPro")%></DIV><%
								blnFirst = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProInstAttributeDataDicDepVo) obj).getEntityIdentification() + " (" + ((ProInstAttributeDataDicDepVo) obj).getProName() + ")");
							countShownProInstAtt++;
						}
					} else if (obj instanceof WsPubAttributeVo){//	
						if (countShownWS > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowWS) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowWS = true;
						} else if (!finShowProInstAtt){
							if (blnFirstWS) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepWS")%></DIV><%
								blnFirstWS = false;
							}
							out.print("<LI class=\"liDep\">" + ((WsPubAttributeVo) obj).getWsName());
							countShownWS++;
						}
					} else if (obj instanceof BusEntInstDepVo) {
						if (countShownBusEntInst > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntInst) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntInst = true;
						} else if (!finShowBusEntInst){
							if (blnSec) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepInsEnt")%></DIV><%
								blnSec = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntInstDepVo) obj).getBusEntName());
							countShownBusEntInst++;
						}
					} else if (obj instanceof QueryVo) {
						if (countShownQuery > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuery) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowQuery = true;
						} else if (!finShowQuery){
							if (blnThird) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepQue")%></DIV><%
								blnThird = false;
							}
							out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('QueryVo'," + ((QueryVo) obj).getQryId().toString() + ")\"> " + ((QueryVo) obj).getQryName() + "</p>");
							countShownQuery++;
						}
					} else if (obj instanceof BusEntityVo) {
						if (countShownBusEntity > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEntity) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEntity = true;
						} else if (!finShowBusEntity){
							if (blnFour) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepBusEnt") %></div><%
								blnFour = false;
							}
							out.print("<li class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation('BusEntityVo'," + ((BusEntityVo) obj).getBusEntId().toString() + ")\"> " + ((BusEntityVo) obj).getBusEntName() + "</p>");
							countShownBusEntity++;
						}
					} else if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
 							if (blnFive) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepConPro") %></div><%
								blnFive = false;
							}
	    		 	 		out.print("<LI class=\"liDep\"><p style=\"color:#0000FF;cursor:pointer;cursor:hand;text-decoration:underline;\" onClick=\"openInformation2('ProcessVo'," + ((ProcessVo) obj).getProId().toString() + "," + ((ProcessVo) obj).getProVerId().toString() + ")\"> " + ((ProcessVo) obj).getProName() + "</p>");
	    		 	 		countShownProcess++;
						}
		  			} else if (obj instanceof EnvDwAttributeVo) {
		  				if (countShownEnvDwAtt > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowEnvDwAtt) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowEnvDwAtt = true;
						} else if (!finShowEnvDwAtt){
 							if (blnDW) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepEnvDW") %></div><%
								blnDW = false;
							}
 							countShownEnvDwAtt++;
						}
					} else if (obj instanceof FormVo) {
						if (countShownForm > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowForm) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowForm = true;
						} else if (!finShowForm){
							if (blnForm) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepFrm") %></div><%
								blnForm = false;
							}
							out.print("<LI class=\"liDep\">" + ((FormVo) obj).getFrmName());
							countShownForm++;
						}
					} else if (obj instanceof BusClaParBindingVo) {
						if (countShownBusClaParBin > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusClaParBin) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusClaParBin = true;
						} else if (!finShowBusClaParBin){
							if (blnParBnd) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepParBnd") %></div><%
								blnParBnd = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusClaParBindingVo) obj).getBusClaName() + " -  " + ((BusClaParBindingVo) obj).getBusClaParName());
							countShownBusClaParBin++;
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
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>