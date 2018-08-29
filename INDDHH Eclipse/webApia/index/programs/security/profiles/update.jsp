<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.ProfileBean"></jsp:useBean><%
ProfileVo profVo = dBean.getProfVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titPer":"titPerEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPer")%></DIV><table class="tblFormLayout"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(profVo!=null) {%>value="<%=dBean.fmtStr(profVo.getPrfName())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(profVo!=null) {%>value="<%=dBean.fmtStr(profVo.getPrfDesc())%>"<%}%>></td></tr></table><!--     - PERFILES          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEnv")%></DIV><div type="grid" id="gridEnv" style="height:200px;"><table id="tblEnv" width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="80px" style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblVerFun")%>"><%=LabelManager.getName(labelSet,"lblVerFun")%></th><th min_width="120px" style="min-width:120px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblAmb")%>"><%=LabelManager.getName(labelSet,"lblAmb")%></th><th style="width:0px;display:none;">&nbsp;</th></tr></thead><tbody id="tblEnvBody"><%if(dBean.isModeGlobal()) {%><tr><td style="width:0px;display:none;"><input type='hidden' name='chkEnvSel' style='visibility:hidden' disabled readonly><input type='hidden' name='chkEnv' value="all"></td><td align=center style="PADDING-TOP:0px;PADDING-BOTTOM:0px;"><img style="cursor:hand;position:static;" src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick='viewFnc(this)'></td><td style="min-width:120px"><%=LabelManager.getName(labelSet,"lblTodAmb")%></td><td style="width:0px;display:none;"><input name= "txtEnvs" type='hidden' value='0'></td></tr><%}%><%
						Collection col = dBean.getProfileEnvs();
						if(col!=null){
							Iterator it = col.iterator();
							if(dBean.isModeGlobal()) {
								while(it.hasNext()){
									EnvProfileVo e = (EnvProfileVo)it.next();
									if(e.getEnvId().intValue()!=0){
										out.print("<tr>");
											out.print("<td style=\"width:0px;display:none;\"><input type='hidden' name='chkEnvSel'><input type='hidden' name='chkEnv' value='" + e.getEnvId() + "'></td>");
											out.print("<td align=center><img style='cursor:hand' src='" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/btn_mod.gif' onclick='viewFnc(this)'></td>");
											out.print("<td>" + dBean.getEnvName(e.getEnvId()) + "</td>");
											out.print("<td style=\"width:0px;display:none;\"><input name= 'txtEnvs' type=hidden value='" + e.getEnvId() + "'></td>");
										out.print("</tr>");
									}
								}
							} else {
							
								while(it.hasNext()){
									EnvProfileVo e = (EnvProfileVo)it.next();
									System.out.println();
									if(e.getEnvId().equals(environmentId)){
										out.print("<tr>");
										out.print("<td style=\"width:0px;display:none;\"><input type='hidden' name='chkEnvSel'><input type='hidden' name='chkEnv' value='" + e.getEnvId() + "'></td>");
										out.print("<td align=center><img style='cursor:hand' src='" + Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/btn_mod.gif' onclick='viewFnc(this)'></td>");
										out.print("<td>" + dBean.getEnvName(e.getEnvId()) + "</td>");
										out.print("<td style=\"width:0px;display:none;\"><input name= 'txtEnvs' type='hidden' value='" + e.getEnvId() + "'></td>");
										out.print("</tr>");
									} else {
										out.print("<input type='hidden' name='chkEnv' value='" + e.getEnvId() + "'>");
									}
								}
							
							}
						}
						
						if((col == null || col.size() == 0) && !dBean.isModeGlobal()){%><tr><td style=\"width:0px;display:none;\"><input type='hidden' name='chkEnvSel' disabled readonly><input type='hidden' name='chkEnv' value="<%=dBean.getEnvId(request)%>"></td><td align=center style="PADDING-TOP:0px;PADDING-BOTTOM:0px;"><img style="cursor:hand" src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick='viewFnc(this)'></td><td><%=dBean.getEnvName(dBean.getEnvId(request)) %></td><td style="width:0px;display:none;"><input name= "txtEnvs" type='hidden' value='0'></td></tr><%}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><%if(dBean.isModeGlobal()) {%><button type="button" onclick="btnAddEnv_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelEnv_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><%}%></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" defer=true src='<%=Parameters.ROOT_PATH%>/programs/security/profiles/update.js'></script>

