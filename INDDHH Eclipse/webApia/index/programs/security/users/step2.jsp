<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserBean"></jsp:useBean><%
UserVo userVo = dBean.getUserVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titUsu":"titUsuEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><br><!--     - Pools del usuario          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtUsuPoo")%>&nbsp;<%=userVo.getUsrLogin() %></DIV><div type="grid" id="gridPools" style="height:100px"><table id="tblPools" width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="250px" style="width:250px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="120px" style="min-width:120px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th></tr></thead><tbody id="tblPoolBody"><%if (userVo.getUserPools() != null){
						userVo.sortUserPools();
						Iterator itPools = userVo.getUserPools().iterator();
 						while (itPools.hasNext()) {
 							PoolVo poolVo = (PoolVo) itPools.next();
 							%><tr<%=("0".equals(poolVo.getPoolGenerated()) && !(!dBean.isModeGlobal() && poolVo.getPoolAllEnvs().intValue() == 1) )?"":" x_disabled=\"true\"" %>><td style="width:0px;display:none;"><input type="hidden" name="chkPoolSel"><input type=hidden name="chkPool" value="<%=dBean.fmtInt(poolVo.getPoolId())%>"></td><td><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(poolVo.getPoolName())%><%if(poolVo.getPoolAllEnvs().intValue() == 1){out.print("</B>");}%></td><td style="min-width:120px"><%=dBean.fmtHTML(poolVo.getPoolDesc())%></td></tr><%
 						} 
 					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelPool_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><!--     - Perfiles del usuario          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtUsuPrf")%>&nbsp;<%=userVo.getUsrLogin() %></DIV><div type="grid" id="gridProfiles" style="height:100px"><table id="tblProfiles"  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="120px" style="min-width:120px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody id="tblPerBody"><%if (userVo.getUserProfiles() != null){
						userVo.sortUserProfiles();
						Iterator itProfiles = userVo.getUserProfiles().iterator();
						while (itProfiles.hasNext()) {
							ProfileVo profileVo = (ProfileVo) itProfiles.next();
							%><tr <%=( !(!dBean.isModeGlobal() && profileVo.getPrfAllEnv().intValue() == 1) )?"":" x_disabled=\"true\"" %> ><td style="width:0px;display:none;"><input type="hidden" name="chkPrfSel"><input type=hidden name="chkPrf" value="<%=dBean.fmtInt(profileVo.getPrfId())%>"></td><td style="min-width:120px"><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(profileVo.getPrfName())%></td><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("</B>");}%></tr><%
						} 
					}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBackStep1_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/users/update.js'></script><SCRIPT>
var isGlobal 			= <%=dBean.isModeGlobal()%>;
var envId 				= <%=dBean.getEnvId(request)%>;
var MSG_PWD_DIF			= "<%=LabelManager.getName(labelSet,"msgUsuPwdDif")%>";
var isAllEnv			= <%=userVo.getFlagValue(UserVo.FLAG_ALL_ENV)%>;

function tabSwitch(){
}
</SCRIPT>