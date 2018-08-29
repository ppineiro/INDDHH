<%@page import="java.io.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.SimScenarioBean"></jsp:useBean><%
out.clear();
try {
	ByteArrayOutputStream baosPDF = dBean.simulateResultGenerateBinary(request);
	if (baosPDF != null){
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
		response.setContentLength(baosPDF.size());
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		
		response.setHeader("Content-Disposition", "attachment; filename=\"simulation.pdf\"");	
		
		ServletOutputStream output = response.getOutputStream();
		baosPDF.writeTo(output);	
	} else {
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>