<%@page import="org.jfree.chart.*" %><%@page import="org.jfree.data.*" %><%@page import="java.io.*" %><%@page import="com.dogma.vo.*" %><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.query.UserAction"%><%@page import="biz.statum.apia.web.bean.query.UserBean"%><%@page import="com.st.util.*"%><%@page import="java.awt.Color" %><%
System.setProperty("java.awt.headless","true");

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
UserBean qBean = UserAction.staticRetrieveBean(http);

try {
	response.setContentType("image/png"); 
	OutputStream outs = response.getOutputStream();

	QryChartVo chartVo = qBean.getQryChartVo();
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
