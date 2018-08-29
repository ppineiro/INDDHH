<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><%
	com.dogma.bean.DocumentBean dBean = (DocumentBean) ((DogmaAbstractBean) session.getAttribute("dBean")).getDocumentBean(request);
	Collection colDocHis = dBean.getDocumentHistory(request);
	DocumentVo docVo = dBean.getSelectedDocument();
%><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDoc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"  target="ifrUno"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocInfo")%></DIV><input type=hidden id=docId value="<%=dBean.fmtInt(docVo.getDocId())%>"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%>:</td><td colspan=3><%=dBean.fmtHTML(docVo.getDocName())%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%>:</td><td colspan=3><%=dBean.fmtHTML(docVo.getDocDesc())%></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDocVer")%></DIV><div type="grid" id="sa" style="height:105px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th min_width="30px" style="width:30px" title="<%=LabelManager.getToolTip(labelSet,"lblVer")%>"><%=LabelManager.getName(labelSet,"lblVer")%></th><th min_width="50px" style="min-width:50px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th><th min_width="50px" style="min-width:50px;max-width:140px;width:50%" title="<%=LabelManager.getToolTip(labelSet,"lblTam")%>"><%=LabelManager.getName(labelSet,"lblFec")%></th></tr></thead><tbody  id="TBbody"><%if (colDocHis != null)  {
					Iterator it = colDocHis.iterator();
					int i=colDocHis.size();
					int j=0;
					while (it.hasNext()) {
						DocVersionVo docVerVo = (DocVersionVo) it.next();
						%><tr <%if (i%2==0){%>class=trOdd<%}%>><td align=right><input type=checkbox style="visibility:hidden"><A href="#nowhere" onclick="downloadDocument('<%=dBean.fmtInt(docVo.getDocId())%>',<%=j%>)"><%=i%></A></td><td style="min-width:50px"><%=dBean.fmtHTML(docVerVo.getUsrLogin())%></td><td style="min-width:50px;max-width:140px"><%=dBean.fmtHTMLTime(docVerVo.getDocDate())%></td></tr><% 
						i--;
						j++;
					}
				}%></tbody></table></div></form><iframe name="ifrUno" id="ifrUno" src="" style="display:none"></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endModalInc.jsp" %><script language="javascript">

function downloadDocument (docId, version) {
	if(document.getElementById("document")){
		document.getElementById("document").getElementById("frmMain").action="DocumentAction.do?action=download&docId="+docId+"&version="+version+"&docBean=<%=request.getParameter("docBean")%>";
	} else {
		document.getElementById("frmMain").action="DocumentAction.do?action=download&docId="+docId+"&version="+version+"&docBean=<%=request.getParameter("docBean")%>";
	}
	document.getElementById("frmMain").submit();
}

function btnExit_click() {
	window.close();
}
</script>