<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.bean.query.TaskListBean"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.util.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="qBeanReady" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><jsp:useBean id="qBeanInproc" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><%
out.clear();

String WORK_MODE = request.getParameter("listType");
com.dogma.bean.query.TaskListBean qBean = null;
if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
	qBean = qBeanInproc;
} else {
	qBean = qBeanReady;
} 
String fileName = StringUtil.replaceAll(qBean.getQueryVo().getQryTitle(), StringUtil.SPACE_STRING, StringUtil.UNDERBAR_SEPARATOR);
if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
	fileName += "_InProcess"; 
}else{
	fileName += "_Ready";
}
try {
	ByteArrayOutputStream baosPDF = qBean.generateQueryNewPdf(request);
	if (baosPDF != null){
	//if (qBean.generateQueryPdf(request)) {
		
		//ByteArrayOutputStream baosPDF = PdfGenerator.toOutputStream(Parameters.APP_PATH + "/templates/queryTemplate.xml",null,qBean.getProperties());
		
		response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
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