<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQry")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			Collection col = dBean.getDependencies();
			if (col!=null && col.size()>0) {
				Iterator it = col.iterator();
				boolean blnFirst = true; boolean blnSec = true; boolean blnQry = true; boolean blnPro = true; boolean blnMonBus = true;
				boolean finShowProfile = false; boolean finShowFrmFldPro = false; boolean finShowQuery = false;
				boolean finShowProcess = false; boolean finShowMonBus = false;
				int countShownProfile = 1; int countShownFrmFldPro = 1; int countShownQuery = 1; 
				int countShownProcess = 1; int countShownMonBus = 1;
				
				while (it.hasNext() && (!finShowProfile || !finShowFrmFldPro || !finShowQuery || !finShowProcess || !finShowMonBus)) {
					Object obj = it.next();
					if (obj instanceof ProfileVo) {
						if (countShownProfile > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProfile) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProfile = true;
						} else if (!finShowProfile){
							if (blnFirst) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPrf")%></DIV><%
								blnFirst = false;
							}
 							out.print("<LI class=\"liDep\">" + ((ProfileVo) obj).getPrfName());
 							countShownProfile ++;
						}
					}else if (obj instanceof FrmFldPropertyVo) {
						if (countShownFrmFldPro > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowFrmFldPro) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowFrmFldPro = true;
						} else if (!finShowFrmFldPro){
							if (blnSec) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConAtt")%></DIV><%
								blnSec = false;
							}
							if (((FrmFldPropertyVo) obj).getFrmFieldVo() != null) {
								out.print("<LI class=\"liDep\">" + ((FrmFldPropertyVo) obj).getFormVo().getFrmName() + " - " + ((FrmFldPropertyVo) obj).getFrmFieldVo().getLabel());
							} else {
								out.print("<LI class=\"liDep\">" + ((FrmFldPropertyVo) obj).getFormVo().getFrmName());
							}
							countShownFrmFldPro ++;
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
 							countShownQuery ++;
						}
					} else if (obj instanceof ProcessVo) {
						if (countShownProcess > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowProcess) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowProcess = true;
						} else if (!finShowProcess){
							if (blnPro) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConPro")%></DIV><%
								blnPro = false;
							}
							out.print("<LI class=\"liDep\">" + ((ProcessVo) obj).getProName() + " (v. " + ((ProcessVo) obj).getProVerId() + ")");
							countShownProcess ++;
						}
					} else if (obj instanceof MonBusinessVo) {
						if (countShownMonBus > Parameters.MAX_DEPENDENCIES_SHOWN && !finShowMonBus) {
							out.print("<BR>" + LabelManager.getName(labelSet,"lblMasDep"));
							finShowMonBus = true;
						} else if (!finShowMonBus){
							if (blnMonBus) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDepConMonBus")%></DIV><%
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
		%></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="lnkDownDeps_click()" <%if (col.size() == 0){%>disabled<%}%> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwnDeps")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwnDeps")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDwnDeps")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/programs/query/administration/dependencies.js"></script>

