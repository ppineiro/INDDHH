<%ListTaskBean absBean = null;
if(WORK_MODE.equals(ListTaskBean.WORKING_MODE_INPROCESS)){
	absBean = lBeanInproc;
} else {
	absBean = lBeanReady;
}
	
%>



<%if (absBean.getTotalRows()!=0){%>
 <td align=center title="<%=LabelManager.getName(labelSet,"lblTotReg")%>:<%=absBean.getTotalRows()%>">
   <input type="hidden" id="hidCantPages" name="hidCantPages" value="<%=absBean.getTotalPages()%>">
   <input type="hidden" id="hidActualPage" name="hidActualPage" value="<%=absBean.getPageNumber()%>">
   <button type="button" onclick="first()" title="<%=LabelManager.getToolTip(labelSet,"btnNavFirst")%>">&lt;&lt;</button>
   <button type="button" onclick="prev()" title="<%=LabelManager.getToolTip(labelSet,"btnNavPrev")%>">&lt;</button>
   <input value="<%=absBean.getPageNumber()%>" style="width:22px;max-width:22px;text-align:right;" name="goToPage" onkeypress="doGoToPage(event)"> <%=LabelManager.getName(labelSet,"lblNavOf")%> 
    <%  if (absBean.hasReachedMax()) {%>
   <B><font title="<%=LabelManager.getName(labelSet,"lblHayMasDad")%>"><%=absBean.getTotalPages()%>*</font></B>&nbsp;
   <%} else {%>
	<%=absBean.getTotalPages()%> &nbsp;
   <%}%>
   <button type="button" onclick="next()" title="<%=LabelManager.getToolTip(labelSet,"btnNavNext")%>">&gt;</button>
   <button type="button" onclick="last()" title="<%=LabelManager.getToolTip(labelSet,"btnNavLast")%>">&gt;&gt;</button>&nbsp;
  <!--     - <button type="button" onclick="refresh()"><%=LabelManager.getName(labelSet,"lblRef")%></button>          -->
 </td>

 <input type="hidden" name="page" value="<%=absBean.getPageNumber()%>">
 <input type="hidden" name="hidActualPage" value="<%=absBean.getPageNumber()%>">
 <input type="hidden" name="hidTotalRecords" value="<%=absBean.getTotalRows()%>">
<%}else{%>
  <td align=center>
   <!--     - <button type="button" onclick="refresh()"><%=LabelManager.getName(labelSet,"lblRef")%></button>&nbsp;          -->

   <%if (absBean.hasReachedMax()) {%>
	   <%=LabelManager.getName(labelSet,"lblReaMaxFil")%>
    <%} else {%>
	   <%=LabelManager.getName(labelSet,"lblNoRet")%>
    <%}%>

    <input type="hidden" name="page" value="1">
  </td>
<%}%>
