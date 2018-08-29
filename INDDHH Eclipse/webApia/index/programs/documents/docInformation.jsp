<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><%
	com.dogma.bean.DocumentBean dBean = (DocumentBean) ((DogmaAbstractBean) session.getAttribute("dBean")).getDocumentBean(request);
	DocumentVo docVo = dBean.getSelectedDocument();
%><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDoc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"  target="ifrUno" action="DocumentAction.do?action=confirm&docBean=<%=request.getParameter("docBean")%>" enctype="multipart/form-data"><%if (docVo != null) {%><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocInfo")%></DIV><input type=hidden id=docId value="<%=dBean.fmtInt(docVo.getDocId())%>"><input type=hidden id=docName value="<%=dBean.fmtStr(docVo.getDocName())%>"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%if (docVo.getDocName() != null) {%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDoc")%>"><%=LabelManager.getName(labelSet,"lblDoc")%>:</td><td colspan=3><%=dBean.fmtHTML(docVo.getDocName())%></td></tr><%}%><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%>:</td><td colspan=3><%=dBean.fmtStr(docVo.getDocDesc())%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLock")%>"><%=LabelManager.getName(labelSet,"lblLock")%>:</td><td><%= (docVo.getDocLock() != null)?LabelManager.getToolTip(labelSet,"lblYes"):LabelManager.getToolTip(labelSet,"lblNo")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblUsuLock")%>"><%=LabelManager.getName(labelSet,"lblUsuLock")%>:</td><td><%= (docVo.getDocLock() != null)?docVo.getDocLock().getUsrLogin():"" %></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtPerAccDoc")%></DIV><div type="grid" id="grid" style="height:100px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="28px" style="width:28px">&nbsp;</th><th min_width="50px" style="min-width:50px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="50px" style="min-width:50px;max-width:150px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblPer")%>"><%=LabelManager.getName(labelSet,"lblPer")%></th></tr></tr></thead><tbody id="tableBody"><tr><td style="width:0px;display:none;"></td><td></td><td style="min-width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblTod")%>"><%=LabelManager.getName(labelSet,"lblTod")%></td><td style="min-width:50px;max-width:150px"><input name="chkAllowRead" 	 disabled type=checkbox <%if (docVo.getDocAllowAll()!=null) {%> checked <%}%> ><%=LabelManager.getName(labelSet,"lblPerVer")%><input name="chkAllowModify" disabled onclick="if (this.checked) { document.getElementById('chkAllowRead').checked=1}" type=checkbox <%if (DocPermissionVo.DOC_PER_TYPE_MODIFY.equals(docVo.getDocAllowAll())) {%> checked <%}%>><%=LabelManager.getName(labelSet,"lblPerMod")%></td></tr><%if  (docVo.getDocPermissions() != null) {
								Iterator it = docVo.getDocPermissions().iterator();
								String strVal = "";
								String strDesc = "";
								String strRad = "";
								String strImage = "";
								int i=0;				
								while (it.hasNext()) {
									i++;
									DocPermissionVo docPerVo = (DocPermissionVo) it.next();
									if (docPerVo.getUsrLogin() != null) {
										strImage="<img src='" + com.dogma.Parameters.ROOT_PATH + "/styles/" + styleDirectory + "/images/user.gif'>";
										strVal = StringUtil.encodeString(new String[] {docPerVo.getUsrLogin(), docPerVo.getUsrName()}) ;
										strDesc = docPerVo.getUsrName();
										strRad = "usu";
									} else if (docPerVo.getPoolId() != null) {
										strImage="<img src='" + com.dogma.Parameters.ROOT_PATH+ "/styles/" + styleDirectory + "/images/pool.gif'>";
										strVal = StringUtil.encodeString(new String[] {docPerVo.getPoolId().toString(), docPerVo.getPoolName()});
										strDesc = docPerVo.getPoolName();
										strRad = "grp";
									}
									%><tr><td align="center"><input type='checkbox' disabled name='chkPoolSel'><input type='hidden' name='chkPool' value="<%=strVal%>"></td><td><%=strImage%></td><td><%=dBean.fmtHTML(strDesc)%></td><td><input type=radio disabled id="rad<%=i%>" name="<%=strRad + i%>" value="<%=DocPermissionVo.DOC_PER_TYPE_READ + strVal%>" <%if (DocPermissionVo.DOC_PER_TYPE_READ.equals(docPerVo.getDocPerType())){%> checked <%}%>><%=dBean.fmtHTML(LabelManager.getName(labelSet,"lblPerVer"))%><input type=radio disabled id="rad<%=i%>" name="<%=strRad + i%>" value="<%=DocPermissionVo.DOC_PER_TYPE_MODIFY + strVal%>" <%if (DocPermissionVo.DOC_PER_TYPE_MODIFY.equals(docPerVo.getDocPerType())){%> checked <%}%>><%=dBean.fmtHTML(LabelManager.getName(labelSet,"lblPerMod"))%></td></tr><%
								}
							}%></tbody></table></div></form><iframe name=ifrUno src="" style="display:none"></iframe><%}%><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" class="feedBackFrame" frameborder="no" style="display:none;" ></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endModalInc.jsp" %><script language="javascript">

function btnExit_click() {
	window.close();
}

function submitOK() {
	window.close();
}
</SCRIPT>