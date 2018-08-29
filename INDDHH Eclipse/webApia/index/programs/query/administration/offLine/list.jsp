<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="java.util.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.OffLineBean"></jsp:useBean><%
QueryVo queryVo = dBean.getQueryVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQry")%>: <%= dBean.fmtHTML(queryVo.getQryTitle()) %></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px" onselect="enabledButons()" multiSelect="false"><table width="100%" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">&nbsp;</th><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblFec")%>"><%=LabelManager.getName(labelSet,"lblFec")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblType")%>"><%=LabelManager.getName(labelSet,"lblType")%></th></tr></thead><tbody><%
				   			String label = null;
				   		    Collection col = dBean.getFileList();
							int i = 0;
							boolean hasView = false;
							boolean hasDown = false;
							if (col != null) {
								Iterator it = col.iterator();
								QryResultFileVo resultVo = null;
								while (it.hasNext()) {
									resultVo = (QryResultFileVo) it.next(); 
									if (! resultVo.isHtmlPage()) { 
										if (QryColumnVo.OFF_LINE_SAVE_AS_PDF.equals(resultVo.getFileType())) {
											label = "lblPdf";
											hasDown = true;
										} else if (QryColumnVo.OFF_LINE_SAVE_AS_HTML.equals(resultVo.getFileType())) {
											label = "lblHtml";
											hasView = true;
										} else if (QryColumnVo.OFF_LINE_SAVE_AS_CSV.equals(resultVo.getFileType())) { 
						   					label = "lblCsv";
											hasDown = true;
										} else if (QryColumnVo.OFF_LINE_SAVE_AS_EXCEL.equals(resultVo.getFileType())) {
											label = "lblExcel";
											hasDown = true;
										} %><tr type="<%= resultVo.getFileType() %>" file="<%=dBean.fmtStr(resultVo.getFileName())%>"><td style="width:0px;display:none;"><input type="checkbox" id="idSel" name="chkSel<%=i%>" value="on"></td><%String strValue=dBean.fmtDateAMPM(resultVo.getDate());%><td title="<%=strValue%>"><%=strValue%></td><%strValue=((label != null)?LabelManager.getName(labelSet,label):"");%><td title="<%=strValue%>" align="center"><%= strValue %><%if (resultVo.getPage() != null) {%> (<%= resultVo.getPage() %>)<% } %></td></tr><%
										i++;
									}
								}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td></td><td><input type="hidden" name="count" value="<%= i %>"><input type="hidden" id="fileToProcess" name="fileToProcess" value=""><button type="button" id="btnView" <% if(!hasView) { %>style="display:none"<%}%> disabled onclick="btnView_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnView")%>" title="<%=LabelManager.getToolTip(labelSet,"btnView")%>"><%=LabelManager.getNameWAccess(labelSet,"btnView")%></button><button type="button" id="btnDown" <% if(!hasDown) { %>style="display:none"<%}%> disabled onclick="btnDowload_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDow")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDow")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDow")%></button></td></tr></table><IFRAME name="idResult" id="idResult" height="0" width="0" frameborder="0"></IFRAME></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
var typePdf		= "<%= QryColumnVo.OFF_LINE_SAVE_AS_PDF %>";
var typeHtml	= "<%= QryColumnVo.OFF_LINE_SAVE_AS_HTML %>";
var typeCsv		= "<%= QryColumnVo.OFF_LINE_SAVE_AS_CSV %>";
var typeExcel	= "<%= QryColumnVo.OFF_LINE_SAVE_AS_EXCEL %>";

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/offLine/list.js'></script>
