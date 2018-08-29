<%@ page import = "org.jfree.chart.*" %><%@ page import = "org.jfree.data.*" %><%@ page import = "java.io.*" %><%@ page import = "java.text.*" %><%@ page import = "java.util.*" %><%@ page import = "java.awt.Color" %><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="org.jfree.chart.renderer.category.LineAndShapeRenderer"%><%@page import="java.awt.BasicStroke"%><%@page import="org.jfree.chart.plot.CategoryPlot"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><% 
	Integer widId = null;
	Integer widRefresh = null;
	Integer widRefType = null;
	Double width = new Double(720);
	Double height = new Double (580);
	
	String widName = "";
	int refresh = 0; //por defecto no se refresca

   if (request.getParameter("widId") != null){ //from widgtet of type cube or query
	   widId = new Integer(request.getParameter("widId"));
   }

   if (request.getParameter("widRefType") != null){
	   widRefType = new Integer(request.getParameter("widRefType"));
   }
   if (request.getParameter("widRefresh")!=null){
	   widRefresh = new Integer(request.getParameter("widRefresh"));
	   if (widRefresh.intValue() != 0){
		   if (widRefType.intValue() == WidgetVo.WIDGET_REF_TIME_SEC.intValue()){ //segundos
			   refresh = widRefresh.intValue(); //ya estan en segundos
			}else if (widRefType.intValue() == WidgetVo.WIDGET_REF_TIME_MIN.intValue()){//minutos
				refresh = widRefresh.intValue() * 60; //los pasamos a segundos		
			}else{
				refresh = widRefresh.intValue() * 60 * 60;	//los pasamos segundos
			}
	   }
   }
   refresh = 0; //No refrescamos la pantalla de historico nunca debido a BUG en el que se llena la pantalla de valores.
   if (request.getParameter("widName")!=null){
	   widName = request.getParameter("widName");
   }
   if (request.getParameter("width")!=null){
	   width = new Double(request.getParameter("width")) - 30;
   }
   if (request.getParameter("height")!=null){
	   height = new Double(request.getParameter("height")) - 60;
   }

   
%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><title><%=LabelManager.getName(labelSet,"lblWidHistory").replace("<TOK1>", " " + widName)+ " "%></title></head><body style="overflow:auto""><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"lblWidHistory").replace("<TOK1>", " " + widName)+ " "%></TD><TD></TD></TR></TABLE><div id="divContent"><iframe id="ifrMain" frameborder="0" allowtransparency="true" width="<%=width%>" height="<%=height%>" FRAMEBORDER="0" src="biExecution.DashboardAction.do?action=loadWidgetHistory&executeHere=true&widId=<%=widId.intValue()%>&width=<%=width%>&height=<%=height%>&refresh=<%=refresh%>"></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD colspan=3 align="right"><button type="button" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%>

