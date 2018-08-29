<%@ page import = "org.jfree.chart.*" %><%@ page import = "org.jfree.data.*" %><%@ page import = "java.io.*" %><%@ page import = "java.text.*" %><%@ page import = "java.util.*" %><%@ page import = "java.awt.Color" %><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.LabelManager"%><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QueryBean"></jsp:useBean><%
//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");

try {
	response.setContentType("image/png"); 
	OutputStream outs = response.getOutputStream();

	QueryVo queryVo = qBean.getQueryVo();
	QryChartVo chartVo = queryVo.getChart(Integer.valueOf(request.getParameter("chtId")));
	JFreeChart chart = chartVo.getChart();
	String color = new String(StringUtil.escapeStr(request.getParameter("bgc"))); 
	
	int	valueR = Integer.parseInt(color.substring(1, 3), 16);
	int	valueG = Integer.parseInt(color.substring(3, 5), 16);
	int	valueB = Integer.parseInt(color.substring(5, 7), 16);
	
	chart.setBackgroundPaint(new Color(valueR,valueG,valueB));
	ChartUtilities.writeChartAsPNG(outs,chart,Integer.valueOf(request.getParameter("sizeX")).intValue(),Integer.valueOf(request.getParameter("sizeY")).intValue());
	
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
} finally{
//	Las siguientes dos lineas evitan la exception: java.lang.IllegalStateException: getOutputStream() has already been called for this response
	out.clear();
	out = pageContext.pushBody();
	////////////////////////////////////
}
%>
