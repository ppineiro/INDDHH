<%@ page import = "org.jfree.chart.*" %><%@ page import = "java.io.*" %><%@ page import = "java.text.*" %><%@ page import = "java.util.*" %><%@ page import = "java.awt.Color" %><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.LabelManager"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorProcessesBean"></jsp:useBean><%
//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");
try {
	//JFreeChart chart = dBean.generateGantt(request);
	Object[] chart = dBean.generateGantt(request);
	    
	response.setContentType("image/png"); 
	
	OutputStream outs = response.getOutputStream();
	
	//ChartUtilities.writeChartAsPNG(outs,chart,150 + (dBean.getDaysRunning() * 3) / 2 + dBean.getMaxTitleLength() * 10,100 + dBean.getCount() * 35);
	//ChartUtilities.writeChartAsPNG(outs,(JFreeChart) chart[0],250 + (((Integer) chart[1]).intValue() * 3) / 2 + ((Integer) chart[2]).intValue() * 10,70 + ((Integer) chart[3]).intValue() * 30);
	//ChartUtilities.writeChartAsPNG(outs,(JFreeChart) chart[0],500,70 + ((Integer) chart[3]).intValue() * 30);
	ChartUtilities.writeChartAsPNG(outs,(JFreeChart) chart[0],Integer.parseInt(request.getParameter("width")),70 + ((Integer) chart[3]).intValue() * 30);
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>
