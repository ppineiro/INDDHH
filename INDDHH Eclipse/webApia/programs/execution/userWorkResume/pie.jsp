<%@ page import = "org.jfree.chart.ChartFactory" %><%@ page import = "org.jfree.chart.JFreeChart" %><%@ page import = "org.jfree.chart.plot.PiePlot3D" %><%@ page import = "org.jfree.data.general.DefaultPieDataset" %><%@ page import = "org.jfree.data.general.PieDataset" %><%@ page import = "org.jfree.ui.ApplicationFrame" %><%@ page import = "org.jfree.ui.RefineryUtilities" %><%@ page import = "org.jfree.util.Rotation" %><%@ page import = "java.awt.image.*" %><%@ page import = "javax.imageio.ImageIO"%><%@page import="java.io.*" %><%@page import="java.awt.*"%><%@page import="com.st.util.*"%><%
try{
	request.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
	response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);	
	response.setContentType("image/jpeg");
	response.setDateHeader ("Expires",0);
//	 get output stream
	out.clear(); 
	out = pageContext.pushBody();
	java.io.OutputStream outb=response.getOutputStream();
	 
	String[] proNames = request.getParameterValues("proName");
	String[] proCants = request.getParameterValues("proCant");
	
	double total=0;

	int w=260;
	int h=240;

	try { w = Integer.parseInt(request.getParameter("width")); } catch (Exception e) {}
	try { h = Integer.parseInt(request.getParameter("height")); } catch (Exception e) {}
	
	DefaultPieDataset result = new DefaultPieDataset();
	for(int i=0;i<proNames.length;i++){
		total+=Double.parseDouble(proCants[i]);
	}
	for(int i=0;i<proNames.length;i++){
		result.setValue(proNames[i],(Double.parseDouble(proCants[i])*100)/total);
		h+=23;
		//d1[i]= (Double.parseDouble(proCants[i])*100)/total;
	}
	
	String title = request.getParameter("title");
	if (title == null) title = "";
	
	String avoidLeyend = request.getParameter("avoidLeyend");
	boolean showLeyend = avoidLeyend == null || "false".equalsIgnoreCase(avoidLeyend);
	
	JFreeChart chart = ChartFactory.createPieChart3D(
		title,  // chart title
        result,                // data
        showLeyend,                   // include legend
        true,
        false
    );
	
	final PiePlot3D plot = (PiePlot3D) chart.getPlot();
    plot.setStartAngle(290);
    plot.setDirection(Rotation.CLOCKWISE);
    plot.setForegroundAlpha(0.5f);
    plot.setNoDataMessage("No data to display");
    plot.setLabelGenerator(null);
	Image img=chart.createBufferedImage(w,h);
	BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
    Graphics2D g2d = bi.createGraphics();
    g2d.drawImage(img, 0, 0,w,h,null);
	ImageIO.write( bi, "jpg", outb);
	outb.close();
	

} catch(Exception e){
	
	e.printStackTrace();
}
%>
