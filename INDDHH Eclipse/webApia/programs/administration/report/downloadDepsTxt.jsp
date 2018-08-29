<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.ReportBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"reportDependencies.txt\"");
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
}
out.clear();

out.print(dBean.exportDepsTxt(request,labelSet));
%>