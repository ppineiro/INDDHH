<%@page import="java.io.FileInputStream"%><%@page import="java.util.*"%><%@page import="com.apia.query.extractors.ElementVo"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorBusinessBean"></jsp:useBean><%
try {
	ServletOutputStream outs = response.getOutputStream();
	FileInputStream in = new FileInputStream(dBean.getExportLocation());
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