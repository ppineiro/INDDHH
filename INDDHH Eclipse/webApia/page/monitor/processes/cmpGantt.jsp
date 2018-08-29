<%@ page import = "org.jfree.chart.*" %><%@ page import = "java.io.*" %><%@ page import = "java.text.*" %><%@ page import = "java.util.*" %><%@ page import = "java.awt.Color" %><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="com.st.util.*"%><%@page import="com.st.util.labels.LabelManager"%><%

HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
ProcessesBean dBean= ProcessesAction.staticRetrieveBean(http);

//esto es para linux.. sino no anda
System.setProperty("java.awt.headless","true");
try {
	out.clear();
	//JFreeChart chart = dBean.generateGantt(request);
	Object[] chart = dBean.generateGantt(http);
	    
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