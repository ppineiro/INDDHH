<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ProjectBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titProjEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnProcess = true; boolean blnForm = true; boolean blnTask= true;
				boolean blnAtt= true;	boolean blnBusClas = true; boolean blnStat= true;
				boolean blnClaTree=true; boolean blnConn = true; boolean blnQry = true;
				boolean blnDocum=true; boolean blnBusEnt = true; boolean blnRole = true;
				boolean blnMonBus=true; boolean blnTskSch=true;
				
				boolean finShowProcess = false; boolean finShowForm = false; boolean finShowTask = false; 
				boolean finShowAttribute = false; boolean finShowBusClass = false; boolean finShowStatus = false; 
				boolean finShowClaTree = false; boolean finShowConn = false; boolean finShowQuery = false; 
				boolean finShowDocum = false; boolean finShowBusEnt = false; boolean finShowRole = false;
				boolean finShowMonBus = false; boolean finShowTskSch=false;

				int countShownProcess = 1; int countShownForm = 1; int countShownTsk= 1;
				int countShownAtt = 1; int countShownBusCla = 1; int countShownStatus = 1; 
				int countShownClaTree = 1; int countShownConn = 1; int countShownQry = 1;
				int countShownDocum = 1; int countShownBusEnt = 1; int countShownRole = 1;
				int countShownMonBus = 1; int countShownTskSch=1;
				
				while (it.hasNext() && (!finShowMonBus || !finShowProcess || !finShowForm || !finShowTask || !finShowAttribute|| !finShowBusClass|| !finShowStatus || !finShowClaTree || !finShowConn || !finShowQuery || !finShowDocum || !finShowBusEnt || !finShowRole || !finShowTskSch)) {
					Object obj = it.next();
					if (obj instanceof ProcessVo) { //PROCESOS
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnProcess) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepPro")%></DIV><%
								blnProcess = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProName() + " (" + ((ProcessVo) obj).getProVerId() + ")");
							countShownProcess ++;
						}
					}else if (obj instanceof FormVo) { //FORMULARIOS
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
					}else if (obj instanceof TaskVo) { //TAREAS
						if (countShownTsk > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowTask) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowTask = true;
						} else if (!finShowTask){
							if (blnTask) { %><div class="subTit"><%= LabelManager.getName(labelSet,"sbtDepTsk") %></div><%
								blnTask = false;
							}
							out.print("<LI class=\"liDep\">" + ((TaskVo) obj).getTskName());
							countShownTsk++;
						}
					}
					else if (obj instanceof AttributeVo) { //ATRIBUTOS
						if (countShownAtt > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowAttribute) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowAttribute = true;
						} else if (!finShowAttribute){
							if (blnAtt) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepAtt")%></DIV><%
								blnAtt = false;
							}
							out.print("<LI class=\"liDep\">" +  ((AttributeVo) obj).getAttName());
							countShownAtt ++;
						}
					}else if (obj instanceof BusClassVo) { //CLASES DE NEGOCIO
						if (countShownBusCla > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusClass) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusClass = true;
						} else if (!finShowBusClass){
							if (blnBusClas) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusCla")%></DIV><%
								blnBusClas = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusClassVo) obj).getBusClaName());
							countShownBusCla ++;
						}
					}else if (obj instanceof BusEntStatusVo) { //ESTADOS
						if (countShownStatus > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowStatus) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowStatus = true;
						} else if (!finShowStatus){
							if (blnStat) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepSta")%></DIV><%
								blnStat = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntStatusVo) obj).getEntStaName());
							countShownStatus ++;
						}
					}else if (obj instanceof ClaTreeVo) { //CLASIFICACIONES
						if (countShownClaTree > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowClaTree) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowClaTree = true;
						} else if (!finShowClaTree){
							if (blnClaTree) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConCla")%></DIV><%
								blnClaTree = false;
							}
							out.print("<LI class=\"liDep\">" + ((ClaTreeVo) obj).getClaTreName());
							countShownClaTree ++;
						}
					}else if (obj instanceof DbConnectionVo) { //CONEXIONES
						if (countShownConn > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowConn) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowConn = true;
						} else if (!finShowConn){
							if (blnConn) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConex")%></DIV><%
								blnConn = false;
							}
							out.print("<LI class=\"liDep\">" + ((DbConnectionVo) obj).getDbConName());
							countShownConn ++;
						}
					}else if (obj instanceof QueryVo) { //CONSULTAS
						if (countShownQry > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowQuery) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowQuery = true;
						} else if (!finShowQuery){
							if (blnQry) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConQry")%></DIV><%
								blnQry = false;
							}
							out.print("<LI class=\"liDep\">" + ((QueryVo) obj).getQryName());
							countShownQry ++;
						}
					}else if (obj instanceof DocumentVo) { //DOCUMENTOS
						if (countShownDocum > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowDocum) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowDocum = true;
						} else if (!finShowDocum) {
							if (blnDocum) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepDoc")%></DIV><%
								blnDocum = false;
							}
							out.print("<LI class=\"liDep\">" + ((DocumentVo) obj).getDocName());
							countShownDocum ++;		
						}
					}else if (obj instanceof BusEntityVo) { //ENTIDADES
						if (countShownBusEnt > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowBusEnt) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowBusEnt = true;
						} else if (!finShowBusEnt){
							if (blnBusEnt) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepBusEntFor")%></DIV><%
								blnBusEnt = false;
							}
							out.print("<LI class=\"liDep\">" + ((BusEntityVo) obj).getBusEntName());
							countShownBusEnt ++;
						}
					}else if (obj instanceof RoleVo) { //ROLES
						if (countShownRole > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowRole) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowRole = true;
						} else if (!finShowRole){
							if (blnRole) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepRol")%></DIV><%
								blnRole = false;
							}
							out.print("<LI class=\"liDep\">" + ((RoleVo) obj).getRolName());
							countShownRole ++;
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
					}else if (obj instanceof TaskSchedulerVo) { //TASK SCHEDULER
						if (countShownTskSch > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowTskSch) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowTskSch = true;
						} else if (!finShowTskSch){
							if (blnTskSch) {	%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepTskSch")%></DIV><%
								blnTskSch = false;
							}
							out.print("<LI class=\"liDep\">" + ((TaskSchedulerVo) obj).getTskSchName());
							countShownTskSch ++;
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
	document.getElementById("frmMain").action = "administration.ProjectAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.ProjectAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}
</script>