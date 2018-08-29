<%@page import="com.dogma.Parameters"%>

<table class="navBar"><tr>
<%if (dBean.getTotalRows()!=0){%>
<td align=center title="<%=LabelManager.getName(labelSet,"lblTotReg")%>:<%=dBean.getTotalRows()%>">
	 <input type="hidden" id="page" name="page" value="<%=dBean.getPageNumber()%>">
	 <input type="hidden" id="hidActualPage" name="hidActualPage" value="<%=dBean.getPageNumber()%>">
	 <input type="hidden" id="hidTotalRecords" name="hidTotalRecords" value="<%=dBean.getTotalRows()%>">
	 <input type="hidden" id="hidCantPages" name="hidCantPages" value="<%=dBean.getTotalPages()%>">
   <button type="button" onclick="first()"  title="<%=LabelManager.getToolTip(labelSet,"btnNavFirst")%>">&lt;&lt;</button>
   <button type="button" onclick="prev()" title="<%=LabelManager.getToolTip(labelSet,"btnNavPrev")%>">&lt;</button>
   <input value="<%=dBean.getPageNumber()%>" style="width:22px;max-width:22px;text-align:right;" name="goToPage" onkeypress="doGoToPage(event)"> <%=LabelManager.getName(labelSet,"lblNavOf")%> <%=dBean.getTotalPages()%>&nbsp;
   <button type="button" onclick="next()" title="<%=LabelManager.getToolTip(labelSet,"btnNavNext")%>">&gt;</button>
   <button type="button" onclick="last()" title="<%=LabelManager.getToolTip(labelSet,"btnNavLast")%>">&gt;&gt;</button>&nbsp;
  <!--     - <button type="button" onclick="refresh()"><%=LabelManager.getName(labelSet,"lblRef")%></button>          -->
  <%=LabelManager.getName(labelSet,"lblNavShow")%>: <select name="showRegs" onchange="setShowRegs();">
    <option value="<%= Parameters.ROWS_PER_PAGE_QUERY %>" <%= (dBean.getRowsPerPage() == Parameters.ROWS_PER_PAGE_QUERY)?"selected":"" %>><%= Parameters.ROWS_PER_PAGE_QUERY %></option>
    <option value="<%= Parameters.ROWS_PER_PAGE_QUERY * 2%>" <%= (dBean.getRowsPerPage() == Parameters.ROWS_PER_PAGE_QUERY * 2)?"selected":"" %>><%= Parameters.ROWS_PER_PAGE_QUERY * 2%></option>
    <option value="<%= Parameters.ROWS_PER_PAGE_QUERY * 5%>" <%= (dBean.getRowsPerPage() == Parameters.ROWS_PER_PAGE_QUERY * 5)?"selected":"" %>><%= Parameters.ROWS_PER_PAGE_QUERY * 5%></option>
  </select>
 </td>
<td align="right" width="0">
	<% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_EXPORT)) { %><button type="button" onclick="btnExport_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExport")%>" title="<%=LabelManager.getToolTip(labelSet,"btnExport")%>"><%=LabelManager.getNameWAccess(labelSet,"btnExport")%></button><% } %>
	<% if (queryVo.getButtonValue(QueryVo.FLAG_SHOW_BUTTON_PRINT)) { %><button type="button" onclick="btnPrint_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnStaPri")%>" title="<%=LabelManager.getToolTip(labelSet,"btnStaPri")%>"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button><% } %>
</td>
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
</tr></table>