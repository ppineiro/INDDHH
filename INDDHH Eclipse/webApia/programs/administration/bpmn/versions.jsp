<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><%ProDefinitionVo proVo = dBean.getProcessVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (proVo.getProId()==null)?true:dBean.hasWritePermission(request, proVo.getProId(), proVo.getPrjId(), actualUser);%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titBPMN")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPro")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td class="readOnly"><%=dBean.fmtHTML(proVo.getProName())%></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table><!--     ---------------------------------------------               --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtProVer")%></DIV><div type="grid" id="gridList" width="900px" height="<%=(Parameters.SCREEN_LIST_SIZE - 30)%>"><table width="900px" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;"></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblVer")%>"><%=LabelManager.getName(labelSet,"lblVer")%></th><th style="width:140px" title="<%=LabelManager.getToolTip(labelSet,"lblFecUltMod")%>"><%=LabelManager.getName(labelSet,"lblFecUltMod")%></th><th style="width:140px" title="<%=LabelManager.getToolTip(labelSet,"lblUsuUltMod")%>"><%=LabelManager.getName(labelSet,"lblUsuUltMod")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblCom")%>"><%=LabelManager.getName(labelSet,"lblCom")%></th></tr></thead><tbody><%	Collection col = dBean.getVersions(request);
							boolean blnTmp = false;
							boolean blnInstanced = false;
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								ProcessVo gVO = null;
								while (it.hasNext()) {
									gVO = (ProcessVo) it.next(); %><tr <%if (com.dogma.DogmaConstants.DB_TRUE_INT.equals(gVO.getProTemporary())){%> style="color=gray"<%blnTmp = true;} else if (!blnInstanced && blnTmp){%>style="font-weight:bold"<%blnInstanced=true;}%>><td style="width:0px;display:none;"><input type="hidden" id="chkSel<%=i%>" name="chkSel<%=i%>" /><input type="hidden" id="hidProId<%=i%>" name="hidProId<%=i%>" value="<%=StringUtil.encodeString(new String[] {gVO.getProId().toString(), gVO.getProVerId().toString()})%>" onclick="selectOneChk(this)"></td><td align="center"><%=dBean.fmtHTML(gVO.getProVerId())%></td><td><%=dBean.fmtHTMLTime(gVO.getRegDate())%></td><td><%=dBean.fmtHTML(gVO.getRegUser())%></td><td><%=dBean.fmtHTML(gVO.getProVerComment())%></td></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnRecover()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRec")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRec")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRec")%></button><button type="button" onclick="btnVerVersion()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVer")%></button></td></tr></table><%if (blnInstanced) {%><B><%=LabelManager.getName(labelSet,"lblLeyProAct")%></B><%}%></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" id="btnBack" onclick="btnBack_click('false')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script language="javascript">
var dependencies=false;
</script><script>
var RECOVER_RECORD = "<%= LabelManager.getName(labelSet,"lblRecMsg") %>";
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/process.js"></script><%@include file="../../../components/scripts/server/endInc.jsp" %>