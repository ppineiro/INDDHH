<%@page import="com.dogma.util.DownloadUtil"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.*"%><%@page import="jxl.*"%><%@page import="jxl.write.*"%><%@page import="javax.activation.*"%><%@page import="java.io.*"%><%@page import="java.util.*"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DataDictionaryBean"></jsp:useBean><%
response.setContentType("application/x-msdownload;charset="+com.dogma.Parameters.APP_ENCODING);
response.setHeader("Content-Disposition", "attachment; filename=\"dataDictionary.xls\"");
out.clear();

try {
	String fileName = dBean.exportAttributesExcel(request);
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(fileName);
	byte[] buffer = new byte[8 * 1024];
	int count = 0;
	do {
		outs.write(buffer, 0, count);
		count = in.read(buffer, 0, buffer.length);
	} while (count != -1);
	
	in.close();
	outs.close();
} catch (Exception e) {
	e.printStackTrace();
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
}

%>