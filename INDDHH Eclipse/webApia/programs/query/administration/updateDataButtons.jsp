<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.business.querys.factory.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabQryBut")%>" tabText="<%=LabelManager.getName(labelSet,"tabQryBut")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryBut")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><% Collection buttons = QueryButtons.getQueryButtons(queryVo);
							if (buttons != null) {
								for (Iterator it = buttons.iterator(); it.hasNext(); ) {
									QueryShowButtonVo buttonVo = (QueryShowButtonVo) it.next();
									if (buttonVo.getButtonCode() == -1) {
										%><tr><td colspan="4"><DIV class="subTit"><%=LabelManager.getName(labelSet,buttonVo.getButtonLabel())%></DIV></td></tr><%
									} else {
										%><tr><td><input type="checkbox" value="1" name="chkBut<%= buttonVo.getButtonCode() %>" id="chkPaged" <%= queryVo.getButtonValue(buttonVo.getButtonCode())?"checked":"" %>></td><td colspan="3"><%=LabelManager.getName(labelSet,buttonVo.getButtonLabel())%></td></tr><%
									}
								}
							} %></table><% if (QueryVo.TYPE_QUERY.equals(queryVo.getQryType())) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryOpt")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><input type="checkbox" value="1" name="chkPaged" id="chkPaged" <%= queryVo.getFlagValue(QueryVo.FLAG_PAGED_QUERY)?"checked":"" %>></td><td colspan="3"><%=LabelManager.getName(labelSet,"lblQryPaged")%></td></tr></table><% } %></div>
