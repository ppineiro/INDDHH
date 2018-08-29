<%if (dBean.getTotalRows()!=0){%>
 <td align=center title="<%=LabelManager.getName(labelSet,"lblTotReg")%>:<%=dBean.getTotalRows()%>">
   <button type="button" onclick="first()"  title="<%=LabelManager.getToolTip(labelSet,"btnNavFirst")%>">&lt;&lt;</button>
   <button type="button" onclick="prev()" title="<%=LabelManager.getToolTip(labelSet,"btnNavPrev")%>">&lt;</button>
   <input value="<%=dBean.getPageNumber()%>" style="width:22px;max-width:22px;text-align:right;" name="goToPage" onkeypress="doGoToPage(event)"> <%=LabelManager.getName(labelSet,"lblNavOf")%> <%=dBean.getTotalPages()%>&nbsp;
   <button type="button" onclick="next()" title="<%=LabelManager.getToolTip(labelSet,"btnNavNext")%>">&gt;</button>
   <button type="button" onclick="last()" title="<%=LabelManager.getToolTip(labelSet,"btnNavLast")%>">&gt;&gt;</button>&nbsp;
  <!--     - <button type="button" onclick="refresh()"><%=LabelManager.getName(labelSet,"lblRef")%></button>          -->
 </td>
 <input type="hidden" id="hidCantPages" name="hidCantPages" value="<%=dBean.getTotalPages()%>">
 <input type="hidden" name="page" value="<%=dBean.getPageNumber()%>">
 <input type="hidden" name="hidActualPage" value="<%=dBean.getPageNumber()%>">
 <input type="hidden" name="hidTotalRecords" value="<%=dBean.getTotalRows()%>">
<%}else{%>
  <td align=center>
   <!--     - <button type="button" onclick="refresh()"><%=LabelManager.getName(labelSet,"lblRef")%></button>&nbsp;          -->
	<%=LabelManager.getName(labelSet,"lblNoRet")%>
    <input type="hidden" name="page" value="1">
  </td>
<%}%>
