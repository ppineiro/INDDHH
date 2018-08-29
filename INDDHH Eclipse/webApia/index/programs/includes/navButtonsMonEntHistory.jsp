 <%if (dBean.getAmountPages()!=0){%>
 <td align="left" title="<%=LabelManager.getName(labelSet,"lblTotReg")%>:<%=dBean.getTotalRows()%>">
	 <input type="hidden" id="page" name="page" value="<%=dBean.getCurrentPage()%>">
	 <input type="hidden" id="hidActualPage" name="hidActualPage" value="<%=dBean.getCurrentPage()%>">
	 <input type="hidden" id="hidTotalRecords" name="hidTotalRecords" value="<%=dBean.getTotalRows()%>">
	 <input type="hidden" id="hidCantPages" name="hidCantPages" value="<%=dBean.getAmountPages()%>">
   <button type="button" onclick="first()">&lt;&lt;</button>
   <button type="button" onclick="prev()">&lt;</button>
   <input value="<%=dBean.getCurrentPage()%>" style="width:22px;max-width:22px;text-align:right;" name="goToPage" onkeypress="doGoToPage(event)"> <%=LabelManager.getName(labelSet,"lblNavOf")%> <%=dBean.getAmountPages()%> &nbsp;
   <button type="button" title="<%=LabelManager.getToolTip(labelSet,"btnNavNext")%>" onclick="next()">&gt;</button>
   <button type="button" title="<%=LabelManager.getToolTip(labelSet,"btnNavLast")%>" onclick="last()">&gt;&gt;</button>
 </td>
<%}else{%>
  <td align="left">
   <%if (dBean.hasReachedMax()) {%>
	   <%=LabelManager.getName(labelSet,"lblReaMaxFil")%>
    <%} else {%>
	   <%=LabelManager.getName(labelSet,"lblNoRet")%>
    <%}%>
  </td>
<%}%>
