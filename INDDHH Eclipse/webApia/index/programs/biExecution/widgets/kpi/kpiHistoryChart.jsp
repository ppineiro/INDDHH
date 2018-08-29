<%@ page import = "org.jfree.chart.*" %><%@ page import = "org.jfree.data.*" %><%@ page import = "java.io.*" %><%@ page import = "java.text.*" %><%@ page import = "java.util.*" %><%@ page import = "java.awt.Color" %><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="org.jfree.chart.plot.CategoryPlot"%><%@page import="org.jfree.chart.renderer.category.LineAndShapeRenderer"%><%@page import="java.awt.BasicStroke"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%
//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");

try {
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	response.setContentType("image/png"); 
	OutputStream outs = response.getOutputStream();
	
	JFreeChart chart = wBean.getHistoryChart(Integer.valueOf(request.getParameter("widId")));
	
	String color = "#f3f5f8";
	int sizeX = 550;
	int sizeY = 350;
	
	int	valueR = Integer.parseInt(color.substring(1, 3), 16);
	int	valueG = Integer.parseInt(color.substring(3, 5), 16);
	int	valueB = Integer.parseInt(color.substring(5, 7), 16);
	
	new Color(valueR,valueG,valueB);
	chart.setBackgroundPaint(new Color(valueR,valueG,valueB));
	
	CategoryPlot plot = chart.getCategoryPlot();
	
	//Hacemos la linea de la grafica mas gruesa
	LineAndShapeRenderer lrenderer = (LineAndShapeRenderer) plot.getRenderer();
    lrenderer.setStroke(new BasicStroke(4f, BasicStroke.JOIN_ROUND, BasicStroke.JOIN_BEVEL));

	//Mostramos puntos en la linea
    lrenderer.setShapesVisible(true);
    lrenderer.setFillPaint(Color.yellow);
    lrenderer.setUseFillPaint(true);
    
    //Escribimos la grafica
	ChartUtilities.writeChartAsPNG(outs,chart,sizeX,sizeY);
	
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
}finally{
//	Las siguientes dos lineas evitan la exception: java.lang.IllegalStateException: getOutputStream() has already been called for this response
	out.clear();
	out = pageContext.pushBody();
	////////////////////////////////////
}
%>
