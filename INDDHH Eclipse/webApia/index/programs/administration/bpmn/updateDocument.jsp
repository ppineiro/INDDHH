		<div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDoc")%>" tabText="<%=LabelManager.getName(labelSet,"tabDoc")%>"><!--     - DOCUMENTOS          --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDoc")%></DIV><jsp:include page="../../documents/documents.jsp" flush="true"><jsp:param name="docBean" value="process"/></jsp:include><script src="<%=Parameters.ROOT_PATH%>/programs/documents/documents.js"></script></div>