<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.util.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorProcessesBean"></jsp:useBean><%
out.clear();

try {
	ByteArrayOutputStream baosPDF = null;
	if (dBean.isFromList()) {
		baosPDF = dBean.generateMonitorProcessesPdf(request);
	} else {
		baosPDF = dBean.generateMonitorTaskPdf(request);
	}
	
	
	if (baosPDF != null){
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setContentLength(baosPDF.size());
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		
		response.setHeader("Content-Disposition", "attachment; filename=\"monitor.pdf\"");	
		
		ServletOutputStream output = response.getOutputStream();
		baosPDF.writeTo(output);
	}
 	else {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
 	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>