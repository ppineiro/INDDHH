<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.LabelBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"langauge.txt\"");

out.clear();

out.print(dBean.exportLangTxt(request));
%>