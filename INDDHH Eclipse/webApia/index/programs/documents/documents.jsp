<%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/includeStart.jsp"%><%
com.dogma.bean.DogmaAbstractBean aBean = (com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean");
com.dogma.bean.DocumentBean dBean = aBean.getDocumentBean(request);
Collection docs = null;
if (dBean != null) {
	dBean.initEnv(request);
	docs = dBean.getDocuments();
}  
boolean blnInsert = (dBean == null || dBean.isInsert());
%><div class="tableContainerNoHScroll" style="height:<%=Parameters.DOCUMENT_LIST_SIZE%>px;" type="grid" id="docGrid<%=request.getParameter("docBean")%>"><table cellpadding="0" cellspacing="0"><thead><tr><th style="display:none;width:0px;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">&nbsp;</th><th min_width="28px" style="width:28px" title="<%=LabelManager.getToolTip(labelSet,"lblLock")%>">&nbsp;</th><th min_width="28px" style="width:28px" title="<%=LabelManager.getToolTip(labelSet,"lblDocVers")%>">&nbsp;</th><th min_width="100px" style="min-width:100px;width:75%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblTam")%>"><%=LabelManager.getName(labelSet,"lblTam")%></th><th min_width="100px" style="min-width:100px;width:25%" title="<%=LabelManager.getToolTip(labelSet,"lblUsu")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th><th min_width="70px" style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblFecUpl")%>"><%=LabelManager.getName(labelSet,"lblFecUpl")%></th></tr></thead><tbody><%if (docs != null) {
								Iterator itDocs = docs.iterator();
								DocumentVo docVo = null;
								int i = 0;
								while (itDocs.hasNext()) {
									docVo = (DocumentVo) itDocs.next();
									if (docVo.canRead()) {
									boolean othUsrLock = (docVo.getDocLock() != null && !docVo.getDocLock().getUsrLogin().equals(dBean.getUserData().getUserId()));
									String usrLock = "";
									if (docVo.getDocLock() != null) {
										if (othUsrLock) {
											usrLock = docVo.getDocLock().getUsrLogin();
										} else {	
											usrLock = "[true]";
										}
									}
									%><TR value="<%=dBean.fmtInt(docVo.getDocId())%>" canModify="true" lock="<%=dBean.fmtStr(usrLock)%>"><TD align="center" style="display:none;width:0px;"><INPUT type="hidden" name="chkDoc" value="<%=dBean.fmtInt(docVo.getDocId())%>" canModify="true" lock="<%=dBean.fmtStr(usrLock)%>"></TD><TD align="center" vAlign="top" style="width:28px;align:center;"><% if (usrLock != "") {
											if (usrLock.equals("[true]")) {%><img border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/lock.gif'><%} else {%><img border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/lock2.gif' title="<%=usrLock%>"><%}
										}else{%><img border=0 src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/lock.gif' style='display:none;'><%}%></TD><TD align="center" style="width:28px"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/history.gif" style="cursor:pointer;cursor:hand;" onclick="btnHisDoc_click('docGrid<%=request.getParameter("docBean")%>', '<%=dBean.fmtInt(docVo.getDocId())%>')"></TD><TD style="min-width:100px" title="<%=dBean.fmtStr(docVo.getDocDesc())%>"><A href='#nowhere' onclick="downloadDocument('<%=dBean.fmtInt(docVo.getDocId())%>','<%=request.getParameter("docBean")%>')"><%=dBean.fmtStr(docVo.getDocName())%></A></TD><TD align="right"><% if (docVo.getDocSize() != null) {
												out.print(dBean.fmtFileSize(docVo.getDocSize().intValue()));
											}%></TD><TD style="min-width:100px"><img class="cellsizer" src="<%=Parameters.ROOT_PATH%>/images/cellsizer.gif" width="15%" height="0" /><br/><%=dBean.fmtHTML(docVo.getRegUser())%></TD><TD><%=dBean.fmtHTML(docVo.getRegDate())%></TD></TR><%i++;
								} // can read
								}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td><% if (!blnInsert) {%><button type="button" type="button" name="btnLockDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnLockDoc_click('<%=request.getParameter("docBean")%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnLoc")%>" title="<%=LabelManager.getToolTip(labelSet,"btnLoc")%>"><%=LabelManager.getNameWAccess(labelSet,"btnLoc")%></button><% }%></td><td align="right"><button type="button" type="button" name="btnUplDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnUplDoc_click('<%=request.getParameter("docBean")%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" type="button" name="btnModDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnModDoc_click('<%=request.getParameter("docBean")%>', '<%=blnInsert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><button type="button" type="button" name="btnDelDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnDelDoc_click('<%=request.getParameter("docBean")%>', '<%=blnInsert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><%if(dBean.signableBean()){%><button type="button" type="button" name="btnSigDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnSig_click('<%=request.getParameter("docBean")%>', '<%=blnInsert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSign")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSign")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSign")%></button><button type="button" type="button" name="btnVerSigDoc" <%if (request.getParameter("readOnly") != null && !"null".equals(request.getParameter("readOnly"))) {%> disabled="true" <%}%> onclick="btnVerSig_click('<%=request.getParameter("docBean")%>', '<%=blnInsert%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblVerSig")%>" title="<%=LabelManager.getToolTip(labelSet,"lblVerSig")%>"><%=LabelManager.getNameWAccess(labelSet,"lblVerSig")%></button><%} %></td></tr></table><%	if (request.getAttribute("docExists") == null) {%><iframe id="docFrame" style="display:none"></iframe><script defer="true">
			var msgNotPer = "<%=LabelManager.getName(labelSet,com.dogma.document.DocumentException.DOC_NO_PER)%>";
			var msgMusLoc = "<%=LabelManager.getName(labelSet,com.dogma.document.DocumentException.DOC_MUST_BE_LOCKED_FOR_UPDATE)%>";
			var DIGITAL_SIGN_IN_CLIENT = <%=Parameters.DIGITAL_SIGN_IN_CLIENT%>;
		</script><%		request.setAttribute("docExists", "true");
	}%><%@include file="../../components/scripts/server/includeEnd.jsp"%>