<%@page import="biz.statum.apia.web.action.monitor.ProcessesAction"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.util.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><%
out.clear();

try {
	HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
	ProcessesBean dBean= ProcessesAction.staticRetrieveBean(http);
	
	ByteArrayOutputStream baosPDF = null;
	if (dBean.getFromList()) {
		baosPDF = dBean.generateMonitorProcessesPdf(http);
	} else {
		baosPDF = dBean.generateMonitorTaskPdf(http);
	}
	
	
	if (baosPDF != null){
		response.setContentType("application/force-download;charset="+com.dogma.Parameters.APP_ENCODING);
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