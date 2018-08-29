<%@page import="java.util.ArrayList"%><%@page import="java.util.Collection"%><%@page import="biz.statum.apia.utils.charts.xycharts.BarChart3D"%><%@page import="biz.statum.apia.utils.charts.xycharts.LineChart"%><%@page import="biz.statum.apia.utils.charts.StatumChart"%><%@page import="biz.statum.apia.utils.ChartUtils"%><%@page import="biz.statum.apia.utils.charts.piecharts.PieChart3D"%><%@page import="org.jfree.chart.axis.ValueAxis"%><%@page import="org.jfree.chart.renderer.category.BarRenderer"%><%@page import="org.jfree.chart.axis.CategoryLabelPositions"%><%@page import="org.jfree.chart.axis.CategoryAxis"%><%@page import="org.jfree.data.category.DefaultCategoryDataset"%><%@page import="org.jfree.chart.plot.PlotOrientation"%><%@page import="org.jfree.chart.plot.Plot"%><%@page import="java.util.HashMap"%><%@page import="org.jfree.ui.RectangleInsets"%><%@page import="org.jfree.chart.renderer.category.BarRenderer3D"%><%@page import="biz.statum.apia.framework.splash.panels.CustomUserWorkTaskExecutionClass"%><%@page import="java.text.AttributedString"%><%@page import="java.text.DecimalFormat"%><%@page import="org.jfree.chart.labels.StandardCategoryItemLabelGenerator"%><%@page import="org.jfree.chart.labels.CategoryItemLabelGenerator"%><%@page import="com.dogma.Configuration"%><%@page import="org.jfree.chart.renderer.category.CategoryItemRenderer"%><%@page import="org.jfree.chart.plot.CategoryPlot"%><%@ page import = "org.jfree.chart.ChartFactory" %><%@ page import = "org.jfree.chart.JFreeChart" %><%@ page import = "org.jfree.chart.plot.PiePlot3D" %><%@ page import = "org.jfree.data.general.DefaultPieDataset" %><%@ page import = "org.jfree.data.general.PieDataset" %><%@ page import = "org.jfree.ui.ApplicationFrame" %><%@ page import = "org.jfree.ui.RefineryUtilities" %><%@ page import = "org.jfree.util.Rotation" %><%@ page import = "java.awt.image.*" %><%@ page import = "javax.imageio.ImageIO"%><%@page import="java.io.*" %><%@page import="java.awt.*"%><%@page import="com.st.util.*"%><%
try{
	request.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
	response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);	
	response.setContentType("image/jpeg");
	response.setDateHeader ("Expires",0);

	out.clear(); 
	out = pageContext.pushBody();
	java.io.OutputStream outb=response.getOutputStream();
	 
	String[] proNames = request.getParameterValues("n");
	String[] proCants = request.getParameterValues("c");
	
	double total=0;

	//Tamaño por defecto
	int w=450;
	int h=300;
	
	//Recuperamos los parámetros
	String schema = request.getParameter("s"); //schema de colores que se desea usar
	String mode = request.getParameter("v");   //tipo de grafico (pie3D, barV3d or barH3d)
	
	if (schema == null || schema.length() == 0) schema = ChartUtils.COLOR_DEFAULT; //Color por defecto en Apia
	if (mode == null || mode.length() == 0) mode = ChartUtils.CHART_PIE_3D; //Grafico por defecto para el splash

	try { w = Integer.parseInt(request.getParameter("w")); } catch (Exception e) {}
	try { h = Integer.parseInt(request.getParameter("h")); } catch (Exception e) {}
	
	String title = request.getParameter("title"); //Título del grafico
	if (title == null) title = "";
	
	String avoidLegend = request.getParameter("avoidLegend");
	String avoidLabels = request.getParameter("avoidLabels");
	boolean showLegend = false; //avoidLegend == null || "false".equalsIgnoreCase(avoidLegend);
	boolean showLabels = proNames.length <= 10; //avoidLegend == null || "false".equalsIgnoreCase(avoidLabels);
	
	Image img = null;
	Collection<Comparable> categories = new ArrayList<Comparable>();
	
	//Create chart
	if (ChartUtils.CHART_PIE_3D.equals(mode)) { //Si es de tipo torta 3d
		
		//Creamos el dataset a utilizar
		DefaultPieDataset dataset = new DefaultPieDataset();
		for(int i=0;i<proNames.length;i++) total+=Double.parseDouble(proCants[i]);
		for(int i=0;i<proNames.length;i++){
			dataset.setValue(proNames[i],(Double.parseDouble(proCants[i])*100)/total);
			categories.add(proNames[i]);
		}
		
		//Creamos el chart
		PieChart3D chart  = ChartUtils.getPieChart3D(dataset, "", showLegend);

		//Seteamos el formato definido por defecto por Apia
		chart.setColorSchema(schema);
		chart.setApiaDefaultFormat(categories);
		
		//Recuperamos la imagen con el gráfico
		img= chart.getChart().createBufferedImage(w,h);
		
	}else { //es de tipo barras

		//Creamos el dataset a utilizar
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		for(int i=0;i<proNames.length;i++) {
			dataset.addValue(Double.parseDouble(proCants[i]), "", proNames[i]);
			categories.add(proNames[i]);
		}
		
		//Recuperamos la orientación definida para el bar actual
		PlotOrientation orientation = PlotOrientation.VERTICAL;
		if (ChartUtils.CHART_BAR_H_3D.equals(mode)) orientation = PlotOrientation.HORIZONTAL;
		
		//Creamos el chart
		BarChart3D chart = ChartUtils.getBarChart3D(dataset, title, "", "", orientation, showLegend, false, false);
		
		//Seteamos el formato definido por defecto por Apia
		chart.setColorSchema(schema);
		chart.setApiaDefaultFormat();
		
		//Recuperamos la imagen con el gráfico
		img= chart.getChart().createBufferedImage(w,h);
	}
	
	//Insertamos la imagen con el grafico en el jsp
	BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
    Graphics2D g2d = bi.createGraphics();
    g2d.drawImage(img, 0, 0,w,h,null);
	ImageIO.write( bi, "png", outb);
	outb.close();
	

} catch(Exception e){
	
	e.printStackTrace();
}
%>
