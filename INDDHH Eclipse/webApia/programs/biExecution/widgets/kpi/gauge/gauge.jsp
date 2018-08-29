<%@page import="com.dogma.vo.WidgetVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.WidKpiZoneVo"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
response.setContentType("text/xml");
String c=request.getParameter("id");
Integer widId = new Integer(request.getParameter("widId"));
boolean viewTimer = "true".equals(request.getParameter("viewTimer"));
WidgetVo widVo = wBean.getWidgetVo(widId);
String defaultColor = "0xD8D8D8";
Collection colNextVal = wBean.getNextValue(widVo,request);
Double nextValue = null;
boolean inconsistent = false;
Integer style = new Integer(1); //por defecto
Integer refTimeType = widVo.getWidRefType();
int refTime = 600; //por defecto 10 minutos (10 minutos sera para los que estan siempre activos)
if (widVo.getWidRefresh().intValue() != 0){
	refTime = widVo.getWidRefresh().intValue();
}
if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_SEC.intValue()){ //segundos
	refTime = refTime * 1000;
}else if (refTimeType.intValue() == WidgetVo.WIDGET_REF_TIME_MIN.intValue()){//minutos
	refTime = refTime * 60 * 1000;		
}else{
	refTime = refTime * 60 * 60 * 1000;	
}

if (widVo.getWidKpiStyle() != null){
	style = widVo.getWidKpiStyle();
}

if (colNextVal!=null && colNextVal.size()>0){
	Iterator itNextVal = colNextVal.iterator();
	Object obj = itNextVal.next();
	if (obj!=null){
		nextValue = (Double)obj;
	}
}
if (nextValue == null || nextValue.doubleValue() < widVo.getWidKpiMin().intValue() || nextValue.doubleValue() > widVo.getWidKpiMax().intValue()){
	inconsistent = true;
}
%><gauges><gauge-definition><gauge id="<%=widId%>" title="<%=widVo.getWidName()%>" valueStart="<%=widVo.getWidKpiMin().intValue()%>" valueEnd="<%=widVo.getWidKpiMax().intValue()%>" valueCurrent="<%=nextValue%>" seeTimer="<%=viewTimer%>" refreshTime="<%=refTime%>" url="<%=Parameters.ROOT_PATH%>/programs/biExecution/widgets/kpi/gauge/gauge.jsp?widId=<%=widId.intValue()%>" inconsistent="<%=inconsistent %>" isFather="false" style="<%=style.intValue()%>"><definition><% Collection widZneCol = widVo.getZones();
				   if (widZneCol!=null && widZneCol.size()>0){
					   Iterator widZneIt = widZneCol.iterator();
					   while (widZneIt.hasNext()){
						   WidKpiZoneVo zoneVo = (WidKpiZoneVo) widZneIt.next();
						   if (zoneVo.getWidZneColor()!= null && !"".equals(zoneVo.getWidZneColor())){%><section color="<%=zoneVo.getWidZneColor().replace("#","0x")%>" min="<%=zoneVo.getWidZneMin().toString()%>" max="<%=zoneVo.getWidZneMax().toString()%>"/><%}else{%><section color="<%=defaultColor%>" min="<%=zoneVo.getWidZneMin().toString()%>" max="<%=zoneVo.getWidZneMax().toString()%>"/><%}
					    }
				   }else{%><section color="<%=defaultColor%>" min="<%=widVo.getWidKpiMin().toString()%>" max="<%=widVo.getWidKpiMax().toString()%>"/><%}
				%></definition></gauge></gauge-definition><menu-definition></menu-definition></gauges>