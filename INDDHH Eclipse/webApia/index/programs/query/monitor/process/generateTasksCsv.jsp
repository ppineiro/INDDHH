<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@page import="com.st.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorProcessesBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
out.clear();

try {
	StringBuffer content = dBean.generateTasksCsv(request);
	response.setHeader("Content-Disposition", "attachment; filename=\"monitor.csv\"");
	out.print(content.toString());
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>