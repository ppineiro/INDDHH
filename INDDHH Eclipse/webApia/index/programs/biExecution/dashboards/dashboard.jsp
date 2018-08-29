<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="dashBean" scope="session" class="com.dogma.bean.administration.DashboardBean"></jsp:useBean><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><script language="javascript">
	function setWidgetsSize(){
		sizeWidgets();
		addListener(window,"resize",sizeWidgets);
	}
	function sizeWidgets(){
		
		if(MSIE) {
			document.getElementById('divContent').style.overflowX = 'hidden';
			document.getElementById('divContent').style.overflowY = 'hidden';
		}
		
		document.getElementById('widgets').style.position = 'relative';
		document.getElementById('widgets').style.width = (document.getElementById('divContent').offsetWidth - (MSIE ? 0 : 9)) + 'px';
		document.getElementById('widgets').style.height = document.getElementById('divContent').offsetHeight + 'px';
	}
</script></head><% Integer dshId = new Integer(request.getParameter("dshId"));
   HashMap widProperties = dashBean.getWidProperties(dshId);
   HashMap dshProperties = dashBean.getDshProperties(dshId);
   Collection widCol = dashBean.getWidgets(dshId);
   double maxWidth = 1200;
   double maxHeight = 800;
   boolean separator = false;
   if (((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_WIDTH))!=null){
	   maxWidth = new Double(((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_WIDTH)).getPropValue()).doubleValue();
   }
   if (((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_HEIGHT))!=null){
	   maxHeight = new Double(((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_HEIGHT)).getPropValue()).doubleValue();
   }
   if (((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_SEPARATOR))!=null){
	   separator = "true".equals(((WidPropertiesVo)widProperties.get("-1_" + DashboardVo.DASHBOARD_PROP_SEPARATOR)).getPropValue());
   }
%><body onload="setWidgetsSize()" style="overflow:auto"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=dashBean.getDashboardTitle(dshId)%></TD><TD></TD></TR></TABLE><div id="divContent"><div id="widgets" style="overflow:auto"><% if (widCol!=null && widCol.size()>0){
	Iterator widIt = widCol.iterator();
	double posX = 0;
	double posY = 0;
	int errorFound = 0;
	boolean seeBorder;
	boolean stop = false;
	while (widIt.hasNext() && !stop){
		seeBorder = false;
		WidgetVo widVo = (WidgetVo) widIt.next();
		if ((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)==null){
			errorFound=1;		
		}
		if ((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)==null){
			errorFound=2;	
		}
		if (widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_X) == null || widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_Y) == null){
			errorFound=3;
		}
		if (errorFound==0){
			double width = new Double(((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_WIDTH)).getPropValue()).doubleValue();
			double height = new Double(((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_HEIGHT)).getPropValue()).doubleValue();
			posX = new Double(((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_X)).getPropValue()).doubleValue();
			posY = new Double(((WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_Y)).getPropValue()).doubleValue();
			WidPropertiesVo widPropVo = (WidPropertiesVo)widProperties.get(widVo.getWidId().intValue() + "_" + WidgetVo.WIDGET_PROP_VIEW_BORDER);
			if (widPropVo!=null){
				seeBorder = "true".equals(widPropVo.getPropValue());
			}
			String scrolling="";
			if (widVo.getWidType().intValue() == WidgetVo.WIDGET_TYPE_CUBE_ID.intValue()){
				scrolling = "no";
			}
			%><iframe id="ifrMain" scrolling="<%=scrolling%>" style="position:absolute;top:<%=posY%>px;left:<%=posX%>px;border:<%=(seeBorder)?1:0%>px solid black; width:<%=width%>px; height:<%=height%>px" frameborder="0" allowtransparency="true" src="biExecution.DashboardAction.do?action=loadWidget&executeHere=true&dshId=<%=dshId.intValue()%>&widId=<%=widVo.getWidId().intValue()%>&widType=<%=widVo.getWidType().intValue()%>"></iframe><%
		}else if (errorFound==1){
			%>
				Some widget Width not found, Dashboard must be re-confirmed
			<%
			stop = true;
			errorFound=0;
		}else if (errorFound==2){
			%>
				Some widget Height not found, Dashboard must be re-confirmed
			<%
			stop = true;
			errorFound=0;
		}else if (errorFound==3){
			%>
			Some widget position not found, Dashboard must be re-confirmed
			<%
			stop = true;
			errorFound=0;
		}
	} 
  }%></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD colspan=3 align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%
  //Seteamos en false la variable de sincronizacion de despliegue de los cubos	
  request.getSession().setAttribute("busy",new Boolean(false));
%><%@include file="../../../components/scripts/server/endInc.jsp"%>
