<%@page import="java.io.*"%><%@page import="java.util.*"%><%@page import="com.apia.query.extractors.ElementVo"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorBusinessBean"></jsp:useBean><%
try {
	ServletOutputStream outs = response.getOutputStream();
	
	String history=request.getParameter("history");
	String historyArr[]=history.split("\n");
	for(int i=0;i<historyArr.length;i++){
		outs.println(historyArr[i]);
	}
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>