<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CalendarBean"></jsp:useBean><%! 
String getOption(int value, String text , boolean selected){
	String option= new String("<option value='"+value+"'");
	if(selected == true){
		option+="selected='true' ";
	}
	option+=">"+text+" </option>";
	return option;
}
%><%
String[] horas={"00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30","05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"};       
Collection horasColIni = new ArrayList(); //Colección de horas de inicio para cada dia
Collection horasColEnd = new ArrayList(); //Coleccion de horas de fin para cada dia
CalendarVo calVo = dBean.getCalendarVo(); //Objeto calendario con id, nombre y descripcion
Collection freeDays = dBean.getFreeDays();//Coleccion de dias feriados (objetos CalendarFreeDaysVo) 
Collection labDays = dBean.getLabDays();  //Coleccion de dias laborales (objetos CalendarLaboralDaysVo)

String horasIni = "";
Collection tempLD = labDays;
Iterator itTempLD = null;
if (tempLD != null){
	itTempLD = tempLD.iterator();
}
boolean selected = false;
CalendarLaboralDaysVo tempVo = null;
if (itTempLD != null && itTempLD.hasNext()){
	tempVo = (CalendarLaboralDaysVo)itTempLD.next();
}

for (int j=1;j<8;j++){
	horasIni = "";
	for(int i=0;i<horas.length;i++){
		if (tempVo != null){
			if ((tempVo.getDay().intValue() == (new Integer (j)).intValue()) && (tempVo.getTimeIni().intValue() == (new Integer (i+1)).intValue())){
				selected=true;
				if (itTempLD.hasNext()){
					tempVo = (CalendarLaboralDaysVo)itTempLD.next();
				}else {
					tempVo = null;
				}
			}else {
				selected = false;
			}
		}else {
			selected = false;
		}
		if (calVo != null && calVo.getCalendarId() != null){
			horasIni+=getOption((i+1),horas[i],selected);
		}else{
			horasIni+=getOption((i+1),horas[i],false);
		}
	}
	horasColIni.add(horasIni);
}

tempLD = labDays;
itTempLD = null;
if (tempLD != null){
	itTempLD = tempLD.iterator();
}
String horasFin = "";
if (itTempLD != null && itTempLD.hasNext()){
	tempVo = (CalendarLaboralDaysVo)itTempLD.next();
}
selected = false;
for (int j=1;j<8;j++){
	horasFin="";
	for(int i=0;i<horas.length;i++){
		if (tempVo != null){
			if ((tempVo.getDay().intValue() == (new Integer(j)).intValue()) && (tempVo.getTimeFin().intValue() == (new Integer (i+1)).intValue())){
				selected=true;
				if (itTempLD.hasNext()){
					tempVo = (CalendarLaboralDaysVo)itTempLD.next();
				}else {
					tempVo = null;
				}
			}else {
				selected = false;
			}
		}else {
			selected = false;
		}
		if (calVo != null && calVo.getCalendarId() != null){
			horasFin+=getOption((i+1),horas[i],selected);
		}else{
			horasFin+=getOption((i+1),horas[i],false);
		}
	}
	horasColEnd.add(horasFin);
}

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCal")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"txtAnaGenData")%></DIV><br><table class="tblFormLayout"><tr><td align=left colspan=4><table><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(calVo!=null && calVo.getCalendarId() != null) {%>value="<%=dBean.fmtStr(calVo.getCalendarName())%>"<%}%>></td><td></td><td></td></tr><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(calVo!=null && calVo.getCalendarId() != null) {%>value="<%=dBean.fmtStr(calVo.getCalendarDesc())%>"<%}%>></td><td><input name="hidCalId" type="hidden" value= "<%=calVo.getCalendarId()%>"></td></tr></table></tr></table><br><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatDayLab")%></DIV><br><table class="tblFormLayout"><tr><td></td><td></td><td></td><td></td></tr><tr><td align=left colspan=4><table><%  int labDay = 0;
			   			Iterator itLabD = null;
			   			CalendarLaboralDaysVo calLabDayVo = null;
			   			if (calVo != null && calVo.getCalendarId() != null && labDays != null){
			   		   		itLabD = labDays.iterator();
			   		   		if (itLabD.hasNext()){
			 			   		calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
		 			   			labDay = (calLabDayVo.getDay()).intValue();
		 			   		}
		 			   }
		 			   Iterator itHCIni = horasColIni.iterator();
		 			   Iterator itHCFin = horasColEnd.iterator();
		 			   boolean disabled = true;
		 			   String str = "";
		 			 %><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDomingo")%>"><%=LabelManager.getName(labelSet,"lblDomingo")%>:</td><td><input name="chkLabDays" id="chkLabDays1" value=1 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 1){
			   					%> checked = "true" <%
			   					disabled = false;
			   					str = "1";
			   					if (itLabD.hasNext()){
				   					calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   				  	}
			   				 } else {
			   				 	str = "0";
			   				 	disabled = true;
			   				 }%>
			   			> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" id="lblHorSta" disabled = <%=disabled%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId1" <%if (disabled==true){%> disabled <%};%> onchange="changeIniOthers(1)"><%=(String)itHCIni.next()%></select>&nbsp;&nbsp;&nbsp;</td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId1" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(1)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLunes")%>"><%=LabelManager.getName(labelSet,"lblLunes")%>:</td><td><input name="chkLabDays" id="chkLabDays2" value=2 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 2){
			   					%> checked = "true" <%
			   					disabled = false;
			   					str = str + "1";
			   					if (itLabD.hasNext()){
			   						calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   					}
			   				   }else{
 	 		   				    str = str + "0";
			   				   	disabled = true;
			   				   }%>
			   			></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" id="lblHorSta" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId2" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(2)"><%=(String)itHCIni.next()%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId2" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(2)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMartes")%>"><%=LabelManager.getName(labelSet,"lblMartes")%>:</td><td><input name="chkLabDays" id="chkLabDays3" value=3 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 3){
			   					%> checked = "true" <%
			   					disabled = false;
			   					str = str + "1";
			   					if (itLabD.hasNext()){
			   						calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   					}
			   				} else {
			   				   str = str + "0";
			   					disabled = true;
			   				}%>
			   			></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" id="lblHorSta" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId3" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(3)"><%=(String)itHCIni.next()%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId3" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(3)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMiercoles")%>"><%=LabelManager.getName(labelSet,"lblMiercoles")%>:</td><td><input name="chkLabDays" id="chkLabDays4" value=4 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 4){
			   					%> checked = "true" <%
			   					disabled=false;
			   					str = str + "1";
				   				if (itLabD.hasNext()){
				   					calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
				   				}
				   			   }else{
				   			        str = str + "0";
				   			   		disabled=true;
				   			   }%>
				   		></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId4" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(4)"><% String test = (String) itHCIni.next();%><%=test%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId4" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(4)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblJueves")%>"><%=LabelManager.getName(labelSet,"lblJueves")%>:</td><td><input name="chkLabDays" id="chkLabDays5" value=5 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 5){
			   					%> checked = "true" <%
			   					disabled=false;
			   					str = str + "1";
			   					if (itLabD.hasNext()){
			   						calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   					}
			   				   }else{
 			   				        str = str + "0";
			   				   		disabled=true;
			   				   }%>
			   			></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId5" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(5)"><%=(String)itHCIni.next()%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId5" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(5)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblViernes")%>"><%=LabelManager.getName(labelSet,"lblViernes")%>:</td><td><input name="chkLabDays" id="chkLabDays6" value=6 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 6){
			   					%> checked = "true" <%
			   					disabled=false;
			   					str = str + "1";
			   					if (itLabD.hasNext()){
			   						calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   					}
			   				   }else{
			   				        str = str + "0";
			   				   		disabled=true;
			   				   }
			   				 %>
			   			></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId6" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(6)"><%=(String)itHCIni.next()%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId6" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(6)"><%=(String)itHCFin.next()%></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblSabado")%>"><%=LabelManager.getName(labelSet,"lblSabado")%>:</td><td><input name="chkLabDays" id="chkLabDays7" value=7 type="checkbox" onclick="ableHour(this)"
			   				<% if (labDay == 7){
			   					%> checked = "true" <%
			   					disabled=false;
			   					str = str + "1";
			   					if (itLabD.hasNext()){
			   						calLabDayVo = (CalendarLaboralDaysVo) itLabD.next();
			   						labDay = (calLabDayVo.getDay()).intValue();
			   					}
			   			      }else{
			   			        str = str + "0";
			   			      	disabled=true;
			   			      }%>
			   			></td><td title="<%=LabelManager.getName(labelSet,"lblHorSta")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorSta")%>:</td><td rowspan=1><select name="selHourIniId" id="selHourIniId7" <%if (disabled) {%> disabled <%}%> onchange="changeIniOthers(7)"><%=(String)itHCIni.next()%></select></td><td title="<%=LabelManager.getName(labelSet,"lblHorEnd")%>" <%if (disabled) {%> disabled <%}%>><%=LabelManager.getNameWAccess(labelSet,"lblHorEnd")%>:</td><td rowspan=1><select name="selHourEndId" id="selHourEndId7" <%if (disabled) {%> disabled <%}%> onchange="changeEndOthers(7)"><%=(String)itHCFin.next()%></select></td></tr><tr><td><input name="hoursIniSelected" value="<%=str%>" type="hidden"></td><td><input name="hoursEndSelected" value="<%=str%>" type="hidden"></td></tr></table></td></tr></table><br><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblFerDay")%></DIV><br><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td></td><td></td><td></td></tr><tr><td align=left style="margin:100px" colspan=4><table><tr><td title="<%=LabelManager.getName(labelSet,"lblDayFer")%>"><%=LabelManager.getName(labelSet,"lblDayFer")%>:</td><td><input name="txtFch" id="txtFch" size="10" p_calendar="true" class="txtDate" p_mask="<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>"maxlength="10" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecDes")%>" type="text" value=""></td></td><td></td><td><button type="button" onclick="addHoliday_click()" title="<%=LabelManager.getToolTip(labelSet,"lblAddHol")%>">&gt;&gt;</button><br><br><button type="button" onclick="delHoliday_click()" title="<%=LabelManager.getToolTip(labelSet,"lblDelHol")%>">&lt;&lt;</button></td><td></td><td rowspan=3><select multiple style="height:60px;width:100px" name="txtHolidays" id="txtHolidays" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><%if (freeDays != null && calVo != null && calVo.getCalendarId()!= null){
									Iterator it = freeDays.iterator();
									int i=0;
									while (it.hasNext()){
									CalendarFreeDaysVo calFreeDaysVo = (CalendarFreeDaysVo) it.next();%><option value="<%=i%>"><%=calFreeDaysVo.getDay()%></option><%
										i++;
									}
								}%><td style="width:10px" align=left style="PADDING-TOP:0px;PADDING-BOTTOM:20px;" title="<%=LabelManager.getToolTip(labelSet,"msgClkHer")%>"><img style="cursor:hand;position:static;" src='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif' onclick='allYears()'></td><td><input name="hidHolidays" type="hidden" value= ""/><input name="hidDateAllYear" id="hidDateAllYear" type="hidden" value=""/></td></select></td></tr></table></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language=javascript>
var MSG_WRNG_INTERVAL = "<%=LabelManager.getName(labelSet,"msgWrngInt")%>";
var MSG_MUST_SEL_DAY = "<%=LabelManager.getName(labelSet,"msgSelDay")%>";
var MSG_WRNG_DAY = "<%=LabelManager.getName(labelSet,"msgWrngDay")%>";
var MSG_SUN = "<%=LabelManager.getName(labelSet,"lblDomingo")%>";
var MSG_MON = "<%=LabelManager.getName(labelSet,"lblLunes")%>";
var MSG_TUE = "<%=LabelManager.getName(labelSet,"lblMartes")%>";
var MSG_WED = "<%=LabelManager.getName(labelSet,"lblMiercoles")%>";
var MSG_THU = "<%=LabelManager.getName(labelSet,"lblJueves")%>";
var MSG_FRI = "<%=LabelManager.getName(labelSet,"lblViernes")%>";
var MSG_SAT = "<%=LabelManager.getName(labelSet,"lblSabado")%>";
</script><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/administration/calendar/update.js'></script>
