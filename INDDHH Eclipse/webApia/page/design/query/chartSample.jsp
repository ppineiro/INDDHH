<%@page import="org.jfree.ui.TextAnchor"%><%@page import="org.jfree.chart.labels.ItemLabelAnchor"%><%@page import="org.jfree.chart.labels.ItemLabelPosition"%><%@page import="biz.statum.apia.utils.CustomLabelGenerator"%><%@page import="org.jfree.chart.renderer.category.LineAndShapeRenderer"%><%@page import="org.jfree.chart.plot.PiePlot"%><%@page import="biz.statum.apia.utils.charts.piecharts.PieChart"%><%@page import="com.dogma.vo.QryChartVo"%><%@page import="org.jfree.chart.ChartUtilities"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Collection"%><%@page import="biz.statum.apia.utils.charts.xycharts.BarChart3D"%><%@page import="biz.statum.apia.utils.charts.xycharts.LineChart"%><%@page import="biz.statum.apia.utils.charts.StatumChart"%><%@page import="biz.statum.apia.utils.ChartUtils"%><%@page import="biz.statum.apia.utils.charts.piecharts.PieChart3D"%><%@page import="org.jfree.chart.axis.ValueAxis"%><%@page import="org.jfree.chart.renderer.category.BarRenderer"%><%@page import="org.jfree.chart.axis.CategoryLabelPositions"%><%@page import="org.jfree.chart.axis.CategoryAxis"%><%@page import="org.jfree.data.category.DefaultCategoryDataset"%><%@page import="org.jfree.chart.plot.PlotOrientation"%><%@page import="org.jfree.chart.plot.Plot"%><%@page import="java.util.HashMap"%><%@page import="org.jfree.ui.RectangleInsets"%><%@page import="org.jfree.chart.renderer.category.BarRenderer3D"%><%@page import="biz.statum.apia.framework.splash.panels.CustomUserWorkTaskExecutionClass"%><%@page import="java.text.AttributedString"%><%@page import="java.text.DecimalFormat"%><%@page import="org.jfree.chart.labels.StandardCategoryItemLabelGenerator"%><%@page import="org.jfree.chart.labels.CategoryItemLabelGenerator"%><%@page import="com.dogma.Configuration"%><%@page import="org.jfree.chart.renderer.category.CategoryItemRenderer"%><%@page import="org.jfree.chart.plot.CategoryPlot"%><%@ page import = "org.jfree.chart.ChartFactory" %><%@ page import = "org.jfree.chart.JFreeChart" %><%@ page import = "org.jfree.chart.plot.PiePlot3D" %><%@ page import = "org.jfree.data.general.DefaultPieDataset" %><%@ page import = "org.jfree.data.general.PieDataset" %><%@ page import = "org.jfree.ui.ApplicationFrame" %><%@ page import = "org.jfree.ui.RefineryUtilities" %><%@ page import = "org.jfree.util.Rotation" %><%@ page import = "java.awt.image.*" %><%@ page import = "javax.imageio.ImageIO"%><%@page import="java.io.*" %><%@page import="java.awt.*"%><%@page import="com.st.util.*"%><%
try{
	request.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
	response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);	
	response.setContentType("image/jpeg");
	response.setDateHeader ("Expires",0);

 	out.clear(); 
	out = pageContext.pushBody();
	java.io.OutputStream outb=response.getOutputStream();
	
	//Tamaño por defecto
	int w=330;
	int h=240;
	
	String custom_width = request.getParameter("w");
	String custom_height = request.getParameter("h");
	if(custom_width != null)
		w = Integer.parseInt(custom_width);
	if(custom_height != null)
		h = Integer.parseInt(custom_height);
	
	Color whiteColor = new Color(255,255,255);
	
	if (request.getParameter("chartType")!=null && request.getParameter("chtSubType") != null){
	
		//Recuperamos los parámetros
		String chartType = request.getParameter("chartType");
		String chartSubType = request.getParameter("chtSubType");
		String chartSchema = request.getParameter("chartSchema"); //si es "0" usar seriesColors
		String seriesColor = request.getParameter("seriesColor"); //#343432;#121212
		String viewGrid = request.getParameter("viewGrid");
		String viewLegend = request.getParameter("viewLegend");
		String viewValues = request.getParameter("viewValues");
		String viewXLabels = request.getParameter("viewXLabels");
		String viewYLabels = request.getParameter("viewYLabels");
		
		boolean showLegend = true; 
		boolean showLabels = false; 
		
		Image img = null;
		Collection<Comparable> categories = new ArrayList<Comparable>();
		
		StatumChart chart = null;
		
		//Create chart
		if (QryChartVo.PIE == Integer.parseInt(chartType)) { //Si es de tipo torta
			
			DefaultPieDataset dataset = new DefaultPieDataset();
			Collection<Comparable> valueNames = new ArrayList<Comparable>();
			
			dataset.setValue("A", 1);
			dataset.setValue("B", 3);
			dataset.setValue("C", 2);
			dataset.setValue("D", 4);
			
			//Obtenemos el chart
			if (QryChartVo.SUBTYPE2D == Integer.valueOf(chartSubType)) { //Si 2D
				chart  = ChartUtils.getPieChart2D(dataset, "", true);	
			}else {
				chart  = ChartUtils.getPieChart3D(dataset, "", true);
			}
			
			//Seteamos el formato definido por defecto por Apia
			chart.setColorSchema(chartSchema);
			((PieChart) chart).setApiaDefaultFormat(dataset.getKeys());
			
			//Ver leyenda
			if ("true".equals(viewLegend)){
				((PieChart) chart).getChart().addLegend(chart.getLegend());
			}
			
			//Ver valores
			if (!"true".equals(viewValues)) {
				((PiePlot) ((PieChart) chart).getChart().getPlot()).setLabelGenerator(null);
			}
			
			//Recuperamos la imagen con el gráfico
			img= ((PieChart) chart).getChart().createBufferedImage(w,h);
			
		}else if (QryChartVo.TYPEBARVERT == Integer.parseInt(chartType) || QryChartVo.TYPEBARHOR == Integer.parseInt(chartType)
				|| QryChartVo.TYPELINES == Integer.parseInt(chartType) || QryChartVo.TYPEWATERFALL == Integer.parseInt(chartType)){ //es de tipo XY
	
			DefaultCategoryDataset dataset = new DefaultCategoryDataset();
			
			dataset.addValue(1, "Values", "A");
			dataset.addValue(3, "Values", "B");
			dataset.addValue(2, "Values", "C");
			dataset.addValue(4, "Values", "D");
			
			PlotOrientation orientation = PlotOrientation.VERTICAL;
			
			if (QryChartVo.TYPEBARVERT == Integer.parseInt(chartType) || QryChartVo.TYPEBARHOR == Integer.parseInt(chartType)){ //es de tipo barras
				//Recuperamos la orientación definida para el bar actual
				
				if (QryChartVo.TYPEBARHOR == Integer.parseInt(chartType)) orientation = PlotOrientation.HORIZONTAL;
				
				//Creamos el chart
				if (QryChartVo.SUBTYPE2D == Integer.valueOf(chartSubType)) { //Si 2D
					chart = ChartUtils.getBarChart2D(dataset, "", "", "", orientation, showLegend, false, false);
				}else {
					chart = ChartUtils.getBarChart3D(dataset, "", "", "", orientation, showLegend, false, false);
				}
				
			}else if (QryChartVo.TYPELINES == Integer.parseInt(chartType)){
				//Creamos el chart
				chart = ChartUtils.getLineChart(dataset, "", "", "", true);
			}else if (QryChartVo.TYPEWATERFALL == Integer.parseInt(chartType)){
				//Creamos el chart
				chart = ChartUtils.getWaterfallChart(dataset, "", "", "", PlotOrientation.VERTICAL, true, false, false);
			}
			
			//Seteamos el formato definido por defecto por Apia
			chart.setColorSchema(chartSchema);
			chart.setApiaDefaultFormat();
			
			//Definición de colores
			if ("0".equals(chartSchema)){ //Si no se eligio un schema de colores para las series
				
				CategoryPlot plot = chart.getChart().getCategoryPlot();
				CategoryItemRenderer renderer = plot.getRenderer();
				if (!"".equals(seriesColor)){ //Si se eligió al menos un color
					String colors[] = seriesColor.split(";");
					for (int index=0; index<colors.length; index++) {
						int valueR = Integer.parseInt(colors[index].substring(0, 2), 16);
						int valueG = Integer.parseInt(colors[index].substring(2, 4), 16);
						int valueB = Integer.parseInt(colors[index].substring(4, 6), 16);
						renderer.setSeriesPaint(index, new Color(valueR,valueG,valueB));
					}
				}else {
					renderer.setSeriesPaint(0, whiteColor);
				}
			}
			
			//VER GRILLA
	        ((CategoryPlot) chart.getChart().getPlot()).setRangeGridlinesVisible("true".equals(viewGrid));
	
	        //VER VALORES
	        if ("true".equals(viewValues)) {
	        	switch (Integer.parseInt(chartType)) {
	        		case QryChartVo.TYPEBARVERT: //Si el tipo es Barra verticales
	        		case QryChartVo.TYPEBARHOR://Si el tipo es Barra horizontales 
	        		case QryChartVo.TYPEWATERFALL: //Si el tipo es WaterFall
	        			CategoryItemRenderer rendererC = chart.getChart().getCategoryPlot().getRenderer();
						rendererC.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
						rendererC.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.CENTER, TextAnchor.CENTER));
						rendererC.setBaseItemLabelsVisible(true);
						break;
	        		case QryChartVo.TYPELINES:
	        			LineAndShapeRenderer lineAndShapeRenderer = (LineAndShapeRenderer) chart.getChart().getCategoryPlot().getRenderer();
	        			lineAndShapeRenderer.setBaseItemLabelGenerator(new CustomLabelGenerator());
	        			lineAndShapeRenderer.setBaseItemLabelsVisible(true);
	        			break;
	        	}
			}
			
	      	//VER LEYENDA
			if ("true".equals(viewLegend)){
				chart.getChart().addLegend(chart.getLegend());
			}
	      	
			//VER Y LABELS
			chart.getChart().getCategoryPlot().getRangeAxis().setVisible("true".equals(viewYLabels));
			
			//VER X LABELS
			chart.getChart().getCategoryPlot().getDomainAxis().setVisible("true".equals(viewXLabels));
			
			//Recuperamos la imagen con el gráfico
			img= chart.getChart().createBufferedImage(w,h);
		}
		
		//Insertamos la imagen con el grafico en el jsp
		BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
	    Graphics2D g2d = bi.createGraphics();
	    g2d.drawImage(img, 0, 0,w,h,null);
		ImageIO.write( bi, "jpg", outb);
		outb.close();
	}
	
	

} catch(Exception e){
	e.printStackTrace();
} finally {
//	Las siguientes dos lineas evitan la exception: java.lang.IllegalStateException: getOutputStream() has already been called for this response
 	out.clear();
	out = pageContext.pushBody();
}
%>
