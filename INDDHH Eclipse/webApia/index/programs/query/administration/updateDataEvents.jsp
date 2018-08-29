<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><% if (! QueryVo.TYPE_OFF_LINE.equals(queryVo.getQryType())) { %><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabQryEvent")%>" tabText="<%=LabelManager.getName(labelSet,"tabQryEvent")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEvent")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryEvtLoad")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryEvtLoad")%>:</td><td colspan="3"><select name="cmbBusClaIdLoad" accesskey="<%=LabelManager.getToolTip(labelSet,"lblQryEvtLoad")%>"><option value=""></option><%
										if (dBean.getBusClasses() != null) {
											Iterator iterator = dBean.getBusClasses().iterator();
											QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_LOAD));
											BusClassVo busClassVo = null;
											while (iterator.hasNext()) {
												busClassVo = (BusClassVo) iterator.next(); %><option value="<%= dBean.fmtInt(busClassVo.getBusClaId()) %>" <%= (eventVo != null && busClassVo.getBusClaId().equals(eventVo.getBusClaId()))?"selected":"" %>><%= dBean.fmtStr(busClassVo.getBusClaName()) %></option><%
											}										
										} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryEvtFilter")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryEvtFilter")%></td><td colspan="3"><select name="cmbBusClaIdFilter" accesskey="<%=LabelManager.getToolTip(labelSet,"lblQryEvtFilter")%>"><option value=""></option><%
										if (dBean.getBusClasses() != null) {
											Iterator iterator = dBean.getBusClasses().iterator();
											QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_FILTER));
											BusClassVo busClassVo = null;
											while (iterator.hasNext()) {
												busClassVo = (BusClassVo) iterator.next(); %><option value="<%= dBean.fmtInt(busClassVo.getBusClaId()) %>" <%= (eventVo != null && busClassVo.getBusClaId().equals(eventVo.getBusClaId()))?"selected":"" %>><%= dBean.fmtStr(busClassVo.getBusClaName()) %></option><%
											}										
										} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryEvtFilterCha")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryEvtFilterCha")%></td><td colspan="3"><select name="cmbBusClaIdFilterCha" accesskey="<%=LabelManager.getToolTip(labelSet,"lblQryEvtFilterCha")%>"><option value=""></option><%
										if (dBean.getBusClasses() != null) {
											Iterator iterator = dBean.getBusClasses().iterator();
											QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_FILTER_CHANGE));
											BusClassVo busClassVo = null;
											while (iterator.hasNext()) {
												busClassVo = (BusClassVo) iterator.next(); %><option value="<%= dBean.fmtInt(busClassVo.getBusClaId()) %>" <%= (eventVo != null && busClassVo.getBusClaId().equals(eventVo.getBusClaId()))?"selected":"" %>><%= dBean.fmtStr(busClassVo.getBusClaName()) %></option><%
											}										
										} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryEvtBeforeGetSQL")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryEvtBeforeGetSQL")%></td><td colspan="3"><select name="cmbBusClaIdBeforeGetSQL" accesskey="<%=LabelManager.getToolTip(labelSet,"lblQryEvtBeforeGetSQL")%>"><option value=""></option><%
										if (dBean.getBusClasses() != null) {
											Iterator iterator = dBean.getBusClasses().iterator();
											QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_BEFORE_GET_SQL));
											BusClassVo busClassVo = null;
											while (iterator.hasNext()) {
												busClassVo = (BusClassVo) iterator.next(); %><option value="<%= dBean.fmtInt(busClassVo.getBusClaId()) %>" <%= (eventVo != null && busClassVo.getBusClaId().equals(eventVo.getBusClaId()))?"selected":"" %>><%= dBean.fmtStr(busClassVo.getBusClaName()) %></option><%
											}
										} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblQryEvtBeforShow")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryEvtBeforShow")%></td><td colspan="3"><select name="cmbBusClaIdBeforShow" accesskey="<%=LabelManager.getToolTip(labelSet,"lblQryEvtBeforShow")%>"><option value=""></option><%
										if (dBean.getBusClasses() != null) {
											Iterator iterator = dBean.getBusClasses().iterator();
											QryEvtBusClassVo eventVo = dBean.getQueryVo().getEvent(new Integer(EventVo.EVENT_QRY_BEFORE_SHOW));
											BusClassVo busClassVo = null;
											while (iterator.hasNext()) {
												busClassVo = (BusClassVo) iterator.next(); %><option value="<%= dBean.fmtInt(busClassVo.getBusClaId()) %>" <%= (eventVo != null && busClassVo.getBusClaId().equals(eventVo.getBusClaId()))?"selected":"" %>><%= dBean.fmtStr(busClassVo.getBusClaName()) %></option><%
											}										
										} %></select></td></tr></table></div><%
				} %>
