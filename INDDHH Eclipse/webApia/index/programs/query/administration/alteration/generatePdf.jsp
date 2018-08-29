<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.util.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="qBean" scope="session" class="com.dogma.bean.query.QryProAlterBean"></jsp:useBean><%
out.clear();
com.dogma.bean.query.QryProAlterBean dBean = qBean;
String fileName = StringUtil.replaceAll(qBean.getQueryVo().getQryTitle(), StringUtil.SPACE_STRING, StringUtil.UNDERBAR_SEPARATOR);
try {
	
	if (dBean.generateQueryPdf(request)) {
		
		ByteArrayOutputStream baosPDF = PdfGenerator.toOutputStream(Parameters.APP_PATH + "/templates/queryTemplate.xml",null,dBean.getProperties());
		
		response.setContentType("application/x-msdownload;charset=ISO-8859-1");
		response.setContentLength(baosPDF.size());
		response.setHeader("Expires", "0");
		response.setHeader("Cache-Control", "must-revalidate, post-check=0, pre-check=0");
		response.setHeader("Pragma", "public");
		
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".pdf\"");	
		
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