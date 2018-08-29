<%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.bean.query.TaskListBean"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="qBeanReady" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><jsp:useBean id="qBeanInproc" scope="session" class="com.dogma.bean.query.TaskListBean"></jsp:useBean><%
System.out.println("Start");

String WORK_MODE = request.getParameter("listType");
com.dogma.bean.query.TaskListBean qBean = null;
if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
	qBean = qBeanInproc;
} else {
	qBean = qBeanReady;
} 
	
System.out.println("1");
String fileName = StringUtil.replaceAll(qBean.getQueryVo().getQryTitle(), StringUtil.SPACE_STRING, StringUtil.UNDERBAR_SEPARATOR);
if (WORK_MODE.equals(TaskListBean.WORKING_MODE_INPROCESS)) {
	fileName += "_InProcess"; 
}else{
	fileName += "_Ready";
}
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".txt\"");
String separator = Parameters.CSV_FIELD_SEPARATOR;
String lineSeparator = DownloadUtil.LINE_SEPARATOR;
out.clear();

System.out.println("2");

out.print(qBean.generateQueryCsv(request));

System.out.println("3");

%>