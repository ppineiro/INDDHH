<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
	CalendarVo calVo = gBean.getCalendar(new Integer(request.getParameter("calendarId")));
	Collection colFreeDays = calVo.getFreeDaysCol();
	Collection colLabDays  = calVo.getLabDaysCol();
	String[] horas={"00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"};       
%></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCal")%></TD><TD></TD></TR></TABLE><div id="divContent"><DIV class="subTit"><%=LabelManager.getName(labelSet,"txtAnaGenData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td class=readOnly><%out.print(calVo.getCalendarName());%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td class=readOnly style="width:600px;"><%out.print(calVo.getCalendarDesc());%></td></tr></table><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatDayLab")%></DIV><div class="tableContainerNoHScroll" style="height:155px;" type="grid" id="calGrid"><table cellpadding="0" cellspacing="0"><thead><tr><th style="display:none;width:0px;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">&nbsp;</th><th style="width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblDayFer")%>"><%=LabelManager.getName(labelSet,"lblDayFer")%></th><th style="width:60%" title="<%=LabelManager.getToolTip(labelSet,"lblHorario")%>"><%=LabelManager.getName(labelSet,"lblHorario")%></th></tr></thead><tbody><%if (colLabDays != null) {
								Iterator itLabDays = colLabDays.iterator();
								CalendarLaboralDaysVo calLabDaysVo = null;
								while (itLabDays.hasNext()) {
									calLabDaysVo = (CalendarLaboralDaysVo) itLabDays.next();
									%><TR value="<%=gBean.fmtInt(calLabDaysVo.getDay())%>" canModify="false"><TD STYLE="display:none;width:0px;"><input type="hidden"></input></TD><TD align="center" style="width:15%"><% String day = "";
											switch (calLabDaysVo.getDay().intValue()){
												case 1 : day=LabelManager.getName(labelSet,"lblDomingo");break;
												case 2 : day=LabelManager.getName(labelSet,"lblLunes");break;
												case 3 : day=LabelManager.getName(labelSet,"lblMartes");break;
												case 4 : day=LabelManager.getName(labelSet,"lblMiercoles");break;
												case 5 : day=LabelManager.getName(labelSet,"lblJueves");break;
												case 6 : day=LabelManager.getName(labelSet,"lblViernes");break;
												case 7 : day=LabelManager.getName(labelSet,"lblSabado");
											};
											out.print(gBean.fmtHTML(day));
										%></TD><TD align="center" style="width:15%"><% String horario = "";
										   horario = horas[calLabDaysVo.getTimeIni().intValue()-1] + " " + LabelManager.getName(labelSet,"lblA") + " " + horas[calLabDaysVo.getTimeFin().intValue()-1];
										   out.print(gBean.fmtHTML(horario));
											%></TD></TR><%}
							}%></tbody></table></div><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblFerDay")%></DIV><div class="tableContainerNoHScroll" style="height:140px;" type="grid" id="calGrid"><table cellpadding="0" cellspacing="0"><thead><tr><th style="display:none;width:0px;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>">&nbsp;</th><th style="width:40%" title="<%=LabelManager.getToolTip(labelSet,"lblDayFer")%>"><%=LabelManager.getName(labelSet,"lblDayFer")%></th></tr></thead><tbody><%if (colFreeDays != null) {
								Iterator itFreeDays = colFreeDays.iterator();
								CalendarFreeDaysVo calFreeDaysVo = null;
								int i=0;
								while (itFreeDays.hasNext()) {
									i++;
									calFreeDaysVo = (CalendarFreeDaysVo) itFreeDays.next();
									%><TR value="<%=i%>" canModify="false"><TD STYLE="display:none;width:0px;"><input type="hidden"></input></TD><TD align="center" style="width:15%"><% out.print(gBean.fmtHTML(calFreeDaysVo.getDay()));
											%></TD></TR><%}
							}%></tbody></table></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" id="exit" onclick="window.close()" accesskey="S" title="Salir"><U>S</U>alir</button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %>